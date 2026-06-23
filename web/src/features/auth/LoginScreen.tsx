import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button, Input } from '../../components/ui';
import { useAuthStore } from '../../stores/auth-store';
import { ArrowLeft, Loader2, Check, X } from 'lucide-react';

export default function LoginScreen() {
  const navigate = useNavigate();
  const { login, register, signInWithGoogle } = useAuthStore();
  const [isSignUp, setIsSignUp] = useState(false);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const passwordRules = useMemo(() => ({
    length: password.length >= 6,
    uppercase: /[A-Z]/.test(password),
    lowercase: /[a-z]/.test(password),
    number: /[0-9]/.test(password),
    special: /[^A-Za-z0-9]/.test(password),
  }), [password]);

  const emailValid = useMemo(() => {
    if (!email) return null;
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }, [email]);

  const allRulesPassed = Object.values(passwordRules).every(Boolean);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      if (isSignUp) {
        await register(email, password, name);
      } else {
        await login(email, password);
      }
      navigate('/dashboard', { replace: true });
    } catch (err: any) {
      setError(err.message || 'Something went wrong');
    } finally {
      setLoading(false);
    }
  };

  const handleGoogleSignIn = async () => {
    setError('');
    setLoading(true);
    try {
      await signInWithGoogle();
      navigate('/dashboard', { replace: true });
    } catch (err: any) {
      if (err.code !== 'auth/popup-closed-by-user') {
        setError(err.message || 'Google sign-in failed');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col lg:flex-row">
      {/* Left: Hero (condensed) */}
      <div className="hidden lg:flex flex-1 flex-col justify-center px-16 bg-gradient-to-br from-gray-50 via-white to-emerald-50/30 dark:from-gray-950 dark:via-gray-900 dark:to-gray-950 relative overflow-hidden">
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-40 -right-40 w-80 h-80 bg-primary/5 rounded-full blur-3xl" />
          <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-primary/5 rounded-full blur-3xl" />
        </div>

        <div className="relative max-w-md space-y-8">
          {/* Logo */}
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-2xl flex items-center justify-center animate-pulse-glow">
              <img src="/favicon.svg" alt="Ease Your Finance" className="w-12 h-12" />
            </div>
            <span className="text-xl font-bold text-gray-900 dark:text-white tracking-tight">
              Ease Your Finance
            </span>
          </div>

          {/* Headline */}
          <div className="space-y-3">
            <h1 className="text-4xl font-extrabold text-gray-900 dark:text-white tracking-tight leading-tight">
              Welcome back
            </h1>
            <p className="text-gray-600 dark:text-gray-400 leading-relaxed">
              Sign in to continue managing your finances with confidence.
            </p>
          </div>

          {/* Trust indicators */}
          <div className="space-y-4 pt-4">
            <div className="flex items-center gap-3 text-sm text-gray-500 dark:text-gray-400">
              <div className="w-8 h-8 bg-emerald-100 dark:bg-emerald-900/30 rounded-lg flex items-center justify-center">
                <svg className="w-4 h-4 text-emerald-600 dark:text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                </svg>
              </div>
              <span>Bank-level encryption for all your data</span>
            </div>
            <div className="flex items-center gap-3 text-sm text-gray-500 dark:text-gray-400">
              <div className="w-8 h-8 bg-blue-100 dark:bg-blue-900/30 rounded-lg flex items-center justify-center">
                <svg className="w-4 h-4 text-blue-600 dark:text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </div>
              <span>Your data never leaves your device</span>
            </div>
            <div className="flex items-center gap-3 text-sm text-gray-500 dark:text-gray-400">
              <div className="w-8 h-8 bg-violet-100 dark:bg-violet-900/30 rounded-lg flex items-center justify-center">
                <svg className="w-4 h-4 text-violet-600 dark:text-violet-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
              </div>
              <span>Works offline — no internet required</span>
            </div>
          </div>
        </div>
      </div>

      {/* Right: Auth form */}
      <div className="flex-1 flex flex-col">
        {/* Mobile header */}
        <div className="lg:hidden p-4">
          <button
            onClick={() => navigate('/')}
            className="w-10 h-10 rounded-xl flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
          >
            <ArrowLeft className="w-5 h-5 text-gray-700 dark:text-gray-300" />
          </button>
        </div>

        {/* Form area */}
        <div className="flex-1 flex flex-col justify-center px-6 sm:px-12 lg:px-16 py-8 lg:py-0">
          <div className="max-w-sm mx-auto w-full">
            {/* Mobile logo */}
            <div className="lg:hidden flex items-center gap-3 mb-8">
              <img src="/favicon.svg" alt="Ease Your Finance" className="w-10 h-10" />
              <span className="text-lg font-bold text-gray-900 dark:text-white">Ease Your Finance</span>
            </div>

            <div className="space-y-6">
              {/* Header */}
              <div>
                <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
                  {isSignUp ? 'Create your account' : 'Sign in to your account'}
                </h2>
                <p className="text-sm text-gray-500 dark:text-gray-400 mt-1.5">
                  {isSignUp
                    ? 'Start your journey to financial clarity'
                    : 'Welcome back! Please enter your details'}
                </p>
              </div>

              {/* Google Sign-In */}
              <Button
                onClick={handleGoogleSignIn}
                variant="outline"
                className="w-full h-12 flex items-center justify-center gap-3 text-sm font-medium"
                disabled={loading}
              >
                {loading ? (
                  <Loader2 className="w-5 h-5 animate-spin" />
                ) : (
                  <svg className="w-5 h-5" viewBox="0 0 24 24">
                    <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 01-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4" />
                    <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                    <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                    <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
                  </svg>
                )}
                Continue with Google
              </Button>

              {/* Divider */}
              <div className="relative">
                <div className="absolute inset-0 flex items-center">
                  <div className="w-full border-t border-gray-200 dark:border-gray-700" />
                </div>
                <div className="relative flex justify-center text-xs">
                  <span className="bg-white dark:bg-gray-900 px-3 text-gray-400">or</span>
                </div>
              </div>

              {/* Form */}
              <form onSubmit={handleSubmit} className="space-y-4">
                {isSignUp && (
                  <Input
                    label="Full name"
                    placeholder="John Doe"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    required
                  />
                )}
                <Input
                  label="Email address"
                  type="email"
                  placeholder="you@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />

                {/* Email validation indicator */}
                {email.length > 0 && (
                  <div className="flex items-center gap-2 text-xs pt-1">
                    {emailValid ? (
                      <div className="w-4 h-4 rounded-full bg-emerald-100 dark:bg-emerald-900/30 flex items-center justify-center shrink-0">
                        <Check className="w-2.5 h-2.5 text-emerald-600 dark:text-emerald-400" />
                      </div>
                    ) : (
                      <div className="w-4 h-4 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center shrink-0">
                        <X className="w-2.5 h-2.5 text-gray-400 dark:text-gray-500" />
                      </div>
                    )}
                    <span className={
                      emailValid
                        ? 'text-emerald-600 dark:text-emerald-400'
                        : 'text-gray-400 dark:text-gray-500'
                    }>
                      {emailValid ? 'Valid email address' : 'Enter a valid email address'}
                    </span>
                  </div>
                )}
                <Input
                  label="Password"
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />

                {/* Password requirements (sign-up only) */}
                {isSignUp && password.length > 0 && (
                  <div className="space-y-1.5 pt-1">
                    {([
                      { key: 'length', label: 'At least 6 characters' },
                      { key: 'uppercase', label: 'One uppercase letter' },
                      { key: 'lowercase', label: 'One lowercase letter' },
                      { key: 'number', label: 'One number' },
                      { key: 'special', label: 'One special character' },
                    ] as const).map(({ key, label }) => (
                      <div key={key} className="flex items-center gap-2 text-xs">
                        {passwordRules[key] ? (
                          <div className="w-4 h-4 rounded-full bg-emerald-100 dark:bg-emerald-900/30 flex items-center justify-center shrink-0">
                            <Check className="w-2.5 h-2.5 text-emerald-600 dark:text-emerald-400" />
                          </div>
                        ) : (
                          <div className="w-4 h-4 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center shrink-0">
                            <X className="w-2.5 h-2.5 text-gray-400 dark:text-gray-500" />
                          </div>
                        )}
                        <span className={
                          passwordRules[key]
                            ? 'text-emerald-600 dark:text-emerald-400'
                            : 'text-gray-400 dark:text-gray-500'
                        }>
                          {label}
                        </span>
                      </div>
                    ))}
                  </div>
                )}

                {error && (
                  <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                    <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
                  </div>
                )}

                <Button
                  type="submit"
                  className="w-full h-12 text-sm font-semibold"
                  disabled={loading || (isSignUp && !allRulesPassed)}
                >
                  {loading ? (
                    <Loader2 className="w-5 h-5 animate-spin" />
                  ) : isSignUp ? (
                    'Create Account'
                  ) : (
                    'Sign In'
                  )}
                </Button>
              </form>

              {/* Toggle */}
              <p className="text-center text-sm text-gray-500 dark:text-gray-400">
                {isSignUp ? 'Already have an account?' : "Don't have an account?"}{' '}
                <button
                  onClick={() => { setIsSignUp(!isSignUp); setError(''); }}
                  className="text-primary font-semibold hover:underline"
                >
                  {isSignUp ? 'Sign in' : 'Sign up'}
                </button>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
