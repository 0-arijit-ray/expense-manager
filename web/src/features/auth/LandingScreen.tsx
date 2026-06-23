import { useNavigate } from 'react-router-dom';
import { Button } from '../../components/ui';
import { Shield, TrendingUp, Wallet, ArrowRight, Sparkles } from 'lucide-react';

const features = [
  {
    icon: Wallet,
    title: 'Track',
    description: 'Log transactions in seconds with smart categorization',
    color: 'from-emerald-500 to-teal-600',
  },
  {
    icon: TrendingUp,
    title: 'Grow',
    description: 'Monitor investments and watch your net worth climb',
    color: 'from-blue-500 to-indigo-600',
  },
  {
    icon: Shield,
    title: 'Secure',
    description: 'Your data stays on your device. No servers, no tracking.',
    color: 'from-violet-500 to-purple-600',
  },
];

export default function LandingScreen() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen flex flex-col lg:flex-row">
      {/* Left: Hero */}
      <div className="flex-1 flex flex-col justify-center px-6 sm:px-12 lg:px-16 py-12 lg:py-0 bg-gradient-to-br from-gray-50 via-white to-emerald-50/30 dark:from-gray-950 dark:via-gray-900 dark:to-gray-950 relative overflow-hidden">
        {/* Background decoration */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-40 -right-40 w-80 h-80 bg-primary/5 rounded-full blur-3xl" />
          <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-primary/5 rounded-full blur-3xl" />
        </div>

        <div className="relative max-w-xl mx-auto lg:mx-0 w-full space-y-10">
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
          <div className="space-y-4">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-gray-900 dark:text-white tracking-tight leading-[1.1]">
              Your money,{' '}
              <span className="bg-gradient-to-r from-primary via-primary-light to-emerald-400 bg-clip-text text-transparent">
                simplified
              </span>
            </h1>
            <p className="text-lg text-gray-600 dark:text-gray-400 max-w-md leading-relaxed">
              Track expenses, manage loans, and grow investments — all in one private, offline-first app.
            </p>
          </div>

          {/* Features */}
          <div className="space-y-4">
            {features.map((feature, i) => (
              <div
                key={feature.title}
                className="flex items-start gap-4 p-4 rounded-2xl bg-white/60 dark:bg-gray-800/60 backdrop-blur-sm border border-gray-100 dark:border-gray-700/50 hover:shadow-lg hover:border-gray-200 dark:hover:border-gray-600 transition-all duration-300"
                style={{ animationDelay: `${i * 100}ms` }}
              >
                <div className={`w-11 h-11 rounded-xl bg-gradient-to-br ${feature.color} flex items-center justify-center shrink-0 shadow-lg`}>
                  <feature.icon className="w-5 h-5 text-white" />
                </div>
                <div>
                  <h3 className="text-sm font-semibold text-gray-900 dark:text-white">
                    {feature.title}
                  </h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400 mt-0.5">
                    {feature.description}
                  </p>
                </div>
              </div>
            ))}
          </div>

          {/* CTAs */}
          <div className="flex flex-col sm:flex-row gap-3">
            <Button
              onClick={() => navigate('/login')}
              size="lg"
              className="group flex items-center justify-center gap-2"
            >
              Get Started Free
              <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
            </Button>
            <Button
              onClick={() => navigate('/login')}
              variant="ghost"
              size="lg"
              className="text-gray-600 dark:text-gray-400"
            >
              Sign In
            </Button>
          </div>

          {/* Trust line */}
          <div className="flex items-center gap-2 text-xs text-gray-400 dark:text-gray-500">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Offline-first. Your data stays on your device.</span>
          </div>
        </div>
      </div>

      {/* Right: Visual */}
      <div className="hidden lg:flex flex-1 items-center justify-center bg-gradient-to-br from-primary/5 via-primary/10 to-emerald-50/50 dark:from-gray-900 dark:via-gray-900 dark:to-gray-950 relative overflow-hidden">
        {/* Background mesh */}
        <div className="absolute inset-0">
          <div className="absolute top-20 left-20 w-64 h-64 bg-primary/10 rounded-full blur-3xl animate-float" />
          <div className="absolute bottom-20 right-20 w-48 h-48 bg-emerald-400/10 rounded-full blur-3xl animate-float" style={{ animationDelay: '2s' }} />
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-teal-400/5 rounded-full blur-3xl animate-float" style={{ animationDelay: '4s' }} />
        </div>

        {/* Floating preview cards */}
        <div className="relative w-full max-w-md px-8">
          {/* Main dashboard card */}
          <div className="bg-white dark:bg-gray-800 rounded-3xl shadow-2xl p-6 border border-gray-100 dark:border-gray-700 animate-card-float-1">
            <div className="flex items-center justify-between mb-6">
              <div>
                <p className="text-xs text-gray-500 dark:text-gray-400 font-medium">Total Balance</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white mt-1">₹2,45,680</p>
              </div>
              <div className="w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
              </div>
            </div>
            <div className="flex gap-2">
              <div className="flex-1 bg-gray-50 dark:bg-gray-700/50 rounded-xl p-3">
                <p className="text-[10px] text-gray-500 dark:text-gray-400 font-medium">Income</p>
                <p className="text-sm font-bold text-emerald-600 dark:text-emerald-400 mt-0.5">₹85,200</p>
              </div>
              <div className="flex-1 bg-gray-50 dark:bg-gray-700/50 rounded-xl p-3">
                <p className="text-[10px] text-gray-500 dark:text-gray-400 font-medium">Expense</p>
                <p className="text-sm font-bold text-red-500 dark:text-red-400 mt-0.5">₹52,340</p>
              </div>
            </div>
          </div>

          {/* Floating stat card */}
          <div className="absolute -right-4 top-8 bg-white dark:bg-gray-800 rounded-2xl shadow-xl p-4 border border-gray-100 dark:border-gray-700 animate-card-float-2">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-blue-100 dark:bg-blue-900/30 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-4 h-4 text-blue-600 dark:text-blue-400" />
              </div>
              <div>
                <p className="text-[10px] text-gray-500 dark:text-gray-400">Portfolio</p>
                <p className="text-xs font-bold text-gray-900 dark:text-white">₹12.4L</p>
              </div>
            </div>
          </div>

          {/* Floating expense card */}
          <div className="absolute -left-4 bottom-12 bg-white dark:bg-gray-800 rounded-2xl shadow-xl p-4 border border-gray-100 dark:border-gray-700 animate-card-float-1" style={{ animationDelay: '1s' }}>
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-violet-100 dark:bg-violet-900/30 rounded-lg flex items-center justify-center">
                <Wallet className="w-4 h-4 text-violet-600 dark:text-violet-400" />
              </div>
              <div>
                <p className="text-[10px] text-gray-500 dark:text-gray-400">Saved</p>
                <p className="text-xs font-bold text-gray-900 dark:text-white">₹32,860</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
