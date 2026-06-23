import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../stores/auth-store';
import ConfirmDialog from './ConfirmDialog';

interface LogoutConfirmProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function LogoutConfirm({ isOpen, onClose }: LogoutConfirmProps) {
  const navigate = useNavigate();
  const logout = useAuthStore((s) => s.logout);

  const handleConfirm = async () => {
    await logout();
    onClose();
    navigate('/login');
  };

  return (
    <ConfirmDialog
      isOpen={isOpen}
      onClose={onClose}
      onConfirm={handleConfirm}
      title="Sign Out"
      message="Are you sure you want to sign out?"
      confirmLabel="Sign Out"
    />
  );
}
