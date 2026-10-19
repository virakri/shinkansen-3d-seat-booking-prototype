import {
  NodeFactory,
  SeatMapSceneView,
  SummaryPreviewView,
  DesignSystem3DView
} from './scenekit-engine.js';

// ============================================================================
// Exact Vector Icons from Assets.xcassets
// ============================================================================
const ICONS = {
  checked: `<svg viewBox="0 0 24 24" width="24" height="24" fill="currentColor"><path d="M 12 21.753906 C 6.628906 21.753906 2.203125 17.320312 2.203125 11.957031 C 2.203125 6.597656 6.628906 2.164062 11.988281 2.164062 C 17.351562 2.164062 21.792969 6.597656 21.792969 11.957031 C 21.792969 17.320312 17.363281 21.753906 12 21.753906 Z M 10.867188 16.878906 C 11.121094 16.878906 11.335938 16.765625 11.5 16.511719 L 16.65625 8.453125 C 16.757812 8.296875 16.84375 8.121094 16.84375 7.957031 C 16.84375 7.582031 16.519531 7.359375 16.1875 7.359375 C 15.984375 7.359375 15.78125 7.476562 15.632812 7.71875 L 10.828125 15.316406 L 8.230469 12.113281 C 8.054688 11.882812 7.871094 11.800781 7.644531 11.800781 C 7.3125 11.800781 7.019531 12.066406 7.019531 12.4375 C 7.019531 12.605469 7.097656 12.789062 7.214844 12.9375 L 10.195312 16.519531 C 10.40625 16.78125 10.605469 16.878906 10.867188 16.878906 Z"/></svg>`,
  unchecked: `<svg viewBox="0 0 24 24" width="24" height="24" fill="currentColor"><path d="M 12 21.753906 C 6.628906 21.753906 2.203125 17.320312 2.203125 11.957031 C 2.203125 6.597656 6.628906 2.164062 11.988281 2.164062 C 17.351562 2.164062 21.792969 6.597656 21.792969 11.957031 C 21.792969 17.320312 17.363281 21.753906 12 21.753906 Z M 12 20.496094 C 16.71875 20.496094 20.535156 16.6875 20.523438 11.957031 C 20.523438 7.230469 16.71875 3.433594 11.988281 3.433594 C 7.265625 3.433594 3.472656 7.230469 3.472656 11.957031 C 3.472656 16.6875 7.273438 20.496094 12 20.496094 Z"/></svg>`,
  granClass: `<svg viewBox="0 0 48 48" width="100%" height="100%" fill="currentColor"><path fill-rule="evenodd" d="M 34.40625 22.929688 C 34.015625 20.226562 32.589844 17.757812 30.4375 16.066406 L 37.113281 4.5 L 47.753906 22.929688 Z M 17.316406 16.066406 C 15.164062 17.757812 13.738281 20.226562 13.347656 22.929688 L 0 22.929688 L 10.640625 4.5 Z M 23.878906 13.792969 C 22.519531 13.792969 21.171875 14.058594 19.914062 14.5625 L 13.238281 3 L 34.515625 3 L 27.839844 14.5625 C 26.582031 14.058594 25.234375 13.792969 23.878906 13.792969 Z M 23.878906 35.066406 C 25.234375 35.066406 26.582031 34.800781 27.839844 34.292969 L 34.515625 45.855469 L 13.238281 45.855469 L 19.914062 34.292969 C 21.171875 34.800781 22.519531 35.066406 23.878906 35.066406 Z M 13.347656 25.929688 C 13.738281 28.628906 15.164062 31.097656 17.316406 32.789062 L 10.640625 44.355469 L 0 25.929688 Z M 37.113281 44.355469 L 26.476562 25.929688 L 47.753906 25.929688 Z"/></svg>`,
  green: `<svg viewBox="0 0 48 48" width="100%" height="100%" fill="currentColor"><path fill-rule="evenodd" d="M 24 22.378906 L 10.449219 8.828125 C 9.28125 7.660156 8.953125 5.992188 9.582031 4.46875 C 10.214844 2.945312 11.628906 2 13.277344 2 L 34.722656 2 C 36.371094 2 37.785156 2.945312 38.417969 4.46875 C 39.046875 5.992188 38.71875 7.660156 37.550781 8.828125 Z M 8.828125 10.449219 L 22.378906 24 L 8.828125 37.550781 C 8.066406 38.308594 7.070312 38.726562 6.023438 38.726562 C 4.046875 38.726562 2 37.230469 2 34.722656 L 2 13.277344 C 2 10.769531 4.046875 9.269531 6.023438 9.269531 C 7.070312 9.269531 8.066406 9.6875 8.828125 10.449219 Z M 24 25.621094 L 37.550781 39.171875 C 38.71875 40.335938 39.046875 42.007812 38.417969 43.53125 C 37.785156 45.054688 36.371094 46 34.722656 46 L 13.277344 46 C 11.628906 46 10.214844 45.054688 9.582031 43.53125 C 8.953125 42.007812 9.28125 40.335938 10.449219 39.171875 Z M 41.972656 9.269531 C 43.953125 9.269531 46 10.769531 46 13.277344 L 46 34.722656 C 46 37.230469 43.953125 38.726562 41.972656 38.726562 C 40.925781 38.726562 39.929688 38.308594 39.171875 37.550781 L 25.621094 24 L 39.171875 10.449219 C 39.929688 9.6875 40.925781 9.269531 41.972656 9.269531 Z"/></svg>`,
  ordinary: `<svg viewBox="0 0 48 48" width="100%" height="100%" fill="currentColor"><path fill-rule="evenodd" d="M 40.882812 15.046875 L 30.738281 32.703125 L 32.355469 38.875 L 19.6875 38.875 L 17.617188 30.976562 L 27.175781 30.976562 L 37.460938 13.082031 C 38.007812 12.132812 39.222656 11.808594 40.167969 12.359375 C 41.105469 12.90625 41.421875 14.109375 40.882812 15.046875 Z M 11.972656 36.601562 L 7.824219 36.601562 L 14.761719 24.527344 C 15.183594 23.789062 15.96875 23.339844 16.8125 23.339844 L 21.253906 23.339844 L 24.199219 18.207031 C 25.070312 16.695312 27.003906 16.179688 28.507812 17.0625 C 29.996094 17.929688 30.503906 19.839844 29.644531 21.335938 L 25.53125 28.492188 L 16.628906 28.492188 Z M 30.199219 8.492188 C 32.230469 8.492188 33.875 10.140625 33.875 12.171875 C 33.875 14.199219 32.230469 15.84375 30.199219 15.84375 C 28.171875 15.84375 26.527344 14.199219 26.527344 12.171875 C 26.527344 10.140625 28.171875 8.492188 30.199219 8.492188 Z M 24 0 C 10.746094 0 0 10.746094 0 24 C 0 37.253906 10.746094 48 24 48 C 37.253906 48 48 37.253906 48 24 C 48 10.746094 37.253906 0 24 0 Z"/></svg>`
};

const ARROW_PATHS = {
  original: 'M 4 12 L 20 12 M 10 6 L 4 12 L 10 18',
  pushedForward: 'M 1 12 L 20 12 M 10 8 L 1 12 L 10 16',
  pullBack: 'M 8 12 L 20 12 M 12 4 L 8 12 L 12 20'
};

// ============================================================================
// Formatters (Formatter.swift & Date.swift)
// ============================================================================
const yenFormatter = new Intl.NumberFormat('ja-JP', {
  style: 'currency',
  currency: 'JPY',
  maximumFractionDigits: 0
});

export function formatYen(amount) {
  return yenFormatter.format(amount).replace('￥', '¥');
}

const fullDateFormatter = new Intl.DateTimeFormat('en-US', {
  month: 'long',
  day: 'numeric',
  year: 'numeric'
});

export function formatFullDate(date) {
  return fullDateFormatter.format(date);
}

const weekdayFormatter = new Intl.DateTimeFormat('en-US', {
  weekday: 'long'
});

export function formatWeekday(date) {
  return weekdayFormatter.format(date);
}

// Parse ISO8601 time in JST (+09:00) and format as HH:mm
export function getJSTComponents(isoString) {
  // e.g. "1970-01-01T06:12:00+09:00"
  const m = isoString.match(/T(\d{2}):(\d{2}):(\d{2})/);
  if (m) {
    return {
      hour: parseInt(m[1], 10),
      minute: parseInt(m[2], 10),
      second: parseInt(m[3], 10)
    };
  }
  const d = new Date(isoString);
  return { hour: d.getUTCHours(), minute: d.getUTCMinutes(), second: d.getUTCSeconds() };
}

export function formatTimeWithOffset(isoString, timeOffsetSec = 0) {
  const { hour, minute } = getJSTComponents(isoString);
  const totalMinutes = hour * 60 + minute + Math.round(timeOffsetSec / 60);
  const h = Math.floor(totalMinutes / 60) % 24;
  const m = totalMinutes % 60;
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
}

export function formatDurationOffset(fromIso, toIso) {
  const d1 = new Date(fromIso);
  const d2 = new Date(toIso);
  const diffMin = Math.round((d2 - d1) / 60000);
  const hrs = Math.floor(diffMin / 60);
  const mins = diffMin % 60;
  if (hrs > 0) return `${hrs} hr`;
  if (mins > 0) return `${mins} min`;
  return '';
}

function createSpinnerHTML() {
  return `<div class="ios-spinner-overlay"><div class="ios-spinner">${'<div></div>'.repeat(12)}</div></div>`;
}

// ============================================================================
// Application State & Controllers
// ============================================================================
class ShinkansenPrototypeApp {
  constructor() {
    this.colorTheme = localStorage.getItem('colorTheme') === 'dark' ? 'dark' : 'light';
    this.navStack = ['criteria'];
    this.isTransitioning = false;

    this.dateSelectedIndex = 0; // 0: Today, 1: Tomorrow, 2: Pick a Date
    this.timeSelectedIndex = 0; // 0: Morning, 1: Afternoon, 2: Evening
    this.dateOffsetSec = 0;
    this.timeOffsetSec = 0;

    this.headerInformation = {
      dayOfWeek: '',
      date: '',
      fromStation: 'Tokyo',
      toStation: 'Ōmiya',
      fromTime: null,
      toTime: null,
      trainNumber: null,
      trainName: null,
      carNumber: null,
      className: null,
      seatNumber: null,
      price: null
    };

    this.trainCriteriaData = null;
    this.filteredSchedules = [];
    this.selectedTrainIndex = null;
    this.selectedTrainSchedule = null;

    this.seatMapData = null;
    this.selectedSeatClassIndex = null;
    this.selectedSeatClass = null;
    this.selectedSeatClassEntity = null;
    this.selectedReservableEntity = null;

    this.seatMapSceneView = null;
    this.summaryPreviewView = null;
    this.ds3DView = null;
    this.badgeTimeout = null;
    this.errorTimeout = null;

    this.init();
  }

  async init() {
    this.applyTheme(this.colorTheme);
    this.setupInitialView();
    this.setupCriteriaView();
    this.setupNavigationInteractions();
    this.setupDesignSystemModal();

    // Preload 3D assets and JSON data in background
    NodeFactory.shared = new NodeFactory();
    NodeFactory.shared.load().then(() => {
      if (this.ds3DView) this.ds3DView.initModels();
    });
    this.preloadBookingData();
  }

  async preloadBookingData() {
    const [tcRes, smRes] = await Promise.all([
      fetch('assets/data/TrainCriteria.json'),
      fetch('assets/data/SeatMap.json')
    ]);
    this.trainCriteriaData = await tcRes.json();
    this.seatMapData = await smRes.json();
  }

  // ==========================================================================
  // Theme Management (Theme.swift)
  // ==========================================================================
  applyTheme(theme) {
    this.colorTheme = theme;
    localStorage.setItem('colorTheme', theme);
    document.documentElement.setAttribute('data-theme', theme);

    const isDark = theme === 'dark';
    const items = document.querySelectorAll('#initial-theme-segmented .initial-theme-item');
    items.forEach((item) => {
      const mode = item.getAttribute('data-theme-mode');
      const selected = mode === theme;
      item.classList.toggle('selected', selected);
      const checkEl = item.querySelector('[data-check-icon]');
      if (checkEl) checkEl.innerHTML = selected ? ICONS.checked : ICONS.unchecked;
    });

    if (this.seatMapSceneView) this.seatMapSceneView.setTheme(isDark);
    if (this.summaryPreviewView) this.summaryPreviewView.setTheme(isDark);
  }

  // ==========================================================================
  // 1. PrototypeInitialViewController
  // ==========================================================================
  setupInitialView() {
    const seg = document.getElementById('initial-theme-segmented');
    seg.querySelectorAll('.initial-theme-item').forEach((item) => {
      item.addEventListener('click', () => {
        const mode = item.getAttribute('data-theme-mode');
        this.applyTheme(mode);
      });
    });

    document.getElementById('btn-github').addEventListener('click', () => {
      window.open('https://github.com/virakri/shinkansen-tickets-booking-prototype', '_blank', 'noopener');
    });

    document.getElementById('btn-design-system').addEventListener('click', () => {
      document.getElementById('design-system-modal').classList.add('open');
      if (this.ds3DView && this.ds3DView.availableModels.length === 0 && NodeFactory.shared?.isLoaded) {
        this.ds3DView.initModels();
      }
    });

    document.getElementById('btn-start-prototype').addEventListener('click', () => {
      this.startPrototypeFlow();
    });
  }

  startPrototypeFlow() {
    const initialView = document.getElementById('initial-view');
    const bookingNav = document.getElementById('booking-nav-view');

    // Reset to criteria root screen
    this.navStack = ['criteria'];
    this.showOnlyScreen('criteria');
    this.reloadCriteriaDateAndTime();

    // PrototypeInitialViewControllerAnimatedTransition.swift (0.15s out + 0.6s in)
    initialView.style.transition = 'opacity 0.15s cubic-bezier(0.2, 0, 0, 1)';
    initialView.style.opacity = '0';

    setTimeout(() => {
      initialView.classList.add('hidden');
      bookingNav.classList.remove('hidden');
      bookingNav.style.opacity = '0';
      bookingNav.style.transition = 'opacity 0.6s cubic-bezier(0.2, 0, 0, 1)';
      requestAnimationFrame(() => {
        bookingNav.style.opacity = '1';
      });
    }, 150);
  }

  dismissPrototypeFlow() {
    const initialView = document.getElementById('initial-view');
    const bookingNav = document.getElementById('booking-nav-view');

    bookingNav.style.transition = 'opacity 0.15s cubic-bezier(0.2, 0, 0, 1)';
    bookingNav.style.opacity = '0';

    setTimeout(() => {
      bookingNav.classList.add('hidden');
      initialView.classList.remove('hidden');
      initialView.style.opacity = '0';
      initialView.style.transition = 'opacity 0.6s cubic-bezier(0.2, 0, 0, 1)';
      requestAnimationFrame(() => {
        initialView.style.opacity = '1';
      });
    }, 150);
  }

  // ==========================================================================
  // 2. BookingCriteriaViewController
  // ==========================================================================
  setupCriteriaView() {
    const showStationError = () => {
      this.showErrorMessage(
        "Oops! Changing station feature doesn't work as this prototype doesn't have it implemented yet."
      );
    };
    document.getElementById('from-station-card').addEventListener('click', showStationError);
    document.getElementById('to-station-card').addEventListener('click', showStationError);

    this.reloadCriteriaDateAndTime();

    document.getElementById('btn-search-tickets').addEventListener('click', () => {
      this.handleSearchTickets();
    });
  }

  reloadCriteriaDateAndTime() {
    const today = new Date();
    const tomorrow = new Date(today.getTime() + 86400 * 1000);

    const dateItems = [
      { title: 'Today', subtitle: formatFullDate(today), isEnabled: true },
      { title: 'Tomorrow', subtitle: formatFullDate(tomorrow), isEnabled: true },
      { title: 'Pick a Date', subtitle: ' ', isEnabled: true }
    ];

    this.renderSegmentedControl(
      document.getElementById('date-segmented-control'),
      dateItems,
      this.dateSelectedIndex,
      (newIdx) => {
        this.dateSelectedIndex = newIdx;
        if (newIdx === 2) {
          this.showErrorMessage(
            "Oops! Picking a particular date feature doesn't work as this prototype doesn't have it implemented yet."
          );
        }
        this.reloadTimeSegmentedControl();
      }
    );

    this.reloadTimeSegmentedControl();
  }

  reloadTimeSegmentedControl() {
    const dayShiftMs = this.dateSelectedIndex === 0 ? 0 : 86400 * 1000;
    const now = new Date();

    const makeBound = (hour) => {
      const d = new Date(now.getFullYear(), now.getMonth(), now.getDate(), hour, 0, 0, 0);
      return new Date(d.getTime() + dayShiftMs);
    };

    const morningEnd = makeBound(12);
    const afternoonEnd = makeBound(18);
    // Keep Evening enabled on Today up until 24:00
    const eveningEnd = makeBound(24);

    const timeItems = [
      { title: 'Morning', subtitle: '6:00 - 12:00', isEnabled: now < morningEnd },
      { title: 'Afternoon', subtitle: '12:00 - 18:00', isEnabled: now < afternoonEnd },
      { title: 'Evening', subtitle: '18:00 - 0:00', isEnabled: now < eveningEnd }
    ];

    if (!timeItems[this.timeSelectedIndex]?.isEnabled) {
      const firstEnabled = timeItems.findIndex((it) => it.isEnabled);
      this.timeSelectedIndex = firstEnabled !== -1 ? firstEnabled : 2;
    }

    this.renderSegmentedControl(
      document.getElementById('time-segmented-control'),
      timeItems,
      this.timeSelectedIndex,
      (newIdx) => {
        this.timeSelectedIndex = newIdx;
      }
    );
  }

  renderSegmentedControl(container, items, selectedIndex, onSelect) {
    container.innerHTML = '';
    items.forEach((item, idx) => {
      const isSelected = idx === selectedIndex && item.isEnabled;
      const itemEl = document.createElement('div');
      itemEl.className = `segmented-item${isSelected ? ' selected' : ''}${!item.isEnabled ? ' disabled' : ''}`;
      itemEl.innerHTML = `
        <div class="item-unselected-title text-headline">${item.title}</div>
        <div class="item-selected-stack">
          <div class="item-title text-headline">${item.title}</div>
          <div class="item-subtitle text-caption2">${item.subtitle}</div>
        </div>
      `;
      if (item.isEnabled) {
        itemEl.addEventListener('click', () => {
          container.querySelectorAll('.segmented-item').forEach((el, i) => {
            el.classList.toggle('selected', i === idx);
          });
          onSelect(idx);
        });
      }
      container.appendChild(itemEl);
    });
  }

  showErrorMessage(message, delayMs = 3000) {
    const banner = document.getElementById('error-banner');
    const textEl = document.getElementById('error-banner-text');
    textEl.textContent = message;
    banner.classList.add('visible');
    if (this.errorTimeout) clearTimeout(this.errorTimeout);
    this.errorTimeout = setTimeout(() => {
      banner.classList.remove('visible');
    }, delayMs);
  }

  handleSearchTickets() {
    if (this.dateSelectedIndex === 0) {
      this.dateOffsetSec = 0;
    } else if (this.dateSelectedIndex === 1) {
      this.dateOffsetSec = 86400;
    } else {
      this.dateOffsetSec = 86400 * 2;
    }

    if (this.timeSelectedIndex === 0) {
      this.timeOffsetSec = 0;
    } else if (this.timeSelectedIndex === 1) {
      this.timeOffsetSec = 6 * 3600;
    } else {
      this.timeOffsetSec = 12 * 3600;
    }

    const selectedDate = new Date(Date.now() + this.dateOffsetSec * 1000);
    this.headerInformation = {
      dayOfWeek: formatWeekday(selectedDate),
      date: formatFullDate(selectedDate),
      fromStation: 'Tokyo',
      toStation: 'Ōmiya',
      fromTime: null,
      toTime: null,
      trainNumber: null,
      trainName: null,
      carNumber: null,
      className: null,
      seatNumber: null,
      price: null
    };

    this.prepareTrainSelectionScreen();
    this.navigateTo('train-selection', true);
  }

  // ==========================================================================
  // 3. TrainSelectionViewController
  // ==========================================================================
  async prepareTrainSelectionScreen() {
    const screen = document.getElementById('screen-train-selection');
    this.syncHeaderToScreen(screen);

    const listEl = document.getElementById('train-schedule-list');
    listEl.innerHTML = createSpinnerHTML();

    if (!this.trainCriteriaData) {
      await this.preloadBookingData();
    }

    // Filter schedules matching TrainSelectionViewController.swift lines 21-27
    const now = new Date();
    const allSchedules = this.trainCriteriaData?.trainSchedules || [];
    let filtered = allSchedules.filter((sched) => {
      const comp = getJSTComponents(sched.fromTime);
      const schedDate = new Date(
        now.getFullYear(),
        now.getMonth(),
        now.getDate(),
        comp.hour,
        comp.minute,
        comp.second
      );
      const targetTime = new Date(schedDate.getTime() + (this.dateOffsetSec + this.timeOffsetSec) * 1000);
      return now < targetTime;
    });

    // If testing late at night between 23:32 and 24:00 when Today+Evening has passed, fallback to showing the schedules
    if (filtered.length === 0 && allSchedules.length > 0) {
      filtered = allSchedules;
    }

    this.filteredSchedules = filtered;
    listEl.innerHTML = '';

    filtered.forEach((sched, index) => {
      const granObj = sched.seatClasses.find((c) => c.seatClass === 'granClass');
      const greenObj = sched.seatClasses.find((c) => c.seatClass === 'green');
      const ordObj = sched.seatClasses.find((c) => c.seatClass === 'ordinary');

      const availPrices = [granObj, greenObj, ordObj].filter(Boolean).map((c) => c.price);
      const cheapest = availPrices.length > 0 ? Math.min(...availPrices) : null;

      const fromTimeStr = formatTimeWithOffset(sched.fromTime, this.timeOffsetSec);
      const toTimeStr = formatTimeWithOffset(sched.toTime, this.timeOffsetSec);
      const durationStr = formatDurationOffset(sched.fromTime, sched.toTime);

      const cell = document.createElement('div');
      cell.className = 'train-schedule-cell';
      cell.innerHTML = `
        <div class="card-control train-schedule-card interactive">
          <div class="card-content">
            <div class="train-cell-header">
              <div class="label-set-view align-left">
                <div class="ls-title text-headline">${fromTimeStr} – ${toTimeStr}</div>
                <div class="ls-subtitle text-caption2">${durationStr}</div>
              </div>
              <div class="label-set-view align-right">
                <div class="ls-title text-caption1">${sched.trainNumber}</div>
                <div class="ls-subtitle text-caption2">${sched.trainName}</div>
              </div>
            </div>
            <div class="train-cell-bottom">
              <div class="seat-class-icons-row">
                ${
                  granObj
                    ? `<span class="seat-class-icon size-small class-granClass${!granObj.isAvailable ? ' unavailable' : ''}">${ICONS.granClass}</span>`
                    : ''
                }
                ${
                  greenObj
                    ? `<span class="seat-class-icon size-small class-green${!greenObj.isAvailable ? ' unavailable' : ''}">${ICONS.green}</span>`
                    : ''
                }
                ${
                  ordObj
                    ? `<span class="seat-class-icon size-small class-ordinary${!ordObj.isAvailable ? ' unavailable' : ''}">${ICONS.ordinary}</span>`
                    : ''
                }
              </div>
              <div class="train-cell-price text-caption2">from ${cheapest ? formatYen(cheapest) : '-'}</div>
            </div>
            <img class="train-cell-image" src="assets/images/trains/${sched.trainImageName}.png" alt="${sched.trainName}" />
          </div>
        </div>
      `;

      // Staggered entrance animation (TrainSelectionViewController.viewDidAppear)
      const imgEl = cell.querySelector('.train-cell-image');
      cell.style.opacity = '0';
      cell.style.transform = `translateY(${24 * Math.min(index, 8)}px)`;
      if (imgEl) imgEl.style.transform = 'translateX(140px)';

      const dur = 0.05 * Math.min(index, 10) + 0.5;
      requestAnimationFrame(() => {
        requestAnimationFrame(() => {
          cell.style.transition = `opacity ${dur}s cubic-bezier(0.2, 0, 0, 1), transform ${dur}s cubic-bezier(0.2, 0, 0, 1)`;
          cell.style.opacity = '1';
          cell.style.transform = 'translateY(0)';
          if (imgEl) imgEl.style.transform = 'translateX(0)';
        });
      });

      cell.addEventListener('click', () => {
        this.handleSelectTrainSchedule(index, sched);
      });

      listEl.appendChild(cell);
    });

    this.attachScrollRubberBand(listEl, screen);
  }

  handleSelectTrainSchedule(index, sched) {
    this.selectedTrainIndex = index;
    this.selectedTrainSchedule = sched;

    this.headerInformation.fromTime = formatTimeWithOffset(sched.fromTime, this.timeOffsetSec);
    this.headerInformation.toTime = formatTimeWithOffset(sched.toTime, this.timeOffsetSec);
    this.headerInformation.trainNumber = sched.trainNumber;
    this.headerInformation.trainName = sched.trainName;
    this.headerInformation.carNumber = null;
    this.headerInformation.className = null;
    this.headerInformation.seatNumber = null;
    this.headerInformation.price = null;

    this.prepareSeatClassScreen();
    this.navigateTo('seat-class', true);
  }

  // ==========================================================================
  // 4. SeatClassSelectionViewController
  // ==========================================================================
  prepareSeatClassScreen() {
    const screen = document.getElementById('screen-seat-class');
    this.syncHeaderToScreen(screen);

    const trainImg = document.getElementById('seat-class-header-train-img');
    if (this.selectedTrainSchedule) {
      trainImg.src = `assets/images/trains/${this.selectedTrainSchedule.trainImageName}.png`;
      trainImg.alt = this.selectedTrainSchedule.trainName;
    }

    const listEl = document.getElementById('seat-class-list');
    listEl.innerHTML = '';

    const seatClasses = this.selectedTrainSchedule?.seatClasses || [];
    seatClasses.forEach((sc, index) => {
      const imgMap = {
        granClass: 'gran',
        green: 'green',
        ordinary: 'ordinary'
      };
      const seatImgName = imgMap[sc.seatClass] || 'ordinary';

      const cell = document.createElement('div');
      cell.className = 'seat-class-cell';
      cell.innerHTML = `
        <div class="card-control seat-class-card interactive">
          <div class="card-content">
            <div class="seat-class-left">
              <div class="seat-class-icon-wrap">
                <span class="seat-class-icon size-regular class-${sc.seatClass}">${ICONS[sc.seatClass] || ICONS.ordinary}</span>
              </div>
              <div class="seat-class-text-stack">
                <div class="label-set-view align-left">
                  <div class="ls-title text-headline">${sc.name}</div>
                  <div class="ls-subtitle text-caption2">${formatYen(sc.price)}</div>
                </div>
                <p class="seat-class-desc text-caption1">${sc.description}</p>
              </div>
            </div>
            <img class="seat-class-image" src="assets/images/seat-classes/${seatImgName}.png" alt="${sc.name}" />
          </div>
        </div>
      `;

      cell.addEventListener('click', () => {
        this.handleSelectSeatClass(index, sc);
      });

      listEl.appendChild(cell);
    });

    this.attachScrollRubberBand(listEl, screen);
  }

  async handleSelectSeatClass(index, seatClass) {
    this.selectedSeatClassIndex = index;
    this.selectedSeatClass = seatClass;

    if (!this.seatMapData) {
      await this.preloadBookingData();
    }
    if (!NodeFactory.shared.isLoaded) {
      await NodeFactory.shared.load();
    }

    const entity = this.seatMapData?.seatClassEntities?.find(
      (e) => e.seatClass === seatClass.seatClass
    );
    this.selectedSeatClassEntity = entity;
    this.selectedReservableEntity = null;

    this.headerInformation.carNumber = entity?.carNumber || '';
    this.headerInformation.className = seatClass.name;
    this.headerInformation.price = formatYen(seatClass.price);
    this.headerInformation.seatNumber = null;

    this.navigateTo('seat-map', true);
    this.prepareSeatMapScreen();
    this.seatMapSceneView?.updateSize?.();
  }

  // ==========================================================================
  // 5. SeatMapSelectionViewController
  // ==========================================================================
  prepareSeatMapScreen() {
    const screen = document.getElementById('screen-seat-map');
    this.syncHeaderToScreen(screen);

    const ctaBtn = document.getElementById('btn-seatmap-cta');
    ctaBtn.disabled = true;
    ctaBtn.textContent = 'Please Select a Seat';

    const badgeEl = document.getElementById('seatmap-heads-up-badge');
    badgeEl.classList.remove('visible');

    const canvasContainer = document.getElementById('seatmap-canvas-container');
    if (!this.seatMapSceneView) {
      this.seatMapSceneView = new SeatMapSceneView(canvasContainer, {
        onSeatSelected: (reservableEntity) => {
          this.handleSeatSelectedIn3D(reservableEntity);
        },
        onOverscrollUpper: (offset) => {
          this.handleSeatMapOverscroll(offset.y);
        },
        onBadgeUpdate: (badgeInfo) => {
          this.handleHeadsUpBadge(badgeInfo);
        }
      });
      this.seatMapSceneView.setTheme(this.colorTheme === 'dark');

      badgeEl.addEventListener('click', () => {
        this.seatMapSceneView?.scrollToSelectedSeat();
      });

      ctaBtn.addEventListener('click', () => {
        if (!this.selectedReservableEntity) return;
        this.handleContinueWithSeat();
      });
    }

    if (this.seatMapData && this.selectedSeatClassEntity) {
      this.seatMapSceneView.setupContent(
        this.seatMapData,
        this.selectedSeatClassEntity,
        this.headerInformation.fromStation,
        this.headerInformation.toStation
      );
    }
  }

  handleSeatSelectedIn3D(reservableEntity) {
    this.selectedReservableEntity = reservableEntity;

    const screen = document.getElementById('screen-seat-map');
    const carSetEl = document.getElementById('seatmap-car-set');
    if (this.headerInformation.carNumber !== reservableEntity.carNumber) {
      this.headerInformation.carNumber = reservableEntity.carNumber;
      carSetEl.style.opacity = '0';
      this.syncHeaderToScreen(screen);
      requestAnimationFrame(() => {
        carSetEl.style.transition = 'opacity 0.35s ease';
        carSetEl.style.opacity = '1';
      });
    }

    const ctaBtn = document.getElementById('btn-seatmap-cta');
    ctaBtn.disabled = false;
    const newTitle = `Continue with seat ${reservableEntity.name}`;
    if (ctaBtn.textContent !== newTitle) {
      ctaBtn.textContent = newTitle;
    }
  }

  handleHeadsUpBadge({ message, visible, autoHideMs }) {
    const badgeEl = document.getElementById('seatmap-heads-up-badge');
    if (this.badgeTimeout) {
      clearTimeout(this.badgeTimeout);
      this.badgeTimeout = null;
    }
    if (!visible) {
      badgeEl.classList.remove('visible');
      return;
    }
    badgeEl.textContent = message;
    badgeEl.classList.add('visible');
    if (autoHideMs > 0) {
      this.badgeTimeout = setTimeout(() => {
        badgeEl.classList.remove('visible');
      }, autoHideMs);
    }
  }

  handleSeatMapOverscroll(contentOffsetY) {
    const cardEl = document.getElementById('seatmap-card');
    const screen = document.getElementById('screen-seat-map');
    if (contentOffsetY < 0) {
      const clampedY = Math.max(contentOffsetY, -80);
      cardEl.style.transform = `translateY(${-clampedY}px)`;
      this.applyHeaderRubberBand(screen, clampedY);
    } else {
      cardEl.style.transform = 'translateY(0)';
      this.applyHeaderRubberBand(screen, 0);
    }
  }

  handleContinueWithSeat() {
    if (!this.selectedReservableEntity) return;
    this.headerInformation.seatNumber = this.selectedReservableEntity.name;
    this.headerInformation.carNumber = this.selectedReservableEntity.carNumber;
    this.headerInformation.price = formatYen(this.selectedSeatClass.price);

    this.navigateTo('confirmation', true);
    this.prepareConfirmationScreen();
    this.summaryPreviewView?.updateSize?.();
  }

  // ==========================================================================
  // 6. BookingConfirmationViewController
  // ==========================================================================
  prepareConfirmationScreen() {
    const screen = document.getElementById('screen-confirmation');
    this.syncHeaderToScreen(screen);

    const purchaseBtn = document.getElementById('btn-purchase-ticket');
    purchaseBtn.textContent = `Purchase this Ticket—${this.headerInformation.price || ''}`;

    const container = document.getElementById('summary-canvas-container');
    if (!this.summaryPreviewView) {
      this.summaryPreviewView = new SummaryPreviewView(container);
      this.summaryPreviewView.setTheme(this.colorTheme === 'dark');

      purchaseBtn.addEventListener('click', () => {
        this.displayAlertToDismiss(true);
      });
    }

    this.summaryPreviewView.setupContent(this.selectedSeatClassEntity?.seatClass || 'ordinary');
  }

  // ==========================================================================
  // Header Sync & RubberBand Effect (HeaderRouteInformationView.swift)
  // ==========================================================================
  syncHeaderToScreen(screenEl) {
    const h = this.headerInformation;
    const dateEl = screenEl.querySelector('[data-header-date]');
    if (dateEl) dateEl.textContent = `${h.dayOfWeek}, ${h.date}`;

    const fromSt = screenEl.querySelector('[data-from-station]');
    if (fromSt) fromSt.textContent = h.fromStation;

    const toSt = screenEl.querySelector('[data-to-station]');
    if (toSt) toSt.textContent = h.toStation;

    const fromTm = screenEl.querySelector('[data-from-time]');
    if (fromTm) {
      fromTm.textContent = h.fromTime || '';
      fromTm.classList.toggle('hidden', !h.fromTime);
    }

    const toTm = screenEl.querySelector('[data-to-time]');
    if (toTm) {
      toTm.textContent = h.toTime || '';
      toTm.classList.toggle('hidden', !h.toTime);
    }

    const trNum = screenEl.querySelector('[data-train-number]');
    if (trNum) trNum.textContent = h.trainNumber || '';

    const trName = screenEl.querySelector('[data-train-name]');
    if (trName) trName.textContent = h.trainName || '';

    const carNum = screenEl.querySelector('[data-car-number]');
    if (carNum) carNum.textContent = h.carNumber || '';

    const clsName = screenEl.querySelector('[data-class-name]');
    if (clsName) clsName.textContent = h.className || '';

    const seatNum = screenEl.querySelector('[data-seat-number]');
    if (seatNum) seatNum.textContent = h.seatNumber || '';

    const priceEl = screenEl.querySelector('[data-price]');
    if (priceEl) priceEl.textContent = h.price || '';
  }

  attachScrollRubberBand(scrollEl, screenEl) {
    scrollEl.onscroll = () => {
      const offsetY = scrollEl.scrollTop;
      if (offsetY < 0) {
        this.applyHeaderRubberBand(screenEl, offsetY);
      } else {
        this.applyHeaderRubberBand(screenEl, 0);
      }
    };
  }

  applyHeaderRubberBand(screenEl, contentOffsetY) {
    const stationPair = screenEl.querySelector('[data-station-pair]');
    const descSet = screenEl.querySelector('[data-desc-set]');
    if (contentOffsetY >= 0) {
      if (stationPair) stationPair.style.transform = 'translateY(0)';
      if (descSet) descSet.style.transform = 'translateY(0)';
      return;
    }
    if (stationPair) {
      stationPair.style.transform = `translateY(${-contentOffsetY * 0.25}px)`;
    }
    if (descSet) {
      descSet.style.transform = `translateY(${-contentOffsetY * 0.65}px)`;
    }
  }

  // ==========================================================================
  // Navigation & Seamless View Transitions (ViewControllerAnimatedTransitioning.swift)
  // ==========================================================================
  showOnlyScreen(screenKey) {
    const map = {
      criteria: 'screen-criteria',
      'train-selection': 'screen-train-selection',
      'seat-class': 'screen-seat-class',
      'seat-map': 'screen-seat-map',
      confirmation: 'screen-confirmation'
    };
    Object.entries(map).forEach(([key, id]) => {
      const el = document.getElementById(id);
      if (el) {
        el.classList.toggle('hidden', key !== screenKey);
        el.style.opacity = '1';
        el.style.transform = 'none';
      }
    });
  }

  navigateTo(targetKey, isPush = true) {
    if (this.isTransitioning) return;
    const currentKey = this.navStack[this.navStack.length - 1];
    if (currentKey === targetKey) return;

    if (isPush) {
      this.navStack.push(targetKey);
    } else {
      this.navStack.pop();
    }

    const map = {
      criteria: 'screen-criteria',
      'train-selection': 'screen-train-selection',
      'seat-class': 'screen-seat-class',
      'seat-map': 'screen-seat-map',
      confirmation: 'screen-confirmation'
    };

    const fromEl = document.getElementById(map[currentKey]);
    const toEl = document.getElementById(map[targetKey]);
    if (!fromEl || !toEl) {
      this.showOnlyScreen(targetKey);
      return;
    }

    this.isTransitioning = true;
    toEl.classList.remove('hidden');

    // Animate Back Button Path (BackButtonControl.swift)
    const toBackPath = toEl.querySelector('.back-arrow-path');
    if (toBackPath) {
      toBackPath.setAttribute('d', isPush ? ARROW_PATHS.pullBack : ARROW_PATHS.pushedForward);
      setTimeout(() => {
        toBackPath.setAttribute('d', ARROW_PATHS.original);
      }, 180);
    }

    // Screen-specific seamless transition choreography (0.6s cubic-bezier(0.2, 0, 0, 1))
    const dur = 600;
    const ease = 'cubic-bezier(0.2, 0, 0, 1)';

    fromEl.style.transition = `opacity ${dur * 0.45}ms ${ease}, transform ${dur}ms ${ease}`;
    toEl.style.transition = 'none';

    if (currentKey === 'seat-map' && targetKey === 'confirmation') {
      // Card slides down out while confirmation card slides down from top
      toEl.style.opacity = '0';
      toEl.style.transform = 'translateY(-48px)';
      requestAnimationFrame(() => {
        fromEl.style.opacity = '0';
        fromEl.style.transform = 'translateY(64px)';
        toEl.style.transition = `opacity ${dur}ms ${ease}, transform ${dur}ms ${ease}`;
        toEl.style.opacity = '1';
        toEl.style.transform = 'translateY(0)';
      });
    } else if (currentKey === 'confirmation' && targetKey === 'seat-map') {
      toEl.style.opacity = '0';
      toEl.style.transform = 'translateY(64px)';
      requestAnimationFrame(() => {
        fromEl.style.opacity = '0';
        fromEl.style.transform = 'translateY(-48px)';
        toEl.style.transition = `opacity ${dur}ms ${ease}, transform ${dur}ms ${ease}`;
        toEl.style.opacity = '1';
        toEl.style.transform = 'translateY(0)';
      });
    } else {
      const offsetY = isPush ? 36 : -36;
      toEl.style.opacity = '0';
      toEl.style.transform = `translateY(${offsetY}px)`;
      requestAnimationFrame(() => {
        fromEl.style.opacity = '0';
        fromEl.style.transform = `translateY(${-offsetY * 0.6}px)`;
        toEl.style.transition = `opacity ${dur * 0.75}ms ${ease} ${dur * 0.15}ms, transform ${dur}ms ${ease}`;
        toEl.style.opacity = '1';
        toEl.style.transform = 'translateY(0)';
      });
    }

    setTimeout(() => {
      fromEl.classList.add('hidden');
      fromEl.style.transition = '';
      fromEl.style.transform = '';
      fromEl.style.opacity = '1';
      toEl.style.transition = '';
      toEl.style.transform = '';
      toEl.style.opacity = '1';
      this.isTransitioning = false;
    }, dur + 50);
  }

  popScreen() {
    if (this.isTransitioning || this.navStack.length <= 1) return;
    const targetKey = this.navStack[this.navStack.length - 2];
    this.navigateTo(targetKey, false);
  }

  setupNavigationInteractions() {
    // Back buttons across all screens
    document.querySelectorAll('[data-back-btn]').forEach((btn) => {
      btn.addEventListener('click', () => {
        this.popScreen();
      });
    });

    // Left screen-edge pan gesture (InteractivePopOverlayView.swift)
    const bookingNav = document.getElementById('booking-nav-view');
    const popFade = document.getElementById('pop-bg-fade');
    const popBlob = document.getElementById('pop-blob');
    const popLabel = document.getElementById('pop-label');

    let edgeTouchActive = false;
    let startX = 0;

    bookingNav.addEventListener('pointerdown', (e) => {
      if (this.navStack.length <= 1 || this.isTransitioning) return;
      if (e.clientX <= 28) {
        edgeTouchActive = true;
        startX = e.clientX;
      }
    });

    bookingNav.addEventListener('pointermove', (e) => {
      if (!edgeTouchActive) return;
      const tx = Math.max(0, e.clientX - startX);
      const threshold = window.innerWidth / 5;
      const progress = Math.min(tx / threshold, 1);

      popFade.style.opacity = String(progress * 0.75);
      popBlob.style.opacity = String(progress * 0.54);
      popBlob.style.transform = `translateY(${e.clientY - window.innerHeight / 2}px) scale(${progress * 0.35}, 1)`;

      const isReady = tx > threshold;
      popLabel.style.opacity = isReady ? '1' : '0';
      popLabel.style.transform = `translate(${isReady ? '0' : '-50%'}, -50%)`;
    });

    const endEdgeSwipe = (e) => {
      if (!edgeTouchActive) return;
      edgeTouchActive = false;
      const tx = Math.max(0, e.clientX - startX);
      const threshold = window.innerWidth / 5;

      popFade.style.opacity = '0';
      popBlob.style.opacity = '0';
      popBlob.style.transform = 'scale(0, 1)';
      popLabel.style.opacity = '0';

      if (tx > threshold) {
        this.popScreen();
      }
    };

    bookingNav.addEventListener('pointerup', endEdgeSwipe);
    bookingNav.addEventListener('pointercancel', endEdgeSwipe);

    // ActionSheet Alert buttons
    document.getElementById('btn-alert-cancel').addEventListener('click', () => {
      document.getElementById('ios-alert-backdrop').classList.remove('visible');
    });

    document.getElementById('btn-alert-exit').addEventListener('click', () => {
      document.getElementById('ios-alert-backdrop').classList.remove('visible');
      this.dismissPrototypeFlow();
    });

    // Escape key or shake gesture triggers exit prompt (NavigationController.motionBegan)
    window.addEventListener('keydown', (e) => {
      const bookingVisible = !bookingNav.classList.contains('hidden');
      if (e.key === 'Escape' && bookingVisible) {
        this.displayAlertToDismiss(false);
      }
    });
  }

  displayAlertToDismiss(isEndOfPrototype = false) {
    const titleEl = document.getElementById('ios-alert-title');
    const msgEl = document.getElementById('ios-alert-message');
    if (isEndOfPrototype) {
      titleEl.textContent = "You're about to exit the Prototype.";
      msgEl.textContent = 'Are you sure you want to proceed this action?';
    } else {
      titleEl.textContent = 'This is the end of this prototype.';
      msgEl.textContent = 'Are you sure you want to exit the prototype?';
    }
    document.getElementById('ios-alert-backdrop').classList.add('visible');
  }

  // ==========================================================================
  // 7. DesignSystemViewController (DesignSystemPreviewer/*.swift)
  // ==========================================================================
  setupDesignSystemModal() {
    const modal = document.getElementById('design-system-modal');
    document.getElementById('btn-close-ds').addEventListener('click', () => {
      modal.classList.remove('open');
    });

    // Tab switching
    const tabBtns = document.querySelectorAll('#ds-tabbar .ds-tab-btn');
    const panes = document.querySelectorAll('#design-system-modal .ds-tab-pane');
    tabBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        const idx = btn.getAttribute('data-ds-tab');
        tabBtns.forEach((b) => b.classList.toggle('active', b === btn));
        panes.forEach((p) => p.classList.toggle('hidden', p.getAttribute('data-ds-pane') !== idx));
        if (idx === '4' && this.ds3DView) {
          requestAnimationFrame(() => {
            this.ds3DView.updateSize?.();
            if (this.ds3DView.availableModels.length === 0 && NodeFactory.shared?.isLoaded) {
              this.ds3DView.initModels();
            }
          });
        }
      });
    });

    this.populateDSComponents();
    this.populateDSColors();
    this.populateDSTextStyles();
    this.populateDSLayerStyles();
    this.setupDS3DAssets();
  }

  populateDSComponents() {
    const container = document.getElementById('ds-components-scroll');
    container.innerHTML = `
      <div class="ds-block">
        <div class="ds-block-header">Contained Button</div>
        <div style="padding:16px;display:flex;justify-content:center;">
          <button type="button" class="btn btn-contained text-button" style="width:auto;">Lorem Ipsum</button>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Outlined Button</div>
        <div style="padding:16px;display:flex;justify-content:center;">
          <button type="button" class="btn btn-outlined text-outlined-button">Lorem Ipsum</button>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Card</div>
        <div style="padding:16px;">
          <div class="card-control interactive" style="height:112px;"><div class="card-content"></div></div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Large Card</div>
        <div style="padding:16px;">
          <div class="card-control card-large interactive" style="height:112px;"><div class="card-content"></div></div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Segmented Card Control</div>
        <div style="padding:16px;">
          <div class="segmented-control" id="ds-demo-segmented"></div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Headline Label Set View</div>
        <div style="padding:16px;">
          <div class="headline-label-set align-left">
            <div class="text-large-title">Lorem ipsum dolor</div>
            <div class="text-subheadline">Lorem ipsum dolor</div>
          </div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Subheadline Label Set View</div>
        <div style="padding:16px;">
          <div class="subheadline-label-set align-left">
            <div class="sub-title text-headline">Lorem ipsum dolor</div>
            <div class="sub-subtitle text-caption1">Lorem ipsum dolor</div>
          </div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Label Set View Regular</div>
        <div style="padding:16px;">
          <div class="label-set-view align-left">
            <div class="ls-title text-headline">Lorem ipsum dolor</div>
            <div class="ls-subtitle text-caption2">Lorem ipsum dolor</div>
          </div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Label Set View Small</div>
        <div style="padding:16px;">
          <div class="label-set-view align-left">
            <div class="ls-title text-caption1">Lorem ipsum dolor</div>
            <div class="ls-subtitle text-caption2">Lorem ipsum dolor</div>
          </div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Station Pair View</div>
        <div style="padding:16px;">
          <div class="station-pair-view">
            <div class="headline-label-set align-left">
              <div class="text-large-title">Bangkok</div>
              <div class="text-subheadline">9:12</div>
            </div>
            <div class="station-to-label text-subheadline">to</div>
            <div class="headline-label-set align-right">
              <div class="text-large-title">Osaka</div>
              <div class="text-subheadline">12:43</div>
            </div>
          </div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Description Set View</div>
        <div style="padding:16px;">
          <div class="description-set-view">
            <div class="subheadline-label-set align-left">
              <div class="sub-title text-headline">Sakura 123</div>
              <div class="sub-subtitle text-caption1">E5 Series</div>
            </div>
            <div class="subheadline-label-set align-center">
              <div class="sub-title text-headline">Car 8</div>
              <div class="sub-subtitle text-caption1">GreenCar</div>
            </div>
            <div class="subheadline-label-set align-center">
              <div class="sub-title text-headline">15C</div>
              <div class="sub-subtitle text-caption1">&nbsp;</div>
            </div>
            <div class="subheadline-label-set align-right">
              <div class="sub-title text-headline">$14,200</div>
              <div class="sub-subtitle text-caption1">&nbsp;</div>
            </div>
          </div>
        </div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Train Schedule Table View Cell</div>
        <div style="padding:16px;">
          <div class="card-control train-schedule-card interactive">
            <div class="card-content">
              <div class="train-cell-header">
                <div class="label-set-view align-left">
                  <div class="ls-title text-headline">9:46 - 11:42</div>
                  <div class="ls-subtitle text-caption2">3hr 12min</div>
                </div>
                <div class="label-set-view align-right">
                  <div class="ls-title text-caption1">Hayabusa 231</div>
                  <div class="ls-subtitle text-caption2">E6 Series</div>
                </div>
              </div>
              <div class="train-cell-bottom">
                <div class="seat-class-icons-row">
                  <span class="seat-class-icon size-small class-granClass">${ICONS.granClass}</span>
                  <span class="seat-class-icon size-small class-green">${ICONS.green}</span>
                  <span class="seat-class-icon size-small class-ordinary">${ICONS.ordinary}</span>
                </div>
                <div class="train-cell-price text-caption2">$13,930</div>
              </div>
              <img class="train-cell-image" src="assets/images/trains/e7-series.png" alt="E7 Series" />
            </div>
          </div>
        </div>
      </div>
    `;

    this.renderSegmentedControl(
      document.getElementById('ds-demo-segmented'),
      [
        { title: 'Item 1', subtitle: 'Lorem Ipsum', isEnabled: true },
        { title: 'Item 2', subtitle: 'Lorem Ipsum', isEnabled: true },
        { title: 'Item 3', subtitle: 'Lorem Ipsum', isEnabled: true }
      ],
      0,
      () => {}
    );
  }

  populateDSColors() {
    const colors = [
      { title: 'Accent Main', color: '#008B3F' },
      { title: 'Accent Dark', color: '#076632' },
      { title: 'Accent Light', color: '#4BB77C' },
      { title: 'Basic Black', color: '#000000' },
      { title: 'Basic Off Black', color: '#212121' },
      { title: 'Basic Gray', color: '#909095' },
      { title: 'Basic Off White', color: '#FAFAFA' },
      { title: 'Basic White', color: '#FFFFFF' }
    ];
    const container = document.getElementById('ds-colors-scroll');
    container.innerHTML = colors
      .map(
        (c) => `
      <div class="ds-block">
        <div class="ds-block-header">${c.title}</div>
        <div class="ds-color-pill" style="background-color:${c.color};"></div>
      </div>
    `
      )
      .join('');
  }

  populateDSTextStyles() {
    const dummy =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
    const styles = [
      { title: 'Large Title', cls: 'text-large-title' },
      { title: 'Headline', cls: 'text-headline' },
      { title: 'Subheadline', cls: 'text-subheadline' },
      { title: 'Body', cls: 'text-body' },
      { title: 'Button', cls: 'text-button' },
      { title: 'Outlined Button', cls: 'text-outlined-button' },
      { title: 'Footnote', cls: 'text-footnote' },
      { title: 'Caption 1', cls: 'text-caption1' },
      { title: 'Caption 2', cls: 'text-caption2' }
    ];
    const container = document.getElementById('ds-textstyles-scroll');
    container.innerHTML = styles
      .map(
        (s) => `
      <div class="ds-block">
        <div class="ds-block-header">${s.title}</div>
        <div class="${s.cls}">${dummy}</div>
      </div>
    `
      )
      .join('');
  }

  populateDSLayerStyles() {
    const container = document.getElementById('ds-layerstyles-scroll');
    container.innerHTML = `
      <div class="ds-block">
        <div class="ds-block-header">Contained Button</div>
        <div class="ds-layer-box-wrap"><div class="ds-layer-box" data-layer-kind="button"></div></div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Outlined Button</div>
        <div class="ds-layer-box-wrap"><div class="ds-layer-box" data-layer-kind="outlined"></div></div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Card</div>
        <div class="ds-layer-box-wrap"><div class="ds-layer-box" data-layer-kind="card"></div></div>
      </div>
      <div class="ds-block">
        <div class="ds-block-header">Large Card</div>
        <div class="ds-layer-box-wrap"><div class="ds-layer-box" data-layer-kind="largeCard"></div></div>
      </div>
    `;

    const applyLayerState = (state) => {
      container.querySelectorAll('[data-layer-kind]').forEach((box) => {
        const kind = box.getAttribute('data-layer-kind');
        box.style.cssText = '';
        if (kind === 'button') {
          box.style.borderRadius = 'var(--radius-button)';
          box.style.backgroundColor =
            state === 'highlighted'
              ? 'var(--comp-call-to-action-highlighted)'
              : state === 'disabled'
              ? 'var(--comp-call-to-action-disabled)'
              : 'var(--comp-call-to-action)';
        } else if (kind === 'outlined') {
          box.style.border = `1px solid ${
            state === 'disabled' ? 'var(--comp-call-to-action-disabled)' : 'var(--comp-call-to-action)'
          }`;
          box.style.opacity = state === 'highlighted' ? 'var(--alpha-highlighted)' : '1';
        } else if (kind === 'card' || kind === 'largeCard') {
          box.style.borderRadius = kind === 'largeCard' ? 'var(--radius-large-card)' : 'var(--radius-card)';
          box.style.backgroundColor =
            state === 'disabled' ? 'var(--comp-card-disabled-background)' : 'var(--comp-card-background)';
          box.style.boxShadow =
            state === 'highlighted'
              ? 'var(--shadow-card-highlighted)'
              : state === 'disabled'
              ? 'var(--shadow-card-disabled)'
              : 'var(--shadow-card-normal)';
        }
      });
    };

    applyLayerState('normal');

    const segBtns = document.querySelectorAll('#ds-layer-state-seg .ios-segment-btn');
    segBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        segBtns.forEach((b) => b.classList.toggle('active', b === btn));
        applyLayerState(btn.getAttribute('data-layer-state'));
      });
    });
  }

  setupDS3DAssets() {
    const container = document.getElementById('ds-3d-canvas-container');
    const labelEl = document.getElementById('ds-3d-node-label');
    this.ds3DView = new DesignSystem3DView(container, (name) => {
      labelEl.textContent = name;
    });

    document.getElementById('ds-3d-prev').addEventListener('click', () => {
      this.ds3DView.prevModel();
    });
    document.getElementById('ds-3d-next').addEventListener('click', () => {
      this.ds3DView.nextModel();
    });

    const segBtns = document.querySelectorAll('#ds-3d-state-seg .ios-segment-btn');
    segBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        segBtns.forEach((b) => b.classList.toggle('active', b === btn));
        this.ds3DView.setState(btn.getAttribute('data-3d-state'));
      });
    });
  }
}

window.addEventListener('DOMContentLoaded', () => {
  window.app = new ShinkansenPrototypeApp();
});
