import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../data/local/database.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../shared/widgets.dart';
import '../expenses/expenses_providers.dart';

class RecurringForm extends ConsumerStatefulWidget {
  final RecurringRule? existing;
  const RecurringForm({this.existing, super.key});

  static Future<void> show(BuildContext context, {RecurringRule? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => RecurringForm(existing: existing),
    );
  }

  @override
  ConsumerState<RecurringForm> createState() => _RecurringFormState();
}

class _RecurringFormState extends ConsumerState<RecurringForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _interval;
  late TxnType _type;
  late Frequency _frequency;
  late DateTime _startDate;
  DateTime? _endDate;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _amount = TextEditingController(text: e != null ? e.amount.toString() : '');
    _interval =
        TextEditingController(text: e != null ? e.interval.toString() : '1');
    _type = e?.type ?? TxnType.income;
    _frequency = e?.frequency ?? Frequency.monthly;
    _startDate = e?.nextDueDate ?? DateTime.now();
    _endDate = e?.endDate;
    _categoryId = e?.categoryId;
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _interval.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(recurringRepoProvider);
    final interval = int.tryParse(_interval.text) ?? 1;
    final companion = RecurringRulesCompanion(
      id: widget.existing != null
          ? Value(widget.existing!.id)
          : const Value.absent(),
      title: Value(_title.text.trim()),
      amount: Value(double.parse(_amount.text.replaceAll(',', ''))),
      categoryId: Value(_categoryId),
      type: Value(_type),
      frequency: Value(_frequency),
      interval: Value(interval < 1 ? 1 : interval),
      nextDueDate: Value(_startDate),
      endDate: Value(_endDate),
      active: const Value(true),
    );
    final id = await repo.upsert(companion);
    // Immediately catch up anything already due so it reflects right away.
    final saved = (widget.existing == null)
        ? (await repo.watchRules().first)
            .firstWhere((r) => r.rule.id == id)
            .rule
        : null;
    if (saved != null) {
      await repo.processRule(saved, DateTime.now());
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
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
              Text(widget.existing == null ? 'New recurring' : 'Edit recurring',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              SegmentedButton<TxnType>(
                segments: const [
                  ButtonSegment(value: TxnType.expense, label: Text('Expense')),
                  ButtonSegment(value: TxnType.income, label: Text('Income')),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                    labelText: 'Title (e.g. Salary, Rent, Netflix)'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: 'Amount', prefixText: '${Money.symbol} '),
                validator: (v) {
                  final d = double.tryParse((v ?? '').replaceAll(',', ''));
                  return (d == null || d <= 0) ? 'Enter a valid amount' : null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Repeat every'),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 64,
                    child: TextFormField(
                      controller: _interval,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(isDense: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<Frequency>(
                      initialValue: _frequency,
                      isDense: true,
                      items: Frequency.values
                          .map((f) => DropdownMenuItem(
                              value: f, child: Text('${f.unitLabel}(s)')))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _frequency = v ?? _frequency),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              categoriesAsync.when(
                data: (cats) => DropdownButtonFormField<int?>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...cats.map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Row(children: [
                            IconBadge(
                                IconData(c.iconCodepoint,
                                    fontFamily: 'MaterialIcons'),
                                color: Color(c.color),
                                size: 22),
                            const SizedBox(width: 8),
                            Text(c.name),
                          ]),
                        )),
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.play_arrow),
                title: const Text('Starts / next on'),
                subtitle: Text(Dates.day(_startDate)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_busy),
                title: const Text('Ends on (optional)'),
                subtitle: Text(_endDate == null ? 'Never' : Dates.day(_endDate!)),
                trailing: _endDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _endDate = null))
                    : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? _startDate,
                    firstDate: _startDate,
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _endDate = picked);
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_type.label} of ${Money.format(double.tryParse(_amount.text.replaceAll(',', '')) ?? 0)} · ${_frequency.describe(int.tryParse(_interval.text) ?? 1)}. Posts automatically on each due date.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text('Save recurring'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
