import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.svg',
                  height: 80,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ease Your Finance',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Your money, simplified."',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'We believe managing your finances should be simple, private, and accessible to everyone. No complicated setups, no data harvesting, no subscriptions.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Values Section
          Text(
            'OUR VALUES',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _ValueCard(
            icon: Icons.shield,
            title: 'Privacy First',
            description: 'Your financial data never leaves your device. No cloud sync, no accounts, no tracking.',
            color: Colors.teal,
          ),
          _ValueCard(
            icon: Icons.wifi_off,
            title: 'Offline by Design',
            description: 'Works without internet. Your money management continues even in airplane mode.',
            color: Colors.blue,
          ),
          _ValueCard(
            icon: Icons.favorite,
            title: 'Built with Care',
            description: 'Designed for real people who want simple, powerful tools to manage their finances.',
            color: Colors.pink,
          ),
          _ValueCard(
            icon: Icons.devices,
            title: 'Multi-Platform',
            description: 'Available on Android, iOS, and Web. Your experience stays consistent everywhere.',
            color: Colors.purple,
          ),
          const SizedBox(height: 24),

          // Features Section
          Text(
            'WHAT WE OFFER',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _FeatureItem('Track daily expenses and income'),
          _FeatureItem('Manage loans with EMI calculations'),
          _FeatureItem('Monitor investment portfolios'),
          _FeatureItem('Automate recurring transactions'),
          _FeatureItem('Calculate net worth in real-time'),
          _FeatureItem('Beautiful charts and insights'),
          const SizedBox(height: 24),

          // Open Source
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.code, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Open Source',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ease Your Finance is built with transparency in mind. Our codebase is open for anyone to audit, contribute, or learn from.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        'Built by developers, for everyone',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Version
          Center(
            child: Column(
              children: [
                Text(
                  'Version 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with care for your financial wellness',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
