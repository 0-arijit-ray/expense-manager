import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signInWithPopup,
  signOut,
  updateProfile,
  type User,
} from 'firebase/auth';
import { auth, googleProvider } from './firebase';

export interface AuthUser {
  id: string;
  email: string;
  name: string;
  photoURL: string | null;
}

function firebaseUserToAuthUser(user: User): AuthUser {
  return {
    id: user.uid,
    email: user.email || '',
    name: user.displayName || user.email?.split('@')[0] || 'User',
    photoURL: user.photoURL,
  };
}

/** Email + password login */
export async function login(email: string, password: string): Promise<AuthUser> {
  const cred = await signInWithEmailAndPassword(auth, email, password);
  return firebaseUserToAuthUser(cred.user);
}

/** Email + password registration */
export async function register(
  email: string,
  password: string,
  name: string
): Promise<AuthUser> {
  const cred = await createUserWithEmailAndPassword(auth, email, password);
  await updateProfile(cred.user, { displayName: name });
  return firebaseUserToAuthUser(cred.user);
}

/** Google sign-in via popup */
export async function signInWithGoogle(): Promise<AuthUser> {
  const cred = await signInWithPopup(auth, googleProvider);
  return firebaseUserToAuthUser(cred.user);
}

/** Sign out */
export async function logout(): Promise<void> {
  await signOut(auth);
}

/** Get current Firebase user */
export function getCurrentUser(): AuthUser | null {
  const user = auth.currentUser;
  return user ? firebaseUserToAuthUser(user) : null;
}

/** Subscribe to auth state changes */
export function onAuthChange(callback: (user: AuthUser | null) => void): () => void {
  return auth.onAuthStateChanged((firebaseUser) => {
    callback(firebaseUser ? firebaseUserToAuthUser(firebaseUser) : null);
  });
}
