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
  updateName: (name: string) => Promise<void>;
  updateEmail: (newEmail: string, currentPassword: string) => Promise<void>;
  updatePassword: (newPassword: string, currentPassword: string) => Promise<void>;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
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

      updateName: async (name: string) => {
        await auth.updateUserName(name);
        const current = get().user;
        if (current) {
          set({ user: { ...current, name } });
        }
      },

      updateEmail: async (newEmail: string, currentPassword: string) => {
        await auth.updateUserEmail(newEmail, currentPassword);
        const current = get().user;
        if (current) {
          set({ user: { ...current, email: newEmail } });
        }
      },

      updatePassword: async (newPassword: string, currentPassword: string) => {
        await auth.updateUserPassword(newPassword, currentPassword);
      },
    }),
    {
      name: 'ease-finance-auth',
      partialize: () => ({}),
    }
  )
);
