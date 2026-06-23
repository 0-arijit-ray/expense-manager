import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import {
  LayoutDashboard,
  Receipt,
  Landmark,
  PiggyBank,
  TrendingUp,
  Home,
} from 'lucide-react';
import { clsx } from 'clsx';

const navItems = [
  { to: '/dashboard', icon: LayoutDashboard, label: 'Home' },
  { to: '/expenses', icon: Receipt, label: 'Expenses' },
  { to: '/loans', icon: Landmark, label: 'Loans' },
  { to: '/investments', icon: PiggyBank, label: 'Invest' },
  { to: '/networth', icon: TrendingUp, label: 'Net Worth' },
];

export default function RootLayout() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Mobile top bar with home button */}
      <div className="sm:hidden sticky top-0 z-40 bg-gray-50 dark:bg-gray-900 px-4 py-2">
        <button
          onClick={() => navigate('/dashboard')}
          className="w-9 h-9 rounded-xl flex items-center justify-center"
          style={{ backgroundColor: 'rgba(30, 111, 92, 0.1)' }}
        >
          <Home className="w-5 h-5" style={{ color: 'var(--color-primary)' }} />
        </button>
      </div>

      <div className="max-w-2xl mx-auto pb-20">
        <Outlet />
      </div>

      <nav className="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 z-50">
        <div className="max-w-2xl mx-auto flex justify-around items-center h-16">
          {navItems.map(({ to, icon: Icon, label }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) =>
                clsx(
                  'flex flex-col items-center justify-center gap-1 px-3 py-2 text-xs font-medium transition-colors',
                  isActive
                    ? 'text-primary dark:text-primary-light'
                    : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'
                )
              }
            >
              <Icon className="w-5 h-5" />
              <span>{label}</span>
            </NavLink>
          ))}
        </div>
      </nav>
    </div>
  );
}
