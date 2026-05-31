// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconCodepointMeta = const VerificationMeta(
    'iconCodepoint',
  );
  @override
  late final GeneratedColumn<int> iconCodepoint = GeneratedColumn<int>(
    'icon_codepoint',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TxnType>($CategoriesTable.$convertertype);
  static const VerificationMeta _keywordsMeta = const VerificationMeta(
    'keywords',
  );
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
    'keywords',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    iconCodepoint,
    color,
    type,
    keywords,
    isDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_codepoint')) {
      context.handle(
        _iconCodepointMeta,
        iconCodepoint.isAcceptableOrUnknown(
          data['icon_codepoint']!,
          _iconCodepointMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_iconCodepointMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('keywords')) {
      context.handle(
        _keywordsMeta,
        keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconCodepoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_codepoint'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      type: $CategoriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      keywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keywords'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnType, int, int> $convertertype =
      const EnumIndexConverter<TxnType>(TxnType.values);
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;

  /// Material icon codepoint so we can render a glyph.
  final int iconCodepoint;

  /// ARGB color value.
  final int color;
  final TxnType type;

  /// Comma separated keywords used to auto-match SMS / imported transactions.
  final String keywords;
  final bool isDefault;
  const Category({
    required this.id,
    required this.name,
    required this.iconCodepoint,
    required this.color,
    required this.type,
    required this.keywords,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon_codepoint'] = Variable<int>(iconCodepoint);
    map['color'] = Variable<int>(color);
    {
      map['type'] = Variable<int>($CategoriesTable.$convertertype.toSql(type));
    }
    map['keywords'] = Variable<String>(keywords);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconCodepoint: Value(iconCodepoint),
      color: Value(color),
      type: Value(type),
      keywords: Value(keywords),
      isDefault: Value(isDefault),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconCodepoint: serializer.fromJson<int>(json['iconCodepoint']),
      color: serializer.fromJson<int>(json['color']),
      type: $CategoriesTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      keywords: serializer.fromJson<String>(json['keywords']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconCodepoint': serializer.toJson<int>(iconCodepoint),
      'color': serializer.toJson<int>(color),
      'type': serializer.toJson<int>(
        $CategoriesTable.$convertertype.toJson(type),
      ),
      'keywords': serializer.toJson<String>(keywords),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    int? iconCodepoint,
    int? color,
    TxnType? type,
    String? keywords,
    bool? isDefault,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    iconCodepoint: iconCodepoint ?? this.iconCodepoint,
    color: color ?? this.color,
    type: type ?? this.type,
    keywords: keywords ?? this.keywords,
    isDefault: isDefault ?? this.isDefault,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconCodepoint: data.iconCodepoint.present
          ? data.iconCodepoint.value
          : this.iconCodepoint,
      color: data.color.present ? data.color.value : this.color,
      type: data.type.present ? data.type.value : this.type,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('color: $color, ')
          ..write('type: $type, ')
          ..write('keywords: $keywords, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, iconCodepoint, color, type, keywords, isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconCodepoint == this.iconCodepoint &&
          other.color == this.color &&
          other.type == this.type &&
          other.keywords == this.keywords &&
          other.isDefault == this.isDefault);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> iconCodepoint;
  final Value<int> color;
  final Value<TxnType> type;
  final Value<String> keywords;
  final Value<bool> isDefault;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconCodepoint = const Value.absent(),
    this.color = const Value.absent(),
    this.type = const Value.absent(),
    this.keywords = const Value.absent(),
    this.isDefault = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int iconCodepoint,
    required int color,
    this.type = const Value.absent(),
    this.keywords = const Value.absent(),
    this.isDefault = const Value.absent(),
  }) : name = Value(name),
       iconCodepoint = Value(iconCodepoint),
       color = Value(color);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? iconCodepoint,
    Expression<int>? color,
    Expression<int>? type,
    Expression<String>? keywords,
    Expression<bool>? isDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconCodepoint != null) 'icon_codepoint': iconCodepoint,
      if (color != null) 'color': color,
      if (type != null) 'type': type,
      if (keywords != null) 'keywords': keywords,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? iconCodepoint,
    Value<int>? color,
    Value<TxnType>? type,
    Value<String>? keywords,
    Value<bool>? isDefault,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      color: color ?? this.color,
      type: type ?? this.type,
      keywords: keywords ?? this.keywords,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconCodepoint.present) {
      map['icon_codepoint'] = Variable<int>(iconCodepoint.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $CategoriesTable.$convertertype.toSql(type.value),
      );
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCodepoint: $iconCodepoint, ')
          ..write('color: $color, ')
          ..write('type: $type, ')
          ..write('keywords: $keywords, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TxnType>($TransactionsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<TxnSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TxnSource>($TransactionsTable.$convertersource);
  static const VerificationMeta _emiIdMeta = const VerificationMeta('emiId');
  @override
  late final GeneratedColumn<int> emiId = GeneratedColumn<int>(
    'emi_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringIdMeta = const VerificationMeta(
    'recurringId',
  );
  @override
  late final GeneratedColumn<int> recurringId = GeneratedColumn<int>(
    'recurring_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    title,
    note,
    categoryId,
    date,
    type,
    source,
    emiId,
    recurringId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('emi_id')) {
      context.handle(
        _emiIdMeta,
        emiId.isAcceptableOrUnknown(data['emi_id']!, _emiIdMeta),
      );
    }
    if (data.containsKey('recurring_id')) {
      context.handle(
        _recurringIdMeta,
        recurringId.isAcceptableOrUnknown(
          data['recurring_id']!,
          _recurringIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      source: $TransactionsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      emiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emi_id'],
      ),
      recurringId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurring_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnType, int, int> $convertertype =
      const EnumIndexConverter<TxnType>(TxnType.values);
  static JsonTypeConverter2<TxnSource, int, int> $convertersource =
      const EnumIndexConverter<TxnSource>(TxnSource.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final double amount;
  final String title;
  final String? note;
  final int? categoryId;
  final DateTime date;
  final TxnType type;
  final TxnSource source;

  /// When source is emi, links back to the schedule row that created it.
  final int? emiId;

  /// When source is recurring, links back to the rule that generated it.
  final int? recurringId;
  final DateTime createdAt;
  const Transaction({
    required this.id,
    required this.amount,
    required this.title,
    this.note,
    this.categoryId,
    required this.date,
    required this.type,
    required this.source,
    this.emiId,
    this.recurringId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['date'] = Variable<DateTime>(date);
    {
      map['type'] = Variable<int>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    {
      map['source'] = Variable<int>(
        $TransactionsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || emiId != null) {
      map['emi_id'] = Variable<int>(emiId);
    }
    if (!nullToAbsent || recurringId != null) {
      map['recurring_id'] = Variable<int>(recurringId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      date: Value(date),
      type: Value(type),
      source: Value(source),
      emiId: emiId == null && nullToAbsent
          ? const Value.absent()
          : Value(emiId),
      recurringId: recurringId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringId),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      source: $TransactionsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      emiId: serializer.fromJson<int?>(json['emiId']),
      recurringId: serializer.fromJson<int?>(json['recurringId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
      'categoryId': serializer.toJson<int?>(categoryId),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<int>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'source': serializer.toJson<int>(
        $TransactionsTable.$convertersource.toJson(source),
      ),
      'emiId': serializer.toJson<int?>(emiId),
      'recurringId': serializer.toJson<int?>(recurringId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaction copyWith({
    int? id,
    double? amount,
    String? title,
    Value<String?> note = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    DateTime? date,
    TxnType? type,
    TxnSource? source,
    Value<int?> emiId = const Value.absent(),
    Value<int?> recurringId = const Value.absent(),
    DateTime? createdAt,
  }) => Transaction(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    title: title ?? this.title,
    note: note.present ? note.value : this.note,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    date: date ?? this.date,
    type: type ?? this.type,
    source: source ?? this.source,
    emiId: emiId.present ? emiId.value : this.emiId,
    recurringId: recurringId.present ? recurringId.value : this.recurringId,
    createdAt: createdAt ?? this.createdAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      source: data.source.present ? data.source.value : this.source,
      emiId: data.emiId.present ? data.emiId.value : this.emiId,
      recurringId: data.recurringId.present
          ? data.recurringId.value
          : this.recurringId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('emiId: $emiId, ')
          ..write('recurringId: $recurringId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    title,
    note,
    categoryId,
    date,
    type,
    source,
    emiId,
    recurringId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.title == this.title &&
          other.note == this.note &&
          other.categoryId == this.categoryId &&
          other.date == this.date &&
          other.type == this.type &&
          other.source == this.source &&
          other.emiId == this.emiId &&
          other.recurringId == this.recurringId &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> title;
  final Value<String?> note;
  final Value<int?> categoryId;
  final Value<DateTime> date;
  final Value<TxnType> type;
  final Value<TxnSource> source;
  final Value<int?> emiId;
  final Value<int?> recurringId;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.emiId = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String title,
    this.note = const Value.absent(),
    this.categoryId = const Value.absent(),
    required DateTime date,
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.emiId = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : amount = Value(amount),
       title = Value(title),
       date = Value(date);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? title,
    Expression<String>? note,
    Expression<int>? categoryId,
    Expression<DateTime>? date,
    Expression<int>? type,
    Expression<int>? source,
    Expression<int>? emiId,
    Expression<int>? recurringId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (categoryId != null) 'category_id': categoryId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (source != null) 'source': source,
      if (emiId != null) 'emi_id': emiId,
      if (recurringId != null) 'recurring_id': recurringId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? title,
    Value<String?>? note,
    Value<int?>? categoryId,
    Value<DateTime>? date,
    Value<TxnType>? type,
    Value<TxnSource>? source,
    Value<int?>? emiId,
    Value<int?>? recurringId,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      type: type ?? this.type,
      source: source ?? this.source,
      emiId: emiId ?? this.emiId,
      recurringId: recurringId ?? this.recurringId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $TransactionsTable.$convertersource.toSql(source.value),
      );
    }
    if (emiId.present) {
      map['emi_id'] = Variable<int>(emiId.value);
    }
    if (recurringId.present) {
      map['recurring_id'] = Variable<int>(recurringId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('emiId: $emiId, ')
          ..write('recurringId: $recurringId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, Loan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LoanType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LoanType>($LoansTable.$convertertype);
  static const VerificationMeta _lenderMeta = const VerificationMeta('lender');
  @override
  late final GeneratedColumn<String> lender = GeneratedColumn<String>(
    'lender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _principalMeta = const VerificationMeta(
    'principal',
  );
  @override
  late final GeneratedColumn<double> principal = GeneratedColumn<double>(
    'principal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _annualRateMeta = const VerificationMeta(
    'annualRate',
  );
  @override
  late final GeneratedColumn<double> annualRate = GeneratedColumn<double>(
    'annual_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenureMonthsMeta = const VerificationMeta(
    'tenureMonths',
  );
  @override
  late final GeneratedColumn<int> tenureMonths = GeneratedColumn<int>(
    'tenure_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emiAmountMeta = const VerificationMeta(
    'emiAmount',
  );
  @override
  late final GeneratedColumn<double> emiAmount = GeneratedColumn<double>(
    'emi_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _autoPostExpenseMeta = const VerificationMeta(
    'autoPostExpense',
  );
  @override
  late final GeneratedColumn<bool> autoPostExpense = GeneratedColumn<bool>(
    'auto_post_expense',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_post_expense" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoDebitMeta = const VerificationMeta(
    'autoDebit',
  );
  @override
  late final GeneratedColumn<bool> autoDebit = GeneratedColumn<bool>(
    'auto_debit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_debit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alertsEnabledMeta = const VerificationMeta(
    'alertsEnabled',
  );
  @override
  late final GeneratedColumn<bool> alertsEnabled = GeneratedColumn<bool>(
    'alerts_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alerts_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _alertLeadDaysMeta = const VerificationMeta(
    'alertLeadDays',
  );
  @override
  late final GeneratedColumn<int> alertLeadDays = GeneratedColumn<int>(
    'alert_lead_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _closedMeta = const VerificationMeta('closed');
  @override
  late final GeneratedColumn<bool> closed = GeneratedColumn<bool>(
    'closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    lender,
    principal,
    annualRate,
    tenureMonths,
    startDate,
    emiAmount,
    dueDay,
    autoPostExpense,
    autoDebit,
    alertsEnabled,
    alertLeadDays,
    closed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Loan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lender')) {
      context.handle(
        _lenderMeta,
        lender.isAcceptableOrUnknown(data['lender']!, _lenderMeta),
      );
    }
    if (data.containsKey('principal')) {
      context.handle(
        _principalMeta,
        principal.isAcceptableOrUnknown(data['principal']!, _principalMeta),
      );
    } else if (isInserting) {
      context.missing(_principalMeta);
    }
    if (data.containsKey('annual_rate')) {
      context.handle(
        _annualRateMeta,
        annualRate.isAcceptableOrUnknown(data['annual_rate']!, _annualRateMeta),
      );
    } else if (isInserting) {
      context.missing(_annualRateMeta);
    }
    if (data.containsKey('tenure_months')) {
      context.handle(
        _tenureMonthsMeta,
        tenureMonths.isAcceptableOrUnknown(
          data['tenure_months']!,
          _tenureMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tenureMonthsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('emi_amount')) {
      context.handle(
        _emiAmountMeta,
        emiAmount.isAcceptableOrUnknown(data['emi_amount']!, _emiAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_emiAmountMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    }
    if (data.containsKey('auto_post_expense')) {
      context.handle(
        _autoPostExpenseMeta,
        autoPostExpense.isAcceptableOrUnknown(
          data['auto_post_expense']!,
          _autoPostExpenseMeta,
        ),
      );
    }
    if (data.containsKey('auto_debit')) {
      context.handle(
        _autoDebitMeta,
        autoDebit.isAcceptableOrUnknown(data['auto_debit']!, _autoDebitMeta),
      );
    }
    if (data.containsKey('alerts_enabled')) {
      context.handle(
        _alertsEnabledMeta,
        alertsEnabled.isAcceptableOrUnknown(
          data['alerts_enabled']!,
          _alertsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('alert_lead_days')) {
      context.handle(
        _alertLeadDaysMeta,
        alertLeadDays.isAcceptableOrUnknown(
          data['alert_lead_days']!,
          _alertLeadDaysMeta,
        ),
      );
    }
    if (data.containsKey('closed')) {
      context.handle(
        _closedMeta,
        closed.isAcceptableOrUnknown(data['closed']!, _closedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Loan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $LoansTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      lender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lender'],
      ),
      principal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}principal'],
      )!,
      annualRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}annual_rate'],
      )!,
      tenureMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenure_months'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      emiAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}emi_amount'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      )!,
      autoPostExpense: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_post_expense'],
      )!,
      autoDebit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_debit'],
      )!,
      alertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alerts_enabled'],
      )!,
      alertLeadDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alert_lead_days'],
      )!,
      closed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}closed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LoanType, int, int> $convertertype =
      const EnumIndexConverter<LoanType>(LoanType.values);
}

class Loan extends DataClass implements Insertable<Loan> {
  final int id;
  final String name;
  final LoanType type;
  final String? lender;

  /// Original sanctioned principal.
  final double principal;

  /// Annual interest rate in percent (e.g. 8.5).
  final double annualRate;
  final int tenureMonths;
  final DateTime startDate;

  /// Computed EMI amount (stored so it survives rate-table changes).
  final double emiAmount;

  /// Day of month the EMI is debited (1-28 usually).
  final int dueDay;
  final bool autoPostExpense;

  /// When true, EMIs are automatically marked paid once their due date passes.
  final bool autoDebit;
  final bool alertsEnabled;

  /// How many days before due date to fire a reminder.
  final int alertLeadDays;
  final bool closed;
  final DateTime createdAt;
  const Loan({
    required this.id,
    required this.name,
    required this.type,
    this.lender,
    required this.principal,
    required this.annualRate,
    required this.tenureMonths,
    required this.startDate,
    required this.emiAmount,
    required this.dueDay,
    required this.autoPostExpense,
    required this.autoDebit,
    required this.alertsEnabled,
    required this.alertLeadDays,
    required this.closed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($LoansTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || lender != null) {
      map['lender'] = Variable<String>(lender);
    }
    map['principal'] = Variable<double>(principal);
    map['annual_rate'] = Variable<double>(annualRate);
    map['tenure_months'] = Variable<int>(tenureMonths);
    map['start_date'] = Variable<DateTime>(startDate);
    map['emi_amount'] = Variable<double>(emiAmount);
    map['due_day'] = Variable<int>(dueDay);
    map['auto_post_expense'] = Variable<bool>(autoPostExpense);
    map['auto_debit'] = Variable<bool>(autoDebit);
    map['alerts_enabled'] = Variable<bool>(alertsEnabled);
    map['alert_lead_days'] = Variable<int>(alertLeadDays);
    map['closed'] = Variable<bool>(closed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      lender: lender == null && nullToAbsent
          ? const Value.absent()
          : Value(lender),
      principal: Value(principal),
      annualRate: Value(annualRate),
      tenureMonths: Value(tenureMonths),
      startDate: Value(startDate),
      emiAmount: Value(emiAmount),
      dueDay: Value(dueDay),
      autoPostExpense: Value(autoPostExpense),
      autoDebit: Value(autoDebit),
      alertsEnabled: Value(alertsEnabled),
      alertLeadDays: Value(alertLeadDays),
      closed: Value(closed),
      createdAt: Value(createdAt),
    );
  }

  factory Loan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Loan(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $LoansTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      lender: serializer.fromJson<String?>(json['lender']),
      principal: serializer.fromJson<double>(json['principal']),
      annualRate: serializer.fromJson<double>(json['annualRate']),
      tenureMonths: serializer.fromJson<int>(json['tenureMonths']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      emiAmount: serializer.fromJson<double>(json['emiAmount']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      autoPostExpense: serializer.fromJson<bool>(json['autoPostExpense']),
      autoDebit: serializer.fromJson<bool>(json['autoDebit']),
      alertsEnabled: serializer.fromJson<bool>(json['alertsEnabled']),
      alertLeadDays: serializer.fromJson<int>(json['alertLeadDays']),
      closed: serializer.fromJson<bool>(json['closed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>($LoansTable.$convertertype.toJson(type)),
      'lender': serializer.toJson<String?>(lender),
      'principal': serializer.toJson<double>(principal),
      'annualRate': serializer.toJson<double>(annualRate),
      'tenureMonths': serializer.toJson<int>(tenureMonths),
      'startDate': serializer.toJson<DateTime>(startDate),
      'emiAmount': serializer.toJson<double>(emiAmount),
      'dueDay': serializer.toJson<int>(dueDay),
      'autoPostExpense': serializer.toJson<bool>(autoPostExpense),
      'autoDebit': serializer.toJson<bool>(autoDebit),
      'alertsEnabled': serializer.toJson<bool>(alertsEnabled),
      'alertLeadDays': serializer.toJson<int>(alertLeadDays),
      'closed': serializer.toJson<bool>(closed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Loan copyWith({
    int? id,
    String? name,
    LoanType? type,
    Value<String?> lender = const Value.absent(),
    double? principal,
    double? annualRate,
    int? tenureMonths,
    DateTime? startDate,
    double? emiAmount,
    int? dueDay,
    bool? autoPostExpense,
    bool? autoDebit,
    bool? alertsEnabled,
    int? alertLeadDays,
    bool? closed,
    DateTime? createdAt,
  }) => Loan(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    lender: lender.present ? lender.value : this.lender,
    principal: principal ?? this.principal,
    annualRate: annualRate ?? this.annualRate,
    tenureMonths: tenureMonths ?? this.tenureMonths,
    startDate: startDate ?? this.startDate,
    emiAmount: emiAmount ?? this.emiAmount,
    dueDay: dueDay ?? this.dueDay,
    autoPostExpense: autoPostExpense ?? this.autoPostExpense,
    autoDebit: autoDebit ?? this.autoDebit,
    alertsEnabled: alertsEnabled ?? this.alertsEnabled,
    alertLeadDays: alertLeadDays ?? this.alertLeadDays,
    closed: closed ?? this.closed,
    createdAt: createdAt ?? this.createdAt,
  );
  Loan copyWithCompanion(LoansCompanion data) {
    return Loan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      lender: data.lender.present ? data.lender.value : this.lender,
      principal: data.principal.present ? data.principal.value : this.principal,
      annualRate: data.annualRate.present
          ? data.annualRate.value
          : this.annualRate,
      tenureMonths: data.tenureMonths.present
          ? data.tenureMonths.value
          : this.tenureMonths,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      emiAmount: data.emiAmount.present ? data.emiAmount.value : this.emiAmount,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      autoPostExpense: data.autoPostExpense.present
          ? data.autoPostExpense.value
          : this.autoPostExpense,
      autoDebit: data.autoDebit.present ? data.autoDebit.value : this.autoDebit,
      alertsEnabled: data.alertsEnabled.present
          ? data.alertsEnabled.value
          : this.alertsEnabled,
      alertLeadDays: data.alertLeadDays.present
          ? data.alertLeadDays.value
          : this.alertLeadDays,
      closed: data.closed.present ? data.closed.value : this.closed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Loan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('lender: $lender, ')
          ..write('principal: $principal, ')
          ..write('annualRate: $annualRate, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('startDate: $startDate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('dueDay: $dueDay, ')
          ..write('autoPostExpense: $autoPostExpense, ')
          ..write('autoDebit: $autoDebit, ')
          ..write('alertsEnabled: $alertsEnabled, ')
          ..write('alertLeadDays: $alertLeadDays, ')
          ..write('closed: $closed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    lender,
    principal,
    annualRate,
    tenureMonths,
    startDate,
    emiAmount,
    dueDay,
    autoPostExpense,
    autoDebit,
    alertsEnabled,
    alertLeadDays,
    closed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Loan &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.lender == this.lender &&
          other.principal == this.principal &&
          other.annualRate == this.annualRate &&
          other.tenureMonths == this.tenureMonths &&
          other.startDate == this.startDate &&
          other.emiAmount == this.emiAmount &&
          other.dueDay == this.dueDay &&
          other.autoPostExpense == this.autoPostExpense &&
          other.autoDebit == this.autoDebit &&
          other.alertsEnabled == this.alertsEnabled &&
          other.alertLeadDays == this.alertLeadDays &&
          other.closed == this.closed &&
          other.createdAt == this.createdAt);
}

class LoansCompanion extends UpdateCompanion<Loan> {
  final Value<int> id;
  final Value<String> name;
  final Value<LoanType> type;
  final Value<String?> lender;
  final Value<double> principal;
  final Value<double> annualRate;
  final Value<int> tenureMonths;
  final Value<DateTime> startDate;
  final Value<double> emiAmount;
  final Value<int> dueDay;
  final Value<bool> autoPostExpense;
  final Value<bool> autoDebit;
  final Value<bool> alertsEnabled;
  final Value<int> alertLeadDays;
  final Value<bool> closed;
  final Value<DateTime> createdAt;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.lender = const Value.absent(),
    this.principal = const Value.absent(),
    this.annualRate = const Value.absent(),
    this.tenureMonths = const Value.absent(),
    this.startDate = const Value.absent(),
    this.emiAmount = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.autoPostExpense = const Value.absent(),
    this.autoDebit = const Value.absent(),
    this.alertsEnabled = const Value.absent(),
    this.alertLeadDays = const Value.absent(),
    this.closed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LoansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required LoanType type,
    this.lender = const Value.absent(),
    required double principal,
    required double annualRate,
    required int tenureMonths,
    required DateTime startDate,
    required double emiAmount,
    this.dueDay = const Value.absent(),
    this.autoPostExpense = const Value.absent(),
    this.autoDebit = const Value.absent(),
    this.alertsEnabled = const Value.absent(),
    this.alertLeadDays = const Value.absent(),
    this.closed = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       principal = Value(principal),
       annualRate = Value(annualRate),
       tenureMonths = Value(tenureMonths),
       startDate = Value(startDate),
       emiAmount = Value(emiAmount);
  static Insertable<Loan> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? lender,
    Expression<double>? principal,
    Expression<double>? annualRate,
    Expression<int>? tenureMonths,
    Expression<DateTime>? startDate,
    Expression<double>? emiAmount,
    Expression<int>? dueDay,
    Expression<bool>? autoPostExpense,
    Expression<bool>? autoDebit,
    Expression<bool>? alertsEnabled,
    Expression<int>? alertLeadDays,
    Expression<bool>? closed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (lender != null) 'lender': lender,
      if (principal != null) 'principal': principal,
      if (annualRate != null) 'annual_rate': annualRate,
      if (tenureMonths != null) 'tenure_months': tenureMonths,
      if (startDate != null) 'start_date': startDate,
      if (emiAmount != null) 'emi_amount': emiAmount,
      if (dueDay != null) 'due_day': dueDay,
      if (autoPostExpense != null) 'auto_post_expense': autoPostExpense,
      if (autoDebit != null) 'auto_debit': autoDebit,
      if (alertsEnabled != null) 'alerts_enabled': alertsEnabled,
      if (alertLeadDays != null) 'alert_lead_days': alertLeadDays,
      if (closed != null) 'closed': closed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LoansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<LoanType>? type,
    Value<String?>? lender,
    Value<double>? principal,
    Value<double>? annualRate,
    Value<int>? tenureMonths,
    Value<DateTime>? startDate,
    Value<double>? emiAmount,
    Value<int>? dueDay,
    Value<bool>? autoPostExpense,
    Value<bool>? autoDebit,
    Value<bool>? alertsEnabled,
    Value<int>? alertLeadDays,
    Value<bool>? closed,
    Value<DateTime>? createdAt,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      lender: lender ?? this.lender,
      principal: principal ?? this.principal,
      annualRate: annualRate ?? this.annualRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      startDate: startDate ?? this.startDate,
      emiAmount: emiAmount ?? this.emiAmount,
      dueDay: dueDay ?? this.dueDay,
      autoPostExpense: autoPostExpense ?? this.autoPostExpense,
      autoDebit: autoDebit ?? this.autoDebit,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      alertLeadDays: alertLeadDays ?? this.alertLeadDays,
      closed: closed ?? this.closed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>($LoansTable.$convertertype.toSql(type.value));
    }
    if (lender.present) {
      map['lender'] = Variable<String>(lender.value);
    }
    if (principal.present) {
      map['principal'] = Variable<double>(principal.value);
    }
    if (annualRate.present) {
      map['annual_rate'] = Variable<double>(annualRate.value);
    }
    if (tenureMonths.present) {
      map['tenure_months'] = Variable<int>(tenureMonths.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (emiAmount.present) {
      map['emi_amount'] = Variable<double>(emiAmount.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (autoPostExpense.present) {
      map['auto_post_expense'] = Variable<bool>(autoPostExpense.value);
    }
    if (autoDebit.present) {
      map['auto_debit'] = Variable<bool>(autoDebit.value);
    }
    if (alertsEnabled.present) {
      map['alerts_enabled'] = Variable<bool>(alertsEnabled.value);
    }
    if (alertLeadDays.present) {
      map['alert_lead_days'] = Variable<int>(alertLeadDays.value);
    }
    if (closed.present) {
      map['closed'] = Variable<bool>(closed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('lender: $lender, ')
          ..write('principal: $principal, ')
          ..write('annualRate: $annualRate, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('startDate: $startDate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('dueDay: $dueDay, ')
          ..write('autoPostExpense: $autoPostExpense, ')
          ..write('autoDebit: $autoDebit, ')
          ..write('alertsEnabled: $alertsEnabled, ')
          ..write('alertLeadDays: $alertLeadDays, ')
          ..write('closed: $closed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EmiSchedulesTable extends EmiSchedules
    with TableInfo<$EmiSchedulesTable, EmiSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmiSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _installmentNoMeta = const VerificationMeta(
    'installmentNo',
  );
  @override
  late final GeneratedColumn<int> installmentNo = GeneratedColumn<int>(
    'installment_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emiAmountMeta = const VerificationMeta(
    'emiAmount',
  );
  @override
  late final GeneratedColumn<double> emiAmount = GeneratedColumn<double>(
    'emi_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalComponentMeta =
      const VerificationMeta('principalComponent');
  @override
  late final GeneratedColumn<double> principalComponent =
      GeneratedColumn<double>(
        'principal_component',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _interestComponentMeta = const VerificationMeta(
    'interestComponent',
  );
  @override
  late final GeneratedColumn<double> interestComponent =
      GeneratedColumn<double>(
        'interest_component',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<bool> paid = GeneratedColumn<bool>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loanId,
    installmentNo,
    dueDate,
    emiAmount,
    principalComponent,
    interestComponent,
    balance,
    paid,
    paidDate,
    transactionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emi_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmiSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('installment_no')) {
      context.handle(
        _installmentNoMeta,
        installmentNo.isAcceptableOrUnknown(
          data['installment_no']!,
          _installmentNoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentNoMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('emi_amount')) {
      context.handle(
        _emiAmountMeta,
        emiAmount.isAcceptableOrUnknown(data['emi_amount']!, _emiAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_emiAmountMeta);
    }
    if (data.containsKey('principal_component')) {
      context.handle(
        _principalComponentMeta,
        principalComponent.isAcceptableOrUnknown(
          data['principal_component']!,
          _principalComponentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalComponentMeta);
    }
    if (data.containsKey('interest_component')) {
      context.handle(
        _interestComponentMeta,
        interestComponent.isAcceptableOrUnknown(
          data['interest_component']!,
          _interestComponentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestComponentMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmiSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmiSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_id'],
      )!,
      installmentNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_no'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      emiAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}emi_amount'],
      )!,
      principalComponent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}principal_component'],
      )!,
      interestComponent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interest_component'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paid'],
      )!,
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
    );
  }

  @override
  $EmiSchedulesTable createAlias(String alias) {
    return $EmiSchedulesTable(attachedDatabase, alias);
  }
}

class EmiSchedule extends DataClass implements Insertable<EmiSchedule> {
  final int id;
  final int loanId;
  final int installmentNo;
  final DateTime dueDate;
  final double emiAmount;
  final double principalComponent;
  final double interestComponent;

  /// Outstanding balance after this installment.
  final double balance;
  final bool paid;
  final DateTime? paidDate;

  /// Links to the transaction row created when the EMI is marked paid.
  final int? transactionId;
  const EmiSchedule({
    required this.id,
    required this.loanId,
    required this.installmentNo,
    required this.dueDate,
    required this.emiAmount,
    required this.principalComponent,
    required this.interestComponent,
    required this.balance,
    required this.paid,
    this.paidDate,
    this.transactionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loan_id'] = Variable<int>(loanId);
    map['installment_no'] = Variable<int>(installmentNo);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['emi_amount'] = Variable<double>(emiAmount);
    map['principal_component'] = Variable<double>(principalComponent);
    map['interest_component'] = Variable<double>(interestComponent);
    map['balance'] = Variable<double>(balance);
    map['paid'] = Variable<bool>(paid);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    return map;
  }

  EmiSchedulesCompanion toCompanion(bool nullToAbsent) {
    return EmiSchedulesCompanion(
      id: Value(id),
      loanId: Value(loanId),
      installmentNo: Value(installmentNo),
      dueDate: Value(dueDate),
      emiAmount: Value(emiAmount),
      principalComponent: Value(principalComponent),
      interestComponent: Value(interestComponent),
      balance: Value(balance),
      paid: Value(paid),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
    );
  }

  factory EmiSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmiSchedule(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int>(json['loanId']),
      installmentNo: serializer.fromJson<int>(json['installmentNo']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      emiAmount: serializer.fromJson<double>(json['emiAmount']),
      principalComponent: serializer.fromJson<double>(
        json['principalComponent'],
      ),
      interestComponent: serializer.fromJson<double>(json['interestComponent']),
      balance: serializer.fromJson<double>(json['balance']),
      paid: serializer.fromJson<bool>(json['paid']),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int>(loanId),
      'installmentNo': serializer.toJson<int>(installmentNo),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'emiAmount': serializer.toJson<double>(emiAmount),
      'principalComponent': serializer.toJson<double>(principalComponent),
      'interestComponent': serializer.toJson<double>(interestComponent),
      'balance': serializer.toJson<double>(balance),
      'paid': serializer.toJson<bool>(paid),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
      'transactionId': serializer.toJson<int?>(transactionId),
    };
  }

  EmiSchedule copyWith({
    int? id,
    int? loanId,
    int? installmentNo,
    DateTime? dueDate,
    double? emiAmount,
    double? principalComponent,
    double? interestComponent,
    double? balance,
    bool? paid,
    Value<DateTime?> paidDate = const Value.absent(),
    Value<int?> transactionId = const Value.absent(),
  }) => EmiSchedule(
    id: id ?? this.id,
    loanId: loanId ?? this.loanId,
    installmentNo: installmentNo ?? this.installmentNo,
    dueDate: dueDate ?? this.dueDate,
    emiAmount: emiAmount ?? this.emiAmount,
    principalComponent: principalComponent ?? this.principalComponent,
    interestComponent: interestComponent ?? this.interestComponent,
    balance: balance ?? this.balance,
    paid: paid ?? this.paid,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
  );
  EmiSchedule copyWithCompanion(EmiSchedulesCompanion data) {
    return EmiSchedule(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      installmentNo: data.installmentNo.present
          ? data.installmentNo.value
          : this.installmentNo,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      emiAmount: data.emiAmount.present ? data.emiAmount.value : this.emiAmount,
      principalComponent: data.principalComponent.present
          ? data.principalComponent.value
          : this.principalComponent,
      interestComponent: data.interestComponent.present
          ? data.interestComponent.value
          : this.interestComponent,
      balance: data.balance.present ? data.balance.value : this.balance,
      paid: data.paid.present ? data.paid.value : this.paid,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmiSchedule(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('installmentNo: $installmentNo, ')
          ..write('dueDate: $dueDate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('principalComponent: $principalComponent, ')
          ..write('interestComponent: $interestComponent, ')
          ..write('balance: $balance, ')
          ..write('paid: $paid, ')
          ..write('paidDate: $paidDate, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    loanId,
    installmentNo,
    dueDate,
    emiAmount,
    principalComponent,
    interestComponent,
    balance,
    paid,
    paidDate,
    transactionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmiSchedule &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.installmentNo == this.installmentNo &&
          other.dueDate == this.dueDate &&
          other.emiAmount == this.emiAmount &&
          other.principalComponent == this.principalComponent &&
          other.interestComponent == this.interestComponent &&
          other.balance == this.balance &&
          other.paid == this.paid &&
          other.paidDate == this.paidDate &&
          other.transactionId == this.transactionId);
}

class EmiSchedulesCompanion extends UpdateCompanion<EmiSchedule> {
  final Value<int> id;
  final Value<int> loanId;
  final Value<int> installmentNo;
  final Value<DateTime> dueDate;
  final Value<double> emiAmount;
  final Value<double> principalComponent;
  final Value<double> interestComponent;
  final Value<double> balance;
  final Value<bool> paid;
  final Value<DateTime?> paidDate;
  final Value<int?> transactionId;
  const EmiSchedulesCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.installmentNo = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.emiAmount = const Value.absent(),
    this.principalComponent = const Value.absent(),
    this.interestComponent = const Value.absent(),
    this.balance = const Value.absent(),
    this.paid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.transactionId = const Value.absent(),
  });
  EmiSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int loanId,
    required int installmentNo,
    required DateTime dueDate,
    required double emiAmount,
    required double principalComponent,
    required double interestComponent,
    required double balance,
    this.paid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.transactionId = const Value.absent(),
  }) : loanId = Value(loanId),
       installmentNo = Value(installmentNo),
       dueDate = Value(dueDate),
       emiAmount = Value(emiAmount),
       principalComponent = Value(principalComponent),
       interestComponent = Value(interestComponent),
       balance = Value(balance);
  static Insertable<EmiSchedule> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<int>? installmentNo,
    Expression<DateTime>? dueDate,
    Expression<double>? emiAmount,
    Expression<double>? principalComponent,
    Expression<double>? interestComponent,
    Expression<double>? balance,
    Expression<bool>? paid,
    Expression<DateTime>? paidDate,
    Expression<int>? transactionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (installmentNo != null) 'installment_no': installmentNo,
      if (dueDate != null) 'due_date': dueDate,
      if (emiAmount != null) 'emi_amount': emiAmount,
      if (principalComponent != null) 'principal_component': principalComponent,
      if (interestComponent != null) 'interest_component': interestComponent,
      if (balance != null) 'balance': balance,
      if (paid != null) 'paid': paid,
      if (paidDate != null) 'paid_date': paidDate,
      if (transactionId != null) 'transaction_id': transactionId,
    });
  }

  EmiSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? loanId,
    Value<int>? installmentNo,
    Value<DateTime>? dueDate,
    Value<double>? emiAmount,
    Value<double>? principalComponent,
    Value<double>? interestComponent,
    Value<double>? balance,
    Value<bool>? paid,
    Value<DateTime?>? paidDate,
    Value<int?>? transactionId,
  }) {
    return EmiSchedulesCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      installmentNo: installmentNo ?? this.installmentNo,
      dueDate: dueDate ?? this.dueDate,
      emiAmount: emiAmount ?? this.emiAmount,
      principalComponent: principalComponent ?? this.principalComponent,
      interestComponent: interestComponent ?? this.interestComponent,
      balance: balance ?? this.balance,
      paid: paid ?? this.paid,
      paidDate: paidDate ?? this.paidDate,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (installmentNo.present) {
      map['installment_no'] = Variable<int>(installmentNo.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (emiAmount.present) {
      map['emi_amount'] = Variable<double>(emiAmount.value);
    }
    if (principalComponent.present) {
      map['principal_component'] = Variable<double>(principalComponent.value);
    }
    if (interestComponent.present) {
      map['interest_component'] = Variable<double>(interestComponent.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (paid.present) {
      map['paid'] = Variable<bool>(paid.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmiSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('installmentNo: $installmentNo, ')
          ..write('dueDate: $dueDate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('principalComponent: $principalComponent, ')
          ..write('interestComponent: $interestComponent, ')
          ..write('balance: $balance, ')
          ..write('paid: $paid, ')
          ..write('paidDate: $paidDate, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }
}

class $InvestmentsTable extends Investments
    with TableInfo<$InvestmentsTable, Investment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AssetType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AssetType>($InvestmentsTable.$convertertype);
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _investedAmountMeta = const VerificationMeta(
    'investedAmount',
  );
  @override
  late final GeneratedColumn<double> investedAmount = GeneratedColumn<double>(
    'invested_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
    'units',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _annualRateMeta = const VerificationMeta(
    'annualRate',
  );
  @override
  late final GeneratedColumn<double> annualRate = GeneratedColumn<double>(
    'annual_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maturityDateMeta = const VerificationMeta(
    'maturityDate',
  );
  @override
  late final GeneratedColumn<DateTime> maturityDate = GeneratedColumn<DateTime>(
    'maturity_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    institution,
    investedAmount,
    currentValue,
    units,
    annualRate,
    startDate,
    maturityDate,
    note,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Investment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    }
    if (data.containsKey('invested_amount')) {
      context.handle(
        _investedAmountMeta,
        investedAmount.isAcceptableOrUnknown(
          data['invested_amount']!,
          _investedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_investedAmountMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
        _unitsMeta,
        units.isAcceptableOrUnknown(data['units']!, _unitsMeta),
      );
    }
    if (data.containsKey('annual_rate')) {
      context.handle(
        _annualRateMeta,
        annualRate.isAcceptableOrUnknown(data['annual_rate']!, _annualRateMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('maturity_date')) {
      context.handle(
        _maturityDateMeta,
        maturityDate.isAcceptableOrUnknown(
          data['maturity_date']!,
          _maturityDateMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Investment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Investment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $InvestmentsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
      investedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}invested_amount'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_value'],
      )!,
      units: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}units'],
      ),
      annualRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}annual_rate'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      maturityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}maturity_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvestmentsTable createAlias(String alias) {
    return $InvestmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AssetType, int, int> $convertertype =
      const EnumIndexConverter<AssetType>(AssetType.values);
}

class Investment extends DataClass implements Insertable<Investment> {
  final int id;
  final String name;
  final AssetType type;
  final String? institution;
  final double investedAmount;

  /// Latest valuation. For fixed instruments equals invested + accrued.
  final double currentValue;

  /// Optional quantity for market-linked holdings (units / grams / shares).
  final double? units;

  /// Annual rate / expected return in percent.
  final double? annualRate;
  final DateTime? startDate;
  final DateTime? maturityDate;
  final String? note;
  final DateTime updatedAt;
  const Investment({
    required this.id,
    required this.name,
    required this.type,
    this.institution,
    required this.investedAmount,
    required this.currentValue,
    this.units,
    this.annualRate,
    this.startDate,
    this.maturityDate,
    this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($InvestmentsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    map['invested_amount'] = Variable<double>(investedAmount);
    map['current_value'] = Variable<double>(currentValue);
    if (!nullToAbsent || units != null) {
      map['units'] = Variable<double>(units);
    }
    if (!nullToAbsent || annualRate != null) {
      map['annual_rate'] = Variable<double>(annualRate);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || maturityDate != null) {
      map['maturity_date'] = Variable<DateTime>(maturityDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvestmentsCompanion toCompanion(bool nullToAbsent) {
    return InvestmentsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      investedAmount: Value(investedAmount),
      currentValue: Value(currentValue),
      units: units == null && nullToAbsent
          ? const Value.absent()
          : Value(units),
      annualRate: annualRate == null && nullToAbsent
          ? const Value.absent()
          : Value(annualRate),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      maturityDate: maturityDate == null && nullToAbsent
          ? const Value.absent()
          : Value(maturityDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory Investment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Investment(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $InvestmentsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      institution: serializer.fromJson<String?>(json['institution']),
      investedAmount: serializer.fromJson<double>(json['investedAmount']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      units: serializer.fromJson<double?>(json['units']),
      annualRate: serializer.fromJson<double?>(json['annualRate']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      maturityDate: serializer.fromJson<DateTime?>(json['maturityDate']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $InvestmentsTable.$convertertype.toJson(type),
      ),
      'institution': serializer.toJson<String?>(institution),
      'investedAmount': serializer.toJson<double>(investedAmount),
      'currentValue': serializer.toJson<double>(currentValue),
      'units': serializer.toJson<double?>(units),
      'annualRate': serializer.toJson<double?>(annualRate),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'maturityDate': serializer.toJson<DateTime?>(maturityDate),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Investment copyWith({
    int? id,
    String? name,
    AssetType? type,
    Value<String?> institution = const Value.absent(),
    double? investedAmount,
    double? currentValue,
    Value<double?> units = const Value.absent(),
    Value<double?> annualRate = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> maturityDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? updatedAt,
  }) => Investment(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    institution: institution.present ? institution.value : this.institution,
    investedAmount: investedAmount ?? this.investedAmount,
    currentValue: currentValue ?? this.currentValue,
    units: units.present ? units.value : this.units,
    annualRate: annualRate.present ? annualRate.value : this.annualRate,
    startDate: startDate.present ? startDate.value : this.startDate,
    maturityDate: maturityDate.present ? maturityDate.value : this.maturityDate,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Investment copyWithCompanion(InvestmentsCompanion data) {
    return Investment(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
      investedAmount: data.investedAmount.present
          ? data.investedAmount.value
          : this.investedAmount,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      units: data.units.present ? data.units.value : this.units,
      annualRate: data.annualRate.present
          ? data.annualRate.value
          : this.annualRate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      maturityDate: data.maturityDate.present
          ? data.maturityDate.value
          : this.maturityDate,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Investment(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('institution: $institution, ')
          ..write('investedAmount: $investedAmount, ')
          ..write('currentValue: $currentValue, ')
          ..write('units: $units, ')
          ..write('annualRate: $annualRate, ')
          ..write('startDate: $startDate, ')
          ..write('maturityDate: $maturityDate, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    institution,
    investedAmount,
    currentValue,
    units,
    annualRate,
    startDate,
    maturityDate,
    note,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Investment &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.institution == this.institution &&
          other.investedAmount == this.investedAmount &&
          other.currentValue == this.currentValue &&
          other.units == this.units &&
          other.annualRate == this.annualRate &&
          other.startDate == this.startDate &&
          other.maturityDate == this.maturityDate &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class InvestmentsCompanion extends UpdateCompanion<Investment> {
  final Value<int> id;
  final Value<String> name;
  final Value<AssetType> type;
  final Value<String?> institution;
  final Value<double> investedAmount;
  final Value<double> currentValue;
  final Value<double?> units;
  final Value<double?> annualRate;
  final Value<DateTime?> startDate;
  final Value<DateTime?> maturityDate;
  final Value<String?> note;
  final Value<DateTime> updatedAt;
  const InvestmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.institution = const Value.absent(),
    this.investedAmount = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.units = const Value.absent(),
    this.annualRate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.maturityDate = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InvestmentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AssetType type,
    this.institution = const Value.absent(),
    required double investedAmount,
    required double currentValue,
    this.units = const Value.absent(),
    this.annualRate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.maturityDate = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       investedAmount = Value(investedAmount),
       currentValue = Value(currentValue);
  static Insertable<Investment> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? institution,
    Expression<double>? investedAmount,
    Expression<double>? currentValue,
    Expression<double>? units,
    Expression<double>? annualRate,
    Expression<DateTime>? startDate,
    Expression<DateTime>? maturityDate,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (institution != null) 'institution': institution,
      if (investedAmount != null) 'invested_amount': investedAmount,
      if (currentValue != null) 'current_value': currentValue,
      if (units != null) 'units': units,
      if (annualRate != null) 'annual_rate': annualRate,
      if (startDate != null) 'start_date': startDate,
      if (maturityDate != null) 'maturity_date': maturityDate,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InvestmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<AssetType>? type,
    Value<String?>? institution,
    Value<double>? investedAmount,
    Value<double>? currentValue,
    Value<double?>? units,
    Value<double?>? annualRate,
    Value<DateTime?>? startDate,
    Value<DateTime?>? maturityDate,
    Value<String?>? note,
    Value<DateTime>? updatedAt,
  }) {
    return InvestmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      institution: institution ?? this.institution,
      investedAmount: investedAmount ?? this.investedAmount,
      currentValue: currentValue ?? this.currentValue,
      units: units ?? this.units,
      annualRate: annualRate ?? this.annualRate,
      startDate: startDate ?? this.startDate,
      maturityDate: maturityDate ?? this.maturityDate,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $InvestmentsTable.$convertertype.toSql(type.value),
      );
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (investedAmount.present) {
      map['invested_amount'] = Variable<double>(investedAmount.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (annualRate.present) {
      map['annual_rate'] = Variable<double>(annualRate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (maturityDate.present) {
      map['maturity_date'] = Variable<DateTime>(maturityDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('institution: $institution, ')
          ..write('investedAmount: $investedAmount, ')
          ..write('currentValue: $currentValue, ')
          ..write('units: $units, ')
          ..write('annualRate: $annualRate, ')
          ..write('startDate: $startDate, ')
          ..write('maturityDate: $maturityDate, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RecurringRulesTable extends RecurringRules
    with TableInfo<$RecurringRulesTable, RecurringRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TxnType>($RecurringRulesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<Frequency, int> frequency =
      GeneratedColumn<int>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Frequency>($RecurringRulesTable.$converterfrequency);
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nextDueDateMeta = const VerificationMeta(
    'nextDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
    'next_due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPostedDateMeta = const VerificationMeta(
    'lastPostedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastPostedDate =
      GeneratedColumn<DateTime>(
        'last_posted_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amount,
    categoryId,
    type,
    frequency,
    interval,
    nextDueDate,
    endDate,
    lastPostedDate,
    active,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
        _nextDueDateMeta,
        nextDueDate.isAcceptableOrUnknown(
          data['next_due_date']!,
          _nextDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('last_posted_date')) {
      context.handle(
        _lastPostedDateMeta,
        lastPostedDate.isAcceptableOrUnknown(
          data['last_posted_date']!,
          _lastPostedDateMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      type: $RecurringRulesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      frequency: $RecurringRulesTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      nextDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      lastPostedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_posted_date'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecurringRulesTable createAlias(String alias) {
    return $RecurringRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnType, int, int> $convertertype =
      const EnumIndexConverter<TxnType>(TxnType.values);
  static JsonTypeConverter2<Frequency, int, int> $converterfrequency =
      const EnumIndexConverter<Frequency>(Frequency.values);
}

class RecurringRule extends DataClass implements Insertable<RecurringRule> {
  final int id;
  final String title;
  final double amount;
  final int? categoryId;
  final TxnType type;
  final Frequency frequency;

  /// Every N units of [frequency] (e.g. every 2 weeks).
  final int interval;

  /// Next date a transaction should be posted for this rule.
  final DateTime nextDueDate;
  final DateTime? endDate;
  final DateTime? lastPostedDate;
  final bool active;
  final String? note;
  final DateTime createdAt;
  const RecurringRule({
    required this.id,
    required this.title,
    required this.amount,
    this.categoryId,
    required this.type,
    required this.frequency,
    required this.interval,
    required this.nextDueDate,
    this.endDate,
    this.lastPostedDate,
    required this.active,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    {
      map['type'] = Variable<int>(
        $RecurringRulesTable.$convertertype.toSql(type),
      );
    }
    {
      map['frequency'] = Variable<int>(
        $RecurringRulesTable.$converterfrequency.toSql(frequency),
      );
    }
    map['interval'] = Variable<int>(interval);
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || lastPostedDate != null) {
      map['last_posted_date'] = Variable<DateTime>(lastPostedDate);
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecurringRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurringRulesCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      type: Value(type),
      frequency: Value(frequency),
      interval: Value(interval),
      nextDueDate: Value(nextDueDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      lastPostedDate: lastPostedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPostedDate),
      active: Value(active),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory RecurringRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRule(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      type: $RecurringRulesTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      frequency: $RecurringRulesTable.$converterfrequency.fromJson(
        serializer.fromJson<int>(json['frequency']),
      ),
      interval: serializer.fromJson<int>(json['interval']),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      lastPostedDate: serializer.fromJson<DateTime?>(json['lastPostedDate']),
      active: serializer.fromJson<bool>(json['active']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'categoryId': serializer.toJson<int?>(categoryId),
      'type': serializer.toJson<int>(
        $RecurringRulesTable.$convertertype.toJson(type),
      ),
      'frequency': serializer.toJson<int>(
        $RecurringRulesTable.$converterfrequency.toJson(frequency),
      ),
      'interval': serializer.toJson<int>(interval),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'lastPostedDate': serializer.toJson<DateTime?>(lastPostedDate),
      'active': serializer.toJson<bool>(active),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecurringRule copyWith({
    int? id,
    String? title,
    double? amount,
    Value<int?> categoryId = const Value.absent(),
    TxnType? type,
    Frequency? frequency,
    int? interval,
    DateTime? nextDueDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<DateTime?> lastPostedDate = const Value.absent(),
    bool? active,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => RecurringRule(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    type: type ?? this.type,
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    lastPostedDate: lastPostedDate.present
        ? lastPostedDate.value
        : this.lastPostedDate,
    active: active ?? this.active,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  RecurringRule copyWithCompanion(RecurringRulesCompanion data) {
    return RecurringRule(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      type: data.type.present ? data.type.value : this.type,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      interval: data.interval.present ? data.interval.value : this.interval,
      nextDueDate: data.nextDueDate.present
          ? data.nextDueDate.value
          : this.nextDueDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      lastPostedDate: data.lastPostedDate.present
          ? data.lastPostedDate.value
          : this.lastPostedDate,
      active: data.active.present ? data.active.value : this.active,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRule(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('endDate: $endDate, ')
          ..write('lastPostedDate: $lastPostedDate, ')
          ..write('active: $active, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amount,
    categoryId,
    type,
    frequency,
    interval,
    nextDueDate,
    endDate,
    lastPostedDate,
    active,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRule &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.categoryId == this.categoryId &&
          other.type == this.type &&
          other.frequency == this.frequency &&
          other.interval == this.interval &&
          other.nextDueDate == this.nextDueDate &&
          other.endDate == this.endDate &&
          other.lastPostedDate == this.lastPostedDate &&
          other.active == this.active &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class RecurringRulesCompanion extends UpdateCompanion<RecurringRule> {
  final Value<int> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<int?> categoryId;
  final Value<TxnType> type;
  final Value<Frequency> frequency;
  final Value<int> interval;
  final Value<DateTime> nextDueDate;
  final Value<DateTime?> endDate;
  final Value<DateTime?> lastPostedDate;
  final Value<bool> active;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const RecurringRulesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    this.frequency = const Value.absent(),
    this.interval = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.lastPostedDate = const Value.absent(),
    this.active = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecurringRulesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required double amount,
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    required Frequency frequency,
    this.interval = const Value.absent(),
    required DateTime nextDueDate,
    this.endDate = const Value.absent(),
    this.lastPostedDate = const Value.absent(),
    this.active = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       amount = Value(amount),
       frequency = Value(frequency),
       nextDueDate = Value(nextDueDate);
  static Insertable<RecurringRule> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<int>? categoryId,
    Expression<int>? type,
    Expression<int>? frequency,
    Expression<int>? interval,
    Expression<DateTime>? nextDueDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? lastPostedDate,
    Expression<bool>? active,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (categoryId != null) 'category_id': categoryId,
      if (type != null) 'type': type,
      if (frequency != null) 'frequency': frequency,
      if (interval != null) 'interval': interval,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (endDate != null) 'end_date': endDate,
      if (lastPostedDate != null) 'last_posted_date': lastPostedDate,
      if (active != null) 'active': active,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecurringRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<double>? amount,
    Value<int?>? categoryId,
    Value<TxnType>? type,
    Value<Frequency>? frequency,
    Value<int>? interval,
    Value<DateTime>? nextDueDate,
    Value<DateTime?>? endDate,
    Value<DateTime?>? lastPostedDate,
    Value<bool>? active,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return RecurringRulesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      endDate: endDate ?? this.endDate,
      lastPostedDate: lastPostedDate ?? this.lastPostedDate,
      active: active ?? this.active,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $RecurringRulesTable.$convertertype.toSql(type.value),
      );
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(
        $RecurringRulesTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (lastPostedDate.present) {
      map['last_posted_date'] = Variable<DateTime>(lastPostedDate.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('endDate: $endDate, ')
          ..write('lastPostedDate: $lastPostedDate, ')
          ..write('active: $active, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $EmiSchedulesTable emiSchedules = $EmiSchedulesTable(this);
  late final $InvestmentsTable investments = $InvestmentsTable(this);
  late final $RecurringRulesTable recurringRules = $RecurringRulesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    transactions,
    loans,
    emiSchedules,
    investments,
    recurringRules,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'loans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('emi_schedules', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurring_rules', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required int iconCodepoint,
      required int color,
      Value<TxnType> type,
      Value<String> keywords,
      Value<bool> isDefault,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> iconCodepoint,
      Value<int> color,
      Value<TxnType> type,
      Value<String> keywords,
      Value<bool> isDefault,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.transactions.categoryId,
    ),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurringRulesTable, List<RecurringRule>>
  _recurringRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurringRules,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.recurringRules.categoryId,
    ),
  );

  $$RecurringRulesTableProcessedTableManager get recurringRulesRefs {
    final manager = $$RecurringRulesTableTableManager(
      $_db,
      $_db.recurringRules,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurringRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconCodepoint => $composableBuilder(
    column: $table.iconCodepoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnType, TxnType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringRulesRefs(
    Expression<bool> Function($$RecurringRulesTableFilterComposer f) f,
  ) {
    final $$RecurringRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableFilterComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCodepoint => $composableBuilder(
    column: $table.iconCodepoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get iconCodepoint => $composableBuilder(
    column: $table.iconCodepoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringRulesRefs<T extends Object>(
    Expression<T> Function($$RecurringRulesTableAnnotationComposer a) f,
  ) {
    final $$RecurringRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool recurringRulesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> iconCodepoint = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<TxnType> type = const Value.absent(),
                Value<String> keywords = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                iconCodepoint: iconCodepoint,
                color: color,
                type: type,
                keywords: keywords,
                isDefault: isDefault,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int iconCodepoint,
                required int color,
                Value<TxnType> type = const Value.absent(),
                Value<String> keywords = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                iconCodepoint: iconCodepoint,
                color: color,
                type: type,
                keywords: keywords,
                isDefault: isDefault,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transactionsRefs = false, recurringRulesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (recurringRulesRefs) db.recurringRules,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurringRulesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          RecurringRule
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._recurringRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool transactionsRefs, bool recurringRulesRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required double amount,
      required String title,
      Value<String?> note,
      Value<int?> categoryId,
      required DateTime date,
      Value<TxnType> type,
      Value<TxnSource> source,
      Value<int?> emiId,
      Value<int?> recurringId,
      Value<DateTime> createdAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<String> title,
      Value<String?> note,
      Value<int?> categoryId,
      Value<DateTime> date,
      Value<TxnType> type,
      Value<TxnSource> source,
      Value<int?> emiId,
      Value<int?> recurringId,
      Value<DateTime> createdAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.transactions.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnType, TxnType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TxnSource, TxnSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get emiId => $composableBuilder(
    column: $table.emiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emiId => $composableBuilder(
    column: $table.emiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get emiId =>
      $composableBuilder(column: $table.emiId, builder: (column) => column);

  GeneratedColumn<int> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({bool categoryId})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<TxnType> type = const Value.absent(),
                Value<TxnSource> source = const Value.absent(),
                Value<int?> emiId = const Value.absent(),
                Value<int?> recurringId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amount: amount,
                title: title,
                note: note,
                categoryId: categoryId,
                date: date,
                type: type,
                source: source,
                emiId: emiId,
                recurringId: recurringId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String title,
                Value<String?> note = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                required DateTime date,
                Value<TxnType> type = const Value.absent(),
                Value<TxnSource> source = const Value.absent(),
                Value<int?> emiId = const Value.absent(),
                Value<int?> recurringId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amount: amount,
                title: title,
                note: note,
                categoryId: categoryId,
                date: date,
                type: type,
                source: source,
                emiId: emiId,
                recurringId: recurringId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$TransactionsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$TransactionsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$LoansTableCreateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      required String name,
      required LoanType type,
      Value<String?> lender,
      required double principal,
      required double annualRate,
      required int tenureMonths,
      required DateTime startDate,
      required double emiAmount,
      Value<int> dueDay,
      Value<bool> autoPostExpense,
      Value<bool> autoDebit,
      Value<bool> alertsEnabled,
      Value<int> alertLeadDays,
      Value<bool> closed,
      Value<DateTime> createdAt,
    });
typedef $$LoansTableUpdateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<LoanType> type,
      Value<String?> lender,
      Value<double> principal,
      Value<double> annualRate,
      Value<int> tenureMonths,
      Value<DateTime> startDate,
      Value<double> emiAmount,
      Value<int> dueDay,
      Value<bool> autoPostExpense,
      Value<bool> autoDebit,
      Value<bool> alertsEnabled,
      Value<int> alertLeadDays,
      Value<bool> closed,
      Value<DateTime> createdAt,
    });

final class $$LoansTableReferences
    extends BaseReferences<_$AppDatabase, $LoansTable, Loan> {
  $$LoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmiSchedulesTable, List<EmiSchedule>>
  _emiSchedulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emiSchedules,
    aliasName: $_aliasNameGenerator(db.loans.id, db.emiSchedules.loanId),
  );

  $$EmiSchedulesTableProcessedTableManager get emiSchedulesRefs {
    final manager = $$EmiSchedulesTableTableManager(
      $_db,
      $_db.emiSchedules,
    ).filter((f) => f.loanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emiSchedulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LoanType, LoanType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get principal => $composableBuilder(
    column: $table.principal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get annualRate => $composableBuilder(
    column: $table.annualRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tenureMonths => $composableBuilder(
    column: $table.tenureMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get emiAmount => $composableBuilder(
    column: $table.emiAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoPostExpense => $composableBuilder(
    column: $table.autoPostExpense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoDebit => $composableBuilder(
    column: $table.autoDebit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alertLeadDays => $composableBuilder(
    column: $table.alertLeadDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get closed => $composableBuilder(
    column: $table.closed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> emiSchedulesRefs(
    Expression<bool> Function($$EmiSchedulesTableFilterComposer f) f,
  ) {
    final $$EmiSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emiSchedules,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmiSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.emiSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get principal => $composableBuilder(
    column: $table.principal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get annualRate => $composableBuilder(
    column: $table.annualRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tenureMonths => $composableBuilder(
    column: $table.tenureMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get emiAmount => $composableBuilder(
    column: $table.emiAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoPostExpense => $composableBuilder(
    column: $table.autoPostExpense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoDebit => $composableBuilder(
    column: $table.autoDebit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alertLeadDays => $composableBuilder(
    column: $table.alertLeadDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get closed => $composableBuilder(
    column: $table.closed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoanType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get lender =>
      $composableBuilder(column: $table.lender, builder: (column) => column);

  GeneratedColumn<double> get principal =>
      $composableBuilder(column: $table.principal, builder: (column) => column);

  GeneratedColumn<double> get annualRate => $composableBuilder(
    column: $table.annualRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tenureMonths => $composableBuilder(
    column: $table.tenureMonths,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<double> get emiAmount =>
      $composableBuilder(column: $table.emiAmount, builder: (column) => column);

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<bool> get autoPostExpense => $composableBuilder(
    column: $table.autoPostExpense,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoDebit =>
      $composableBuilder(column: $table.autoDebit, builder: (column) => column);

  GeneratedColumn<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get alertLeadDays => $composableBuilder(
    column: $table.alertLeadDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get closed =>
      $composableBuilder(column: $table.closed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> emiSchedulesRefs<T extends Object>(
    Expression<T> Function($$EmiSchedulesTableAnnotationComposer a) f,
  ) {
    final $$EmiSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emiSchedules,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmiSchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.emiSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTable,
          Loan,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (Loan, $$LoansTableReferences),
          Loan,
          PrefetchHooks Function({bool emiSchedulesRefs})
        > {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<LoanType> type = const Value.absent(),
                Value<String?> lender = const Value.absent(),
                Value<double> principal = const Value.absent(),
                Value<double> annualRate = const Value.absent(),
                Value<int> tenureMonths = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<double> emiAmount = const Value.absent(),
                Value<int> dueDay = const Value.absent(),
                Value<bool> autoPostExpense = const Value.absent(),
                Value<bool> autoDebit = const Value.absent(),
                Value<bool> alertsEnabled = const Value.absent(),
                Value<int> alertLeadDays = const Value.absent(),
                Value<bool> closed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                name: name,
                type: type,
                lender: lender,
                principal: principal,
                annualRate: annualRate,
                tenureMonths: tenureMonths,
                startDate: startDate,
                emiAmount: emiAmount,
                dueDay: dueDay,
                autoPostExpense: autoPostExpense,
                autoDebit: autoDebit,
                alertsEnabled: alertsEnabled,
                alertLeadDays: alertLeadDays,
                closed: closed,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required LoanType type,
                Value<String?> lender = const Value.absent(),
                required double principal,
                required double annualRate,
                required int tenureMonths,
                required DateTime startDate,
                required double emiAmount,
                Value<int> dueDay = const Value.absent(),
                Value<bool> autoPostExpense = const Value.absent(),
                Value<bool> autoDebit = const Value.absent(),
                Value<bool> alertsEnabled = const Value.absent(),
                Value<int> alertLeadDays = const Value.absent(),
                Value<bool> closed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                name: name,
                type: type,
                lender: lender,
                principal: principal,
                annualRate: annualRate,
                tenureMonths: tenureMonths,
                startDate: startDate,
                emiAmount: emiAmount,
                dueDay: dueDay,
                autoPostExpense: autoPostExpense,
                autoDebit: autoDebit,
                alertsEnabled: alertsEnabled,
                alertLeadDays: alertLeadDays,
                closed: closed,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LoansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({emiSchedulesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (emiSchedulesRefs) db.emiSchedules],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (emiSchedulesRefs)
                    await $_getPrefetchedData<Loan, $LoansTable, EmiSchedule>(
                      currentTable: table,
                      referencedTable: $$LoansTableReferences
                          ._emiSchedulesRefsTable(db),
                      managerFromTypedResult: (p0) => $$LoansTableReferences(
                        db,
                        table,
                        p0,
                      ).emiSchedulesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.loanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTable,
      Loan,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (Loan, $$LoansTableReferences),
      Loan,
      PrefetchHooks Function({bool emiSchedulesRefs})
    >;
typedef $$EmiSchedulesTableCreateCompanionBuilder =
    EmiSchedulesCompanion Function({
      Value<int> id,
      required int loanId,
      required int installmentNo,
      required DateTime dueDate,
      required double emiAmount,
      required double principalComponent,
      required double interestComponent,
      required double balance,
      Value<bool> paid,
      Value<DateTime?> paidDate,
      Value<int?> transactionId,
    });
typedef $$EmiSchedulesTableUpdateCompanionBuilder =
    EmiSchedulesCompanion Function({
      Value<int> id,
      Value<int> loanId,
      Value<int> installmentNo,
      Value<DateTime> dueDate,
      Value<double> emiAmount,
      Value<double> principalComponent,
      Value<double> interestComponent,
      Value<double> balance,
      Value<bool> paid,
      Value<DateTime?> paidDate,
      Value<int?> transactionId,
    });

final class $$EmiSchedulesTableReferences
    extends BaseReferences<_$AppDatabase, $EmiSchedulesTable, EmiSchedule> {
  $$EmiSchedulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LoansTable _loanIdTable(_$AppDatabase db) => db.loans.createAlias(
    $_aliasNameGenerator(db.emiSchedules.loanId, db.loans.id),
  );

  $$LoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<int>('loan_id')!;

    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmiSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $EmiSchedulesTable> {
  $$EmiSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentNo => $composableBuilder(
    column: $table.installmentNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get emiAmount => $composableBuilder(
    column: $table.emiAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get principalComponent => $composableBuilder(
    column: $table.principalComponent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get interestComponent => $composableBuilder(
    column: $table.interestComponent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  $$LoansTableFilterComposer get loanId {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmiSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmiSchedulesTable> {
  $$EmiSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentNo => $composableBuilder(
    column: $table.installmentNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get emiAmount => $composableBuilder(
    column: $table.emiAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get principalComponent => $composableBuilder(
    column: $table.principalComponent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestComponent => $composableBuilder(
    column: $table.interestComponent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoansTableOrderingComposer get loanId {
    final $$LoansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableOrderingComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmiSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmiSchedulesTable> {
  $$EmiSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get installmentNo => $composableBuilder(
    column: $table.installmentNo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get emiAmount =>
      $composableBuilder(column: $table.emiAmount, builder: (column) => column);

  GeneratedColumn<double> get principalComponent => $composableBuilder(
    column: $table.principalComponent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get interestComponent => $composableBuilder(
    column: $table.interestComponent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<bool> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  $$LoansTableAnnotationComposer get loanId {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmiSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmiSchedulesTable,
          EmiSchedule,
          $$EmiSchedulesTableFilterComposer,
          $$EmiSchedulesTableOrderingComposer,
          $$EmiSchedulesTableAnnotationComposer,
          $$EmiSchedulesTableCreateCompanionBuilder,
          $$EmiSchedulesTableUpdateCompanionBuilder,
          (EmiSchedule, $$EmiSchedulesTableReferences),
          EmiSchedule,
          PrefetchHooks Function({bool loanId})
        > {
  $$EmiSchedulesTableTableManager(_$AppDatabase db, $EmiSchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmiSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmiSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmiSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> loanId = const Value.absent(),
                Value<int> installmentNo = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<double> emiAmount = const Value.absent(),
                Value<double> principalComponent = const Value.absent(),
                Value<double> interestComponent = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<bool> paid = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
              }) => EmiSchedulesCompanion(
                id: id,
                loanId: loanId,
                installmentNo: installmentNo,
                dueDate: dueDate,
                emiAmount: emiAmount,
                principalComponent: principalComponent,
                interestComponent: interestComponent,
                balance: balance,
                paid: paid,
                paidDate: paidDate,
                transactionId: transactionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int loanId,
                required int installmentNo,
                required DateTime dueDate,
                required double emiAmount,
                required double principalComponent,
                required double interestComponent,
                required double balance,
                Value<bool> paid = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
              }) => EmiSchedulesCompanion.insert(
                id: id,
                loanId: loanId,
                installmentNo: installmentNo,
                dueDate: dueDate,
                emiAmount: emiAmount,
                principalComponent: principalComponent,
                interestComponent: interestComponent,
                balance: balance,
                paid: paid,
                paidDate: paidDate,
                transactionId: transactionId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmiSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (loanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.loanId,
                                referencedTable: $$EmiSchedulesTableReferences
                                    ._loanIdTable(db),
                                referencedColumn: $$EmiSchedulesTableReferences
                                    ._loanIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmiSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmiSchedulesTable,
      EmiSchedule,
      $$EmiSchedulesTableFilterComposer,
      $$EmiSchedulesTableOrderingComposer,
      $$EmiSchedulesTableAnnotationComposer,
      $$EmiSchedulesTableCreateCompanionBuilder,
      $$EmiSchedulesTableUpdateCompanionBuilder,
      (EmiSchedule, $$EmiSchedulesTableReferences),
      EmiSchedule,
      PrefetchHooks Function({bool loanId})
    >;
typedef $$InvestmentsTableCreateCompanionBuilder =
    InvestmentsCompanion Function({
      Value<int> id,
      required String name,
      required AssetType type,
      Value<String?> institution,
      required double investedAmount,
      required double currentValue,
      Value<double?> units,
      Value<double?> annualRate,
      Value<DateTime?> startDate,
      Value<DateTime?> maturityDate,
      Value<String?> note,
      Value<DateTime> updatedAt,
    });
typedef $$InvestmentsTableUpdateCompanionBuilder =
    InvestmentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<AssetType> type,
      Value<String?> institution,
      Value<double> investedAmount,
      Value<double> currentValue,
      Value<double?> units,
      Value<double?> annualRate,
      Value<DateTime?> startDate,
      Value<DateTime?> maturityDate,
      Value<String?> note,
      Value<DateTime> updatedAt,
    });

class $$InvestmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AssetType, AssetType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get investedAmount => $composableBuilder(
    column: $table.investedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get annualRate => $composableBuilder(
    column: $table.annualRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get maturityDate => $composableBuilder(
    column: $table.maturityDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvestmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get investedAmount => $composableBuilder(
    column: $table.investedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get annualRate => $composableBuilder(
    column: $table.annualRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get maturityDate => $composableBuilder(
    column: $table.maturityDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvestmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AssetType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumn<double> get investedAmount => $composableBuilder(
    column: $table.investedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<double> get annualRate => $composableBuilder(
    column: $table.annualRate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get maturityDate => $composableBuilder(
    column: $table.maturityDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InvestmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvestmentsTable,
          Investment,
          $$InvestmentsTableFilterComposer,
          $$InvestmentsTableOrderingComposer,
          $$InvestmentsTableAnnotationComposer,
          $$InvestmentsTableCreateCompanionBuilder,
          $$InvestmentsTableUpdateCompanionBuilder,
          (
            Investment,
            BaseReferences<_$AppDatabase, $InvestmentsTable, Investment>,
          ),
          Investment,
          PrefetchHooks Function()
        > {
  $$InvestmentsTableTableManager(_$AppDatabase db, $InvestmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AssetType> type = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<double> investedAmount = const Value.absent(),
                Value<double> currentValue = const Value.absent(),
                Value<double?> units = const Value.absent(),
                Value<double?> annualRate = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> maturityDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InvestmentsCompanion(
                id: id,
                name: name,
                type: type,
                institution: institution,
                investedAmount: investedAmount,
                currentValue: currentValue,
                units: units,
                annualRate: annualRate,
                startDate: startDate,
                maturityDate: maturityDate,
                note: note,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required AssetType type,
                Value<String?> institution = const Value.absent(),
                required double investedAmount,
                required double currentValue,
                Value<double?> units = const Value.absent(),
                Value<double?> annualRate = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> maturityDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InvestmentsCompanion.insert(
                id: id,
                name: name,
                type: type,
                institution: institution,
                investedAmount: investedAmount,
                currentValue: currentValue,
                units: units,
                annualRate: annualRate,
                startDate: startDate,
                maturityDate: maturityDate,
                note: note,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvestmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvestmentsTable,
      Investment,
      $$InvestmentsTableFilterComposer,
      $$InvestmentsTableOrderingComposer,
      $$InvestmentsTableAnnotationComposer,
      $$InvestmentsTableCreateCompanionBuilder,
      $$InvestmentsTableUpdateCompanionBuilder,
      (
        Investment,
        BaseReferences<_$AppDatabase, $InvestmentsTable, Investment>,
      ),
      Investment,
      PrefetchHooks Function()
    >;
typedef $$RecurringRulesTableCreateCompanionBuilder =
    RecurringRulesCompanion Function({
      Value<int> id,
      required String title,
      required double amount,
      Value<int?> categoryId,
      Value<TxnType> type,
      required Frequency frequency,
      Value<int> interval,
      required DateTime nextDueDate,
      Value<DateTime?> endDate,
      Value<DateTime?> lastPostedDate,
      Value<bool> active,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$RecurringRulesTableUpdateCompanionBuilder =
    RecurringRulesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<double> amount,
      Value<int?> categoryId,
      Value<TxnType> type,
      Value<Frequency> frequency,
      Value<int> interval,
      Value<DateTime> nextDueDate,
      Value<DateTime?> endDate,
      Value<DateTime?> lastPostedDate,
      Value<bool> active,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$RecurringRulesTableReferences
    extends BaseReferences<_$AppDatabase, $RecurringRulesTable, RecurringRule> {
  $$RecurringRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.recurringRules.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurringRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnType, TxnType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Frequency, Frequency, int> get frequency =>
      $composableBuilder(
        column: $table.frequency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPostedDate => $composableBuilder(
    column: $table.lastPostedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPostedDate => $composableBuilder(
    column: $table.lastPostedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Frequency, int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPostedDate => $composableBuilder(
    column: $table.lastPostedDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringRulesTable,
          RecurringRule,
          $$RecurringRulesTableFilterComposer,
          $$RecurringRulesTableOrderingComposer,
          $$RecurringRulesTableAnnotationComposer,
          $$RecurringRulesTableCreateCompanionBuilder,
          $$RecurringRulesTableUpdateCompanionBuilder,
          (RecurringRule, $$RecurringRulesTableReferences),
          RecurringRule,
          PrefetchHooks Function({bool categoryId})
        > {
  $$RecurringRulesTableTableManager(
    _$AppDatabase db,
    $RecurringRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<TxnType> type = const Value.absent(),
                Value<Frequency> frequency = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<DateTime> nextDueDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> lastPostedDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecurringRulesCompanion(
                id: id,
                title: title,
                amount: amount,
                categoryId: categoryId,
                type: type,
                frequency: frequency,
                interval: interval,
                nextDueDate: nextDueDate,
                endDate: endDate,
                lastPostedDate: lastPostedDate,
                active: active,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required double amount,
                Value<int?> categoryId = const Value.absent(),
                Value<TxnType> type = const Value.absent(),
                required Frequency frequency,
                Value<int> interval = const Value.absent(),
                required DateTime nextDueDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> lastPostedDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecurringRulesCompanion.insert(
                id: id,
                title: title,
                amount: amount,
                categoryId: categoryId,
                type: type,
                frequency: frequency,
                interval: interval,
                nextDueDate: nextDueDate,
                endDate: endDate,
                lastPostedDate: lastPostedDate,
                active: active,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$RecurringRulesTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn:
                                    $$RecurringRulesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecurringRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringRulesTable,
      RecurringRule,
      $$RecurringRulesTableFilterComposer,
      $$RecurringRulesTableOrderingComposer,
      $$RecurringRulesTableAnnotationComposer,
      $$RecurringRulesTableCreateCompanionBuilder,
      $$RecurringRulesTableUpdateCompanionBuilder,
      (RecurringRule, $$RecurringRulesTableReferences),
      RecurringRule,
      PrefetchHooks Function({bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$EmiSchedulesTableTableManager get emiSchedules =>
      $$EmiSchedulesTableTableManager(_db, _db.emiSchedules);
  $$InvestmentsTableTableManager get investments =>
      $$InvestmentsTableTableManager(_db, _db.investments);
  $$RecurringRulesTableTableManager get recurringRules =>
      $$RecurringRulesTableTableManager(_db, _db.recurringRules);
}
