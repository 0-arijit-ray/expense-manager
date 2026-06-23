import { useState } from 'react';
import { NavLink, useLocation, useNavigate } from 'react-router-dom';
import {
  LayoutDashboard,
  Receipt,
  Repeat,
  Landmark,
  PiggyBank,
  TrendingUp,
  Settings,
  Users,
  MessageSquare,
  X,
  LogOut,
} from 'lucide-react';
import { clsx } from 'clsx';
import { useAuthStore } from '../../stores/auth-store';
import Avatar from '../ui/Avatar';
import LogoutConfirm from '../ui/LogoutConfirm';

interface NavItem {
  to: string;
  icon: React.ComponentType<{ className?: string }>;
  label: string;
}

interface NavGroup {
  label: string;
  items: NavItem[];
}

const navGroups: NavGroup[] = [
  {
    label: 'Overview',
    items: [{ to: '/dashboard', icon: LayoutDashboard, label: 'Dashboard' }],
  },
  {
    label: 'Money',
    items: [
      { to: '/expenses', icon: Receipt, label: 'Transactions' },
      { to: '/recurring', icon: Repeat, label: 'Recurring' },
    ],
  },
  {
    label: 'Debt',
    items: [
      { to: '/loans', icon: Landmark, label: 'Loans' },
    ],
  },
  {
    label: 'Wealth',
    items: [
      { to: '/investments', icon: PiggyBank, label: 'Investments' },
      { to: '/networth', icon: TrendingUp, label: 'Net Worth' },
    ],
  },
  {
    label: 'More',
    items: [
      { to: '/about', icon: Users, label: 'About Us' },
      { to: '/contact', icon: MessageSquare, label: 'Contact' },
    ],
  },
];

interface SidebarProps {
  mobileOpen: boolean;
  onMobileClose: () => void;
}

export default function Sidebar({ mobileOpen, onMobileClose }: SidebarProps) {
  const location = useLocation();
  const navigate = useNavigate();
  const user = useAuthStore((s) => s.user);
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);

  const sidebarContent = (
    <div className="flex flex-col h-full w-[260px] bg-white dark:bg-gray-900 border-r border-gray-200 dark:border-gray-800">
      {/* Logo */}
      <div className="flex items-center h-16 px-4 border-b border-gray-200 dark:border-gray-800">
        <button
          onClick={() => navigate('/dashboard')}
          className="flex items-center gap-2 hover:opacity-80 transition-opacity cursor-pointer"
        >
          <img src="/favicon.svg" alt="Ease Your Finance" className="w-8 h-8" />
          <div className="flex flex-col text-left">
            <span className="font-bold text-sm text-gray-900 dark:text-white leading-tight">
              Ease Your Finance
            </span>
            <span className="text-[10px] text-gray-500 dark:text-gray-400 leading-tight">
              Your money, simplified
            </span>
          </div>
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto py-4 px-3">
        {navGroups.map((group) => (
          <div key={group.label} className="mb-6">
            <div className="px-3 mb-2 text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider">
              {group.label}
            </div>
            <div className="space-y-1">
              {group.items.map((item) => {
                const Icon = item.icon;
                const isActive = location.pathname === item.to;
                return (
                  <NavLink
                    key={item.to}
                    to={item.to}
                    onClick={onMobileClose}
                    className={clsx(
                      'flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200',
                      isActive
                        ? 'bg-primary/10 text-primary'
                        : 'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-900 dark:hover:text-gray-200'
                    )}
                  >
                    <Icon className={clsx('w-5 h-5 flex-shrink-0', isActive && 'text-primary')} />
                    <span>{item.label}</span>
                  </NavLink>
                );
              })}
            </div>
          </div>
        ))}
      </nav>

      {/* Bottom section */}
      <div className="border-t border-gray-200 dark:border-gray-800">
        {/* User Profile */}
        {user && (
          <div className="flex items-center gap-2 px-4 py-3">
            <button
              onClick={() => { navigate('/profile'); onMobileClose(); }}
              className="flex items-center gap-3 flex-1 min-w-0 hover:opacity-80 transition-opacity text-left"
            >
              <Avatar src={user.photoURL} name={user.name} size="sm" />
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-gray-900 dark:text-white truncate">{user.name}</p>
                <p className="text-xs text-gray-500 dark:text-gray-400 truncate">{user.email}</p>
              </div>
            </button>
            <button
              onClick={() => setShowLogoutConfirm(true)}
              className="p-2 rounded-lg text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors shrink-0"
              title="Sign out"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        )}

        {/* Settings */}
        <div className="p-3 pt-0">
          <NavLink
            to="/settings"
            onClick={onMobileClose}
            className={clsx(
              'flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200',
              location.pathname === '/settings'
                ? 'bg-primary/10 text-primary'
                : 'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-900 dark:hover:text-gray-200'
            )}
          >
            <Settings className="w-5 h-5" />
            <span>Settings</span>
          </NavLink>
        </div>
      </div>
    </div>
  );

  return (
    <>
      {/* Desktop Sidebar */}
      <div className="hidden lg:block h-screen sticky top-0 shrink-0">
        {sidebarContent}
      </div>

      {/* Mobile Overlay */}
      {mobileOpen && (
        <div className="lg:hidden fixed inset-0 z-50">
          <div
            className="absolute inset-0 bg-black/50 backdrop-blur-sm animate-fadeIn"
            onClick={onMobileClose}
          />
          <div className="absolute left-0 top-0 h-full animate-slideInRight">
            {sidebarContent}
          </div>
          <button
            onClick={onMobileClose}
            className="absolute top-4 right-4 z-10 p-2 rounded-full bg-white dark:bg-gray-800 shadow-lg"
          >
            <X className="w-5 h-5 text-gray-600 dark:text-gray-400" />
          </button>
        </div>
      )}

      <LogoutConfirm isOpen={showLogoutConfirm} onClose={() => setShowLogoutConfirm(false)} />
    </>
  );
}
