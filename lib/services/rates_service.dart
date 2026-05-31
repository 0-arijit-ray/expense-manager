import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../core/settings.dart';

/// An indicative market/instrument rate shown in the investments screen.
class RateInfo {
  final String key;
  final String label;
  final double ratePct;
  final String unit; // e.g. "p.a." or "per 10g"
  const RateInfo(this.key, this.label, this.ratePct, {this.unit = 'p.a.'});
}

class RatesSnapshot {
  final List<RateInfo> rates;
  final DateTime fetchedAt;
  final bool isLive;
  const RatesSnapshot(this.rates, this.fetchedAt, {this.isLive = false});
}

/// Provides indicative instrument rates. When a remote endpoint is configured
/// in settings it is fetched and parsed; otherwise sensible bundled defaults
/// are returned so the UI always has data ("dynamic" but resilient offline).
class RatesService {
  RatesService(this._client);
  final http.Client _client;

  static const _defaults = <RateInfo>[
    RateInfo('fd_1y', 'Bank FD (1 yr)', 6.8),
    RateInfo('fd_5y', 'Bank FD (5 yr)', 7.0),
    RateInfo('senior_fd', 'Senior Citizen FD', 7.5),
    RateInfo('ppf', 'PPF', 7.1),
    RateInfo('nsc', 'NSC', 7.7),
    RateInfo('savings', 'Savings Account', 3.0),
    RateInfo('rd_1y', 'Recurring Deposit', 6.5),
    RateInfo('gsec_10y', 'Govt Bond (10 yr)', 7.0),
    RateInfo('nifty_cagr', 'Nifty 50 (10yr CAGR)', 12.5),
    RateInfo('gold_cagr', 'Gold (10yr CAGR)', 10.0),
  ];

  Future<RatesSnapshot> fetch(String endpoint) async {
    if (endpoint.trim().isEmpty) {
      return RatesSnapshot(_defaults, DateTime.now());
    }
    try {
      final res = await _client
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) {
        return RatesSnapshot(_defaults, DateTime.now());
      }
      final body = jsonDecode(res.body);
      final rates = _parse(body);
      if (rates.isEmpty) return RatesSnapshot(_defaults, DateTime.now());
      return RatesSnapshot(rates, DateTime.now(), isLive: true);
    } catch (_) {
      return RatesSnapshot(_defaults, DateTime.now());
    }
  }

  /// Accepts either `{"rates": {"key": {"label":..,"rate":..}}}` or a flat map
  /// `{"FD 1yr": 6.8}`.
  List<RateInfo> _parse(dynamic body) {
    final out = <RateInfo>[];
    Map<String, dynamic>? map;
    if (body is Map && body['rates'] is Map) {
      map = Map<String, dynamic>.from(body['rates'] as Map);
    } else if (body is Map) {
      map = Map<String, dynamic>.from(body);
    }
    if (map == null) return out;
    map.forEach((key, value) {
      if (value is num) {
        out.add(RateInfo(key, key, value.toDouble()));
      } else if (value is Map) {
        final label = (value['label'] ?? key).toString();
        final rate = (value['rate'] as num?)?.toDouble();
        final unit = (value['unit'] ?? 'p.a.').toString();
        if (rate != null) out.add(RateInfo(key, label, rate, unit: unit));
      }
    });
    return out;
  }
}

final ratesServiceProvider = Provider<RatesService>(
  (ref) => RatesService(http.Client()),
);

final ratesProvider = FutureProvider<RatesSnapshot>((ref) async {
  final endpoint = ref.watch(settingsProvider).ratesEndpoint;
  return ref.watch(ratesServiceProvider).fetch(endpoint);
});
