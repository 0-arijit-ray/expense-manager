import { create } from 'zustand';

interface NetWorthState {
  includeLoans: boolean;
  toggleIncludeLoans: () => void;
}

export const useNetWorthStore = create<NetWorthState>()((set) => ({
  includeLoans: true,
  toggleIncludeLoans: () => set((state) => ({ includeLoans: !state.includeLoans })),
}));
