import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../core/recurrence.dart';
import '../../data/local/database.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../shared/widgets.dart';
import 'expenses_providers.dart';

/// Bottom-sheet form to add or edit a transaction.
class ExpenseForm extends ConsumerStatefulWidget {
  final Transaction? existing;
  const ExpenseForm({this.existing, super.key});

  static Future<void> show(BuildContext context, {Transaction? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => ExpenseForm(existing: existing),
    );
  }

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _title;
  late final TextEditingController _note;
  late TxnType _type;
  late DateTime _date;
  int? _categoryId;
  Frequency? _repeat;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _amount = TextEditingController(text: e != null ? e.amount.toString() : '');
    _title = TextEditingController(text: e?.title ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _type = e?.type ?? TxnType.expense;
    _date = e?.date ?? DateTime.now();
    _categoryId = e?.categoryId;
  }

  @override
  void dispose() {
    _amount.dispose();
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(expenseRepoProvider);
    final amount = double.parse(_amount.text.replaceAll(',', ''));
    final companion = TransactionsCompanion(
      id: widget.existing != null
          ? Value(widget.existing!.id)
          : const Value.absent(),
      amount: Value(amount),
      title: Value(_title.text.trim()),
      note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
      categoryId: Value(_categoryId),
      date: Value(_date),
      type: Value(_type),
      source: Value(widget.existing?.source ?? TxnSource.manual),
    );
    await repo.upsertTransaction(companion);

    // Optionally turn this into a recurring rule. The one-off above counts as
    // the first occurrence, so the rule starts from the next cycle.
    if (_repeat != null && widget.existing == null) {
      await ref.read(recurringRepoProvider).upsert(RecurringRulesCompanion(
            title: Value(_title.text.trim()),
            amount: Value(amount),
            categoryId: Value(_categoryId),
            type: Value(_type),
            frequency: Value(_repeat!),
            interval: const Value(1),
            nextDueDate: Value(Recurrence.next(_date, _repeat!, 1)),
            note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
          ));
    }
    if (mounted) {
      Navigator.pop(context);
      // Navigate to expenses page after adding a new transaction
      if (widget.existing == null) {
        context.go('/expenses');
      }
    }
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
              Text(
                widget.existing == null ? 'Add transaction' : 'Edit transaction',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              SegmentedButton<TxnType>(
                segments: const [
                  ButtonSegment(
                      value: TxnType.expense,
                      label: Text('Expense'),
                      icon: Icon(Icons.south_west)),
                  ButtonSegment(
                      value: TxnType.income,
                      label: Text('Income'),
                      icon: Icon(Icons.north_east)),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amount,
                autofocus: widget.existing == null,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '${Money.symbol} ',
                ),
                validator: (v) {
                  final d = double.tryParse((v ?? '').replaceAll(',', ''));
                  if (d == null || d <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              categoriesAsync.when(
                data: (cats) => _CategoryPicker(
                  categories: cats
                      .where((c) =>
                          c.type == _type || c.name == 'Others')
                      .toList(),
                  selectedId: _categoryId,
                  onSelected: (id) => setState(() => _categoryId = id),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(Dates.full(_date)),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _date = DateTime(
                        picked.year, picked.month, picked.day,
                        _date.hour, _date.minute));
                  }
                },
              ),
              TextFormField(
                controller: _note,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                ),
                maxLines: 2,
              ),
              if (widget.existing == null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.repeat, size: 20),
                    const SizedBox(width: 12),
                    const Text('Repeat'),
                    const Spacer(),
                    DropdownButton<Frequency?>(
                      value: _repeat,
                      hint: const Text('Never'),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Never')),
                        DropdownMenuItem(
                            value: Frequency.daily, child: Text('Daily')),
                        DropdownMenuItem(
                            value: Frequency.weekly, child: Text('Weekly')),
                        DropdownMenuItem(
                            value: Frequency.monthly, child: Text('Monthly')),
                        DropdownMenuItem(
                            value: Frequency.yearly, child: Text('Yearly')),
                      ],
                      onChanged: (v) => setState(() => _repeat = v),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  final List<Category> categories;
  final int? selectedId;
  final ValueChanged<int?> onSelected;
  const _CategoryPicker({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((c) {
            final color = Color(c.color);
            final selected = c.id == selectedId;
            return ChoiceChip(
              selected: selected,
              avatar: IconBadge(
                IconData(c.iconCodepoint, fontFamily: 'MaterialIcons'),
                color: color,
                size: 22,
              ),
              label: Text(c.name),
              onSelected: (_) => onSelected(c.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}
