import { initializeApp } from 'firebase/app';
import { getAuth, GoogleAuthProvider } from 'firebase/auth';

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY || 'AIzaSyBRhjzt0nEabRggii2torZ2xzduYhf4_FI',
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN || 'expense-manager-4c7df.firebaseapp.com',
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID || 'expense-manager-4c7df',
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET || 'expense-manager-4c7df.firebasestorage.app',
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID || '116305206662',
  appId: import.meta.env.VITE_FIREBASE_APP_ID || '1:116305206662:web:3fcab208db66d6c47a6007',
  measurementId: import.meta.env.VITE_FIREBASE_MEASUREMENT_ID || 'G-WMGXBY2ZBG',
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();
