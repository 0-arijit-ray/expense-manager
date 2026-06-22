import { useNavigate } from 'react-router-dom';
import { useSettingsStore } from '../../stores/settings-store';
import { Card, Button } from '../../components/ui';
import { ArrowLeft, Repeat, Bell, Info, Palette, DollarSign, Link, Tag } from 'lucide-react';

const currencies = [
  { symbol: '₹', label: 'Indian Rupee (₹)', locale: 'en-IN' },
  { symbol: '$', label: 'US Dollar ($)', locale: 'en-US' },
  { symbol: '€', label: 'Euro (€)', locale: 'de-DE' },
  { symbol: '£', label: 'British Pound (£)', locale: 'en-GB' },
  { symbol: '¥', label: 'Japanese Yen (¥)', locale: 'ja-JP' },
];

export default function SettingsScreen() {
  const navigate = useNavigate();
  const {
    themeMode,
    currencySymbol,
    ratesEndpoint,
    autoLabel,
    emiLabel,
    setThemeMode,
    setCurrencySymbol,
    setRatesEndpoint,
    setAutoLabel,
    setEmiLabel,
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
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => navigate(-1)}
          className="rounded-xl"
        >
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Settings
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Customize your experience
          </p>
        </div>
      </div>

      {/* Appearance */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-purple-100 dark:bg-purple-900/30 rounded-xl flex items-center justify-center">
            <Palette className="w-5 h-5 text-purple-600 dark:text-purple-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Appearance
          </h2>
        </div>
        <div className="space-y-2">
          {(['system', 'light', 'dark'] as const).map((mode) => (
            <label
              key={mode}
              className="flex items-center justify-between p-3 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-750 cursor-pointer transition-colors"
            >
              <span className="text-sm text-gray-700 dark:text-gray-300 capitalize">
                {mode === 'system' ? 'System Default' : mode}
              </span>
              <input
                type="radio"
                name="theme"
                checked={themeMode === mode}
                onChange={() => setThemeMode(mode)}
                className="w-4 h-4 text-primary focus:ring-primary"
              />
            </label>
          ))}
        </div>
      </Card>

      {/* Currency */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-green-100 dark:bg-green-900/30 rounded-xl flex items-center justify-center">
            <DollarSign className="w-5 h-5 text-green-600 dark:text-green-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Currency
          </h2>
        </div>
        <div className="space-y-2">
          {currencies.map((curr) => (
            <label
              key={curr.symbol}
              className="flex items-center justify-between p-3 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-750 cursor-pointer transition-colors"
            >
              <span className="text-sm text-gray-700 dark:text-gray-300">
                {curr.label}
              </span>
              <input
                type="radio"
                name="currency"
                checked={currencySymbol === curr.symbol}
                onChange={() => setCurrencySymbol(curr.symbol, curr.locale)}
                className="w-4 h-4 text-primary focus:ring-primary"
              />
            </label>
          ))}
        </div>
      </Card>

      {/* Automation */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-blue-100 dark:bg-blue-900/30 rounded-xl flex items-center justify-center">
            <Repeat className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Automation
          </h2>
        </div>
        <button
          onClick={() => navigate('/recurring')}
          className="w-full flex items-center justify-between p-3 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
        >
          <span className="text-sm text-gray-700 dark:text-gray-300">
            Recurring Rules
          </span>
          <span className="text-gray-400 dark:text-gray-500">›</span>
        </button>
      </Card>

      {/* Labels */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-teal-100 dark:bg-teal-900/30 rounded-xl flex items-center justify-center">
            <Tag className="w-5 h-5 text-teal-600 dark:text-teal-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Labels
          </h2>
        </div>
        <div className="space-y-4">
          <div>
            <label className="block text-sm text-gray-700 dark:text-gray-300 mb-2">
              Auto Tag Label
            </label>
            <input
              type="text"
              value={autoLabel}
              onChange={(e) => setAutoLabel(e.target.value)}
              className="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary focus:border-transparent"
              placeholder="Auto"
            />
            <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
              Label for recurring transactions
            </p>
          </div>
          <div>
            <label className="block text-sm text-gray-700 dark:text-gray-300 mb-2">
              EMI Tag Label
            </label>
            <input
              type="text"
              value={emiLabel}
              onChange={(e) => setEmiLabel(e.target.value)}
              className="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary focus:border-transparent"
              placeholder="EMI"
            />
            <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
              Label for EMI transactions
            </p>
          </div>
        </div>
      </Card>

      {/* Investment Rates */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-amber-100 dark:bg-amber-900/30 rounded-xl flex items-center justify-center">
            <Link className="w-5 h-5 text-amber-600 dark:text-amber-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Investment Rates
          </h2>
        </div>
        <div>
          <label className="block text-sm text-gray-700 dark:text-gray-300 mb-2">
            Live Rates Endpoint
          </label>
          <input
            type="url"
            value={ratesEndpoint}
            onChange={(e) => setRatesEndpoint(e.target.value)}
            className="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary focus:border-transparent"
            placeholder="https://api.example.com/rates"
          />
          <p className="text-xs text-gray-500 dark:text-gray-400 mt-2">
            JSON endpoint returning investment rates. Leave empty for bundled defaults.
          </p>
        </div>
      </Card>

      {/* Notifications */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center">
            <Bell className="w-5 h-5 text-red-600 dark:text-red-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Notifications
          </h2>
        </div>
        <Button
          variant="secondary"
          onClick={handleNotificationPermission}
          className="w-full rounded-xl"
        >
          Enable EMI Reminders
        </Button>
      </Card>

      {/* About */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-gray-100 dark:bg-gray-700 rounded-xl flex items-center justify-center">
            <Info className="w-5 h-5 text-gray-600 dark:text-gray-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            About
          </h2>
        </div>
        <div className="space-y-2">
          <div className="flex items-center justify-between p-3">
            <span className="text-sm text-gray-600 dark:text-gray-400">
              App Name
            </span>
            <span className="text-sm font-medium text-gray-900 dark:text-white">
              Ease Your Finance
            </span>
          </div>
          <div className="flex items-center justify-between p-3">
            <span className="text-sm text-gray-600 dark:text-gray-400">
              Version
            </span>
            <span className="text-sm font-medium text-gray-900 dark:text-white">
              1.0.0
            </span>
          </div>
        </div>
        <p className="text-xs text-gray-500 dark:text-gray-400 mt-4">
          A private, offline-first personal finance app. All data is stored
          locally on your device.
        </p>
      </Card>
    </div>
  );
}
