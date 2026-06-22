export default function Footer() {
  return (
    <footer className="mt-auto py-6 px-6 lg:px-8">
      <div className="max-w-5xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <img src="/favicon.svg" alt="Ease Your Finance" className="w-5 h-5 opacity-60" />
          <span className="text-sm font-medium text-gray-500 dark:text-gray-400">
            Ease Your Finance
          </span>
        </div>

        <p className="text-xs text-gray-400 dark:text-gray-500">
          © {new Date().getFullYear()} All rights reserved
        </p>

        <p className="text-xs text-gray-400 dark:text-gray-500 italic">
          Your money, simplified
        </p>
      </div>
    </footer>
  );
}
