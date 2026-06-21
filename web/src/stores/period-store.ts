import { create } from 'zustand';
import { Period } from '../lib/date-range';

interface PeriodState {
  period: Period;
  anchor: Date;
  setPeriod: (period: Period) => void;
  next: () => void;
  prev: () => void;
}

export const usePeriodStore = create<PeriodState>()((set) => ({
  period: Period.Monthly,
  anchor: new Date(),

  setPeriod: (period) => set({ period }),

  next: () =>
    set((state) => {
      const newAnchor = new Date(state.anchor);
      switch (state.period) {
        case Period.Weekly:
          newAnchor.setDate(newAnchor.getDate() + 7);
          break;
        case Period.Monthly:
          newAnchor.setMonth(newAnchor.getMonth() + 1);
          break;
        case Period.Yearly:
          newAnchor.setFullYear(newAnchor.getFullYear() + 1);
          break;
      }
      return { anchor: newAnchor };
    }),

  prev: () =>
    set((state) => {
      const newAnchor = new Date(state.anchor);
      switch (state.period) {
        case Period.Weekly:
          newAnchor.setDate(newAnchor.getDate() - 7);
          break;
        case Period.Monthly:
          newAnchor.setMonth(newAnchor.getMonth() - 1);
          break;
        case Period.Yearly:
          newAnchor.setFullYear(newAnchor.getFullYear() - 1);
          break;
      }
      return { anchor: newAnchor };
    }),
}));
