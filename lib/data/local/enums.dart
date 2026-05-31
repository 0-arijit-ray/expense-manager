import 'package:flutter/material.dart';

/// Whether a transaction adds to or subtracts from balance.
enum TxnType { expense, income }

/// Where a transaction originated.
enum TxnSource { manual, emi, recurring }

/// How often a recurring rule posts a transaction.
enum Frequency { daily, weekly, monthly, yearly }

/// Supported loan products.
enum LoanType { home, car, personal, education, gold, business, other }

/// Investment / asset classes used for the portfolio and net-worth views.
enum AssetType { fd, mutualFund, equity, gold, cash, bank, realEstate, ppf, crypto, other }

extension TxnTypeX on TxnType {
  String get label => this == TxnType.expense ? 'Expense' : 'Income';
}

extension FrequencyX on Frequency {
  String get unitLabel {
    switch (this) {
      case Frequency.daily:
        return 'day';
      case Frequency.weekly:
        return 'week';
      case Frequency.monthly:
        return 'month';
      case Frequency.yearly:
        return 'year';
    }
  }

  /// Human description e.g. "Monthly" or "Every 2 weeks".
  String describe(int interval) {
    if (interval <= 1) {
      switch (this) {
        case Frequency.daily:
          return 'Daily';
        case Frequency.weekly:
          return 'Weekly';
        case Frequency.monthly:
          return 'Monthly';
        case Frequency.yearly:
          return 'Yearly';
      }
    }
    return 'Every $interval ${unitLabel}s';
  }
}

extension LoanTypeX on LoanType {
  String get label {
    switch (this) {
      case LoanType.home:
        return 'Home Loan';
      case LoanType.car:
        return 'Car / Auto Loan';
      case LoanType.personal:
        return 'Personal Loan';
      case LoanType.education:
        return 'Education Loan';
      case LoanType.gold:
        return 'Gold Loan';
      case LoanType.business:
        return 'Business Loan';
      case LoanType.other:
        return 'Other Loan';
    }
  }

  IconData get icon {
    switch (this) {
      case LoanType.home:
        return Icons.home_rounded;
      case LoanType.car:
        return Icons.directions_car_rounded;
      case LoanType.personal:
        return Icons.person_rounded;
      case LoanType.education:
        return Icons.school_rounded;
      case LoanType.gold:
        return Icons.diamond_rounded;
      case LoanType.business:
        return Icons.business_center_rounded;
      case LoanType.other:
        return Icons.request_quote_rounded;
    }
  }
}

extension AssetTypeX on AssetType {
  String get label {
    switch (this) {
      case AssetType.fd:
        return 'Fixed Deposit';
      case AssetType.mutualFund:
        return 'Mutual Fund';
      case AssetType.equity:
        return 'Equity / Stocks';
      case AssetType.gold:
        return 'Gold';
      case AssetType.cash:
        return 'Cash';
      case AssetType.bank:
        return 'Bank Balance';
      case AssetType.realEstate:
        return 'Real Estate';
      case AssetType.ppf:
        return 'PPF / EPF';
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.other:
        return 'Other Asset';
    }
  }

  IconData get icon {
    switch (this) {
      case AssetType.fd:
        return Icons.account_balance_rounded;
      case AssetType.mutualFund:
        return Icons.pie_chart_rounded;
      case AssetType.equity:
        return Icons.show_chart_rounded;
      case AssetType.gold:
        return Icons.diamond_rounded;
      case AssetType.cash:
        return Icons.payments_rounded;
      case AssetType.bank:
        return Icons.account_balance_wallet_rounded;
      case AssetType.realEstate:
        return Icons.apartment_rounded;
      case AssetType.ppf:
        return Icons.savings_rounded;
      case AssetType.crypto:
        return Icons.currency_bitcoin_rounded;
      case AssetType.other:
        return Icons.category_rounded;
    }
  }

  /// Whether the asset typically tracks a market rate / NAV (vs a fixed value).
  bool get isMarketLinked =>
      this == AssetType.equity || this == AssetType.mutualFund || this == AssetType.gold || this == AssetType.crypto;
}
