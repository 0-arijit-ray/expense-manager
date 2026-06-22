import { useNavigate } from 'react-router-dom';
import { Card, Button } from '../../components/ui';
import { ArrowLeft, Shield, Heart, Lock, Globe, Code, Users } from 'lucide-react';

const values = [
  {
    icon: Shield,
    title: 'Privacy First',
    description: 'Your financial data never leaves your device. No cloud sync, no accounts, no tracking.',
    color: 'bg-teal-100 dark:bg-teal-900/30',
    iconColor: 'text-teal-600 dark:text-teal-400',
  },
  {
    icon: Lock,
    title: 'Offline by Design',
    description: 'Works without internet. Your money management continues even in airplane mode.',
    color: 'bg-blue-100 dark:bg-blue-900/30',
    iconColor: 'text-blue-600 dark:text-blue-400',
  },
  {
    icon: Heart,
    title: 'Built with Care',
    description: 'Designed for real people who want simple, powerful tools to manage their finances.',
    color: 'bg-pink-100 dark:bg-pink-900/30',
    iconColor: 'text-pink-600 dark:text-pink-400',
  },
  {
    icon: Globe,
    title: 'Multi-Platform',
    description: 'Available on Android, iOS, and Web. Your experience stays consistent everywhere.',
    color: 'bg-purple-100 dark:bg-purple-900/30',
    iconColor: 'text-purple-600 dark:text-purple-400',
  },
];

const features = [
  'Track daily expenses and income',
  'Manage loans with EMI calculations',
  'Monitor investment portfolios',
  'Automate recurring transactions',
  'Calculate net worth in real-time',
  'Beautiful charts and insights',
];

export default function AboutScreen() {
  const navigate = useNavigate();

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => navigate(-1)}
          className="rounded-xl"
        >
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            About Us
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            The story behind Ease Your Finance
          </p>
        </div>
      </div>

      {/* Mission Statement */}
      <Card padding="lg" className="bg-gradient-to-br from-teal-50 to-emerald-50 dark:from-teal-900/20 dark:to-emerald-900/20 border-teal-200 dark:border-teal-800">
        <div className="text-center py-4">
          <img src="/favicon.svg" alt="Ease Your Finance" className="w-16 h-16 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-teal-800 dark:text-teal-200 mb-2">
            Ease Your Finance
          </h2>
          <p className="text-lg text-teal-600 dark:text-teal-300 italic mb-4">
            "Your money, simplified."
          </p>
          <p className="text-gray-700 dark:text-gray-300 max-w-2xl mx-auto">
            We believe managing your finances should be simple, private, and accessible to everyone.
            No complicated setups, no data harvesting, no subscriptions. Just powerful tools
            that help you take control of your money.
          </p>
        </div>
      </Card>

      {/* Values */}
      <div>
        <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Our Values
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {values.map((value) => {
            const Icon = value.icon;
            return (
              <Card key={value.title} padding="md">
                <div className="flex items-start gap-3">
                  <div className={`w-10 h-10 ${value.color} rounded-xl flex items-center justify-center flex-shrink-0`}>
                    <Icon className={`w-5 h-5 ${value.iconColor}`} />
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {value.title}
                    </h3>
                    <p className="text-sm text-gray-600 dark:text-gray-400 mt-1">
                      {value.description}
                    </p>
                  </div>
                </div>
              </Card>
            );
          })}
        </div>
      </div>

      {/* Features */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-green-100 dark:bg-green-900/30 rounded-xl flex items-center justify-center">
            <Code className="w-5 h-5 text-green-600 dark:text-green-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            What We Offer
          </h2>
        </div>
        <ul className="space-y-3">
          {features.map((feature, index) => (
            <li key={index} className="flex items-center gap-3">
              <div className="w-6 h-6 bg-teal-100 dark:bg-teal-900/30 rounded-full flex items-center justify-center flex-shrink-0">
                <span className="text-xs font-bold text-teal-600 dark:text-teal-400">
                  {index + 1}
                </span>
              </div>
              <span className="text-sm text-gray-700 dark:text-gray-300">
                {feature}
              </span>
            </li>
          ))}
        </ul>
      </Card>

      {/* Open Source */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-gray-100 dark:bg-gray-700 rounded-xl flex items-center justify-center">
            <Globe className="w-5 h-5 text-gray-600 dark:text-gray-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Open Source
          </h2>
        </div>
        <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
          Ease Your Finance is built with transparency in mind. Our codebase is open
          for anyone to audit, contribute, or learn from.
        </p>
        <div className="flex items-center gap-2 text-sm">
          <Users className="w-4 h-4 text-gray-500" />
          <span className="text-gray-600 dark:text-gray-400">
            Built by developers, for everyone
          </span>
        </div>
      </Card>

      {/* Version */}
      <div className="text-center py-4">
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Version 1.0.0
        </p>
        <p className="text-xs text-gray-400 dark:text-gray-500 mt-1">
          Made with care for your financial wellness
        </p>
      </div>
    </div>
  );
}
