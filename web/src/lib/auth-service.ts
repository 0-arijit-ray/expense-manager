/**
 * Auth service stubs — replace these with real API calls to your backend.
 *
 * Each function simulates a network request with a short delay.
 * TODO: Wire up to real backend endpoints.
 */

export interface AuthUser {
  id: string;
  email: string;
  name: string;
}

export interface AuthResponse {
  token: string;
  user: AuthUser;
}

const DEVICE_KEY = 'ease-finance-device-pin';

function delay(ms = 800) {
  return new Promise((r) => setTimeout(r, ms));
}

/** Email + password login. Replace stub with real fetch. */
export async function login(email: string, _password: string): Promise<AuthResponse> {
  await delay();
  // TODO: POST /api/auth/login
  // For now, accept any non-empty email/password
  if (!email) throw new Error('Email is required');
  return {
    token: `mock-token-${Date.now()}`,
    user: { id: '1', email, name: email.split('@')[0] },
  };
}

/** Email + password registration. Replace stub with real fetch. */
export async function register(
  email: string,
  _password: string,
  name: string
): Promise<AuthResponse> {
  await delay();
  // TODO: POST /api/auth/register
  if (!email) throw new Error('Email is required');
  return {
    token: `mock-token-${Date.now()}`,
    user: { id: '1', email, name },
  };
}

/** Check if device has a PIN set up. */
export function hasDevicePin(): boolean {
  return localStorage.getItem(DEVICE_KEY) !== null;
}

/** Set up a new device PIN (hashed in production). */
export function setupDevicePin(pin: string): void {
  // TODO: hash pin before storing
  localStorage.setItem(DEVICE_KEY, pin);
}

/** Verify device PIN. */
export function verifyDevicePin(pin: string): boolean {
  const stored = localStorage.getItem(DEVICE_KEY);
  return stored === pin;
}

/** Remove device PIN (logout). */
export function clearDevicePin(): void {
  localStorage.removeItem(DEVICE_KEY);
}
