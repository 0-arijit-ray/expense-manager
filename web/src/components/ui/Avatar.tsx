import { clsx } from 'clsx';

interface AvatarProps {
  src: string | null | undefined;
  name: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
}

const sizeClasses = {
  sm: 'w-8 h-8 text-xs',
  md: 'w-10 h-10 text-sm',
  lg: 'w-14 h-14 text-lg',
  xl: 'w-20 h-20 text-2xl',
};

const gradientColors = [
  'from-emerald-400 to-teal-600',
  'from-blue-400 to-indigo-600',
  'from-purple-400 to-pink-600',
  'from-orange-400 to-red-600',
  'from-cyan-400 to-blue-600',
  'from-rose-400 to-fuchsia-600',
];

function getInitials(name: string): string {
  return name
    .split(' ')
    .map((word) => word[0])
    .slice(0, 2)
    .join('')
    .toUpperCase();
}

function getGradient(name: string): string {
  const index = name.charCodeAt(0) % gradientColors.length;
  return gradientColors[index];
}

export default function Avatar({ src, name, size = 'md', className }: AvatarProps) {
  return (
    <div
      className={clsx(
        'relative rounded-full overflow-hidden shrink-0',
        sizeClasses[size],
        !src && 'bg-gradient-to-br',
        !src && getGradient(name),
        className
      )}
    >
      {src ? (
        <img
          src={src}
          alt={name}
          className="w-full h-full object-cover"
          onError={(e) => {
            e.currentTarget.style.display = 'none';
          }}
        />
      ) : (
        <div className="w-full h-full flex items-center justify-center font-bold text-white">
          {getInitials(name)}
        </div>
      )}
    </div>
  );
}
