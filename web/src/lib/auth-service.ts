import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signInWithPopup,
  signOut,
  updateProfile,
  updateEmail,
  updatePassword,
  EmailAuthProvider,
  reauthenticateWithCredential,
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

/** Re-authenticate user with current password */
export async function reauthenticate(currentPassword: string): Promise<void> {
  const user = auth.currentUser;
  if (!user || !user.email) throw new Error('Not authenticated');
  const credential = EmailAuthProvider.credential(user.email, currentPassword);
  await reauthenticateWithCredential(user, credential);
}

/** Update display name */
export async function updateUserName(name: string): Promise<void> {
  const user = auth.currentUser;
  if (!user) throw new Error('Not authenticated');
  await updateProfile(user, { displayName: name });
}

/** Update email address */
export async function updateUserEmail(newEmail: string, currentPassword: string): Promise<void> {
  const user = auth.currentUser;
  if (!user) throw new Error('Not authenticated');
  await reauthenticate(currentPassword);
  await updateEmail(user, newEmail);
}

/** Update password */
export async function updateUserPassword(newPassword: string, currentPassword: string): Promise<void> {
  const user = auth.currentUser;
  if (!user) throw new Error('Not authenticated');
  await reauthenticate(currentPassword);
  await updatePassword(user, newPassword);
}

/** Get user creation time */
export function getUserCreationTime(): string | null {
  const user = auth.currentUser;
  return user?.metadata.creationTime || null;
}

/** Check if user signed in with Google (no password) */
export function isGoogleUser(): boolean {
  const user = auth.currentUser;
  return user?.providerData.some((p) => p.providerId === 'google.com') || false;
}
