import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/finance_math.dart';
import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../services/notification_service.dart';
import 'loans_providers.dart';

class LoanForm extends ConsumerStatefulWidget {
  const LoanForm({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const LoanForm(),
    );
  }

  @override
  ConsumerState<LoanForm> createState() => _LoanFormState();
}

class _LoanFormState extends ConsumerState<LoanForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _lender = TextEditingController();
  final _principal = TextEditingController();
  final _rate = TextEditingController(text: '9.0');
  final _tenure = TextEditingController(text: '60');
  LoanType _type = LoanType.home;
  DateTime _startDate = DateTime.now();
  int _dueDay = 5;
  bool _autoPost = true;
  bool _autoDebit = false;
  bool _alerts = true;
  int _leadDays = 2;

  @override
  void dispose() {
    _name.dispose();
    _lender.dispose();
    _principal.dispose();
    _rate.dispose();
    _tenure.dispose();
    super.dispose();
  }

  double get _emiPreview {
    final p = double.tryParse(_principal.text.replaceAll(',', '')) ?? 0;
    final r = double.tryParse(_rate.text) ?? 0;
    final n = int.tryParse(_tenure.text) ?? 0;
    if (p <= 0 || n <= 0) return 0;
    return FinanceMath.emi(principal: p, annualRatePct: r, tenureMonths: n);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(loanRepoProvider);
    final id = await repo.createLoan(
      name: _name.text.trim(),
      type: _type,
      lender: _lender.text.trim().isEmpty ? null : _lender.text.trim(),
      principal: double.parse(_principal.text.replaceAll(',', '')),
      annualRate: double.parse(_rate.text),
      tenureMonths: int.parse(_tenure.text),
      startDate: _startDate,
      dueDay: _dueDay,
      autoPostExpense: _autoPost,
      autoDebit: _autoDebit,
      alertsEnabled: _alerts,
      alertLeadDays: _leadDays,
    );
    ref.read(scheduleRefreshProvider.notifier).bump();

    if (_alerts) {
      final loan = await repo.getLoan(id);
      final schedule = await repo.watchSchedule(id).first;
      for (final e in schedule.where((e) => !e.paid).take(6)) {
        await NotificationService.instance
            .scheduleEmiReminder(loan: loan, emi: e);
      }
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New loan',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              DropdownButtonFormField<LoanType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Loan type'),
                items: LoanType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Row(children: [
                            Icon(t.icon, size: 18),
                            const SizedBox(width: 8),
                            Text(t.label),
                          ]),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                    labelText: 'Loan name (e.g. SBI Home Loan)'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lender,
                decoration:
                    const InputDecoration(labelText: 'Lender (optional)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _principal,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                          labelText: 'Principal',
                          prefixText: '${Money.symbol} '),
                      validator: (v) {
                        final d = double.tryParse((v ?? '').replaceAll(',', ''));
                        return (d == null || d <= 0) ? 'Required' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rate,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration:
                          const InputDecoration(labelText: 'Rate % p.a.'),
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tenure,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                          labelText: 'Tenure (months)'),
                      validator: (v) =>
                          int.tryParse(v ?? '') == null ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _dueDay,
                      decoration: const InputDecoration(labelText: 'EMI day'),
                      items: [
                        for (var d = 1; d <= 28; d++)
                          DropdownMenuItem(value: d, child: Text('$d'))
                      ],
                      onChanged: (v) => setState(() => _dueDay = v ?? 5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Start date'),
                subtitle: Text(Dates.day(_startDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2005),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _autoPost,
                onChanged: (v) => setState(() => _autoPost = v),
                title: const Text('Auto-add expense on EMI payment'),
                subtitle:
                    const Text('Posts an expense when an EMI is marked paid'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _autoDebit,
                onChanged: (v) => setState(() => _autoDebit = v),
                title: const Text('Auto-pay EMIs on due date'),
                subtitle: const Text(
                    'Automatically marks each EMI paid once its due date passes'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _alerts,
                onChanged: (v) => setState(() => _alerts = v),
                title: const Text('EMI reminders'),
              ),
              if (_alerts)
                Row(
                  children: [
                    const Text('Remind me'),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      value: _leadDays,
                      items: [1, 2, 3, 5, 7]
                          .map((d) => DropdownMenuItem(
                              value: d, child: Text('$d days before')))
                          .toList(),
                      onChanged: (v) => setState(() => _leadDays = v ?? 2),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly EMI',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(Money.precise(_emiPreview),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text('Create loan & schedule'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
