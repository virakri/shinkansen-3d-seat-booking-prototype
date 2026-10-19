import * as THREE from './vendor/three.module.min.js';

// Shared Texture Cache (with SceneKit top-left UV convention: flipY = false)
const textureCache = new Map();

// 1x1 white canvas so textures are white (1,1,1,1) before async image load finishes
const placeholderCanvas = document.createElement('canvas');
placeholderCanvas.width = 1;
placeholderCanvas.height = 1;
const pCtx = placeholderCanvas.getContext('2d');
pCtx.fillStyle = '#ffffff';
pCtx.fillRect(0, 0, 1, 1);

function getTexture(path) {
  if (!path) return null;
  if (textureCache.has(path)) return textureCache.get(path);
  const tex = new THREE.Texture(placeholderCanvas);
  tex.flipY = false;
  tex.colorSpace = THREE.LinearSRGBColorSpace;
  tex.wrapS = THREE.ClampToEdgeWrapping;
  tex.wrapT = THREE.ClampToEdgeWrapping;
  tex.minFilter = THREE.LinearMipmapLinearFilter;
  tex.magFilter = THREE.LinearFilter;
  tex.needsUpdate = true;

  const loadImg = (attempt = 0) => {
    const img = new Image();
    img.onload = () => {
      tex.image = img;
      tex.needsUpdate = true;
    };
    img.onerror = () => {
      if (attempt < 2) {
        setTimeout(() => loadImg(attempt + 1), 150);
      }
    };
    img.src = path;
  };
  loadImg();

  textureCache.set(path, tex);
  return tex;
}

// White 1x1 fallback texture
const whiteData = new Uint8Array([255, 255, 255, 255]);
const whiteTexture = new THREE.DataTexture(whiteData, 1, 1, THREE.RGBAFormat);
whiteTexture.needsUpdate = true;

// SceneKit Constant Lighting Shader Material
const SCN_VERTEX_SHADER = `
  varying vec2 vUv;
  void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
`;

const SCN_FRAGMENT_SHADER = `
  uniform vec4 uDiffuseColor;
  uniform sampler2D uMultiplyMap;
  uniform bool uHasMultiplyMap;
  uniform vec4 uMultiplyColor;
  uniform float uMultiplyIntensity;
  uniform sampler2D uTransparentMap;
  uniform bool uHasTransparentMap;
  uniform float uTransparency;
  uniform int uTransparencyMode;
  uniform int uBlendMode;

  varying vec2 vUv;

  void main() {
    vec4 diff = uDiffuseColor;
    vec3 multSample = uHasMultiplyMap ? texture2D(uMultiplyMap, vUv).rgb : uMultiplyColor.rgb;
    vec3 multFactor = mix(vec3(1.0), multSample, uMultiplyIntensity);
    vec3 finalRgb = diff.rgb * multFactor;

    float alpha = 1.0;
    if (uTransparencyMode == 0) {
      // SCNTransparencyModeAOne
      alpha = diff.a * uTransparency;
    } else {
      // SCNTransparencyModeRGBZero
      if (uHasTransparentMap) {
        vec3 tc = texture2D(uTransparentMap, vUv).rgb;
        float lum = dot(tc, vec3(0.2126, 0.7152, 0.0722));
        alpha = clamp((1.0 - lum) * uTransparency, 0.0, 1.0);
      } else {
        alpha = clamp(1.0 - uTransparency, 0.0, 1.0);
      }
    }

    if (uBlendMode == 3) {
      // SCNBlendModeMultiply: output factor to multiply with destination
      gl_FragColor = vec4(finalRgb, 1.0);
      return;
    }

    if (alpha <= 0.001) discard;
    gl_FragColor = vec4(finalRgb, alpha);
  }
`;

function createSCNShaderMaterial(matDef) {
  const diffColor = matDef.diffuse?.type === 'color' ? matDef.diffuse.color : [1, 1, 1, 1];
  const hasMultMap = matDef.multiply?.type === 'texture';
  const multTex = hasMultMap ? getTexture(matDef.multiply.path) : whiteTexture;
  const multColor = matDef.multiply?.type === 'color' ? matDef.multiply.color : [1, 1, 1, 1];
  const hasTransMap = matDef.transparent?.type === 'texture';
  const transTex = hasTransMap ? getTexture(matDef.transparent.path) : whiteTexture;

  const isMultiplyBlend = matDef.blendMode === 3;
  const isTransparent =
    isMultiplyBlend ||
    hasTransMap ||
    (matDef.transparencyMode === 0 && matDef.transparency < 0.999) ||
    (matDef.transparencyMode === 1 && !hasTransMap && matDef.transparency > 0.001);

  const mat = new THREE.ShaderMaterial({
    vertexShader: SCN_VERTEX_SHADER,
    fragmentShader: SCN_FRAGMENT_SHADER,
    uniforms: {
      uDiffuseColor: { value: new THREE.Vector4(diffColor[0], diffColor[1], diffColor[2], diffColor[3]) },
      uMultiplyMap: { value: multTex },
      uHasMultiplyMap: { value: hasMultMap },
      uMultiplyColor: { value: new THREE.Vector4(multColor[0], multColor[1], multColor[2], multColor[3]) },
      uMultiplyIntensity: { value: matDef.multiplyIntensity ?? 1.0 },
      uTransparentMap: { value: transTex },
      uHasTransparentMap: { value: hasTransMap },
      uTransparency: { value: matDef.transparency ?? 1.0 },
      uTransparencyMode: { value: matDef.transparencyMode ?? 0 },
      uBlendMode: { value: matDef.blendMode ?? 0 }
    },
    side: matDef.isDoubleSided ? THREE.DoubleSide : THREE.FrontSide,
    transparent: isTransparent,
    depthWrite: isMultiplyBlend ? false : !isTransparent,
    depthTest: matDef.readsFromDepthBuffer !== false
  });

  if (isMultiplyBlend) {
    mat.blending = THREE.CustomBlending;
    mat.blendEquation = THREE.AddEquation;
    mat.blendSrc = THREE.ZeroFactor;
    mat.blendDst = THREE.SrcColorFactor;
    mat.polygonOffset = true;
    mat.polygonOffsetFactor = -1;
    mat.polygonOffsetUnits = -1;
  }

  return mat;
}

function applyMaterialDefToShader(shaderMat, matDef, animateDuration = 0) {
  const diffColor = matDef.diffuse?.type === 'color' ? matDef.diffuse.color : [1, 1, 1, 1];
  const hasMultMap = matDef.multiply?.type === 'texture';
  const multTex = hasMultMap ? getTexture(matDef.multiply.path) : whiteTexture;
  const hasTransMap = matDef.transparent?.type === 'texture';
  const transTex = hasTransMap ? getTexture(matDef.transparent.path) : whiteTexture;

  shaderMat.uniforms.uMultiplyMap.value = multTex;
  shaderMat.uniforms.uHasMultiplyMap.value = hasMultMap;
  shaderMat.uniforms.uMultiplyIntensity.value = matDef.multiplyIntensity ?? 1.0;
  shaderMat.uniforms.uTransparentMap.value = transTex;
  shaderMat.uniforms.uHasTransparentMap.value = hasTransMap;
  shaderMat.uniforms.uTransparencyMode.value = matDef.transparencyMode ?? 0;
  shaderMat.uniforms.uBlendMode.value = matDef.blendMode ?? 0;

  const isMultiplyBlend = matDef.blendMode === 3;
  const targetTrans = matDef.transparency ?? 1.0;
  const isTransparent =
    isMultiplyBlend ||
    hasTransMap ||
    (matDef.transparencyMode === 0 && targetTrans < 0.999) ||
    (matDef.transparencyMode === 1 && !hasTransMap && targetTrans > 0.001);

  shaderMat.transparent = isTransparent;
  shaderMat.depthWrite = isMultiplyBlend ? false : !isTransparent;

  if (animateDuration > 0) {
    const startColor = shaderMat.uniforms.uDiffuseColor.value.clone();
    const endColor = new THREE.Vector4(diffColor[0], diffColor[1], diffColor[2], diffColor[3]);
    const startTrans = shaderMat.uniforms.uTransparency.value;
    const startTime = performance.now();
    const durMs = animateDuration * 1000;

    const tick = (now) => {
      const t = Math.min((now - startTime) / durMs, 1);
      shaderMat.uniforms.uDiffuseColor.value.lerpVectors(startColor, endColor, t);
      shaderMat.uniforms.uTransparency.value = startTrans + (targetTrans - startTrans) * t;
      if (t < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  } else {
    shaderMat.uniforms.uDiffuseColor.value.set(diffColor[0], diffColor[1], diffColor[2], diffColor[3]);
    shaderMat.uniforms.uTransparency.value = targetTrans;
  }
}

// DecayFunction.swift port
export const DecayFunction = {
  timeToHalt(velocity) {
    const fps = 1 / 60;
    let i = 0;
    let v = { x: velocity.x, y: velocity.y };
    while (Math.abs(v.x) > 0.1 || Math.abs(v.y) > 0.1) {
      v = this.step(fps, v).velocity;
      i++;
      if (i > 600) break;
    }
    return i / 60;
  },
  step(timeElapsed, velocity) {
    const deceleration = 0.996;
    const dt = timeElapsed * 1000.0;
    const kv = Math.pow(deceleration, dt);
    const kx = (deceleration * (1 - kv)) / (1 - deceleration);
    const v0x = velocity.x / 1000.0;
    const v0y = velocity.y / 1000.0;
    const vx = v0x * kv * 1000.0;
    const vy = v0y * kv * 1000.0;
    return {
      velocity: { x: vx, y: vy },
      displacement: { x: v0x * kx, y: v0y * kx }
    };
  }
};

// Cubic-bezier evaluator for SceneKitAnimator timing functions
export function cubicBezier(p1x, p1y, p2x, p2y) {
  return function (x) {
    if (x <= 0) return 0;
    if (x >= 1) return 1;
    let t = x;
    for (let i = 0; i < 8; i++) {
      const cx = 3 * p1x;
      const bx = 3 * (p2x - p1x) - cx;
      const ax = 1 - cx - bx;
      const currentX = ((ax * t + bx) * t + cx) * t - x;
      if (Math.abs(currentX) < 1e-5) break;
      const dx = (3 * ax * t + 2 * bx) * t + cx;
      if (Math.abs(dx) < 1e-6) break;
      t -= currentX / dx;
    }
    const cy = 3 * p1y;
    const by = 3 * (p2y - p1y) - cy;
    const ay = 1 - cy - by;
    return ((ay * t + by) * t + cy) * t;
  };
}

export const TimingFunctions = {
  linear: (t) => t,
  easeIn: cubicBezier(0.9, 0, 0.9, 1),
  easeOut: cubicBezier(0.1, 0, 0.1, 1),
  easeInOut: cubicBezier(0.45, 0, 0.55, 1),
  explodingEaseOut: cubicBezier(0, 0, 0, 1),
  default: cubicBezier(0, 0, 0.2, 1),
  summaryBounceEnd: cubicBezier(0.33, 0, 0.33, 1)
};

// NodeFactory.swift port
export class NodeFactory {
  static shared = null;

  constructor() {
    this.isLoaded = false;
    this.modelsMeta = null;
    this.binaryBuffer = null;
    this.geometryCache = new Map();
    this.callbacks = [];
  }

  async load() {
    if (this.isLoaded) return;
    const [metaRes, binRes] = await Promise.all([
      fetch('assets/scn/models.json'),
      fetch('assets/scn/models.bin')
    ]);
    this.modelsMeta = await metaRes.json();
    this.binaryBuffer = await binRes.arrayBuffer();

    // Preload all textures referenced across all 3D models
    const texPaths = new Set();
    const collectTex = (node) => {
      if (node.geometry?.allMaterials) {
        for (const m of node.geometry.allMaterials) {
          if (m.diffuse?.type === 'texture') texPaths.add(m.diffuse.path);
          if (m.multiply?.type === 'texture') texPaths.add(m.multiply.path);
          if (m.transparent?.type === 'texture') texPaths.add(m.transparent.path);
        }
      }
      if (node.children) node.children.forEach(collectTex);
    };
    Object.values(this.modelsMeta).forEach((m) => collectTex(m.rootNode));
    texPaths.forEach((p) => getTexture(p));

    this.isLoaded = true;
    const cbs = this.callbacks.splice(0);
    cbs.forEach((cb) => cb());
  }

  onComplete(cb) {
    if (this.isLoaded) {
      cb();
    } else {
      this.callbacks.push(cb);
    }
  }

  getBufferGeometry(nodeKey, geoDef) {
    if (this.geometryCache.has(nodeKey)) {
      return this.geometryCache.get(nodeKey);
    }
    const geom = new THREE.BufferGeometry();
    if (geoDef.vertex) {
      const posArr = new Float32Array(
        this.binaryBuffer,
        geoDef.vertex.byteOffset,
        geoDef.vertex.count * 3
      );
      geom.setAttribute('position', new THREE.BufferAttribute(posArr, 3));
    }
    if (geoDef.normal) {
      const normArr = new Float32Array(
        this.binaryBuffer,
        geoDef.normal.byteOffset,
        geoDef.normal.count * 3
      );
      geom.setAttribute('normal', new THREE.BufferAttribute(normArr, 3));
    }
    if (geoDef.texcoord) {
      const uvArr = new Float32Array(
        this.binaryBuffer,
        geoDef.texcoord.byteOffset,
        geoDef.texcoord.count * 2
      );
      geom.setAttribute('uv', new THREE.BufferAttribute(uvArr, 2));
    }

    // Combine element index buffers into a single index buffer with groups
    let totalIndices = 0;
    const elemArrays = geoDef.elements.map((el) => {
      const count = el.primitiveCount * 3;
      totalIndices += count;
      if (el.bytesPerIndex === 1) {
        return new Uint8Array(this.binaryBuffer, el.byteOffset, count);
      } else if (el.bytesPerIndex === 2) {
        // Ensure 2-byte alignment
        if (el.byteOffset % 2 === 0) {
          return new Uint16Array(this.binaryBuffer, el.byteOffset, count);
        } else {
          const slice = this.binaryBuffer.slice(el.byteOffset, el.byteOffset + el.byteLength);
          return new Uint16Array(slice);
        }
      } else {
        const slice = this.binaryBuffer.slice(el.byteOffset, el.byteOffset + el.byteLength);
        return new Uint32Array(slice);
      }
    });

    const combinedIndices = new Uint32Array(totalIndices);
    let offset = 0;
    elemArrays.forEach((arr, groupIdx) => {
      combinedIndices.set(arr, offset);
      geom.addGroup(offset, arr.length, groupIdx);
      offset += arr.length;
    });
    geom.setIndex(new THREE.BufferAttribute(combinedIndices, 1));

    this.geometryCache.set(nodeKey, geom);
    return geom;
  }

  buildThreeNode(nodeDef, modelName, pathPrefix = 'root', collector = { geoNodes: [], stateNodes: [] }) {
    const nodePath = `${modelName}:${pathPrefix}:${nodeDef.name}`;
    let obj;

    if (nodeDef.geometry) {
      const geom = this.getBufferGeometry(nodePath, nodeDef.geometry);
      const baseNames = nodeDef.geometry.baseMaterialNames || [];
      const allMats = nodeDef.geometry.allMaterials || [];
      const stateSet = new Set(['normal', 'highlighted', 'selected', 'disabled', 'focus']);
      const normalMaterials = allMats.filter((m) => {
        const name = (m.name || '').trim();
        if (name.includes('-')) {
          const parts = name.split('-');
          const last = parts[parts.length - 1];
          if (stateSet.has(last) && parts.length > 1) {
            return last === 'normal';
          }
        }
        return true;
      });
      const materials = nodeDef.geometry.elements.map((_, idx) => {
        const normalMatDef = normalMaterials[idx] || allMats[idx] || allMats[0];
        return createSCNShaderMaterial(normalMatDef);
      });
      obj = new THREE.Mesh(geom, materials);
      if (modelName === 'e7-main-shadow') {
        obj.renderOrder = 1;
      }
      collector.geoNodes.push({
        mesh: obj,
        baseMaterialNames: baseNames,
        normalMaterials,
        allMaterials: allMats
      });
    } else {
      obj = new THREE.Group();
    }

    obj.name = nodeDef.name || '';
    obj.position.set(nodeDef.position[0], nodeDef.position[1], nodeDef.position[2]);
    obj.quaternion.set(
      nodeDef.quaternion[0],
      nodeDef.quaternion[1],
      nodeDef.quaternion[2],
      nodeDef.quaternion[3]
    );
    obj.scale.set(nodeDef.scale[0], nodeDef.scale[1], nodeDef.scale[2]);

    if (nodeDef.stateTransforms) {
      collector.stateNodes.push({
        object: obj,
        original: {
          position: new THREE.Vector3(...nodeDef.position),
          quaternion: new THREE.Quaternion(...nodeDef.quaternion),
          scale: new THREE.Vector3(...nodeDef.scale)
        },
        stateTransforms: nodeDef.stateTransforms
      });
    }

    if (nodeDef.children) {
      nodeDef.children.forEach((childDef, idx) => {
        const childObj = this.buildThreeNode(childDef, modelName, `${pathPrefix}.${idx}`, collector);
        obj.add(childObj);
      });
    }

    return obj;
  }

  createInstance(modelName) {
    const meta = this.modelsMeta?.[modelName];
    if (!meta) return null;
    const collector = { geoNodes: [], stateNodes: [] };
    const rootGroup = new THREE.Group();
    rootGroup.name = modelName;
    const childObj = this.buildThreeNode(meta.rootNode, modelName, '0', collector);
    rootGroup.add(childObj);
    return new SCNModelInstance(modelName, rootGroup, collector, meta);
  }
}

// Represents StaticNode / InteractiveNode / SeatNode
export class SCNModelInstance {
  constructor(name, group, collector, meta) {
    this.name = name;
    this.group = group;
    this.geoNodes = collector.geoNodes;
    this.stateNodes = collector.stateNodes;
    this.meta = meta;
    this.isEnabled = true;
    this.isHighlighted = false;
    this.isSelected = false;
    this.state = 'normal';
    this.reservableEntity = null;
    this.transformedModelEntity = null;

    // Tag all meshes with reference to this SCNModelInstance for raycasting
    this.group.traverse((child) => {
      if (child.isMesh) {
        child.userData.scnInstance = this;
      }
    });
  }

  setTransformedModelEntity(entity) {
    this.transformedModelEntity = entity;
    if (!entity) return;
    this.group.position.set(entity.position.x, entity.position.y, entity.position.z);
    // SceneKit eulerAngles order is ZYX
    const euler = new THREE.Euler(entity.rotation.x, entity.rotation.y, entity.rotation.z, 'ZYX');
    this.group.quaternion.setFromEuler(euler);
  }

  setReservableEntity(entity) {
    this.reservableEntity = entity;
    if (entity?.transformedModelEntity) {
      this.setTransformedModelEntity(entity.transformedModelEntity);
    }
  }

  setStaticEnabled(enabled) {
    this.isEnabled = enabled;
    const targetState = enabled ? 'normal' : 'disabled';
    this.applyState(targetState, false);
  }

  updateInteractiveState(animated = true) {
    const newState = !this.isEnabled
      ? 'disabled'
      : this.isHighlighted
      ? 'highlighted'
      : this.isSelected
      ? 'selected'
      : 'normal';

    if (newState !== this.state || !animated) {
      this.state = newState;
      this.applyState(newState, animated);
    }
  }

  applyState(state, animated = false) {
    const dur = animated ? 0.35 / 4 : 0;

    // 1. Update materials (StaticNode.updateMaterial & InteractiveNode.updateMaterial)
    for (const gNode of this.geoNodes) {
      const { mesh, baseMaterialNames, normalMaterials, allMaterials } = gNode;
      const mats = Array.isArray(mesh.material) ? mesh.material : [mesh.material];
      mats.forEach((shaderMat, idx) => {
        const baseName = baseMaterialNames[idx] ?? '';
        const fallbackNormal = normalMaterials?.[idx] || allMaterials[idx] || allMaterials[0];
        const matchMat =
          state === 'normal'
            ? fallbackNormal
            : allMaterials.find((m) => m.name.trim() === `${baseName}-${state}`) || fallbackNormal;
        if (matchMat) {
          applyMaterialDefToShader(shaderMat, matchMat, dur);
        }
      });
    }

    // 2. Update child transforms (InteractiveNode.updateTransfrom)
    for (const sNode of this.stateNodes) {
      const { object, original, stateTransforms } = sNode;
      const st = stateTransforms[state];
      const targetPos = st ? new THREE.Vector3(...st.position) : original.position;
      const targetQuat = st ? new THREE.Quaternion(...st.quaternion) : original.quaternion;
      const targetScale = st ? new THREE.Vector3(...st.scale) : original.scale;

      if (dur > 0) {
        const startPos = object.position.clone();
        const startQuat = object.quaternion.clone();
        const startScale = object.scale.clone();
        const startTime = performance.now();
        const durMs = dur * 1000;

        const tick = (now) => {
          const t = Math.min((now - startTime) / durMs, 1);
          object.position.lerpVectors(startPos, targetPos, t);
          object.quaternion.slerpQuaternions(startQuat, targetQuat, t);
          object.scale.lerpVectors(startScale, targetScale, t);
          if (t < 1) requestAnimationFrame(tick);
        };
        requestAnimationFrame(tick);
      } else {
        object.position.copy(targetPos);
        object.quaternion.copy(targetQuat);
        object.scale.copy(targetScale);
      }
    }
  }
}

// TextNode.swift port: 3D flat text on XZ plane matching SceneKit's SCNText layout
export function createTextNode({
  text = '',
  fontSize = 0.2,
  fontWeight = '900',
  textAlignment = 'center',
  color = '#909095',
  position = { x: 0, y: 0, z: 0 },
  rotation = { x: 0, y: 0, z: 0 }
}) {
  const group = new THREE.Group();
  group.position.set(position.x, position.y, position.z);
  const euler = new THREE.Euler(rotation.x, rotation.y, rotation.z, 'ZYX');
  group.quaternion.setFromEuler(euler);

  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  const pxPerUnit = 360;
  // In SceneKit SCNText, pointSize 0.2 produces capHeight ~0.142 world units (0.71 * fontSize)
  const effectiveSize = fontSize * 0.72;
  const fontPx = Math.max(Math.round(effectiveSize * pxPerUnit), 16);
  const fontSpec = `${fontWeight} ${fontPx}px -apple-system, BlinkMacSystemFont, "SF Pro Display", "Helvetica Neue", sans-serif`;
  ctx.font = fontSpec;
  const metrics = ctx.measureText(text);
  const padPx = Math.ceil(fontPx * 0.15);
  const textWidthPx = Math.ceil(metrics.width) + padPx * 2;
  const textHeightPx = Math.ceil(fontPx * 1.25);

  canvas.width = Math.max(textWidthPx, 16);
  canvas.height = Math.max(textHeightPx, 16);

  function drawText(fillColor) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.font = fontSpec;
    ctx.fillStyle = fillColor;
    ctx.textBaseline = 'middle';
    if (textAlignment === 'left') {
      ctx.textAlign = 'left';
      ctx.fillText(text, padPx, canvas.height / 2);
    } else if (textAlignment === 'right') {
      ctx.textAlign = 'right';
      ctx.fillText(text, canvas.width - padPx, canvas.height / 2);
    } else {
      ctx.textAlign = 'center';
      ctx.fillText(text, canvas.width / 2, canvas.height / 2);
    }
  }

  drawText(color);

  const tex = new THREE.CanvasTexture(canvas);
  tex.colorSpace = THREE.SRGBColorSpace;
  tex.minFilter = THREE.LinearFilter;
  tex.magFilter = THREE.LinearFilter;

  const worldW = canvas.width / pxPerUnit;
  const worldH = canvas.height / pxPerUnit;

  const planeGeo = new THREE.PlaneGeometry(worldW, worldH);
  const planeMat = new THREE.MeshBasicMaterial({
    map: tex,
    transparent: true,
    depthWrite: false,
    side: THREE.DoubleSide
  });

  const mesh = new THREE.Mesh(planeGeo, planeMat);
  mesh.rotation.x = -Math.PI / 2;

  if (textAlignment === 'left') {
    mesh.position.x = worldW / 2;
  } else if (textAlignment === 'right') {
    mesh.position.x = -worldW / 2;
  } else {
    mesh.position.x = 0;
  }

  group.add(mesh);

  group.userData.setColor = (newColor) => {
    drawText(newColor);
    tex.needsUpdate = true;
  };

  return group;
}

// ============================================================================
// SeatMapSceneView.swift Port
// ============================================================================
export class SeatMapSceneView {
  constructor(containerEl, callbacks = {}) {
    this.container = containerEl;
    this.onSeatSelected = callbacks.onSeatSelected || (() => {});
    this.onOverscrollUpper = callbacks.onOverscrollUpper || (() => {});
    this.onBadgeUpdate = callbacks.onBadgeUpdate || (() => {});

    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0xffffff);

    // CameraNode.swift
    this.cameraContainer = new THREE.Group();
    const cameraPosition = { x: 0, y: 7.2, z: 5 };
    const offsetPosition = { x: 0, y: 2, z: 1.5 };

    this.camera = new THREE.PerspectiveCamera(64, 1, 1, 100);
    this.camera.position.set(
      0,
      cameraPosition.y - offsetPosition.y,
      cameraPosition.z - offsetPosition.z
    );
    this.camera.rotation.set(-0.9638087153434753, 0, 0, 'ZYX');

    this.cameraContainer.add(this.camera);
    this.cameraContainer.position.set(0, offsetPosition.y, -cameraPosition.z + offsetPosition.z);
    this.scene.add(this.cameraContainer);

    // ContentNode
    this.contentNode = new THREE.Group();
    this.scene.add(this.contentNode);

    // Mathematical HitTestFloorNode at y = 1.3 (HitTestFloorNode.swift)
    this.hitTestPlane = new THREE.Plane(new THREE.Vector3(0, 1, 0), -1.3);
    this.raycaster = new THREE.Raycaster();

    this.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: false, powerPreference: 'high-performance' });
    this.renderer.outputColorSpace = THREE.LinearSRGBColorSpace;
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    this.container.appendChild(this.renderer.domElement);

    this.contentZPositionLimit = { lower: 0, upper: 1 };
    this.currentContentZ = 0;
    this.centerScreenZ = 0;
    this.perspectiveVelocity = 0;

    this.interactiveSeatMeshes = [];
    this.highlightedSeatNode = null;
    this.selectedSeatNode = null;
    this.seatNavigationState = 'hide';
    this.textNodes = [];
    this.stationDirectionNode = null;

    this.activeAnimCancel = null;
    this.isDisposed = false;

    this.setupResizeObserver();
    this.setupInteraction();
    this.startRenderLoop();
  }

  setupResizeObserver() {
    this.updateSize = () => {
      if (this.isDisposed) return;
      const rect = this.container.getBoundingClientRect();
      if (rect.width < 2 || rect.height < 2) return;
      const w = rect.width;
      const h = rect.height;
      this.camera.aspect = w / h;
      this.camera.updateProjectionMatrix();
      this.renderer.setSize(w, h, false);
      const midHit = this.positionOfFloorHitTest(w / 2, h / 2);
      if (midHit) this.centerScreenZ = midHit.z;
    };
    this.resizeObserver = new ResizeObserver(this.updateSize);
    this.resizeObserver.observe(this.container);
    this.updateSize();
  }

  setTheme(isDark) {
    if (isDark) {
      this.scene.background = new THREE.Color().setRGB(46 / 255, 46 / 255, 46 / 255, THREE.LinearSRGBColorSpace);
    } else {
      this.scene.background = new THREE.Color().setRGB(1, 1, 1, THREE.LinearSRGBColorSpace);
    }
    const textColor = '#909095';
    if (this.stationDirectionNode?.userData?.setColor) {
      this.stationDirectionNode.userData.setColor(textColor);
    }
  }

  positionOfFloorHitTest(localX, localY) {
    const rect = this.renderer.domElement.getBoundingClientRect();
    const w = Math.max(rect.width, 1);
    const h = Math.max(rect.height, 1);
    const ndc = new THREE.Vector2((localX / w) * 2 - 1, -(localY / h) * 2 + 1);
    this.raycaster.setFromCamera(ndc, this.camera);
    const target = new THREE.Vector3();
    const hit = this.raycaster.ray.intersectPlane(this.hitTestPlane, target);
    return hit ? target : null;
  }

  zPositionClamp(value) {
    const { lower, upper } = this.contentZPositionLimit;
    let trimmedMax = value;
    if (value > upper) {
      const ratio = upper !== 0 ? Math.max(value / upper, 1) : 1 + (value - upper);
      trimmedMax = upper !== 0 ? upper * (1 + Math.log10(ratio)) : Math.log10(ratio);
    }
    if (trimmedMax < lower) {
      if (lower > 0) {
        const ratio = Math.max(trimmedMax / lower, 0.01);
        return lower * (1 + Math.log10(ratio));
      } else {
        const excess = lower - trimmedMax;
        return lower - Math.log10(1 + excess) * 2;
      }
    }
    return trimmedMax;
  }

  setCurrentContentZ(newZ, reportOverscroll = true) {
    const oldZ = this.currentContentZ;
    this.currentContentZ = newZ;
    this.contentNode.position.z = newZ;
    this.perspectiveVelocity = (newZ - oldZ) / (1 / 60);

    if (reportOverscroll) {
      const upperBoundLimitOffsetY = this.contentZPositionLimit.upper - newZ;
      this.onOverscrollUpper({ x: 0, y: upperBoundLimitOffsetY / 0.04 });
    }

    if (this.centerScreenZ === 0) {
      const rect = this.renderer.domElement.getBoundingClientRect();
      const midHit = this.positionOfFloorHitTest(rect.width / 2, rect.height / 2);
      if (midHit) this.centerScreenZ = midHit.z;
    }

    if (this.selectedSeatNode && this.centerScreenZ !== 0) {
      const seatZ = this.selectedSeatNode.group.position.z;
      let nextNavState = 'hide';
      if (seatZ > this.centerScreenZ - newZ + 3) {
        nextNavState = 'bottom';
      } else if (seatZ < this.centerScreenZ - newZ - 4) {
        nextNavState = 'top';
      }
      if (nextNavState !== this.seatNavigationState) {
        this.seatNavigationState = nextNavState;
        const seatName = this.selectedSeatNode.reservableEntity?.name || 'selected';
        if (nextNavState === 'top') {
          this.onBadgeUpdate({
            type: 'nav',
            message: `↑ Your ${seatName} seat is up there.`,
            visible: true
          });
        } else if (nextNavState === 'bottom') {
          this.onBadgeUpdate({
            type: 'nav',
            message: `↓ Your ${seatName} seat is down there.`,
            visible: true
          });
        } else {
          this.onBadgeUpdate({ type: 'nav', visible: false });
        }
      }
    }
  }

  animateContentZ(targetZ, durationSec, timingFn = TimingFunctions.easeOut, reportOverscroll = true) {
    if (this.activeAnimCancel) this.activeAnimCancel();
    const startZ = this.currentContentZ;
    const startTime = performance.now();
    const durMs = Math.max(durationSec * 1000, 16);
    let cancelled = false;
    this.activeAnimCancel = () => {
      cancelled = true;
    };

    const step = (now) => {
      if (cancelled || this.isDisposed) return;
      const rawT = Math.min((now - startTime) / durMs, 1);
      const easedT = timingFn(rawT);
      const z = startZ + (targetZ - startZ) * easedT;
      this.setCurrentContentZ(z, reportOverscroll);
      if (rawT < 1) {
        requestAnimationFrame(step);
      } else {
        this.activeAnimCancel = null;
      }
    };
    requestAnimationFrame(step);
  }

  scrollToSelectedSeat() {
    if (!this.selectedSeatNode) return;
    this.animateContentNodeToZPosition(this.selectedSeatNode.group.position.z);
  }

  animateContentNodeToZPosition(seatZ) {
    const rect = this.renderer.domElement.getBoundingClientRect();
    const centerHit = this.positionOfFloorHitTest(rect.width / 2, rect.height / 2);
    const centerZ = centerHit ? centerHit.z : -5.0;
    const targetZ = Math.max(
      this.contentZPositionLimit.lower,
      Math.min(this.contentZPositionLimit.upper, -seatZ + centerZ)
    );
    this.animateContentZ(targetZ, 0.7, TimingFunctions.easeOut);
  }

  setupContent(seatMap, currentEntity, fromStation, toStation) {
    const factory = NodeFactory.shared;
    if (!factory || !factory.isLoaded) return;

    // Clear previous content
    while (this.contentNode.children.length > 0) {
      this.contentNode.remove(this.contentNode.children[0]);
    }
    if (this.stationDirectionNode) {
      this.scene.remove(this.stationDirectionNode);
      this.stationDirectionNode = null;
    }
    this.interactiveSeatMeshes = [];
    this.selectedSeatNode = null;
    this.highlightedSeatNode = null;
    this.seatNavigationState = 'hide';

    // 1. Place global static nodes (SeatMap.transformedModelEntities)
    for (const tme of seatMap.transformedModelEntities) {
      const inst = factory.createInstance(tme.modelEntity);
      if (inst) {
        inst.setTransformedModelEntity(tme);
        inst.setStaticEnabled(true);
        this.contentNode.add(inst.group);
      }
    }

    // 2. Place SeatClassEntities (current entity first)
    const entities = [...seatMap.seatClassEntities];
    const currentIdx = entities.findIndex((e) => e.seatClass === currentEntity.seatClass);
    if (currentIdx > 0) {
      const [curr] = entities.splice(currentIdx, 1);
      entities.unshift(curr);
    }

    for (const sce of entities) {
      const isCurrent = sce.seatClass === currentEntity.seatClass;
      if (isCurrent) {
        const r0 = sce.viewableRange[0].z;
        const r1 = sce.viewableRange[1].z;
        this.contentZPositionLimit = {
          lower: Math.min(r0, r1),
          upper: Math.max(r0, r1)
        };
      }

      // Static sections for this car
      for (const tme of sce.transformedModelEntities) {
        const inst = factory.createInstance(tme.modelEntity);
        if (inst) {
          inst.setTransformedModelEntity(tme);
          inst.setStaticEnabled(isCurrent);
          this.contentNode.add(inst.group);
        }
      }

      // Reservable seats for this car
      for (const rev of sce.reservableEntities) {
        const inst = factory.createInstance(rev.transformedModelEntity.modelEntity);
        if (inst) {
          inst.setReservableEntity(rev);
          inst.isEnabled = Boolean(rev.isAvailable && isCurrent);
          inst.updateInteractiveState(false);
          this.contentNode.add(inst.group);

          if (inst.isEnabled) {
            inst.group.traverse((ch) => {
              if (ch.isMesh) this.interactiveSeatMeshes.push(ch);
            });
          }
        }
      }
    }

    // 3. Place 3D row number TextNodes
    for (const tNode of seatMap.transformedTextModelEntities) {
      const group = createTextNode({
        text: tNode.text,
        fontSize: tNode.font?.size || 0.2,
        fontWeight: '800',
        textAlignment: tNode.textAlignment || 'center',
        color: '#909095',
        position: tNode.position,
        rotation: tNode.rotation
      });
      this.contentNode.add(group);
      this.textNodes.push(group);
    }

    // 4. Station direction label node in scene root
    const dirText = `${toStation ? `← ${toStation}` : ''}${fromStation ? `     ${fromStation} →` : ''}`;
    this.stationDirectionNode = createTextNode({
      text: dirText,
      fontSize: 0.5,
      fontWeight: '300',
      textAlignment: 'right',
      color: '#909095',
      position: { x: -3.15, y: 1.2, z: -13 },
      rotation: { x: 0, y: Math.PI / 2, z: 0 }
    });
    this.scene.add(this.stationDirectionNode);

    // 5. Play initial animation (SeatMapSceneView.playInitialAnimation)
    const { lower, upper } = this.contentZPositionLimit;
    this.setCurrentContentZ(lower, false);
    const duration = (Math.abs(upper) - Math.abs(lower)) / 100 + 0.5;
    const targetZ = (lower * 2 + upper) / 3;
    this.animateContentZ(targetZ, duration, TimingFunctions.explodingEaseOut, false);
  }

  hitTestSeat(localX, localY) {
    const rect = this.renderer.domElement.getBoundingClientRect();
    const w = Math.max(rect.width, 1);
    const h = Math.max(rect.height, 1);
    const ndc = new THREE.Vector2((localX / w) * 2 - 1, -(localY / h) * 2 + 1);
    this.raycaster.setFromCamera(ndc, this.camera);
    const hits = this.raycaster.intersectObjects(this.interactiveSeatMeshes, false);
    if (hits.length > 0) {
      const inst = hits[0].object.userData.scnInstance;
      if (inst && inst.isEnabled) return inst;
    }
    return null;
  }

  setupInteraction() {
    const dom = this.renderer.domElement;
    let isPointerDown = false;
    let startClientX = 0;
    let startClientY = 0;
    let isDragging = false;
    let hitStart = null;
    let contentZStart = 0;

    const getLocalCoords = (e) => {
      const rect = dom.getBoundingClientRect();
      return {
        x: e.clientX - rect.left,
        y: e.clientY - rect.top
      };
    };

    dom.addEventListener('pointerdown', (e) => {
      if (e.button !== undefined && e.button !== 0) return;
      if (this.activeAnimCancel) {
        this.activeAnimCancel();
        this.activeAnimCancel = null;
      }
      isPointerDown = true;
      isDragging = false;
      startClientX = e.clientX;
      startClientY = e.clientY;
      dom.setPointerCapture?.(e.pointerId);

      const local = getLocalCoords(e);
      hitStart = this.positionOfFloorHitTest(local.x, local.y);
      contentZStart = this.currentContentZ;

      const seatInst = this.hitTestSeat(local.x, local.y);
      if (seatInst) {
        this.highlightedSeatNode = seatInst;
        seatInst.isHighlighted = true;
        seatInst.updateInteractiveState(true);
      }
    });

    dom.addEventListener('pointermove', (e) => {
      if (!isPointerDown) return;
      const dx = e.clientX - startClientX;
      const dy = e.clientY - startClientY;
      if (!isDragging && Math.hypot(dx, dy) > 6) {
        isDragging = true;
        if (this.highlightedSeatNode) {
          this.highlightedSeatNode.isHighlighted = false;
          this.highlightedSeatNode.updateInteractiveState(true);
          this.highlightedSeatNode = null;
        }
      }

      if (isDragging && hitStart) {
        const local = getLocalCoords(e);
        const hitNow = this.positionOfFloorHitTest(local.x, local.y);
        if (hitNow) {
          const zPos = this.zPositionClamp(hitNow.z - hitStart.z + contentZStart);
          this.setCurrentContentZ(zPos, true);
        }
      }
    });

    const endPointer = (e) => {
      if (!isPointerDown) return;
      isPointerDown = false;
      try {
        dom.releasePointerCapture?.(e.pointerId);
      } catch (_) {}

      if (!isDragging && this.highlightedSeatNode) {
        const picked = this.highlightedSeatNode;
        picked.isHighlighted = false;
        this.highlightedSeatNode = null;

        const prevSelected = this.selectedSeatNode;
        if (prevSelected && prevSelected !== picked) {
          prevSelected.isSelected = false;
          prevSelected.updateInteractiveState(true);
        }
        this.selectedSeatNode = picked;
        picked.isSelected = true;
        picked.updateInteractiveState(true);

        if (picked.reservableEntity) {
          this.onSeatSelected(picked.reservableEntity);
          if (prevSelected !== picked) {
            const msg = `Seat ${picked.reservableEntity.name} in ${picked.reservableEntity.carNumber.toLowerCase()} has been selected.`;
            this.onBadgeUpdate({
              type: 'selected',
              message: msg,
              visible: true,
              autoHideMs: 4000
            });
          }
        }
        this.animateContentNodeToZPosition(picked.group.position.z);
        return;
      }

      if (this.highlightedSeatNode) {
        this.highlightedSeatNode.isHighlighted = false;
        this.highlightedSeatNode.updateInteractiveState(true);
        this.highlightedSeatNode = null;
      }

      // Inertia drift (DecayFunction.swift)
      let currentVelocity = { x: 0, y: this.perspectiveVelocity || 0 };
      const totalDuration = DecayFunction.timeToHalt(currentVelocity);
      if (totalDuration > 0.02) {
        let lastTime = performance.now();
        let cancelled = false;
        this.activeAnimCancel = () => {
          cancelled = true;
        };
        const driftTick = (now) => {
          if (cancelled || this.isDisposed) return;
          const dt = Math.min((now - lastTime) / 1000, 0.05);
          lastTime = now;
          const stepRes = DecayFunction.step(dt, currentVelocity);
          currentVelocity = stepRes.velocity;
          const newZ = this.currentContentZ + stepRes.displacement.y;
          const clampedAvg = (newZ + this.zPositionClamp(newZ)) / 2;
          this.setCurrentContentZ(clampedAvg, true);

          if (Math.abs(currentVelocity.y) > 0.15) {
            requestAnimationFrame(driftTick);
          } else {
            this.snapBackIfNeeded();
          }
        };
        requestAnimationFrame(driftTick);
      } else {
        this.snapBackIfNeeded();
      }
    };

    dom.addEventListener('pointerup', endPointer);
    dom.addEventListener('pointercancel', endPointer);

    // Wheel support for desktop trackpads/mice
    dom.addEventListener(
      'wheel',
      (e) => {
        e.preventDefault();
        if (this.activeAnimCancel) {
          this.activeAnimCancel();
          this.activeAnimCancel = null;
        }
        const deltaZ = e.deltaY * 0.03;
        const { lower, upper } = this.contentZPositionLimit;
        const nextZ = Math.max(lower, Math.min(upper, this.currentContentZ + deltaZ));
        this.setCurrentContentZ(nextZ, false);
      },
      { passive: false }
    );
  }

  snapBackIfNeeded() {
    const { lower, upper } = this.contentZPositionLimit;
    if (this.currentContentZ < lower || this.currentContentZ > upper) {
      const target = Math.max(lower, Math.min(upper, this.currentContentZ));
      this.animateContentZ(target, 0.3, TimingFunctions.easeOut, true);
    } else {
      this.onOverscrollUpper({ x: 0, y: 0 });
    }
  }

  startRenderLoop() {
    const render = () => {
      if (this.isDisposed) return;
      this.renderer.render(this.scene, this.camera);
      requestAnimationFrame(render);
    };
    requestAnimationFrame(render);
  }

  dispose() {
    this.isDisposed = true;
    this.resizeObserver?.disconnect();
  }
}

// ============================================================================
// SummaryPreviewView.swift Port (BookingConfirmationViewController)
// ============================================================================
export class SummaryPreviewView {
  constructor(containerEl) {
    this.container = containerEl;
    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0xffffff);

    // setupCamera() from SummaryPreviewView.swift
    this.cameraControlNode = new THREE.Group();
    this.cameraControlNode.position.set(0, 0.75, 0);

    this.camera = new THREE.PerspectiveCamera(16, 1, 0.5, 50);
    this.camera.position.set(0, 0.25, 8);
    this.camera.rotation.set(-0.0312398336827755, 0, 0, 'ZYX');

    this.cameraControlNode.add(this.camera);
    this.scene.add(this.cameraControlNode);

    this.contentNode = new THREE.Group();
    this.scene.add(this.contentNode);

    this.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: false });
    this.renderer.outputColorSpace = THREE.LinearSRGBColorSpace;
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    this.container.appendChild(this.renderer.domElement);

    this.isDisposed = false;
    this.setupResizeObserver();
    this.setupGesture();
    this.startRenderLoop();
  }

  setupResizeObserver() {
    this.updateSize = () => {
      if (this.isDisposed) return;
      const rect = this.container.getBoundingClientRect();
      if (rect.width < 2 || rect.height < 2) return;
      const w = rect.width;
      const h = rect.height;
      this.camera.aspect = w / h;
      this.camera.updateProjectionMatrix();
      this.renderer.setSize(w, h, false);
    };
    this.resizeObserver = new ResizeObserver(this.updateSize);
    this.resizeObserver.observe(this.container);
    this.updateSize();
  }

  setTheme(isDark) {
    if (isDark) {
      this.scene.background = new THREE.Color().setRGB(46 / 255, 46 / 255, 46 / 255, THREE.LinearSRGBColorSpace);
    } else {
      this.scene.background = new THREE.Color().setRGB(1, 1, 1, THREE.LinearSRGBColorSpace);
    }
  }

  setupContent(seatClassType) {
    while (this.contentNode.children.length > 0) {
      this.contentNode.remove(this.contentNode.children[0]);
    }
    const completeMap = {
      granClass: '_e7_gran_seat_complete',
      green: '_e7_green_seat_complete',
      ordinary: '_e7_ordinary_seat_complete'
    };
    const modelName = completeMap[seatClassType] || '_e7_ordinary_seat_complete';
    const inst = NodeFactory.shared?.createInstance(modelName);
    if (inst) {
      inst.group.position.set(0, 0, 0);
      inst.group.rotation.set(0, -Math.PI / 6, 0, 'ZYX');
      this.contentNode.add(inst.group);
    }
    this.playInitialAnimation();
  }

  playInitialAnimation() {
    this.contentNode.scale.set(0.1, 0.1, 0.1);
    this.contentNode.rotation.set(0, Math.PI * 1.5, 0);

    const dur1 = 0.35 * 1.5 * 1000;
    const dur2 = (0.35 / 1.5) * 1000;
    const t0 = performance.now();

    const step1 = (now) => {
      if (this.isDisposed) return;
      const p = Math.min((now - t0) / dur1, 1);
      const e = TimingFunctions.explodingEaseOut(p);
      const s = 0.1 + (1.066 - 0.1) * e;
      const ry = Math.PI * 1.5 + (Math.PI * -0.066 - Math.PI * 1.5) * e;
      this.contentNode.scale.set(s, s, s);
      this.contentNode.rotation.y = ry;
      if (p < 1) {
        requestAnimationFrame(step1);
      } else {
        const t1 = performance.now();
        const step2 = (now2) => {
          if (this.isDisposed) return;
          const p2 = Math.min((now2 - t1) / dur2, 1);
          const e2 = TimingFunctions.summaryBounceEnd(p2);
          const s2 = 1.066 + (1.0 - 1.066) * e2;
          const ry2 = Math.PI * -0.066 * (1 - e2);
          this.contentNode.scale.set(s2, s2, s2);
          this.contentNode.rotation.y = ry2;
          if (p2 < 1) requestAnimationFrame(step2);
        };
        requestAnimationFrame(step2);
      }
    };
    requestAnimationFrame(step1);
  }

  setupGesture() {
    const dom = this.renderer.domElement;
    let isDown = false;
    let startX = 0;

    dom.addEventListener('pointerdown', (e) => {
      isDown = true;
      startX = e.clientX;
      dom.setPointerCapture?.(e.pointerId);
    });

    dom.addEventListener('pointermove', (e) => {
      if (!isDown) return;
      const rect = dom.getBoundingClientRect();
      const maxDim = Math.max(rect.width, rect.height, 1);
      const translatePercentage = (e.clientX - startX) / maxDim;
      this.contentNode.rotation.y = translatePercentage * (Math.PI / 2);
    });

    const onEnd = (e) => {
      if (!isDown) return;
      isDown = false;
      try {
        dom.releasePointerCapture?.(e.pointerId);
      } catch (_) {}
      const startRy = this.contentNode.rotation.y;
      const durMs = Math.max((Math.abs(startRy) / Math.PI) * 1000, 120);
      const t0 = performance.now();
      const springBack = (now) => {
        if (this.isDisposed || isDown) return;
        const p = Math.min((now - t0) / durMs, 1);
        const e = TimingFunctions.default(p);
        this.contentNode.rotation.y = startRy * (1 - e);
        if (p < 1) requestAnimationFrame(springBack);
      };
      requestAnimationFrame(springBack);
    };

    dom.addEventListener('pointerup', onEnd);
    dom.addEventListener('pointercancel', onEnd);
  }

  startRenderLoop() {
    const render = () => {
      if (this.isDisposed) return;
      this.renderer.render(this.scene, this.camera);
      requestAnimationFrame(render);
    };
    requestAnimationFrame(render);
  }
}

// ============================================================================
// DesignSystemModel3DContentView.swift Port
// ============================================================================
export class DesignSystem3DView {
  constructor(containerEl, onLabelChange) {
    this.container = containerEl;
    this.onLabelChange = onLabelChange || (() => {});
    this.scene = new THREE.Scene();

    this.camera = new THREE.PerspectiveCamera(45, 1, 0.1, 100);
    this.contentNode = new THREE.Group();
    this.scene.add(this.contentNode);

    this.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    this.renderer.outputColorSpace = THREE.LinearSRGBColorSpace;
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
    this.container.appendChild(this.renderer.domElement);

    this.availableModels = [];
    this.currentIndex = 0;
    this.currentInstance = null;
    this.currentState = 'normal';
    this.orbitAngles = { yaw: 0, pitch: 0 };
    this.targetCenter = new THREE.Vector3();
    this.baseCamOffset = new THREE.Vector3(0, 1, 3);

    this.setupResizeObserver();
    this.setupOrbitGesture();
    this.startRenderLoop();
  }

  setupResizeObserver() {
    this.updateSize = () => {
      const rect = this.container.getBoundingClientRect();
      if (rect.width < 2 || rect.height < 2) return;
      const w = rect.width;
      const h = rect.height;
      this.camera.aspect = w / h;
      this.camera.updateProjectionMatrix();
      this.renderer.setSize(w, h, false);
    };
    this.resizeObserver = new ResizeObserver(this.updateSize);
    this.resizeObserver.observe(this.container);
    this.updateSize();
  }

  initModels() {
    const factory = NodeFactory.shared;
    if (!factory || !factory.isLoaded) return;
    this.availableModels = Object.keys(factory.modelsMeta).sort();
    this.showModelAtIndex(0);
  }

  showModelAtIndex(idx) {
    if (this.availableModels.length === 0) return;
    if (idx >= this.availableModels.length) idx = 0;
    if (idx < 0) idx = this.availableModels.length - 1;
    this.currentIndex = idx;

    while (this.contentNode.children.length > 0) {
      this.contentNode.remove(this.contentNode.children[0]);
    }

    const name = this.availableModels[idx];
    const inst = NodeFactory.shared.createInstance(name);
    if (!inst) return;
    this.currentInstance = inst;
    this.applyStateToCurrent(false);
    this.contentNode.add(inst.group);

    const firstChildName = inst.meta?.rootNode?.name || name;
    this.onLabelChange(firstChildName);

    const bs = inst.meta?.boundingSphere || { center: [0, 0.5, 0], radius: 1.5 };
    const center = new THREE.Vector3(...bs.center);
    const radius = Math.max(bs.radius, 0.5);
    this.targetCenter.copy(center);
    this.baseCamOffset.set(-radius * 0.75, radius, radius * 3);
    this.orbitAngles = { yaw: 0, pitch: 0 };
    this.updateOrbitCamera();
  }

  updateOrbitCamera() {
    const offset = this.baseCamOffset.clone();
    const euler = new THREE.Euler(this.orbitAngles.pitch, this.orbitAngles.yaw, 0, 'YXZ');
    offset.applyEuler(euler);
    this.camera.position.copy(this.targetCenter).add(offset);
    this.camera.lookAt(this.targetCenter);
  }

  setState(stateName) {
    this.currentState = stateName;
    this.applyStateToCurrent(true);
  }

  applyStateToCurrent(animated = true) {
    if (!this.currentInstance) return;
    this.currentInstance.isEnabled = this.currentState !== 'disabled';
    this.currentInstance.isSelected = this.currentState === 'selected';
    this.currentInstance.isHighlighted = this.currentState === 'highlighted';
    this.currentInstance.updateInteractiveState(animated);
  }

  nextModel() {
    this.showModelAtIndex(this.currentIndex + 1);
  }

  prevModel() {
    this.showModelAtIndex(this.currentIndex - 1);
  }

  setupOrbitGesture() {
    const dom = this.renderer.domElement;
    let isDown = false;
    let lastX = 0;
    let lastY = 0;

    dom.addEventListener('pointerdown', (e) => {
      isDown = true;
      lastX = e.clientX;
      lastY = e.clientY;
      dom.setPointerCapture?.(e.pointerId);
    });

    dom.addEventListener('pointermove', (e) => {
      if (!isDown) return;
      const dx = e.clientX - lastX;
      const dy = e.clientY - lastY;
      lastX = e.clientX;
      lastY = e.clientY;
      this.orbitAngles.yaw -= dx * 0.01;
      this.orbitAngles.pitch = Math.max(-1.2, Math.min(1.2, this.orbitAngles.pitch - dy * 0.01));
      this.updateOrbitCamera();
    });

    const end = (e) => {
      isDown = false;
      try {
        dom.releasePointerCapture?.(e.pointerId);
      } catch (_) {}
    };
    dom.addEventListener('pointerup', end);
    dom.addEventListener('pointercancel', end);
  }

  startRenderLoop() {
    const render = () => {
      this.renderer.render(this.scene, this.camera);
      requestAnimationFrame(render);
    };
    requestAnimationFrame(render);
  }
}

