import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { AuthUser } from '../lib/auth-service';
import * as auth from '../lib/auth-service';

interface AuthState {
  user: AuthUser | null;
  token: string | null;
  isInitialized: boolean;
  needsDeviceSetup: boolean;

  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  verifyDevice: (pin: string) => boolean;
  setupDevice: (pin: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isInitialized: false,
      needsDeviceSetup: false,

      login: async (email, password) => {
        const res = await auth.login(email, password);
        const hasPin = auth.hasDevicePin();
        set({
          user: res.user,
          token: res.token,
          isInitialized: true,
          needsDeviceSetup: !hasPin,
        });
      },

      register: async (email, password, name) => {
        const res = await auth.register(email, password, name);
        set({
          user: res.user,
          token: res.token,
          isInitialized: true,
          needsDeviceSetup: true,
        });
      },

      verifyDevice: (pin) => {
        const ok = auth.verifyDevicePin(pin);
        if (ok) set({ isInitialized: true });
        return ok;
      },

      setupDevice: (pin) => {
        auth.setupDevicePin(pin);
        set({ needsDeviceSetup: false });
      },

      logout: () => {
        auth.clearDevicePin();
        set({
          user: null,
          token: null,
          isInitialized: false,
          needsDeviceSetup: false,
        });
      },
    }),
    {
      name: 'ease-finance-auth',
      partialize: (state) => ({
        user: state.user,
        token: state.token,
      }),
    }
  )
);
