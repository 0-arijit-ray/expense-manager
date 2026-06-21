import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import RootLayout from './components/layout/RootLayout';
import DashboardScreen from './features/dashboard/DashboardScreen';
import ExpensesScreen from './features/expenses/ExpensesScreen';
import LoansScreen from './features/loans/LoansScreen';
import LoanDetailScreen from './features/loans/LoanDetailScreen';
import InvestmentsScreen from './features/investments/InvestmentsScreen';
import NetWorthScreen from './features/networth/NetWorthScreen';
import RecurringScreen from './features/recurring/RecurringScreen';
import SettingsScreen from './features/settings/SettingsScreen';
import './index.css';

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <Routes>
          <Route element={<RootLayout />}>
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
