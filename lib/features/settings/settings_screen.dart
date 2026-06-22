import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/settings.dart';
import '../../services/notification_service.dart';
import '../../shared/widgets/app_footer.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionLabel('Appearance'),
          RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (m) => notifier.setThemeMode(m ?? ThemeMode.system),
            child: const Column(
              children: [
                RadioListTile(
                    value: ThemeMode.system, title: Text('System default')),
                RadioListTile(value: ThemeMode.light, title: Text('Light')),
                RadioListTile(value: ThemeMode.dark, title: Text('Dark')),
              ],
            ),
          ),
          const Divider(),
          const _SectionLabel('Currency'),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency'),
            subtitle: Text('${settings.currencySymbol} · ${settings.locale}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickCurrency(context, notifier),
          ),
          const Divider(),
          const _SectionLabel('Automation'),
          ListTile(
            leading: const Icon(Icons.repeat),
            title: const Text('Recurring income & expenses'),
            subtitle: const Text('Salary, rent, subscriptions, SIPs'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/recurring'),
          ),
          const Divider(),
          const _SectionLabel('Labels'),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Auto tag label'),
            subtitle: Text(settings.autoLabel),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editLabel(context, notifier, 'Auto tag label', settings.autoLabel, (v) => notifier.setAutoLabel(v)),
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('EMI tag label'),
            subtitle: Text(settings.emiLabel),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editLabel(context, notifier, 'EMI tag label', settings.emiLabel, (v) => notifier.setEmiLabel(v)),
          ),
          const Divider(),
          const _SectionLabel('Investments'),
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text('Live rates endpoint'),
            subtitle: Text(settings.ratesEndpoint.isEmpty
                ? 'Using built-in reference rates'
                : settings.ratesEndpoint),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editRates(context, notifier, settings.ratesEndpoint),
          ),
          const Divider(),
          const _SectionLabel('Notifications'),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('Enable EMI reminders'),
            subtitle: const Text('Grant notification permission'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final granted =
                  await NotificationService.instance.requestPermissions();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(granted
                          ? 'Notifications enabled'
                          : 'Permission denied')),
                );
              }
            },
          ),
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'Ease Your Finance',
            applicationVersion: '1.0.0',
            aboutBoxChildren: [
              Text(
                  'A private, offline-first personal finance app for expenses, loans, investments and net worth.'),
            ],
          ),
          const SizedBox(height: 24),
          
          // Footer
          const AppFooter(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _pickCurrency(
      BuildContext context, SettingsNotifier notifier) async {
    const options = [
      ('\u20B9', 'en_IN', 'Indian Rupee'),
      ('\$', 'en_US', 'US Dollar'),
      ('\u20AC', 'de_DE', 'Euro'),
      ('\u00A3', 'en_GB', 'British Pound'),
      ('\u00A5', 'ja_JP', 'Japanese Yen'),
    ];
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((o) => ListTile(
                    leading: Text(o.$1,
                        style: const TextStyle(fontSize: 22)),
                    title: Text(o.$3),
                    subtitle: Text(o.$2),
                    onTap: () {
                      notifier.setCurrency(o.$1, o.$2);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<void> _editRates(BuildContext context, SettingsNotifier notifier,
      String current) async {
    final controller = TextEditingController(text: current);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Live rates endpoint'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'https://example.com/rates.json',
            helperText: 'Returns JSON of indicative rates. Leave blank for defaults.',
            helperMaxLines: 2,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              notifier.setRatesEndpoint(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editLabel(BuildContext context, SettingsNotifier notifier,
      String title, String current, Function(String) onSave) async {
    final controller = TextEditingController(text: current);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter label text',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5),
      ),
    );
  }
}
