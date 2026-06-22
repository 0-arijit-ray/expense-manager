import { Navigate, Outlet } from 'react-router-dom';
import { useAuthStore } from '../../stores/auth-store';
import { hasDevicePin } from '../../lib/auth-service';

export default function AuthGuard() {
  const { token, isInitialized } = useAuthStore();

  if (!token) {
    return <Navigate to="/" replace />;
  }

  if (!isInitialized && hasDevicePin()) {
    return <Navigate to="/verify" replace />;
  }

  if (!isInitialized) {
    return <Navigate to="/verify" replace />;
  }

  return <Outlet />;
}
