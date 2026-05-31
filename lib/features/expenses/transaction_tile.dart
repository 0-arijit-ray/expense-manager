import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../data/repositories/expense_repository.dart';
import '../../shared/widgets.dart';

class TransactionTile extends StatelessWidget {
  final TransactionWithCategory item;
  final VoidCallback? onTap;
  const TransactionTile({required this.item, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final txn = item.txn;
    final cat = item.category;
    final color = cat != null ? Color(cat.color) : Theme.of(context).colorScheme.outline;
    final icon = cat != null
        ? IconData(cat.iconCodepoint, fontFamily: 'MaterialIcons')
        : Icons.receipt_long;

    return ListTile(
      onTap: onTap,
      leading: IconBadge(icon, color: color),
      title: Text(
        txn.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Text(cat?.name ?? 'Uncategorized'),
          if (txn.source != TxnSource.manual) ...[
            const SizedBox(width: 6),
            _SourceBadge(txn.source),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AmountText(
            txn.amount,
            isExpense: txn.type == TxnType.expense,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          Text(Dates.dayShort(txn.date),
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  final TxnSource source;
  const _SourceBadge(this.source);

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (source) {
      TxnSource.emi => ('EMI', Icons.account_balance),
      TxnSource.recurring => ('Auto', Icons.repeat),
      TxnSource.manual => ('', Icons.edit),
    };
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: scheme.onSecondaryContainer),
          const SizedBox(width: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
