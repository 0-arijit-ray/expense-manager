import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { AuthUser } from '../lib/auth-service';
import * as auth from '../lib/auth-service';

interface AuthState {
  user: AuthUser | null;
  isInitialized: boolean;

  init: () => void;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  signInWithGoogle: () => Promise<void>;
  logout: () => Promise<void>;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isInitialized: false,

      init: () => {
        auth.onAuthChange((user) => {
          set({ user, isInitialized: true });
        });
      },

      login: async (email, password) => {
        const user = await auth.login(email, password);
        set({ user });
      },

      register: async (email, password, name) => {
        const user = await auth.register(email, password, name);
        set({ user });
      },

      signInWithGoogle: async () => {
        const user = await auth.signInWithGoogle();
        set({ user });
      },

      logout: async () => {
        await auth.logout();
        set({ user: null, isInitialized: true });
      },
    }),
    {
      name: 'ease-finance-auth',
      partialize: () => ({}),
    }
  )
);
