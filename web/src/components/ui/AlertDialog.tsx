import Modal from './Modal';
import { Info, CheckCircle, AlertCircle } from 'lucide-react';

interface AlertDialogProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  message: string;
  buttonLabel?: string;
  variant?: 'success' | 'error' | 'info';
}

export default function AlertDialog({
  isOpen,
  onClose,
  title,
  message,
  buttonLabel = 'OK',
  variant = 'info',
}: AlertDialogProps) {
  const iconColor =
    variant === 'success'
      ? 'text-green-500 bg-green-50 dark:bg-green-900/30'
      : variant === 'error'
        ? 'text-red-500 bg-red-50 dark:bg-red-900/30'
        : 'text-primary bg-primary/10';

  const Icon = variant === 'success' ? CheckCircle : variant === 'error' ? AlertCircle : Info;

  return (
    <Modal isOpen={isOpen} onClose={onClose} size="sm">
      <div className="flex flex-col items-center text-center gap-4">
        <div className={`w-12 h-12 rounded-full flex items-center justify-center ${iconColor}`}>
          <Icon className="w-6 h-6" />
        </div>
        <div>
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
            {title}
          </h3>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {message}
          </p>
        </div>
        <button
          onClick={onClose}
          className="w-full px-4 py-2.5 rounded-xl bg-primary hover:bg-primary-dark text-white font-medium transition-colors"
        >
          {buttonLabel}
        </button>
      </div>
    </Modal>
  );
}
