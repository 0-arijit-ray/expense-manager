import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { AppSettings } from '../types';
import { setCurrency } from '../lib/formatters';

interface SettingsState extends AppSettings {
  setThemeMode: (mode: AppSettings['themeMode']) => void;
  setCurrencySymbol: (symbol: string, locale: string) => void;
  setRatesEndpoint: (endpoint: string) => void;
}

export const useSettingsStore = create<SettingsState>()(
  persist(
    (set) => ({
      themeMode: 'system',
      currencySymbol: '₹',
      locale: 'en-IN',
      ratesEndpoint: '',

      setThemeMode: (mode) => set({ themeMode: mode }),
      setCurrencySymbol: (symbol, locale) => {
        setCurrency(symbol, locale);
        set({ currencySymbol: symbol, locale });
      },
      setRatesEndpoint: (endpoint) => set({ ratesEndpoint: endpoint }),
    }),
    {
      name: 'expense-manager-settings',
      onRehydrateStorage: () => (state) => {
        if (state) {
          setCurrency(state.currencySymbol, state.locale);
        }
      },
    }
  )
);
