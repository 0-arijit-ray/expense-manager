import { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import AppLayout from './components/layout/AppLayout';
import DashboardScreen from './features/dashboard/DashboardScreen';
import ExpensesScreen from './features/expenses/ExpensesScreen';
import LoansScreen from './features/loans/LoansScreen';
import LoanDetailScreen from './features/loans/LoanDetailScreen';
import InvestmentsScreen from './features/investments/InvestmentsScreen';
import NetWorthScreen from './features/networth/NetWorthScreen';
import RecurringScreen from './features/recurring/RecurringScreen';
import SettingsScreen from './features/settings/SettingsScreen';
import { useSettingsStore } from './stores/settings-store';
import './index.css';

const queryClient = new QueryClient();

function ThemeSync() {
  const themeMode = useSettingsStore((s) => s.themeMode);

  useEffect(() => {
    const root = document.documentElement;

    const applyTheme = (dark: boolean) => {
      if (dark) {
        root.classList.add('dark');
      } else {
        root.classList.remove('dark');
      }
    };

    if (themeMode === 'dark') {
      applyTheme(true);
    } else if (themeMode === 'light') {
      applyTheme(false);
    } else {
      // system
      const mq = window.matchMedia('(prefers-color-scheme: dark)');
      applyTheme(mq.matches);

      const handler = (e: MediaQueryListEvent) => applyTheme(e.matches);
      mq.addEventListener('change', handler);
      return () => mq.removeEventListener('change', handler);
    }
  }, [themeMode]);

  return null;
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeSync />
      <BrowserRouter>
        <Routes>
          <Route element={<AppLayout />}>
            <Route path="/" element={<Navigate to="/dashboard" replace />} />
            <Route path="/dashboard" element={<DashboardScreen />} />
            <Route path="/expenses" element={<ExpensesScreen />} />
            <Route path="/loans" element={<LoansScreen />} />
            <Route path="/loans/:id" element={<LoanDetailScreen />} />
            <Route path="/investments" element={<InvestmentsScreen />} />
            <Route path="/networth" element={<NetWorthScreen />} />
            <Route path="/recurring" element={<RecurringScreen />} />
            <Route path="/settings" element={<SettingsScreen />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </QueryClientProvider>
  );
}

export default App;
