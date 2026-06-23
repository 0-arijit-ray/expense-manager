import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button, Card, Input, Avatar } from '../../components/ui';
import { useAuthStore } from '../../stores/auth-store';
import { getUserCreationTime, isGoogleUser } from '../../lib/auth-service';
import {
  ArrowLeft,
  User,
  Mail,
  Lock,
  Calendar,
  Shield,
  Loader2,
  Check,
  AlertTriangle,
} from 'lucide-react';

export default function ProfileScreen() {
  const navigate = useNavigate();
  const user = useAuthStore((s) => s.user);
  const updateName = useAuthStore((s) => s.updateName);
  const updateEmail = useAuthStore((s) => s.updateEmail);
  const updatePassword = useAuthStore((s) => s.updatePassword);

  const [editingName, setEditingName] = useState(false);
  const [name, setName] = useState(user?.name || '');
  const [nameLoading, setNameLoading] = useState(false);
  const [nameSuccess, setNameSuccess] = useState(false);

  const [editingEmail, setEditingEmail] = useState(false);
  const [newEmail, setNewEmail] = useState('');
  const [emailPassword, setEmailPassword] = useState('');
  const [emailLoading, setEmailLoading] = useState(false);
  const [emailSuccess, setEmailSuccess] = useState(false);

  const [editingPassword, setEditingPassword] = useState(false);
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [passwordLoading, setPasswordLoading] = useState(false);
  const [passwordSuccess, setPasswordSuccess] = useState(false);

  const [error, setError] = useState('');

  const isGoogle = isGoogleUser();
  const creationTime = getUserCreationTime();

  useEffect(() => {
    if (user) setName(user.name);
  }, [user]);

  if (!user) return null;

  const handleSaveName = async () => {
    if (!name.trim()) return;
    setError('');
    setNameLoading(true);
    try {
      await updateName(name.trim());
      setEditingName(false);
      setNameSuccess(true);
      setTimeout(() => setNameSuccess(false), 2000);
    } catch (e: any) {
      setError(e.message || 'Failed to update name');
    } finally {
      setNameLoading(false);
    }
  };

  const handleSaveEmail = async () => {
    if (!newEmail.trim() || !emailPassword) return;
    setError('');
    setEmailLoading(true);
    try {
      await updateEmail(newEmail.trim(), emailPassword);
      setEditingEmail(false);
      setEmailPassword('');
      setEmailSuccess(true);
      setTimeout(() => setEmailSuccess(false), 2000);
    } catch (e: any) {
      setError(e.message === 'Firebase: Error (auth/wrong-password).'
        ? 'Incorrect password'
        : e.message || 'Failed to update email');
    } finally {
      setEmailLoading(false);
    }
  };

  const handleSavePassword = async () => {
    if (!currentPassword || !newPassword) return;
    if (newPassword !== confirmPassword) {
      setError('New passwords do not match');
      return;
    }
    setError('');
    setPasswordLoading(true);
    try {
      await updatePassword(newPassword, currentPassword);
      setEditingPassword(false);
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
      setPasswordSuccess(true);
      setTimeout(() => setPasswordSuccess(false), 2000);
    } catch (e: any) {
      setError(e.message === 'Firebase: Error (auth/wrong-password).'
        ? 'Incorrect current password'
        : e.message || 'Failed to update password');
    } finally {
      setPasswordLoading(false);
    }
  };

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="rounded-xl">
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Profile</h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">Manage your account</p>
        </div>
      </div>

      {/* Profile Hero */}
      <Card padding="none" className="overflow-hidden">
        <div className="relative h-40 sm:h-48 bg-gradient-to-br from-emerald-600 via-teal-500 to-cyan-400">
          {/* Decorative blobs */}
          <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full -translate-y-1/2 translate-x-1/4 blur-2xl" />
          <div className="absolute bottom-0 left-1/4 w-48 h-48 bg-emerald-300/20 rounded-full translate-y-1/2 blur-2xl" />
          <div className="absolute top-1/2 right-1/3 w-32 h-32 bg-cyan-300/15 rounded-full -translate-y-1/2 blur-xl" />
          {/* Grid pattern */}
          <div className="absolute inset-0 opacity-[0.07]" style={{
            backgroundImage: 'linear-gradient(rgba(255,255,255,0.5) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.5) 1px, transparent 1px)',
            backgroundSize: '40px 40px',
          }} />
          {/* Shimmer */}
          <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent animate-shimmer" style={{ animationDuration: '3s' }} />
          <div className="absolute -bottom-10 left-6">
            <Avatar src={user.photoURL} name={user.name} size="xl" className="ring-4 ring-white dark:ring-gray-900 shadow-lg" />
          </div>
        </div>
        <div className="px-6 pt-12 pb-6">
          <div className="flex flex-col sm:flex-row items-center sm:items-center gap-3">
            <div className="flex-1 text-center sm:text-left">
              <h2 className="text-xl font-bold text-gray-900 dark:text-white">{user.name}</h2>
              <p className="text-sm text-gray-500 dark:text-gray-400">{user.email}</p>
            </div>
          </div>
        </div>
      </Card>

      {/* Error */}
      {error && (
        <div className="p-4 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 flex items-center gap-3">
          <AlertTriangle className="w-5 h-5 text-red-500 shrink-0" />
          <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
        </div>
      )}

      {/* Personal Info */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 rounded-xl flex items-center justify-center">
            <User className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">Personal Information</h2>
        </div>

        {/* Name */}
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div className="flex items-center gap-3">
              <User className="w-4 h-4 text-gray-400" />
              <div>
                <p className="text-xs text-gray-500 dark:text-gray-400">Display Name</p>
                {editingName ? (
                  <div className="flex items-center gap-2 mt-1">
                    <Input
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      className="h-9 text-sm"
                    />
                    <Button size="sm" onClick={handleSaveName} disabled={nameLoading || !name.trim()}>
                      {nameLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />}
                    </Button>
                    <Button size="sm" variant="ghost" onClick={() => { setEditingName(false); setName(user.name); }}>
                      Cancel
                    </Button>
                  </div>
                ) : (
                  <p className="text-sm font-medium text-gray-900 dark:text-white">{user.name}</p>
                )}
              </div>
            </div>
            {!editingName && (
              <button
                onClick={() => setEditingName(true)}
                className="text-sm text-primary hover:underline"
              >
                Edit
              </button>
            )}
          </div>
          {nameSuccess && (
            <p className="text-sm text-emerald-600 dark:text-emerald-400 flex items-center gap-1">
              <Check className="w-4 h-4" /> Name updated successfully
            </p>
          )}

          {/* Email */}
          <div className="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Mail className="w-4 h-4 text-gray-400" />
                <div>
                  <p className="text-xs text-gray-500 dark:text-gray-400">Email Address</p>
                  {editingEmail ? (
                    <div className="space-y-2 mt-1">
                      <Input
                        type="email"
                        value={newEmail}
                        onChange={(e) => setNewEmail(e.target.value)}
                        placeholder="New email"
                        className="h-9 text-sm"
                      />
                      <Input
                        type="password"
                        value={emailPassword}
                        onChange={(e) => setEmailPassword(e.target.value)}
                        placeholder="Current password to confirm"
                        className="h-9 text-sm"
                      />
                      <div className="flex items-center gap-2">
                        <Button size="sm" onClick={handleSaveEmail} disabled={emailLoading || !newEmail.trim() || !emailPassword}>
                          {emailLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />}
                          Save
                        </Button>
                        <Button size="sm" variant="ghost" onClick={() => { setEditingEmail(false); setNewEmail(''); setEmailPassword(''); }}>
                          Cancel
                        </Button>
                      </div>
                    </div>
                  ) : (
                    <p className="text-sm font-medium text-gray-900 dark:text-white">{user.email}</p>
                  )}
                </div>
              </div>
              {!editingEmail && !isGoogle && (
                <button
                  onClick={() => { setEditingEmail(true); setNewEmail(user.email); }}
                  className="text-sm text-primary hover:underline"
                >
                  Edit
                </button>
              )}
            </div>
            {emailSuccess && (
              <p className="text-sm text-emerald-600 dark:text-emerald-400 flex items-center gap-1 mt-2">
                <Check className="w-4 h-4" /> Email updated successfully
              </p>
            )}
          </div>
        </div>
      </Card>

      {/* Security */}
      {!isGoogle && (
        <Card padding="lg">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 bg-blue-100 dark:bg-blue-900/30 rounded-xl flex items-center justify-center">
              <Lock className="w-5 h-5 text-blue-600 dark:text-blue-400" />
            </div>
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white">Security</h2>
          </div>

          <div className="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Lock className="w-4 h-4 text-gray-400" />
                <div>
                  <p className="text-xs text-gray-500 dark:text-gray-400">Password</p>
                  {editingPassword ? (
                    <div className="space-y-2 mt-1">
                      <Input
                        type="password"
                        value={currentPassword}
                        onChange={(e) => setCurrentPassword(e.target.value)}
                        placeholder="Current password"
                        className="h-9 text-sm"
                      />
                      <Input
                        type="password"
                        value={newPassword}
                        onChange={(e) => setNewPassword(e.target.value)}
                        placeholder="New password"
                        className="h-9 text-sm"
                      />
                      <Input
                        type="password"
                        value={confirmPassword}
                        onChange={(e) => setConfirmPassword(e.target.value)}
                        placeholder="Confirm new password"
                        className="h-9 text-sm"
                      />
                      <div className="flex items-center gap-2">
                        <Button size="sm" onClick={handleSavePassword} disabled={passwordLoading || !currentPassword || !newPassword}>
                          {passwordLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />}
                          Update
                        </Button>
                        <Button size="sm" variant="ghost" onClick={() => { setEditingPassword(false); setCurrentPassword(''); setNewPassword(''); setConfirmPassword(''); }}>
                          Cancel
                        </Button>
                      </div>
                    </div>
                  ) : (
                    <p className="text-sm font-medium text-gray-900 dark:text-white">••••••••</p>
                  )}
                </div>
              </div>
              {!editingPassword && (
                <button
                  onClick={() => setEditingPassword(true)}
                  className="text-sm text-primary hover:underline"
                >
                  Change
                </button>
              )}
            </div>
            {passwordSuccess && (
              <p className="text-sm text-emerald-600 dark:text-emerald-400 flex items-center gap-1 mt-2">
                <Check className="w-4 h-4" /> Password updated successfully
              </p>
            )}
          </div>
        </Card>
      )}

      {/* Account Info */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 bg-purple-100 dark:bg-purple-900/30 rounded-xl flex items-center justify-center">
            <Shield className="w-5 h-5 text-purple-600 dark:text-purple-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">Account Details</h2>
        </div>

        <div className="space-y-3">
          <div className="flex items-center justify-between p-3 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div className="flex items-center gap-3">
              <Calendar className="w-4 h-4 text-gray-400" />
              <div>
                <p className="text-xs text-gray-500 dark:text-gray-400">Member Since</p>
                <p className="text-sm font-medium text-gray-900 dark:text-white">
                  {creationTime
                    ? new Date(creationTime).toLocaleDateString('en-US', {
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric',
                      })
                    : 'Unknown'}
                </p>
              </div>
            </div>
          </div>

          <div className="flex items-center justify-between p-3 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div className="flex items-center gap-3">
              <Shield className="w-4 h-4 text-gray-400" />
              <div>
                <p className="text-xs text-gray-500 dark:text-gray-400">Sign-in Method</p>
                <p className="text-sm font-medium text-gray-900 dark:text-white">
                  {isGoogle ? 'Google' : 'Email & Password'}
                </p>
              </div>
            </div>
          </div>

          <div className="flex items-center justify-between p-3 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div className="flex items-center gap-3">
              <Mail className="w-4 h-4 text-gray-400" />
              <div>
                <p className="text-xs text-gray-500 dark:text-gray-400">User ID</p>
                <p className="text-sm font-medium text-gray-900 dark:text-white font-mono">{user.id}</p>
              </div>
            </div>
          </div>
        </div>
      </Card>
    </div>
  );
}
