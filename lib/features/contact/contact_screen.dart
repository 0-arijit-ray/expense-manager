import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  int? _expandedFaq;
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      final subject = Uri.encodeComponent(_subjectController.text);
      final body = Uri.encodeComponent(_messageController.text);
      final uri = Uri.parse('mailto:support@easeyourfinance.app?subject=$subject&body=$body');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Text(
            "We'd love to hear from you",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Contact Methods
          _ContactMethod(
            icon: Icons.email,
            title: 'Email',
            description: 'For support, feedback, or business inquiries',
            contact: 'support@easeyourfinance.app',
            color: Colors.blue,
            onTap: () async {
              final uri = Uri.parse('mailto:support@easeyourfinance.app');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ),
          _ContactMethod(
            icon: Icons.code,
            title: 'GitHub',
            description: 'Report bugs, request features, or contribute',
            contact: 'github.com/easeyourfinance',
            color: Colors.grey,
            onTap: () async {
              final uri = Uri.parse('https://github.com/easeyourfinance');
              if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          _ContactMethod(
            icon: Icons.flutter_dash,
            title: 'Twitter',
            description: 'Follow us for updates and tips',
            contact: '@EaseYourFinance',
            color: Colors.lightBlue,
            onTap: () async {
              final uri = Uri.parse('https://twitter.com/EaseYourFinance');
              if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          const SizedBox(height: 24),

          // Send Message Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.message, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Send a Message',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        hintText: 'How can we help?',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        hintText: "Tell us what's on your mind...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _sendEmail,
                        icon: const Icon(Icons.send),
                        label: const Text('Send Message'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // FAQs
          Text(
            'FREQUENTLY ASKED QUESTIONS',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'Is my financial data safe?',
            answer: 'Absolutely. All your data stays on your device. We have no servers, no accounts, and no way to access your information.',
            isExpanded: _expandedFaq == 0,
            onTap: () => setState(() => _expandedFaq = _expandedFaq == 0 ? null : 0),
          ),
          _FaqItem(
            question: 'Can I use it offline?',
            answer: 'Yes! Ease Your Finance is designed to work entirely offline. The only optional internet feature is fetching live investment rates.',
            isExpanded: _expandedFaq == 1,
            onTap: () => setState(() => _expandedFaq = _expandedFaq == 1 ? null : 1),
          ),
          _FaqItem(
            question: 'How do I backup my data?',
            answer: "Currently, your data is stored locally. We recommend using your device's backup features. A dedicated backup/restore feature is planned.",
            isExpanded: _expandedFaq == 2,
            onTap: () => setState(() => _expandedFaq = _expandedFaq == 2 ? null : 2),
          ),
          _FaqItem(
            question: 'Is it really free?',
            answer: 'Yes, completely free. No premium tiers, no subscriptions, no ads. Just a tool built to help people manage their finances.',
            isExpanded: _expandedFaq == 3,
            onTap: () => setState(() => _expandedFaq = _expandedFaq == 3 ? null : 3),
          ),
          const SizedBox(height: 24),

          // Community
          Container(
            padding: const EdgeInsets.all(20),
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
                Text(
                  'Join Our Community',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with other users, share tips, and help shape the future of Ease Your Finance.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('https://github.com/easeyourfinance');
                        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                      icon: const Icon(Icons.code, size: 16),
                      label: const Text('GitHub'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('https://twitter.com/EaseYourFinance');
                        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                      icon: const Icon(Icons.flutter_dash, size: 16),
                      label: const Text('Twitter'),
                    ),
                  ],
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

class _ContactMethod extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String contact;
  final Color color;
  final VoidCallback onTap;

  const _ContactMethod({
    required this.icon,
    required this.title,
    required this.description,
    required this.contact,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
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
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                contact,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more, size: 20),
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  answer,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
