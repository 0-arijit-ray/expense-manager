import { useState, useEffect, useRef } from 'react';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import Sidebar from './Sidebar';
import Footer from './Footer';
import { Menu } from 'lucide-react';

export default function AppLayout() {
  const [collapsed, setCollapsed] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();
  const mainRef = useRef<HTMLDivElement>(null);

  // Close mobile sidebar on route change
  useEffect(() => {
    setMobileOpen(false);
  }, [location.pathname]);

  // Scroll to top on route change
  useEffect(() => {
    mainRef.current?.scrollTo(0, 0);
  }, [location.pathname]);

  // Handle resize
  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth < 1024) {
        setCollapsed(true);
      }
    };
    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return (
    <div className="flex h-screen bg-gray-50 dark:bg-gray-950">
      <Sidebar
        collapsed={collapsed}
        onToggle={() => setCollapsed(!collapsed)}
        mobileOpen={mobileOpen}
        onMobileClose={() => setMobileOpen(false)}
      />

      {/* Main Content - sticky footer layout */}
      <main ref={mainRef} className="flex-1 overflow-y-auto">
        <div className="min-h-screen flex flex-col">
          {/* Mobile Header */}
          <header className="lg:hidden sticky top-0 z-20 flex items-center h-14 px-4 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800">
            <button
              onClick={() => navigate('/dashboard')}
              className="flex items-center gap-2 shrink-0 cursor-pointer"
            >
              <div
                className="w-9 h-9 rounded-xl flex items-center justify-center"
                style={{ backgroundColor: 'rgba(30, 111, 92, 0.1)' }}
              >
                <img src="/favicon.svg" alt="Logo" className="w-5 h-5" />
              </div>
              <span className="font-semibold text-sm text-gray-900 dark:text-white">
                Ease Your Finance
              </span>
            </button>
            <div className="flex-1" />
            <button
              onClick={() => setMobileOpen(true)}
              className="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            >
              <Menu className="w-5 h-5 text-gray-600 dark:text-gray-400" />
            </button>
          </header>

          <div className="flex-1 max-w-5xl mx-auto px-4 py-4 sm:px-6 sm:py-6 lg:p-8 w-full">
            <Outlet />
          </div>
          <Footer />
        </div>
      </main>
    </div>
  );
}
