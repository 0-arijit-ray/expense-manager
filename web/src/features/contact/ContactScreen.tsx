import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Card, Button } from '../../components/ui';
import { ArrowLeft, Mail, MessageSquare, Send, ExternalLink, Globe, AtSign } from 'lucide-react';

const contactMethods = [
  {
    icon: Mail,
    title: 'Email',
    description: 'For support, feedback, or business inquiries',
    contact: 'support@easeyourfinance.app',
    color: 'bg-blue-100 dark:bg-blue-900/30',
    iconColor: 'text-blue-600 dark:text-blue-400',
  },
  {
    icon: Globe,
    title: 'GitHub',
    description: 'Report bugs, request features, or contribute',
    contact: 'github.com/easeyourfinance',
    color: 'bg-gray-100 dark:bg-gray-700',
    iconColor: 'text-gray-600 dark:text-gray-400',
    link: 'https://github.com/easeyourfinance',
  },
  {
    icon: AtSign,
    title: 'Twitter',
    description: 'Follow us for updates and tips',
    contact: '@EaseYourFinance',
    color: 'bg-sky-100 dark:bg-sky-900/30',
    iconColor: 'text-sky-600 dark:text-sky-400',
    link: 'https://twitter.com/EaseYourFinance',
  },
];

const faqs = [
  {
    question: 'Is my financial data safe?',
    answer: 'Absolutely. All your data stays on your device. We have no servers, no accounts, and no way to access your information.',
  },
  {
    question: 'Can I use it offline?',
    answer: 'Yes! Ease Your Finance is designed to work entirely offline. The only optional internet feature is fetching live investment rates.',
  },
  {
    question: 'How do I backup my data?',
    answer: 'Currently, your data is stored locally. We recommend using your device\'s backup features. A dedicated backup/restore feature is planned.',
  },
  {
    question: 'Is it really free?',
    answer: 'Yes, completely free. No premium tiers, no subscriptions, no ads. Just a tool built to help people manage their finances.',
  },
];

export default function ContactScreen() {
  const navigate = useNavigate();
  const [expandedFaq, setExpandedFaq] = useState<number | null>(null);

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
            Contact Us
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            We'd love to hear from you
          </p>
        </div>
      </div>

      {/* Contact Methods */}
      <div className="space-y-3">
        {contactMethods.map((method) => {
          const Icon = method.icon;
          return (
            <Card key={method.title} padding="md">
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 ${method.color} rounded-xl flex items-center justify-center flex-shrink-0`}>
                  <Icon className={`w-6 h-6 ${method.iconColor}`} />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900 dark:text-white">
                    {method.title}
                  </h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {method.description}
                  </p>
                </div>
                {method.link ? (
                  <a
                    href={method.link}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center gap-1 text-sm text-primary hover:text-primary/80 transition-colors"
                  >
                    {method.contact}
                    <ExternalLink className="w-3 h-3" />
                  </a>
                ) : (
                  <span className="text-sm text-gray-700 dark:text-gray-300">
                    {method.contact}
                  </span>
                )}
              </div>
            </Card>
          );
        })}
      </div>

      {/* Quick Message */}
      <Card padding="lg">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-teal-100 dark:bg-teal-900/30 rounded-xl flex items-center justify-center">
            <MessageSquare className="w-5 h-5 text-teal-600 dark:text-teal-400" />
          </div>
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            Send a Message
          </h2>
        </div>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            const formData = new FormData(e.currentTarget);
            const subject = encodeURIComponent(formData.get('subject') as string);
            const body = encodeURIComponent(formData.get('message') as string);
            window.open(`mailto:support@easeyourfinance.app?subject=${subject}&body=${body}`);
          }}
          className="space-y-4"
        >
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Subject
            </label>
            <input
              name="subject"
              type="text"
              required
              className="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary focus:border-transparent"
              placeholder="How can we help?"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Message
            </label>
            <textarea
              name="message"
              required
              rows={4}
              className="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary focus:border-transparent resize-none"
              placeholder="Tell us what's on your mind..."
            />
          </div>
          <Button type="submit" className="w-full rounded-xl">
            <Send className="w-4 h-4 mr-2" />
            Send Message
          </Button>
        </form>
      </Card>

      {/* FAQs */}
      <div>
        <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Frequently Asked Questions
        </h2>
        <div className="space-y-3">
          {faqs.map((faq, index) => (
            <Card key={index} padding="md">
              <button
                onClick={() => setExpandedFaq(expandedFaq === index ? null : index)}
                className="w-full text-left"
              >
                <div className="flex items-center justify-between">
                  <h3 className="font-medium text-gray-900 dark:text-white pr-4">
                    {faq.question}
                  </h3>
                  <span className={`text-gray-400 transition-transform ${expandedFaq === index ? 'rotate-180' : ''}`}>
                    ▼
                  </span>
                </div>
                {expandedFaq === index && (
                  <p className="text-sm text-gray-600 dark:text-gray-400 mt-3">
                    {faq.answer}
                  </p>
                )}
              </button>
            </Card>
          ))}
        </div>
      </div>

      {/* Community */}
      <Card padding="lg" className="bg-gradient-to-br from-teal-50 to-emerald-50 dark:from-teal-900/20 dark:to-emerald-900/20 border-teal-200 dark:border-teal-800">
        <div className="text-center py-2">
          <h2 className="text-lg font-semibold text-teal-800 dark:text-teal-200 mb-2">
            Join Our Community
          </h2>
          <p className="text-sm text-teal-600 dark:text-teal-300 mb-4">
            Connect with other users, share tips, and help shape the future of Ease Your Finance.
          </p>
          <div className="flex justify-center gap-4">
            <a
              href="https://github.com/easeyourfinance"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-2 px-4 py-2 bg-white dark:bg-gray-800 rounded-xl text-sm font-medium text-gray-700 dark:text-gray-300 hover:shadow-md transition-shadow"
            >
              <Globe className="w-4 h-4" />
              GitHub
            </a>
            <a
              href="https://twitter.com/EaseYourFinance"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-2 px-4 py-2 bg-white dark:bg-gray-800 rounded-xl text-sm font-medium text-gray-700 dark:text-gray-300 hover:shadow-md transition-shadow"
            >
              <AtSign className="w-4 h-4" />
              Twitter
            </a>
          </div>
        </div>
      </Card>
    </div>
  );
}
