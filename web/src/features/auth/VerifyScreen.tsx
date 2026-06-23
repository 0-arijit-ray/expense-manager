import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '../../components/ui';
import { useAuthStore } from '../../stores/auth-store';
import { hasDevicePin } from '../../lib/auth-service';
import { Fingerprint, KeyRound, ArrowLeft } from 'lucide-react';

export default function VerifyScreen() {
  const navigate = useNavigate();
  const { verifyDevice, setupDevice, isDeviceVerified, user, logout } = useAuthStore();
  const [pin, setPin] = useState('');
  const [confirmPin, setConfirmPin] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const isSetup = !isDeviceVerified && !hasDevicePin();

  const handleVerify = async () => {
    setError('');
    setLoading(true);
    try {
      if (isSetup) {
        if (pin.length < 4) {
          setError('PIN must be at least 4 digits');
          setLoading(false);
          return;
        }
        if (pin !== confirmPin) {
          setError('PINs do not match');
          setLoading(false);
          return;
        }
        setupDevice(pin);
        navigate('/dashboard', { replace: true });
      } else {
        const ok = verifyDevice(pin);
        if (ok) {
          navigate('/dashboard', { replace: true });
        } else {
          setError('Incorrect PIN');
          setPin('');
        }
      }
    } finally {
      setLoading(false);
    }
  };

  const handleBiometric = async () => {
    // TODO: Use WebAuthn API for real biometric auth
    // For now, navigate directly (simulates biometric success)
    navigate('/dashboard', { replace: true });
  };

  const handleLogout = () => {
    logout();
    navigate('/', { replace: true });
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col">
      <div className="p-4 flex items-center justify-between">
        <button
          onClick={() => navigate('/')}
          className="w-10 h-10 rounded-xl flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        >
          <ArrowLeft className="w-5 h-5 text-gray-700 dark:text-gray-300" />
        </button>
        <button
          onClick={handleLogout}
          className="text-sm text-gray-500 dark:text-gray-400 hover:text-red-500 transition-colors"
        >
          Sign out
        </button>
      </div>

      <div className="flex-1 flex flex-col justify-center px-6 max-w-sm mx-auto w-full">
        <div className="space-y-6">
          <div className="text-center">
            <div className="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <KeyRound className="w-8 h-8 text-primary" />
            </div>
            <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
              {isSetup ? 'Set up device PIN' : 'Enter PIN'}
            </h1>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
              {isSetup
                ? `Set a PIN for quick access on this device`
                : `Welcome back, ${user?.name || user?.email}`}
            </p>
          </div>

          <div className="space-y-4">
            <div className="space-y-1.5">
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                PIN
              </label>
              <input
                type="password"
                inputMode="numeric"
                maxLength={6}
                placeholder="••••"
                value={pin}
                onChange={(e) => setPin(e.target.value.replace(/\D/g, ''))}
                onKeyDown={(e) => e.key === 'Enter' && handleVerify()}
                autoFocus
                className="w-full px-4 py-2.5 text-sm rounded-xl border transition-all duration-200 bg-white dark:bg-gray-700 text-center text-2xl tracking-[0.5em] font-mono placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-0 border-gray-200 dark:border-gray-600 focus:border-primary focus:ring-primary/20 text-gray-900 dark:text-white"
              />
            </div>

            {isSetup && (
              <div className="space-y-1.5">
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  Confirm PIN
                </label>
                <input
                  type="password"
                  inputMode="numeric"
                  maxLength={6}
                  placeholder="••••"
                  value={confirmPin}
                  onChange={(e) => setConfirmPin(e.target.value.replace(/\D/g, ''))}
                  onKeyDown={(e) => e.key === 'Enter' && handleVerify()}
                  className="w-full px-4 py-2.5 text-sm rounded-xl border transition-all duration-200 bg-white dark:bg-gray-700 text-center text-2xl tracking-[0.5em] font-mono placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-0 border-gray-200 dark:border-gray-600 focus:border-primary focus:ring-primary/20 text-gray-900 dark:text-white"
                />
              </div>
            )}

            {error && (
              <p className="text-sm text-red-500 text-center">{error}</p>
            )}

            <Button
              onClick={handleVerify}
              className="w-full"
              disabled={loading || pin.length < 4}
            >
              {loading ? 'Verifying...' : isSetup ? 'Set PIN' : 'Verify'}
            </Button>

            {!isSetup && (
              <>
                <div className="relative my-2">
                  <div className="absolute inset-0 flex items-center">
                    <div className="w-full border-t border-gray-200 dark:border-gray-700" />
                  </div>
                  <div className="relative flex justify-center text-xs">
                    <span className="bg-gray-50 dark:bg-gray-900 px-3 text-gray-500">or</span>
                  </div>
                </div>

                <Button
                  onClick={handleBiometric}
                  variant="outline"
                  className="w-full flex items-center justify-center gap-2"
                >
                  <Fingerprint className="w-5 h-5" />
                  Use biometric
                </Button>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
