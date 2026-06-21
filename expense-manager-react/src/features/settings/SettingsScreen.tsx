import { useNavigate } from 'react-router-dom';
import { useSettingsStore } from '../../stores/settings-store';
import { ArrowLeft, Repeat, Bell, Info } from 'lucide-react';

const currencies = [
  { symbol: '₹', label: 'INR (₹)', locale: 'en-IN' },
  { symbol: '$', label: 'USD ($)', locale: 'en-US' },
  { symbol: '€', label: 'EUR (€)', locale: 'de-DE' },
  { symbol: '£', label: 'GBP (£)', locale: 'en-GB' },
  { symbol: '¥', label: 'JPY (¥)', locale: 'ja-JP' },
];

export default function SettingsScreen() {
  const navigate = useNavigate();
  const {
    themeMode,
    currencySymbol,
    ratesEndpoint,
    setThemeMode,
    setCurrencySymbol,
    setRatesEndpoint,
  } = useSettingsStore();

  const handleNotificationPermission = async () => {
    if ('Notification' in window) {
      const permission = await Notification.requestPermission();
      alert(
        permission === 'granted'
          ? 'Notifications enabled!'
          : 'Notifications blocked. Please enable in browser settings.'
      );
    } else {
      alert('Notifications not supported in this browser.');
    }
  };

  return (
    <div className="p-4 pb-24">
      <div className="flex items-center gap-3 mb-6">
        <button
          onClick={() => navigate(-1)}
          className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800"
        >
          <ArrowLeft className="w-5 h-5 text-gray-600 dark:text-gray-400" />
        </button>
        <h1 className="text-xl font-bold text-gray-900 dark:text-white">Settings</h1>
      </div>

      <div className="space-y-4">
        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase mb-3">
            Appearance
          </h3>
          <div className="space-y-2">
            {(['system', 'light', 'dark'] as const).map((mode) => (
              <label
                key={mode}
                className="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-750 cursor-pointer"
              >
                <input
                  type="radio"
                  name="theme"
                  checked={themeMode === mode}
                  onChange={() => setThemeMode(mode)}
                  className="w-4 h-4 text-primary focus:ring-primary"
                />
                <span className="text-sm text-gray-700 dark:text-gray-300 capitalize">
                  {mode === 'system' ? 'System Default' : mode}
                </span>
              </label>
            ))}
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase mb-3">
            Currency
          </h3>
          <div className="space-y-2">
            {currencies.map((curr) => (
              <label
                key={curr.symbol}
                className="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-750 cursor-pointer"
              >
                <input
                  type="radio"
                  name="currency"
                  checked={currencySymbol === curr.symbol}
                  onChange={() => setCurrencySymbol(curr.symbol, curr.locale)}
                  className="w-4 h-4 text-primary focus:ring-primary"
                />
                <span className="text-sm text-gray-700 dark:text-gray-300">{curr.label}</span>
              </label>
            ))}
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase mb-3">
            Automation
          </h3>

          <button
            onClick={() => navigate('/recurring')}
            className="w-full flex items-center justify-between p-3 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
          >
            <div className="flex items-center gap-3">
              <Repeat className="w-5 h-5 text-gray-500" />
              <span className="text-sm text-gray-700 dark:text-gray-300">
                Recurring Rules
              </span>
            </div>
            <span className="text-gray-400">›</span>
          </button>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase mb-3">
            Investment Rates
          </h3>
          <div>
            <label className="block text-sm text-gray-700 dark:text-gray-300 mb-2">
              Live Rates Endpoint (optional)
            </label>
            <input
              type="url"
              value={ratesEndpoint}
              onChange={(e) => setRatesEndpoint(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white text-sm"
              placeholder="https://api.example.com/rates"
            />
            <p className="text-xs text-gray-500 mt-1">
              JSON endpoint returning investment rates. Leave empty for bundled defaults.
            </p>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase mb-3">
            Notifications
          </h3>
          <button
            onClick={handleNotificationPermission}
            className="w-full flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
          >
            <Bell className="w-5 h-5 text-gray-500" />
            <span className="text-sm text-gray-700 dark:text-gray-300">
              Enable EMI Reminders
            </span>
          </button>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase mb-3">
            About
          </h3>
          <div className="flex items-center gap-3 p-3">
            <Info className="w-5 h-5 text-gray-500" />
            <div>
              <div className="text-sm font-medium text-gray-900 dark:text-white">
                Expense Manager
              </div>
              <div className="text-xs text-gray-500">Version 1.0.0</div>
            </div>
          </div>
          <p className="text-xs text-gray-500 px-3 mt-2">
            A private, offline-first personal finance app. All data is stored locally on your device.
          </p>
        </div>
      </div>
    </div>
  );
}
