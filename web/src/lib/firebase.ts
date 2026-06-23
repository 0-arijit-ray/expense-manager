import { initializeApp } from 'firebase/app';
import { getAuth, GoogleAuthProvider } from 'firebase/auth';

const firebaseConfig = {
  apiKey: 'AIzaSyBRhjzt0nEabRggii2torZ2xzduYhf4_FI',
  authDomain: 'expense-manager-4c7df.firebaseapp.com',
  projectId: 'expense-manager-4c7df',
  storageBucket: 'expense-manager-4c7df.firebasestorage.app',
  messagingSenderId: '116305206662',
  appId: '1:116305206662:web:3fcab208db66d6c47a6007',
  measurementId: 'G-WMGXBY2ZBG',
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();
