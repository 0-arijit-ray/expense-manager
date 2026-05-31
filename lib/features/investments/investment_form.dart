import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../data/local/database.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';

class InvestmentForm extends ConsumerStatefulWidget {
  final Investment? existing;
  const InvestmentForm({this.existing, super.key});

  static Future<void> show(BuildContext context, {Investment? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => InvestmentForm(existing: existing),
    );
  }

  @override
  ConsumerState<InvestmentForm> createState() => _InvestmentFormState();
}

class _InvestmentFormState extends ConsumerState<InvestmentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _institution;
  late final TextEditingController _invested;
  late final TextEditingController _current;
  late final TextEditingController _units;
  late final TextEditingController _rate;
  late final TextEditingController _note;
  late AssetType _type;
  DateTime? _maturity;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _institution = TextEditingController(text: e?.institution ?? '');
    _invested =
        TextEditingController(text: e != null ? e.investedAmount.toString() : '');
    _current =
        TextEditingController(text: e != null ? e.currentValue.toString() : '');
    _units = TextEditingController(text: e?.units?.toString() ?? '');
    _rate = TextEditingController(text: e?.annualRate?.toString() ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _type = e?.type ?? AssetType.mutualFund;
    _maturity = e?.maturityDate;
  }

  @override
  void dispose() {
    for (final c in [_name, _institution, _invested, _current, _units, _rate, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final invested = double.parse(_invested.text.replaceAll(',', ''));
    final current = _current.text.trim().isEmpty
        ? invested
        : double.parse(_current.text.replaceAll(',', ''));
    final companion = InvestmentsCompanion(
      id: widget.existing != null
          ? Value(widget.existing!.id)
          : const Value.absent(),
      name: Value(_name.text.trim()),
      type: Value(_type),
      institution: Value(
          _institution.text.trim().isEmpty ? null : _institution.text.trim()),
      investedAmount: Value(invested),
      currentValue: Value(current),
      units: Value(double.tryParse(_units.text)),
      annualRate: Value(double.tryParse(_rate.text)),
      maturityDate: Value(_maturity),
      note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
      updatedAt: Value(DateTime.now()),
    );
    await ref.read(investmentRepoProvider).upsert(companion);
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
              Text(widget.existing == null ? 'Add investment' : 'Edit investment',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              DropdownButtonFormField<AssetType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Asset type'),
                items: AssetType.values
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
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _institution,
                decoration: const InputDecoration(
                    labelText: 'Institution / fund house (optional)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _invested,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                          labelText: 'Invested', prefixText: '${Money.symbol} '),
                      validator: (v) {
                        final d = double.tryParse((v ?? '').replaceAll(',', ''));
                        return (d == null || d <= 0) ? 'Required' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _current,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                          labelText: 'Current value',
                          prefixText: '${Money.symbol} '),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _units,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Units / grams (optional)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rate,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Rate / return % (optional)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Maturity date (optional)'),
                subtitle:
                    Text(_maturity == null ? 'Not set' : Dates.day(_maturity!)),
                trailing: _maturity == null
                    ? const Icon(Icons.chevron_right)
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _maturity = null),
                      ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _maturity ?? DateTime.now(),
                    firstDate: DateTime(2005),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _maturity = picked);
                },
              ),
              TextFormField(
                controller: _note,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
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
