import { useNavigate } from 'react-router-dom';
import { Button } from '../../components/ui';
import { Shield, TrendingUp, Wallet } from 'lucide-react';

export default function LandingScreen() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary via-primary-dark to-primary flex flex-col items-center justify-center px-6 text-white">
      <div className="max-w-sm w-full text-center space-y-8">
        {/* Logo */}
        <div className="space-y-3">
          <img src="/favicon.svg" alt="Ease Your Finance" className="w-20 h-20 mx-auto drop-shadow-lg" />
          <h1 className="text-3xl font-bold tracking-tight">Ease Your Finance</h1>
          <p className="text-white/70 text-sm">Your money, simplified</p>
        </div>

        {/* Features */}
        <div className="grid grid-cols-3 gap-4 py-4">
          <div className="flex flex-col items-center gap-2">
            <div className="w-12 h-12 bg-white/15 rounded-2xl flex items-center justify-center">
              <Wallet className="w-6 h-6" />
            </div>
            <span className="text-xs text-white/80">Track</span>
          </div>
          <div className="flex flex-col items-center gap-2">
            <div className="w-12 h-12 bg-white/15 rounded-2xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6" />
            </div>
            <span className="text-xs text-white/80">Grow</span>
          </div>
          <div className="flex flex-col items-center gap-2">
            <div className="w-12 h-12 bg-white/15 rounded-2xl flex items-center justify-center">
              <Shield className="w-6 h-6" />
            </div>
            <span className="text-xs text-white/80">Secure</span>
          </div>
        </div>

        {/* CTAs */}
        <div className="space-y-3 pt-2">
          <Button
            onClick={() => navigate('/login')}
            className="w-full bg-white text-primary font-semibold py-3 rounded-xl hover:bg-white/90 transition-colors"
          >
            Get Started
          </Button>
          <Button
            onClick={() => navigate('/login')}
            variant="ghost"
            className="w-full text-white/80 hover:text-white hover:bg-white/10 rounded-xl"
          >
            I already have an account
          </Button>
        </div>

        <p className="text-[11px] text-white/40 pt-4">
          Offline-first. Your data stays on your device.
        </p>
      </div>
    </div>
  );
}
