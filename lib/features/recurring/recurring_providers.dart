import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/repositories/recurring_repository.dart';

final recurringRulesProvider =
    StreamProvider<List<RecurringWithCategory>>(
  (ref) => ref.watch(recurringRepoProvider).watchRules(),
);
