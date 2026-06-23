import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { AuthUser } from '../lib/auth-service';
import * as auth from '../lib/auth-service';

interface AuthState {
  user: AuthUser | null;
  isInitialized: boolean;
  isDeviceVerified: boolean;

  init: () => void;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  signInWithGoogle: () => Promise<void>;
  verifyDevice: (pin: string) => boolean;
  setupDevice: (pin: string) => void;
  logout: () => Promise<void>;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isInitialized: false,
      isDeviceVerified: false,

      init: () => {
        auth.onAuthChange((user) => {
          set({
            user,
            isInitialized: true,
            isDeviceVerified: user ? !auth.hasDevicePin() : false,
          });
        });
      },

      login: async (email, password) => {
        const user = await auth.login(email, password);
        set({ user, isDeviceVerified: !auth.hasDevicePin() });
      },

      register: async (email, password, name) => {
        const user = await auth.register(email, password, name);
        set({ user, isDeviceVerified: false });
      },

      signInWithGoogle: async () => {
        const user = await auth.signInWithGoogle();
        set({ user, isDeviceVerified: !auth.hasDevicePin() });
      },

      verifyDevice: (pin) => {
        const ok = auth.verifyDevicePin(pin);
        if (ok) set({ isDeviceVerified: true });
        return ok;
      },

      setupDevice: (pin) => {
        auth.setupDevicePin(pin);
        set({ isDeviceVerified: true });
      },

      logout: async () => {
        await auth.logout();
        auth.clearDevicePin();
        set({ user: null, isInitialized: true, isDeviceVerified: false });
      },
    }),
    {
      name: 'ease-finance-auth',
      partialize: () => ({}),
    }
  )
);
