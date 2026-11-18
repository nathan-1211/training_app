// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  const Exercise({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(id: Value(id), name: Value(name));
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Exercise copyWith({int? id, String? name}) =>
      Exercise(id: id ?? this.id, name: name ?? this.name);
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise && other.id == this.id && other.name == this.name);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ExercisesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ExercisesCompanion(id: id ?? this.id, name: name ?? this.name);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $BlocksTable extends Blocks with TableInfo<$BlocksTable, Block> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlocksTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
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
  static const VerificationMeta _weeksMeta = const VerificationMeta('weeks');
  @override
  late final GeneratedColumn<int> weeks = GeneratedColumn<int>(
    'weeks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
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
    startDate,
    weeks,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Block> instance, {
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
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('weeks')) {
      context.handle(
        _weeksMeta,
        weeks.isAcceptableOrUnknown(data['weeks']!, _weeksMeta),
      );
    } else if (isInserting) {
      context.missing(_weeksMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
  Block map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Block(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      weeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weeks'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BlocksTable createAlias(String alias) {
    return $BlocksTable(attachedDatabase, alias);
  }
}

class Block extends DataClass implements Insertable<Block> {
  final int id;
  final String name;
  final DateTime startDate;
  final int weeks;
  final bool isActive;
  final DateTime createdAt;
  const Block({
    required this.id,
    required this.name,
    required this.startDate,
    required this.weeks,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['weeks'] = Variable<int>(weeks);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BlocksCompanion toCompanion(bool nullToAbsent) {
    return BlocksCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      weeks: Value(weeks),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Block.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Block(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      weeks: serializer.fromJson<int>(json['weeks']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'weeks': serializer.toJson<int>(weeks),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Block copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    int? weeks,
    bool? isActive,
    DateTime? createdAt,
  }) => Block(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    weeks: weeks ?? this.weeks,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Block copyWithCompanion(BlocksCompanion data) {
    return Block(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      weeks: data.weeks.present ? data.weeks.value : this.weeks,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Block(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('weeks: $weeks, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, startDate, weeks, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Block &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.weeks == this.weeks &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class BlocksCompanion extends UpdateCompanion<Block> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<int> weeks;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const BlocksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.weeks = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BlocksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startDate,
    required int weeks,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       startDate = Value(startDate),
       weeks = Value(weeks);
  static Insertable<Block> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<int>? weeks,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (weeks != null) 'weeks': weeks,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BlocksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<int>? weeks,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return BlocksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      weeks: weeks ?? this.weeks,
      isActive: isActive ?? this.isActive,
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
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (weeks.present) {
      map['weeks'] = Variable<int>(weeks.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('weeks: $weeks, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BlockWeeksTable extends BlockWeeks
    with TableInfo<$BlockWeeksTable, BlockWeek> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockWeeksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES blocks (id)',
    ),
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _mainSetsMeta = const VerificationMeta(
    'mainSets',
  );
  @override
  late final GeneratedColumn<int> mainSets = GeneratedColumn<int>(
    'main_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<String> rir = GeneratedColumn<String>(
    'rir',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _runPrescriptionMeta = const VerificationMeta(
    'runPrescription',
  );
  @override
  late final GeneratedColumn<String> runPrescription = GeneratedColumn<String>(
    'run_prescription',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _conditioningPrescriptionMeta =
      const VerificationMeta('conditioningPrescription');
  @override
  late final GeneratedColumn<String> conditioningPrescription =
      GeneratedColumn<String>(
        'conditioning_prescription',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    blockId,
    weekNumber,
    phase,
    mainSets,
    rir,
    runPrescription,
    conditioningPrescription,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'block_weeks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BlockWeek> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    }
    if (data.containsKey('main_sets')) {
      context.handle(
        _mainSetsMeta,
        mainSets.isAcceptableOrUnknown(data['main_sets']!, _mainSetsMeta),
      );
    } else if (isInserting) {
      context.missing(_mainSetsMeta);
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('run_prescription')) {
      context.handle(
        _runPrescriptionMeta,
        runPrescription.isAcceptableOrUnknown(
          data['run_prescription']!,
          _runPrescriptionMeta,
        ),
      );
    }
    if (data.containsKey('conditioning_prescription')) {
      context.handle(
        _conditioningPrescriptionMeta,
        conditioningPrescription.isAcceptableOrUnknown(
          data['conditioning_prescription']!,
          _conditioningPrescriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockWeek map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockWeek(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      )!,
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      mainSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}main_sets'],
      )!,
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rir'],
      )!,
      runPrescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}run_prescription'],
      )!,
      conditioningPrescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conditioning_prescription'],
      )!,
    );
  }

  @override
  $BlockWeeksTable createAlias(String alias) {
    return $BlockWeeksTable(attachedDatabase, alias);
  }
}

class BlockWeek extends DataClass implements Insertable<BlockWeek> {
  final int id;
  final int blockId;
  final int weekNumber;
  final String phase;
  final int mainSets;
  final String rir;
  final String runPrescription;
  final String conditioningPrescription;
  const BlockWeek({
    required this.id,
    required this.blockId,
    required this.weekNumber,
    required this.phase,
    required this.mainSets,
    required this.rir,
    required this.runPrescription,
    required this.conditioningPrescription,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_id'] = Variable<int>(blockId);
    map['week_number'] = Variable<int>(weekNumber);
    map['phase'] = Variable<String>(phase);
    map['main_sets'] = Variable<int>(mainSets);
    map['rir'] = Variable<String>(rir);
    map['run_prescription'] = Variable<String>(runPrescription);
    map['conditioning_prescription'] = Variable<String>(
      conditioningPrescription,
    );
    return map;
  }

  BlockWeeksCompanion toCompanion(bool nullToAbsent) {
    return BlockWeeksCompanion(
      id: Value(id),
      blockId: Value(blockId),
      weekNumber: Value(weekNumber),
      phase: Value(phase),
      mainSets: Value(mainSets),
      rir: Value(rir),
      runPrescription: Value(runPrescription),
      conditioningPrescription: Value(conditioningPrescription),
    );
  }

  factory BlockWeek.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockWeek(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int>(json['blockId']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      phase: serializer.fromJson<String>(json['phase']),
      mainSets: serializer.fromJson<int>(json['mainSets']),
      rir: serializer.fromJson<String>(json['rir']),
      runPrescription: serializer.fromJson<String>(json['runPrescription']),
      conditioningPrescription: serializer.fromJson<String>(
        json['conditioningPrescription'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int>(blockId),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'phase': serializer.toJson<String>(phase),
      'mainSets': serializer.toJson<int>(mainSets),
      'rir': serializer.toJson<String>(rir),
      'runPrescription': serializer.toJson<String>(runPrescription),
      'conditioningPrescription': serializer.toJson<String>(
        conditioningPrescription,
      ),
    };
  }

  BlockWeek copyWith({
    int? id,
    int? blockId,
    int? weekNumber,
    String? phase,
    int? mainSets,
    String? rir,
    String? runPrescription,
    String? conditioningPrescription,
  }) => BlockWeek(
    id: id ?? this.id,
    blockId: blockId ?? this.blockId,
    weekNumber: weekNumber ?? this.weekNumber,
    phase: phase ?? this.phase,
    mainSets: mainSets ?? this.mainSets,
    rir: rir ?? this.rir,
    runPrescription: runPrescription ?? this.runPrescription,
    conditioningPrescription:
        conditioningPrescription ?? this.conditioningPrescription,
  );
  BlockWeek copyWithCompanion(BlockWeeksCompanion data) {
    return BlockWeek(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
      phase: data.phase.present ? data.phase.value : this.phase,
      mainSets: data.mainSets.present ? data.mainSets.value : this.mainSets,
      rir: data.rir.present ? data.rir.value : this.rir,
      runPrescription: data.runPrescription.present
          ? data.runPrescription.value
          : this.runPrescription,
      conditioningPrescription: data.conditioningPrescription.present
          ? data.conditioningPrescription.value
          : this.conditioningPrescription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockWeek(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('phase: $phase, ')
          ..write('mainSets: $mainSets, ')
          ..write('rir: $rir, ')
          ..write('runPrescription: $runPrescription, ')
          ..write('conditioningPrescription: $conditioningPrescription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    blockId,
    weekNumber,
    phase,
    mainSets,
    rir,
    runPrescription,
    conditioningPrescription,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockWeek &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.weekNumber == this.weekNumber &&
          other.phase == this.phase &&
          other.mainSets == this.mainSets &&
          other.rir == this.rir &&
          other.runPrescription == this.runPrescription &&
          other.conditioningPrescription == this.conditioningPrescription);
}

class BlockWeeksCompanion extends UpdateCompanion<BlockWeek> {
  final Value<int> id;
  final Value<int> blockId;
  final Value<int> weekNumber;
  final Value<String> phase;
  final Value<int> mainSets;
  final Value<String> rir;
  final Value<String> runPrescription;
  final Value<String> conditioningPrescription;
  const BlockWeeksCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.phase = const Value.absent(),
    this.mainSets = const Value.absent(),
    this.rir = const Value.absent(),
    this.runPrescription = const Value.absent(),
    this.conditioningPrescription = const Value.absent(),
  });
  BlockWeeksCompanion.insert({
    this.id = const Value.absent(),
    required int blockId,
    required int weekNumber,
    this.phase = const Value.absent(),
    required int mainSets,
    this.rir = const Value.absent(),
    this.runPrescription = const Value.absent(),
    this.conditioningPrescription = const Value.absent(),
  }) : blockId = Value(blockId),
       weekNumber = Value(weekNumber),
       mainSets = Value(mainSets);
  static Insertable<BlockWeek> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<int>? weekNumber,
    Expression<String>? phase,
    Expression<int>? mainSets,
    Expression<String>? rir,
    Expression<String>? runPrescription,
    Expression<String>? conditioningPrescription,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (phase != null) 'phase': phase,
      if (mainSets != null) 'main_sets': mainSets,
      if (rir != null) 'rir': rir,
      if (runPrescription != null) 'run_prescription': runPrescription,
      if (conditioningPrescription != null)
        'conditioning_prescription': conditioningPrescription,
    });
  }

  BlockWeeksCompanion copyWith({
    Value<int>? id,
    Value<int>? blockId,
    Value<int>? weekNumber,
    Value<String>? phase,
    Value<int>? mainSets,
    Value<String>? rir,
    Value<String>? runPrescription,
    Value<String>? conditioningPrescription,
  }) {
    return BlockWeeksCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      weekNumber: weekNumber ?? this.weekNumber,
      phase: phase ?? this.phase,
      mainSets: mainSets ?? this.mainSets,
      rir: rir ?? this.rir,
      runPrescription: runPrescription ?? this.runPrescription,
      conditioningPrescription:
          conditioningPrescription ?? this.conditioningPrescription,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (mainSets.present) {
      map['main_sets'] = Variable<int>(mainSets.value);
    }
    if (rir.present) {
      map['rir'] = Variable<String>(rir.value);
    }
    if (runPrescription.present) {
      map['run_prescription'] = Variable<String>(runPrescription.value);
    }
    if (conditioningPrescription.present) {
      map['conditioning_prescription'] = Variable<String>(
        conditioningPrescription.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockWeeksCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('phase: $phase, ')
          ..write('mainSets: $mainSets, ')
          ..write('rir: $rir, ')
          ..write('runPrescription: $runPrescription, ')
          ..write('conditioningPrescription: $conditioningPrescription')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplatesTable extends WorkoutTemplates
    with TableInfo<$WorkoutTemplatesTable, WorkoutTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES blocks (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, blockId, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WorkoutTemplatesTable createAlias(String alias) {
    return $WorkoutTemplatesTable(attachedDatabase, alias);
  }
}

class WorkoutTemplate extends DataClass implements Insertable<WorkoutTemplate> {
  final int id;
  final int blockId;
  final String name;
  final int sortOrder;
  const WorkoutTemplate({
    required this.id,
    required this.blockId,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_id'] = Variable<int>(blockId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WorkoutTemplatesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplatesCompanion(
      id: Value(id),
      blockId: Value(blockId),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory WorkoutTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplate(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int>(json['blockId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int>(blockId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WorkoutTemplate copyWith({
    int? id,
    int? blockId,
    String? name,
    int? sortOrder,
  }) => WorkoutTemplate(
    id: id ?? this.id,
    blockId: blockId ?? this.blockId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WorkoutTemplate copyWithCompanion(WorkoutTemplatesCompanion data) {
    return WorkoutTemplate(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplate(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, blockId, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplate &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class WorkoutTemplatesCompanion extends UpdateCompanion<WorkoutTemplate> {
  final Value<int> id;
  final Value<int> blockId;
  final Value<String> name;
  final Value<int> sortOrder;
  const WorkoutTemplatesCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  WorkoutTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required int blockId,
    required String name,
    required int sortOrder,
  }) : blockId = Value(blockId),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<WorkoutTemplate> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<String>? name,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  WorkoutTemplatesCompanion copyWith({
    Value<int>? id,
    Value<int>? blockId,
    Value<String>? name,
    Value<int>? sortOrder,
  }) {
    return WorkoutTemplatesCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $TemplateExercisesTable extends TemplateExercises
    with TableInfo<$TemplateExercisesTable, TemplateExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_templates (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LogType, String> logType =
      GeneratedColumn<String>(
        'log_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LogType>($TemplateExercisesTable.$converterlogType);
  static const VerificationMeta _isWarmupMeta = const VerificationMeta(
    'isWarmup',
  );
  @override
  late final GeneratedColumn<bool> isWarmup = GeneratedColumn<bool>(
    'is_warmup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_warmup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _repsTextMeta = const VerificationMeta(
    'repsText',
  );
  @override
  late final GeneratedColumn<String> repsText = GeneratedColumn<String>(
    'reps_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _repsMinMeta = const VerificationMeta(
    'repsMin',
  );
  @override
  late final GeneratedColumn<int> repsMin = GeneratedColumn<int>(
    'reps_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMaxMeta = const VerificationMeta(
    'repsMax',
  );
  @override
  late final GeneratedColumn<int> repsMax = GeneratedColumn<int>(
    'reps_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecMeta = const VerificationMeta(
    'restSec',
  );
  @override
  late final GeneratedColumn<int> restSec = GeneratedColumn<int>(
    'rest_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tipMeta = const VerificationMeta('tip');
  @override
  late final GeneratedColumn<String> tip = GeneratedColumn<String>(
    'tip',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fixedSetsMeta = const VerificationMeta(
    'fixedSets',
  );
  @override
  late final GeneratedColumn<int> fixedSets = GeneratedColumn<int>(
    'fixed_sets',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    exerciseId,
    position,
    logType,
    isWarmup,
    repsText,
    repsMin,
    repsMax,
    restSec,
    tip,
    fixedSets,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('is_warmup')) {
      context.handle(
        _isWarmupMeta,
        isWarmup.isAcceptableOrUnknown(data['is_warmup']!, _isWarmupMeta),
      );
    }
    if (data.containsKey('reps_text')) {
      context.handle(
        _repsTextMeta,
        repsText.isAcceptableOrUnknown(data['reps_text']!, _repsTextMeta),
      );
    }
    if (data.containsKey('reps_min')) {
      context.handle(
        _repsMinMeta,
        repsMin.isAcceptableOrUnknown(data['reps_min']!, _repsMinMeta),
      );
    }
    if (data.containsKey('reps_max')) {
      context.handle(
        _repsMaxMeta,
        repsMax.isAcceptableOrUnknown(data['reps_max']!, _repsMaxMeta),
      );
    }
    if (data.containsKey('rest_sec')) {
      context.handle(
        _restSecMeta,
        restSec.isAcceptableOrUnknown(data['rest_sec']!, _restSecMeta),
      );
    }
    if (data.containsKey('tip')) {
      context.handle(
        _tipMeta,
        tip.isAcceptableOrUnknown(data['tip']!, _tipMeta),
      );
    }
    if (data.containsKey('fixed_sets')) {
      context.handle(
        _fixedSetsMeta,
        fixedSets.isAcceptableOrUnknown(data['fixed_sets']!, _fixedSetsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      logType: $TemplateExercisesTable.$converterlogType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}log_type'],
        )!,
      ),
      isWarmup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_warmup'],
      )!,
      repsText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reps_text'],
      )!,
      repsMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_min'],
      ),
      repsMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_max'],
      ),
      restSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_sec'],
      )!,
      tip: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tip'],
      )!,
      fixedSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixed_sets'],
      ),
    );
  }

  @override
  $TemplateExercisesTable createAlias(String alias) {
    return $TemplateExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LogType, String, String> $converterlogType =
      const EnumNameConverter<LogType>(LogType.values);
}

class TemplateExercise extends DataClass
    implements Insertable<TemplateExercise> {
  final int id;
  final int templateId;
  final int exerciseId;
  final int position;
  final LogType logType;
  final bool isWarmup;
  final String repsText;
  final int? repsMin;
  final int? repsMax;
  final int restSec;
  final String tip;
  final int? fixedSets;
  const TemplateExercise({
    required this.id,
    required this.templateId,
    required this.exerciseId,
    required this.position,
    required this.logType,
    required this.isWarmup,
    required this.repsText,
    this.repsMin,
    this.repsMax,
    required this.restSec,
    required this.tip,
    this.fixedSets,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['position'] = Variable<int>(position);
    {
      map['log_type'] = Variable<String>(
        $TemplateExercisesTable.$converterlogType.toSql(logType),
      );
    }
    map['is_warmup'] = Variable<bool>(isWarmup);
    map['reps_text'] = Variable<String>(repsText);
    if (!nullToAbsent || repsMin != null) {
      map['reps_min'] = Variable<int>(repsMin);
    }
    if (!nullToAbsent || repsMax != null) {
      map['reps_max'] = Variable<int>(repsMax);
    }
    map['rest_sec'] = Variable<int>(restSec);
    map['tip'] = Variable<String>(tip);
    if (!nullToAbsent || fixedSets != null) {
      map['fixed_sets'] = Variable<int>(fixedSets);
    }
    return map;
  }

  TemplateExercisesCompanion toCompanion(bool nullToAbsent) {
    return TemplateExercisesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      exerciseId: Value(exerciseId),
      position: Value(position),
      logType: Value(logType),
      isWarmup: Value(isWarmup),
      repsText: Value(repsText),
      repsMin: repsMin == null && nullToAbsent
          ? const Value.absent()
          : Value(repsMin),
      repsMax: repsMax == null && nullToAbsent
          ? const Value.absent()
          : Value(repsMax),
      restSec: Value(restSec),
      tip: Value(tip),
      fixedSets: fixedSets == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedSets),
    );
  }

  factory TemplateExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateExercise(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      position: serializer.fromJson<int>(json['position']),
      logType: $TemplateExercisesTable.$converterlogType.fromJson(
        serializer.fromJson<String>(json['logType']),
      ),
      isWarmup: serializer.fromJson<bool>(json['isWarmup']),
      repsText: serializer.fromJson<String>(json['repsText']),
      repsMin: serializer.fromJson<int?>(json['repsMin']),
      repsMax: serializer.fromJson<int?>(json['repsMax']),
      restSec: serializer.fromJson<int>(json['restSec']),
      tip: serializer.fromJson<String>(json['tip']),
      fixedSets: serializer.fromJson<int?>(json['fixedSets']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'position': serializer.toJson<int>(position),
      'logType': serializer.toJson<String>(
        $TemplateExercisesTable.$converterlogType.toJson(logType),
      ),
      'isWarmup': serializer.toJson<bool>(isWarmup),
      'repsText': serializer.toJson<String>(repsText),
      'repsMin': serializer.toJson<int?>(repsMin),
      'repsMax': serializer.toJson<int?>(repsMax),
      'restSec': serializer.toJson<int>(restSec),
      'tip': serializer.toJson<String>(tip),
      'fixedSets': serializer.toJson<int?>(fixedSets),
    };
  }

  TemplateExercise copyWith({
    int? id,
    int? templateId,
    int? exerciseId,
    int? position,
    LogType? logType,
    bool? isWarmup,
    String? repsText,
    Value<int?> repsMin = const Value.absent(),
    Value<int?> repsMax = const Value.absent(),
    int? restSec,
    String? tip,
    Value<int?> fixedSets = const Value.absent(),
  }) => TemplateExercise(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    exerciseId: exerciseId ?? this.exerciseId,
    position: position ?? this.position,
    logType: logType ?? this.logType,
    isWarmup: isWarmup ?? this.isWarmup,
    repsText: repsText ?? this.repsText,
    repsMin: repsMin.present ? repsMin.value : this.repsMin,
    repsMax: repsMax.present ? repsMax.value : this.repsMax,
    restSec: restSec ?? this.restSec,
    tip: tip ?? this.tip,
    fixedSets: fixedSets.present ? fixedSets.value : this.fixedSets,
  );
  TemplateExercise copyWithCompanion(TemplateExercisesCompanion data) {
    return TemplateExercise(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      position: data.position.present ? data.position.value : this.position,
      logType: data.logType.present ? data.logType.value : this.logType,
      isWarmup: data.isWarmup.present ? data.isWarmup.value : this.isWarmup,
      repsText: data.repsText.present ? data.repsText.value : this.repsText,
      repsMin: data.repsMin.present ? data.repsMin.value : this.repsMin,
      repsMax: data.repsMax.present ? data.repsMax.value : this.repsMax,
      restSec: data.restSec.present ? data.restSec.value : this.restSec,
      tip: data.tip.present ? data.tip.value : this.tip,
      fixedSets: data.fixedSets.present ? data.fixedSets.value : this.fixedSets,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExercise(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('logType: $logType, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('repsText: $repsText, ')
          ..write('repsMin: $repsMin, ')
          ..write('repsMax: $repsMax, ')
          ..write('restSec: $restSec, ')
          ..write('tip: $tip, ')
          ..write('fixedSets: $fixedSets')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    exerciseId,
    position,
    logType,
    isWarmup,
    repsText,
    repsMin,
    repsMax,
    restSec,
    tip,
    fixedSets,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateExercise &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.exerciseId == this.exerciseId &&
          other.position == this.position &&
          other.logType == this.logType &&
          other.isWarmup == this.isWarmup &&
          other.repsText == this.repsText &&
          other.repsMin == this.repsMin &&
          other.repsMax == this.repsMax &&
          other.restSec == this.restSec &&
          other.tip == this.tip &&
          other.fixedSets == this.fixedSets);
}

class TemplateExercisesCompanion extends UpdateCompanion<TemplateExercise> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<int> exerciseId;
  final Value<int> position;
  final Value<LogType> logType;
  final Value<bool> isWarmup;
  final Value<String> repsText;
  final Value<int?> repsMin;
  final Value<int?> repsMax;
  final Value<int> restSec;
  final Value<String> tip;
  final Value<int?> fixedSets;
  const TemplateExercisesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.logType = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.repsText = const Value.absent(),
    this.repsMin = const Value.absent(),
    this.repsMax = const Value.absent(),
    this.restSec = const Value.absent(),
    this.tip = const Value.absent(),
    this.fixedSets = const Value.absent(),
  });
  TemplateExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    required int exerciseId,
    required int position,
    required LogType logType,
    this.isWarmup = const Value.absent(),
    this.repsText = const Value.absent(),
    this.repsMin = const Value.absent(),
    this.repsMax = const Value.absent(),
    this.restSec = const Value.absent(),
    this.tip = const Value.absent(),
    this.fixedSets = const Value.absent(),
  }) : templateId = Value(templateId),
       exerciseId = Value(exerciseId),
       position = Value(position),
       logType = Value(logType);
  static Insertable<TemplateExercise> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<int>? exerciseId,
    Expression<int>? position,
    Expression<String>? logType,
    Expression<bool>? isWarmup,
    Expression<String>? repsText,
    Expression<int>? repsMin,
    Expression<int>? repsMax,
    Expression<int>? restSec,
    Expression<String>? tip,
    Expression<int>? fixedSets,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (position != null) 'position': position,
      if (logType != null) 'log_type': logType,
      if (isWarmup != null) 'is_warmup': isWarmup,
      if (repsText != null) 'reps_text': repsText,
      if (repsMin != null) 'reps_min': repsMin,
      if (repsMax != null) 'reps_max': repsMax,
      if (restSec != null) 'rest_sec': restSec,
      if (tip != null) 'tip': tip,
      if (fixedSets != null) 'fixed_sets': fixedSets,
    });
  }

  TemplateExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? templateId,
    Value<int>? exerciseId,
    Value<int>? position,
    Value<LogType>? logType,
    Value<bool>? isWarmup,
    Value<String>? repsText,
    Value<int?>? repsMin,
    Value<int?>? repsMax,
    Value<int>? restSec,
    Value<String>? tip,
    Value<int?>? fixedSets,
  }) {
    return TemplateExercisesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      exerciseId: exerciseId ?? this.exerciseId,
      position: position ?? this.position,
      logType: logType ?? this.logType,
      isWarmup: isWarmup ?? this.isWarmup,
      repsText: repsText ?? this.repsText,
      repsMin: repsMin ?? this.repsMin,
      repsMax: repsMax ?? this.repsMax,
      restSec: restSec ?? this.restSec,
      tip: tip ?? this.tip,
      fixedSets: fixedSets ?? this.fixedSets,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (logType.present) {
      map['log_type'] = Variable<String>(
        $TemplateExercisesTable.$converterlogType.toSql(logType.value),
      );
    }
    if (isWarmup.present) {
      map['is_warmup'] = Variable<bool>(isWarmup.value);
    }
    if (repsText.present) {
      map['reps_text'] = Variable<String>(repsText.value);
    }
    if (repsMin.present) {
      map['reps_min'] = Variable<int>(repsMin.value);
    }
    if (repsMax.present) {
      map['reps_max'] = Variable<int>(repsMax.value);
    }
    if (restSec.present) {
      map['rest_sec'] = Variable<int>(restSec.value);
    }
    if (tip.present) {
      map['tip'] = Variable<String>(tip.value);
    }
    if (fixedSets.present) {
      map['fixed_sets'] = Variable<int>(fixedSets.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExercisesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('logType: $logType, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('repsText: $repsText, ')
          ..write('repsMin: $repsMin, ')
          ..write('repsMax: $repsMax, ')
          ..write('restSec: $restSec, ')
          ..write('tip: $tip, ')
          ..write('fixedSets: $fixedSets')
          ..write(')'))
        .toString();
  }
}

class $ScheduleDaysTable extends ScheduleDays
    with TableInfo<$ScheduleDaysTable, ScheduleDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleDaysTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES blocks (id)',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DayKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DayKind>($ScheduleDaysTable.$converterkind);
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    blockId,
    weekday,
    kind,
    templateId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      kind: $ScheduleDaysTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      ),
    );
  }

  @override
  $ScheduleDaysTable createAlias(String alias) {
    return $ScheduleDaysTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DayKind, String, String> $converterkind =
      const EnumNameConverter<DayKind>(DayKind.values);
}

class ScheduleDay extends DataClass implements Insertable<ScheduleDay> {
  final int id;
  final int blockId;
  final int weekday;
  final DayKind kind;
  final int? templateId;
  const ScheduleDay({
    required this.id,
    required this.blockId,
    required this.weekday,
    required this.kind,
    this.templateId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_id'] = Variable<int>(blockId);
    map['weekday'] = Variable<int>(weekday);
    {
      map['kind'] = Variable<String>(
        $ScheduleDaysTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    return map;
  }

  ScheduleDaysCompanion toCompanion(bool nullToAbsent) {
    return ScheduleDaysCompanion(
      id: Value(id),
      blockId: Value(blockId),
      weekday: Value(weekday),
      kind: Value(kind),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
    );
  }

  factory ScheduleDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleDay(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int>(json['blockId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      kind: $ScheduleDaysTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      templateId: serializer.fromJson<int?>(json['templateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int>(blockId),
      'weekday': serializer.toJson<int>(weekday),
      'kind': serializer.toJson<String>(
        $ScheduleDaysTable.$converterkind.toJson(kind),
      ),
      'templateId': serializer.toJson<int?>(templateId),
    };
  }

  ScheduleDay copyWith({
    int? id,
    int? blockId,
    int? weekday,
    DayKind? kind,
    Value<int?> templateId = const Value.absent(),
  }) => ScheduleDay(
    id: id ?? this.id,
    blockId: blockId ?? this.blockId,
    weekday: weekday ?? this.weekday,
    kind: kind ?? this.kind,
    templateId: templateId.present ? templateId.value : this.templateId,
  );
  ScheduleDay copyWithCompanion(ScheduleDaysCompanion data) {
    return ScheduleDay(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      kind: data.kind.present ? data.kind.value : this.kind,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleDay(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekday: $weekday, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, blockId, weekday, kind, templateId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleDay &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.weekday == this.weekday &&
          other.kind == this.kind &&
          other.templateId == this.templateId);
}

class ScheduleDaysCompanion extends UpdateCompanion<ScheduleDay> {
  final Value<int> id;
  final Value<int> blockId;
  final Value<int> weekday;
  final Value<DayKind> kind;
  final Value<int?> templateId;
  const ScheduleDaysCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.kind = const Value.absent(),
    this.templateId = const Value.absent(),
  });
  ScheduleDaysCompanion.insert({
    this.id = const Value.absent(),
    required int blockId,
    required int weekday,
    required DayKind kind,
    this.templateId = const Value.absent(),
  }) : blockId = Value(blockId),
       weekday = Value(weekday),
       kind = Value(kind);
  static Insertable<ScheduleDay> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<int>? weekday,
    Expression<String>? kind,
    Expression<int>? templateId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (weekday != null) 'weekday': weekday,
      if (kind != null) 'kind': kind,
      if (templateId != null) 'template_id': templateId,
    });
  }

  ScheduleDaysCompanion copyWith({
    Value<int>? id,
    Value<int>? blockId,
    Value<int>? weekday,
    Value<DayKind>? kind,
    Value<int?>? templateId,
  }) {
    return ScheduleDaysCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      weekday: weekday ?? this.weekday,
      kind: kind ?? this.kind,
      templateId: templateId ?? this.templateId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ScheduleDaysTable.$converterkind.toSql(kind.value),
      );
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleDaysCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekday: $weekday, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId')
          ..write(')'))
        .toString();
  }
}

class $PlannedSessionsTable extends PlannedSessions
    with TableInfo<$PlannedSessionsTable, PlannedSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES blocks (id)',
    ),
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  late final GeneratedColumnWithTypeConverter<DayKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DayKind>($PlannedSessionsTable.$converterkind);
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    blockId,
    weekNumber,
    date,
    kind,
    templateId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      )!,
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      kind: $PlannedSessionsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      ),
    );
  }

  @override
  $PlannedSessionsTable createAlias(String alias) {
    return $PlannedSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DayKind, String, String> $converterkind =
      const EnumNameConverter<DayKind>(DayKind.values);
}

class PlannedSession extends DataClass implements Insertable<PlannedSession> {
  final int id;
  final int blockId;
  final int weekNumber;
  final DateTime date;
  final DayKind kind;
  final int? templateId;
  const PlannedSession({
    required this.id,
    required this.blockId,
    required this.weekNumber,
    required this.date,
    required this.kind,
    this.templateId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_id'] = Variable<int>(blockId);
    map['week_number'] = Variable<int>(weekNumber);
    map['date'] = Variable<DateTime>(date);
    {
      map['kind'] = Variable<String>(
        $PlannedSessionsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    return map;
  }

  PlannedSessionsCompanion toCompanion(bool nullToAbsent) {
    return PlannedSessionsCompanion(
      id: Value(id),
      blockId: Value(blockId),
      weekNumber: Value(weekNumber),
      date: Value(date),
      kind: Value(kind),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
    );
  }

  factory PlannedSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedSession(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int>(json['blockId']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      kind: $PlannedSessionsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      templateId: serializer.fromJson<int?>(json['templateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int>(blockId),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'date': serializer.toJson<DateTime>(date),
      'kind': serializer.toJson<String>(
        $PlannedSessionsTable.$converterkind.toJson(kind),
      ),
      'templateId': serializer.toJson<int?>(templateId),
    };
  }

  PlannedSession copyWith({
    int? id,
    int? blockId,
    int? weekNumber,
    DateTime? date,
    DayKind? kind,
    Value<int?> templateId = const Value.absent(),
  }) => PlannedSession(
    id: id ?? this.id,
    blockId: blockId ?? this.blockId,
    weekNumber: weekNumber ?? this.weekNumber,
    date: date ?? this.date,
    kind: kind ?? this.kind,
    templateId: templateId.present ? templateId.value : this.templateId,
  );
  PlannedSession copyWithCompanion(PlannedSessionsCompanion data) {
    return PlannedSession(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
      date: data.date.present ? data.date.value : this.date,
      kind: data.kind.present ? data.kind.value : this.kind,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedSession(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, blockId, weekNumber, date, kind, templateId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedSession &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.weekNumber == this.weekNumber &&
          other.date == this.date &&
          other.kind == this.kind &&
          other.templateId == this.templateId);
}

class PlannedSessionsCompanion extends UpdateCompanion<PlannedSession> {
  final Value<int> id;
  final Value<int> blockId;
  final Value<int> weekNumber;
  final Value<DateTime> date;
  final Value<DayKind> kind;
  final Value<int?> templateId;
  const PlannedSessionsCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.kind = const Value.absent(),
    this.templateId = const Value.absent(),
  });
  PlannedSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int blockId,
    required int weekNumber,
    required DateTime date,
    required DayKind kind,
    this.templateId = const Value.absent(),
  }) : blockId = Value(blockId),
       weekNumber = Value(weekNumber),
       date = Value(date),
       kind = Value(kind);
  static Insertable<PlannedSession> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<int>? weekNumber,
    Expression<DateTime>? date,
    Expression<String>? kind,
    Expression<int>? templateId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (date != null) 'date': date,
      if (kind != null) 'kind': kind,
      if (templateId != null) 'template_id': templateId,
    });
  }

  PlannedSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? blockId,
    Value<int>? weekNumber,
    Value<DateTime>? date,
    Value<DayKind>? kind,
    Value<int?>? templateId,
  }) {
    return PlannedSessionsCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      weekNumber: weekNumber ?? this.weekNumber,
      date: date ?? this.date,
      kind: kind ?? this.kind,
      templateId: templateId ?? this.templateId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PlannedSessionsTable.$converterkind.toSql(kind.value),
      );
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedSessionsCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _templateNameMeta = const VerificationMeta(
    'templateName',
  );
  @override
  late final GeneratedColumn<String> templateName = GeneratedColumn<String>(
    'template_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planJsonMeta = const VerificationMeta(
    'planJson',
  );
  @override
  late final GeneratedColumn<String> planJson = GeneratedColumn<String>(
    'plan_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionStatus>($SessionsTable.$converterstatus);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cursorExerciseMeta = const VerificationMeta(
    'cursorExercise',
  );
  @override
  late final GeneratedColumn<int> cursorExercise = GeneratedColumn<int>(
    'cursor_exercise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cursorSetMeta = const VerificationMeta(
    'cursorSet',
  );
  @override
  late final GeneratedColumn<int> cursorSet = GeneratedColumn<int>(
    'cursor_set',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSetAtMeta = const VerificationMeta(
    'lastSetAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSetAt = GeneratedColumn<DateTime>(
    'last_set_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restEndsAtMeta = const VerificationMeta(
    'restEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> restEndsAt = GeneratedColumn<DateTime>(
    'rest_ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    blockId,
    templateId,
    templateName,
    weekNumber,
    planJson,
    status,
    startedAt,
    endedAt,
    cursorExercise,
    cursorSet,
    lastSetAt,
    restEndsAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('template_name')) {
      context.handle(
        _templateNameMeta,
        templateName.isAcceptableOrUnknown(
          data['template_name']!,
          _templateNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateNameMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
      );
    }
    if (data.containsKey('plan_json')) {
      context.handle(
        _planJsonMeta,
        planJson.isAcceptableOrUnknown(data['plan_json']!, _planJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_planJsonMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('cursor_exercise')) {
      context.handle(
        _cursorExerciseMeta,
        cursorExercise.isAcceptableOrUnknown(
          data['cursor_exercise']!,
          _cursorExerciseMeta,
        ),
      );
    }
    if (data.containsKey('cursor_set')) {
      context.handle(
        _cursorSetMeta,
        cursorSet.isAcceptableOrUnknown(data['cursor_set']!, _cursorSetMeta),
      );
    }
    if (data.containsKey('last_set_at')) {
      context.handle(
        _lastSetAtMeta,
        lastSetAt.isAcceptableOrUnknown(data['last_set_at']!, _lastSetAtMeta),
      );
    }
    if (data.containsKey('rest_ends_at')) {
      context.handle(
        _restEndsAtMeta,
        restEndsAt.isAcceptableOrUnknown(
          data['rest_ends_at']!,
          _restEndsAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      ),
      templateName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_name'],
      )!,
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      ),
      planJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_json'],
      )!,
      status: $SessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      cursorExercise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cursor_exercise'],
      )!,
      cursorSet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cursor_set'],
      )!,
      lastSetAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_set_at'],
      ),
      restEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rest_ends_at'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SessionStatus, String, String> $converterstatus =
      const EnumNameConverter<SessionStatus>(SessionStatus.values);
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int? blockId;
  final int? templateId;
  final String templateName;
  final int? weekNumber;

  /// Snapshot JSON do plano (exercícios × séries) no momento do início.
  final String planJson;
  final SessionStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int cursorExercise;
  final int cursorSet;
  final DateTime? lastSetAt;
  final DateTime? restEndsAt;
  const Session({
    required this.id,
    this.blockId,
    this.templateId,
    required this.templateName,
    this.weekNumber,
    required this.planJson,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.cursorExercise,
    required this.cursorSet,
    this.lastSetAt,
    this.restEndsAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || blockId != null) {
      map['block_id'] = Variable<int>(blockId);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    map['template_name'] = Variable<String>(templateName);
    if (!nullToAbsent || weekNumber != null) {
      map['week_number'] = Variable<int>(weekNumber);
    }
    map['plan_json'] = Variable<String>(planJson);
    {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['cursor_exercise'] = Variable<int>(cursorExercise);
    map['cursor_set'] = Variable<int>(cursorSet);
    if (!nullToAbsent || lastSetAt != null) {
      map['last_set_at'] = Variable<DateTime>(lastSetAt);
    }
    if (!nullToAbsent || restEndsAt != null) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      blockId: blockId == null && nullToAbsent
          ? const Value.absent()
          : Value(blockId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      templateName: Value(templateName),
      weekNumber: weekNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(weekNumber),
      planJson: Value(planJson),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      cursorExercise: Value(cursorExercise),
      cursorSet: Value(cursorSet),
      lastSetAt: lastSetAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSetAt),
      restEndsAt: restEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restEndsAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int?>(json['blockId']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      templateName: serializer.fromJson<String>(json['templateName']),
      weekNumber: serializer.fromJson<int?>(json['weekNumber']),
      planJson: serializer.fromJson<String>(json['planJson']),
      status: $SessionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      cursorExercise: serializer.fromJson<int>(json['cursorExercise']),
      cursorSet: serializer.fromJson<int>(json['cursorSet']),
      lastSetAt: serializer.fromJson<DateTime?>(json['lastSetAt']),
      restEndsAt: serializer.fromJson<DateTime?>(json['restEndsAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int?>(blockId),
      'templateId': serializer.toJson<int?>(templateId),
      'templateName': serializer.toJson<String>(templateName),
      'weekNumber': serializer.toJson<int?>(weekNumber),
      'planJson': serializer.toJson<String>(planJson),
      'status': serializer.toJson<String>(
        $SessionsTable.$converterstatus.toJson(status),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'cursorExercise': serializer.toJson<int>(cursorExercise),
      'cursorSet': serializer.toJson<int>(cursorSet),
      'lastSetAt': serializer.toJson<DateTime?>(lastSetAt),
      'restEndsAt': serializer.toJson<DateTime?>(restEndsAt),
    };
  }

  Session copyWith({
    int? id,
    Value<int?> blockId = const Value.absent(),
    Value<int?> templateId = const Value.absent(),
    String? templateName,
    Value<int?> weekNumber = const Value.absent(),
    String? planJson,
    SessionStatus? status,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? cursorExercise,
    int? cursorSet,
    Value<DateTime?> lastSetAt = const Value.absent(),
    Value<DateTime?> restEndsAt = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    blockId: blockId.present ? blockId.value : this.blockId,
    templateId: templateId.present ? templateId.value : this.templateId,
    templateName: templateName ?? this.templateName,
    weekNumber: weekNumber.present ? weekNumber.value : this.weekNumber,
    planJson: planJson ?? this.planJson,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    cursorExercise: cursorExercise ?? this.cursorExercise,
    cursorSet: cursorSet ?? this.cursorSet,
    lastSetAt: lastSetAt.present ? lastSetAt.value : this.lastSetAt,
    restEndsAt: restEndsAt.present ? restEndsAt.value : this.restEndsAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      templateName: data.templateName.present
          ? data.templateName.value
          : this.templateName,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
      planJson: data.planJson.present ? data.planJson.value : this.planJson,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      cursorExercise: data.cursorExercise.present
          ? data.cursorExercise.value
          : this.cursorExercise,
      cursorSet: data.cursorSet.present ? data.cursorSet.value : this.cursorSet,
      lastSetAt: data.lastSetAt.present ? data.lastSetAt.value : this.lastSetAt,
      restEndsAt: data.restEndsAt.present
          ? data.restEndsAt.value
          : this.restEndsAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('templateId: $templateId, ')
          ..write('templateName: $templateName, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('planJson: $planJson, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('cursorExercise: $cursorExercise, ')
          ..write('cursorSet: $cursorSet, ')
          ..write('lastSetAt: $lastSetAt, ')
          ..write('restEndsAt: $restEndsAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    blockId,
    templateId,
    templateName,
    weekNumber,
    planJson,
    status,
    startedAt,
    endedAt,
    cursorExercise,
    cursorSet,
    lastSetAt,
    restEndsAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.templateId == this.templateId &&
          other.templateName == this.templateName &&
          other.weekNumber == this.weekNumber &&
          other.planJson == this.planJson &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.cursorExercise == this.cursorExercise &&
          other.cursorSet == this.cursorSet &&
          other.lastSetAt == this.lastSetAt &&
          other.restEndsAt == this.restEndsAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int?> blockId;
  final Value<int?> templateId;
  final Value<String> templateName;
  final Value<int?> weekNumber;
  final Value<String> planJson;
  final Value<SessionStatus> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> cursorExercise;
  final Value<int> cursorSet;
  final Value<DateTime?> lastSetAt;
  final Value<DateTime?> restEndsAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateName = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.planJson = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.cursorExercise = const Value.absent(),
    this.cursorSet = const Value.absent(),
    this.lastSetAt = const Value.absent(),
    this.restEndsAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.templateId = const Value.absent(),
    required String templateName,
    this.weekNumber = const Value.absent(),
    required String planJson,
    required SessionStatus status,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.cursorExercise = const Value.absent(),
    this.cursorSet = const Value.absent(),
    this.lastSetAt = const Value.absent(),
    this.restEndsAt = const Value.absent(),
  }) : templateName = Value(templateName),
       planJson = Value(planJson),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<int>? templateId,
    Expression<String>? templateName,
    Expression<int>? weekNumber,
    Expression<String>? planJson,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? cursorExercise,
    Expression<int>? cursorSet,
    Expression<DateTime>? lastSetAt,
    Expression<DateTime>? restEndsAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (templateId != null) 'template_id': templateId,
      if (templateName != null) 'template_name': templateName,
      if (weekNumber != null) 'week_number': weekNumber,
      if (planJson != null) 'plan_json': planJson,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (cursorExercise != null) 'cursor_exercise': cursorExercise,
      if (cursorSet != null) 'cursor_set': cursorSet,
      if (lastSetAt != null) 'last_set_at': lastSetAt,
      if (restEndsAt != null) 'rest_ends_at': restEndsAt,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int?>? blockId,
    Value<int?>? templateId,
    Value<String>? templateName,
    Value<int?>? weekNumber,
    Value<String>? planJson,
    Value<SessionStatus>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? cursorExercise,
    Value<int>? cursorSet,
    Value<DateTime?>? lastSetAt,
    Value<DateTime?>? restEndsAt,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      weekNumber: weekNumber ?? this.weekNumber,
      planJson: planJson ?? this.planJson,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      cursorExercise: cursorExercise ?? this.cursorExercise,
      cursorSet: cursorSet ?? this.cursorSet,
      lastSetAt: lastSetAt ?? this.lastSetAt,
      restEndsAt: restEndsAt ?? this.restEndsAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (templateName.present) {
      map['template_name'] = Variable<String>(templateName.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (planJson.present) {
      map['plan_json'] = Variable<String>(planJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (cursorExercise.present) {
      map['cursor_exercise'] = Variable<int>(cursorExercise.value);
    }
    if (cursorSet.present) {
      map['cursor_set'] = Variable<int>(cursorSet.value);
    }
    if (lastSetAt.present) {
      map['last_set_at'] = Variable<DateTime>(lastSetAt.value);
    }
    if (restEndsAt.present) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('templateId: $templateId, ')
          ..write('templateName: $templateName, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('planJson: $planJson, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('cursorExercise: $cursorExercise, ')
          ..write('cursorSet: $cursorSet, ')
          ..write('lastSetAt: $lastSetAt, ')
          ..write('restEndsAt: $restEndsAt')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIndexMeta = const VerificationMeta(
    'exerciseIndex',
  );
  @override
  late final GeneratedColumn<int> exerciseIndex = GeneratedColumn<int>(
    'exercise_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loadKgMeta = const VerificationMeta('loadKg');
  @override
  late final GeneratedColumn<double> loadKg = GeneratedColumn<double>(
    'load_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<double> distanceM = GeneratedColumn<double>(
    'distance_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWarmupMeta = const VerificationMeta(
    'isWarmup',
  );
  @override
  late final GeneratedColumn<bool> isWarmup = GeneratedColumn<bool>(
    'is_warmup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_warmup" IN (0, 1))',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    exerciseIndex,
    setIndex,
    loadKg,
    reps,
    distanceM,
    durationSec,
    isWarmup,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('exercise_index')) {
      context.handle(
        _exerciseIndexMeta,
        exerciseIndex.isAcceptableOrUnknown(
          data['exercise_index']!,
          _exerciseIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseIndexMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('load_kg')) {
      context.handle(
        _loadKgMeta,
        loadKg.isAcceptableOrUnknown(data['load_kg']!, _loadKgMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('is_warmup')) {
      context.handle(
        _isWarmupMeta,
        isWarmup.isAcceptableOrUnknown(data['is_warmup']!, _isWarmupMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      exerciseIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_index'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      loadKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_kg'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_m'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      ),
      isWarmup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_warmup'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLog extends DataClass implements Insertable<SetLog> {
  final int id;
  final int sessionId;
  final int exerciseId;

  /// Posição do exercício no plano da sessão.
  final int exerciseIndex;
  final int setIndex;
  final double? loadKg;
  final int? reps;
  final double? distanceM;
  final int? durationSec;
  final bool isWarmup;
  final DateTime createdAt;
  const SetLog({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseIndex,
    required this.setIndex,
    this.loadKg,
    this.reps,
    this.distanceM,
    this.durationSec,
    required this.isWarmup,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['exercise_index'] = Variable<int>(exerciseIndex);
    map['set_index'] = Variable<int>(setIndex);
    if (!nullToAbsent || loadKg != null) {
      map['load_kg'] = Variable<double>(loadKg);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || distanceM != null) {
      map['distance_m'] = Variable<double>(distanceM);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    map['is_warmup'] = Variable<bool>(isWarmup);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      exerciseIndex: Value(exerciseIndex),
      setIndex: Value(setIndex),
      loadKg: loadKg == null && nullToAbsent
          ? const Value.absent()
          : Value(loadKg),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      distanceM: distanceM == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceM),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      isWarmup: Value(isWarmup),
      createdAt: Value(createdAt),
    );
  }

  factory SetLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      exerciseIndex: serializer.fromJson<int>(json['exerciseIndex']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      loadKg: serializer.fromJson<double?>(json['loadKg']),
      reps: serializer.fromJson<int?>(json['reps']),
      distanceM: serializer.fromJson<double?>(json['distanceM']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      isWarmup: serializer.fromJson<bool>(json['isWarmup']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'exerciseIndex': serializer.toJson<int>(exerciseIndex),
      'setIndex': serializer.toJson<int>(setIndex),
      'loadKg': serializer.toJson<double?>(loadKg),
      'reps': serializer.toJson<int?>(reps),
      'distanceM': serializer.toJson<double?>(distanceM),
      'durationSec': serializer.toJson<int?>(durationSec),
      'isWarmup': serializer.toJson<bool>(isWarmup),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SetLog copyWith({
    int? id,
    int? sessionId,
    int? exerciseId,
    int? exerciseIndex,
    int? setIndex,
    Value<double?> loadKg = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<double?> distanceM = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    bool? isWarmup,
    DateTime? createdAt,
  }) => SetLog(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    exerciseIndex: exerciseIndex ?? this.exerciseIndex,
    setIndex: setIndex ?? this.setIndex,
    loadKg: loadKg.present ? loadKg.value : this.loadKg,
    reps: reps.present ? reps.value : this.reps,
    distanceM: distanceM.present ? distanceM.value : this.distanceM,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    isWarmup: isWarmup ?? this.isWarmup,
    createdAt: createdAt ?? this.createdAt,
  );
  SetLog copyWithCompanion(SetLogsCompanion data) {
    return SetLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      exerciseIndex: data.exerciseIndex.present
          ? data.exerciseIndex.value
          : this.exerciseIndex,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      loadKg: data.loadKg.present ? data.loadKg.value : this.loadKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      isWarmup: data.isWarmup.present ? data.isWarmup.value : this.isWarmup,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseIndex: $exerciseIndex, ')
          ..write('setIndex: $setIndex, ')
          ..write('loadKg: $loadKg, ')
          ..write('reps: $reps, ')
          ..write('distanceM: $distanceM, ')
          ..write('durationSec: $durationSec, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    exerciseIndex,
    setIndex,
    loadKg,
    reps,
    distanceM,
    durationSec,
    isWarmup,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.exerciseIndex == this.exerciseIndex &&
          other.setIndex == this.setIndex &&
          other.loadKg == this.loadKg &&
          other.reps == this.reps &&
          other.distanceM == this.distanceM &&
          other.durationSec == this.durationSec &&
          other.isWarmup == this.isWarmup &&
          other.createdAt == this.createdAt);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> exerciseId;
  final Value<int> exerciseIndex;
  final Value<int> setIndex;
  final Value<double?> loadKg;
  final Value<int?> reps;
  final Value<double?> distanceM;
  final Value<int?> durationSec;
  final Value<bool> isWarmup;
  final Value<DateTime> createdAt;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.exerciseIndex = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.loadKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int exerciseId,
    required int exerciseIndex,
    required int setIndex,
    this.loadKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.isWarmup = const Value.absent(),
    required DateTime createdAt,
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       exerciseIndex = Value(exerciseIndex),
       setIndex = Value(setIndex),
       createdAt = Value(createdAt);
  static Insertable<SetLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? exerciseId,
    Expression<int>? exerciseIndex,
    Expression<int>? setIndex,
    Expression<double>? loadKg,
    Expression<int>? reps,
    Expression<double>? distanceM,
    Expression<int>? durationSec,
    Expression<bool>? isWarmup,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (exerciseIndex != null) 'exercise_index': exerciseIndex,
      if (setIndex != null) 'set_index': setIndex,
      if (loadKg != null) 'load_kg': loadKg,
      if (reps != null) 'reps': reps,
      if (distanceM != null) 'distance_m': distanceM,
      if (durationSec != null) 'duration_sec': durationSec,
      if (isWarmup != null) 'is_warmup': isWarmup,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SetLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? exerciseId,
    Value<int>? exerciseIndex,
    Value<int>? setIndex,
    Value<double?>? loadKg,
    Value<int?>? reps,
    Value<double?>? distanceM,
    Value<int?>? durationSec,
    Value<bool>? isWarmup,
    Value<DateTime>? createdAt,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseIndex: exerciseIndex ?? this.exerciseIndex,
      setIndex: setIndex ?? this.setIndex,
      loadKg: loadKg ?? this.loadKg,
      reps: reps ?? this.reps,
      distanceM: distanceM ?? this.distanceM,
      durationSec: durationSec ?? this.durationSec,
      isWarmup: isWarmup ?? this.isWarmup,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (exerciseIndex.present) {
      map['exercise_index'] = Variable<int>(exerciseIndex.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (loadKg.present) {
      map['load_kg'] = Variable<double>(loadKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<double>(distanceM.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (isWarmup.present) {
      map['is_warmup'] = Variable<bool>(isWarmup.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseIndex: $exerciseIndex, ')
          ..write('setIndex: $setIndex, ')
          ..write('loadKg: $loadKg, ')
          ..write('reps: $reps, ')
          ..write('distanceM: $distanceM, ')
          ..write('durationSec: $durationSec, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CardioLogsTable extends CardioLogs
    with TableInfo<$CardioLogsTable, CardioLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardioLogsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<CardioType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CardioType>($CardioLogsTable.$convertertype);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kmMeta = const VerificationMeta('km');
  @override
  late final GeneratedColumn<double> km = GeneratedColumn<double>(
    'km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paceSecPerKmMeta = const VerificationMeta(
    'paceSecPerKm',
  );
  @override
  late final GeneratedColumn<int> paceSecPerKm = GeneratedColumn<int>(
    'pace_sec_per_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<int> rpe = GeneratedColumn<int>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    date,
    km,
    durationSec,
    paceSecPerKm,
    rpe,
    notes,
    blockId,
    weekNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cardio_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardioLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('km')) {
      context.handle(_kmMeta, km.isAcceptableOrUnknown(data['km']!, _kmMeta));
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecMeta);
    }
    if (data.containsKey('pace_sec_per_km')) {
      context.handle(
        _paceSecPerKmMeta,
        paceSecPerKm.isAcceptableOrUnknown(
          data['pace_sec_per_km']!,
          _paceSecPerKmMeta,
        ),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardioLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardioLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $CardioLogsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      km: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}km'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      )!,
      paceSecPerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pace_sec_per_km'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rpe'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      ),
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      ),
    );
  }

  @override
  $CardioLogsTable createAlias(String alias) {
    return $CardioLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CardioType, String, String> $convertertype =
      const EnumNameConverter<CardioType>(CardioType.values);
}

class CardioLog extends DataClass implements Insertable<CardioLog> {
  final int id;
  final CardioType type;
  final DateTime date;
  final double? km;
  final int durationSec;
  final int? paceSecPerKm;
  final int? rpe;
  final String? notes;
  final int? blockId;
  final int? weekNumber;
  const CardioLog({
    required this.id,
    required this.type,
    required this.date,
    this.km,
    required this.durationSec,
    this.paceSecPerKm,
    this.rpe,
    this.notes,
    this.blockId,
    this.weekNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>(
        $CardioLogsTable.$convertertype.toSql(type),
      );
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || km != null) {
      map['km'] = Variable<double>(km);
    }
    map['duration_sec'] = Variable<int>(durationSec);
    if (!nullToAbsent || paceSecPerKm != null) {
      map['pace_sec_per_km'] = Variable<int>(paceSecPerKm);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<int>(rpe);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || blockId != null) {
      map['block_id'] = Variable<int>(blockId);
    }
    if (!nullToAbsent || weekNumber != null) {
      map['week_number'] = Variable<int>(weekNumber);
    }
    return map;
  }

  CardioLogsCompanion toCompanion(bool nullToAbsent) {
    return CardioLogsCompanion(
      id: Value(id),
      type: Value(type),
      date: Value(date),
      km: km == null && nullToAbsent ? const Value.absent() : Value(km),
      durationSec: Value(durationSec),
      paceSecPerKm: paceSecPerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(paceSecPerKm),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      blockId: blockId == null && nullToAbsent
          ? const Value.absent()
          : Value(blockId),
      weekNumber: weekNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(weekNumber),
    );
  }

  factory CardioLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardioLog(
      id: serializer.fromJson<int>(json['id']),
      type: $CardioLogsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      km: serializer.fromJson<double?>(json['km']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      paceSecPerKm: serializer.fromJson<int?>(json['paceSecPerKm']),
      rpe: serializer.fromJson<int?>(json['rpe']),
      notes: serializer.fromJson<String?>(json['notes']),
      blockId: serializer.fromJson<int?>(json['blockId']),
      weekNumber: serializer.fromJson<int?>(json['weekNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $CardioLogsTable.$convertertype.toJson(type),
      ),
      'date': serializer.toJson<DateTime>(date),
      'km': serializer.toJson<double?>(km),
      'durationSec': serializer.toJson<int>(durationSec),
      'paceSecPerKm': serializer.toJson<int?>(paceSecPerKm),
      'rpe': serializer.toJson<int?>(rpe),
      'notes': serializer.toJson<String?>(notes),
      'blockId': serializer.toJson<int?>(blockId),
      'weekNumber': serializer.toJson<int?>(weekNumber),
    };
  }

  CardioLog copyWith({
    int? id,
    CardioType? type,
    DateTime? date,
    Value<double?> km = const Value.absent(),
    int? durationSec,
    Value<int?> paceSecPerKm = const Value.absent(),
    Value<int?> rpe = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> blockId = const Value.absent(),
    Value<int?> weekNumber = const Value.absent(),
  }) => CardioLog(
    id: id ?? this.id,
    type: type ?? this.type,
    date: date ?? this.date,
    km: km.present ? km.value : this.km,
    durationSec: durationSec ?? this.durationSec,
    paceSecPerKm: paceSecPerKm.present ? paceSecPerKm.value : this.paceSecPerKm,
    rpe: rpe.present ? rpe.value : this.rpe,
    notes: notes.present ? notes.value : this.notes,
    blockId: blockId.present ? blockId.value : this.blockId,
    weekNumber: weekNumber.present ? weekNumber.value : this.weekNumber,
  );
  CardioLog copyWithCompanion(CardioLogsCompanion data) {
    return CardioLog(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      km: data.km.present ? data.km.value : this.km,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      paceSecPerKm: data.paceSecPerKm.present
          ? data.paceSecPerKm.value
          : this.paceSecPerKm,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      notes: data.notes.present ? data.notes.value : this.notes,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardioLog(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('km: $km, ')
          ..write('durationSec: $durationSec, ')
          ..write('paceSecPerKm: $paceSecPerKm, ')
          ..write('rpe: $rpe, ')
          ..write('notes: $notes, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    date,
    km,
    durationSec,
    paceSecPerKm,
    rpe,
    notes,
    blockId,
    weekNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardioLog &&
          other.id == this.id &&
          other.type == this.type &&
          other.date == this.date &&
          other.km == this.km &&
          other.durationSec == this.durationSec &&
          other.paceSecPerKm == this.paceSecPerKm &&
          other.rpe == this.rpe &&
          other.notes == this.notes &&
          other.blockId == this.blockId &&
          other.weekNumber == this.weekNumber);
}

class CardioLogsCompanion extends UpdateCompanion<CardioLog> {
  final Value<int> id;
  final Value<CardioType> type;
  final Value<DateTime> date;
  final Value<double?> km;
  final Value<int> durationSec;
  final Value<int?> paceSecPerKm;
  final Value<int?> rpe;
  final Value<String?> notes;
  final Value<int?> blockId;
  final Value<int?> weekNumber;
  const CardioLogsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.km = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.paceSecPerKm = const Value.absent(),
    this.rpe = const Value.absent(),
    this.notes = const Value.absent(),
    this.blockId = const Value.absent(),
    this.weekNumber = const Value.absent(),
  });
  CardioLogsCompanion.insert({
    this.id = const Value.absent(),
    required CardioType type,
    required DateTime date,
    this.km = const Value.absent(),
    required int durationSec,
    this.paceSecPerKm = const Value.absent(),
    this.rpe = const Value.absent(),
    this.notes = const Value.absent(),
    this.blockId = const Value.absent(),
    this.weekNumber = const Value.absent(),
  }) : type = Value(type),
       date = Value(date),
       durationSec = Value(durationSec);
  static Insertable<CardioLog> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<double>? km,
    Expression<int>? durationSec,
    Expression<int>? paceSecPerKm,
    Expression<int>? rpe,
    Expression<String>? notes,
    Expression<int>? blockId,
    Expression<int>? weekNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (km != null) 'km': km,
      if (durationSec != null) 'duration_sec': durationSec,
      if (paceSecPerKm != null) 'pace_sec_per_km': paceSecPerKm,
      if (rpe != null) 'rpe': rpe,
      if (notes != null) 'notes': notes,
      if (blockId != null) 'block_id': blockId,
      if (weekNumber != null) 'week_number': weekNumber,
    });
  }

  CardioLogsCompanion copyWith({
    Value<int>? id,
    Value<CardioType>? type,
    Value<DateTime>? date,
    Value<double?>? km,
    Value<int>? durationSec,
    Value<int?>? paceSecPerKm,
    Value<int?>? rpe,
    Value<String?>? notes,
    Value<int?>? blockId,
    Value<int?>? weekNumber,
  }) {
    return CardioLogsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      km: km ?? this.km,
      durationSec: durationSec ?? this.durationSec,
      paceSecPerKm: paceSecPerKm ?? this.paceSecPerKm,
      rpe: rpe ?? this.rpe,
      notes: notes ?? this.notes,
      blockId: blockId ?? this.blockId,
      weekNumber: weekNumber ?? this.weekNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $CardioLogsTable.$convertertype.toSql(type.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (km.present) {
      map['km'] = Variable<double>(km.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (paceSecPerKm.present) {
      map['pace_sec_per_km'] = Variable<int>(paceSecPerKm.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<int>(rpe.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardioLogsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('km: $km, ')
          ..write('durationSec: $durationSec, ')
          ..write('paceSecPerKm: $paceSecPerKm, ')
          ..write('rpe: $rpe, ')
          ..write('notes: $notes, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber')
          ..write(')'))
        .toString();
  }
}

class $AssessmentResultsTable extends AssessmentResults
    with TableInfo<$AssessmentResultsTable, AssessmentResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssessmentResultsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _testKeyMeta = const VerificationMeta(
    'testKey',
  );
  @override
  late final GeneratedColumn<String> testKey = GeneratedColumn<String>(
    'test_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    blockId,
    weekNumber,
    date,
    testKey,
    value,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessment_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssessmentResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
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
    if (data.containsKey('test_key')) {
      context.handle(
        _testKeyMeta,
        testKey.isAcceptableOrUnknown(data['test_key']!, _testKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_testKeyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssessmentResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssessmentResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      ),
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      testKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AssessmentResultsTable createAlias(String alias) {
    return $AssessmentResultsTable(attachedDatabase, alias);
  }
}

class AssessmentResult extends DataClass
    implements Insertable<AssessmentResult> {
  final int id;
  final int? blockId;
  final int? weekNumber;
  final DateTime date;
  final String testKey;
  final double value;
  const AssessmentResult({
    required this.id,
    this.blockId,
    this.weekNumber,
    required this.date,
    required this.testKey,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || blockId != null) {
      map['block_id'] = Variable<int>(blockId);
    }
    if (!nullToAbsent || weekNumber != null) {
      map['week_number'] = Variable<int>(weekNumber);
    }
    map['date'] = Variable<DateTime>(date);
    map['test_key'] = Variable<String>(testKey);
    map['value'] = Variable<double>(value);
    return map;
  }

  AssessmentResultsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentResultsCompanion(
      id: Value(id),
      blockId: blockId == null && nullToAbsent
          ? const Value.absent()
          : Value(blockId),
      weekNumber: weekNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(weekNumber),
      date: Value(date),
      testKey: Value(testKey),
      value: Value(value),
    );
  }

  factory AssessmentResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssessmentResult(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int?>(json['blockId']),
      weekNumber: serializer.fromJson<int?>(json['weekNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      testKey: serializer.fromJson<String>(json['testKey']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int?>(blockId),
      'weekNumber': serializer.toJson<int?>(weekNumber),
      'date': serializer.toJson<DateTime>(date),
      'testKey': serializer.toJson<String>(testKey),
      'value': serializer.toJson<double>(value),
    };
  }

  AssessmentResult copyWith({
    int? id,
    Value<int?> blockId = const Value.absent(),
    Value<int?> weekNumber = const Value.absent(),
    DateTime? date,
    String? testKey,
    double? value,
  }) => AssessmentResult(
    id: id ?? this.id,
    blockId: blockId.present ? blockId.value : this.blockId,
    weekNumber: weekNumber.present ? weekNumber.value : this.weekNumber,
    date: date ?? this.date,
    testKey: testKey ?? this.testKey,
    value: value ?? this.value,
  );
  AssessmentResult copyWithCompanion(AssessmentResultsCompanion data) {
    return AssessmentResult(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
      date: data.date.present ? data.date.value : this.date,
      testKey: data.testKey.present ? data.testKey.value : this.testKey,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentResult(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('date: $date, ')
          ..write('testKey: $testKey, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, blockId, weekNumber, date, testKey, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssessmentResult &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.weekNumber == this.weekNumber &&
          other.date == this.date &&
          other.testKey == this.testKey &&
          other.value == this.value);
}

class AssessmentResultsCompanion extends UpdateCompanion<AssessmentResult> {
  final Value<int> id;
  final Value<int?> blockId;
  final Value<int?> weekNumber;
  final Value<DateTime> date;
  final Value<String> testKey;
  final Value<double> value;
  const AssessmentResultsCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.testKey = const Value.absent(),
    this.value = const Value.absent(),
  });
  AssessmentResultsCompanion.insert({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    required DateTime date,
    required String testKey,
    required double value,
  }) : date = Value(date),
       testKey = Value(testKey),
       value = Value(value);
  static Insertable<AssessmentResult> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<int>? weekNumber,
    Expression<DateTime>? date,
    Expression<String>? testKey,
    Expression<double>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (date != null) 'date': date,
      if (testKey != null) 'test_key': testKey,
      if (value != null) 'value': value,
    });
  }

  AssessmentResultsCompanion copyWith({
    Value<int>? id,
    Value<int?>? blockId,
    Value<int?>? weekNumber,
    Value<DateTime>? date,
    Value<String>? testKey,
    Value<double>? value,
  }) {
    return AssessmentResultsCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      weekNumber: weekNumber ?? this.weekNumber,
      date: date ?? this.date,
      testKey: testKey ?? this.testKey,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (testKey.present) {
      map['test_key'] = Variable<String>(testKey.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentResultsCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('date: $date, ')
          ..write('testKey: $testKey, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $BlocksTable blocks = $BlocksTable(this);
  late final $BlockWeeksTable blockWeeks = $BlockWeeksTable(this);
  late final $WorkoutTemplatesTable workoutTemplates = $WorkoutTemplatesTable(
    this,
  );
  late final $TemplateExercisesTable templateExercises =
      $TemplateExercisesTable(this);
  late final $ScheduleDaysTable scheduleDays = $ScheduleDaysTable(this);
  late final $PlannedSessionsTable plannedSessions = $PlannedSessionsTable(
    this,
  );
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $CardioLogsTable cardioLogs = $CardioLogsTable(this);
  late final $AssessmentResultsTable assessmentResults =
      $AssessmentResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    blocks,
    blockWeeks,
    workoutTemplates,
    templateExercises,
    scheduleDays,
    plannedSessions,
    sessions,
    setLogs,
    cardioLogs,
    assessmentResults,
  ];
}

typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TemplateExercisesTable, List<TemplateExercise>>
  _templateExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.templateExercises,
        aliasName: 'exercises__id__template_exercises__exercise_id',
      );

  $$TemplateExercisesTableProcessedTableManager get templateExercisesRefs {
    final manager = $$TemplateExercisesTableTableManager(
      $_db,
      $_db.templateExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _templateExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  Expression<bool> templateExercisesRefs(
    Expression<bool> Function($$TemplateExercisesTableFilterComposer f) f,
  ) {
    final $$TemplateExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateExercisesTableFilterComposer(
            $db: $db,
            $table: $db.templateExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
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

  Expression<T> templateExercisesRefs<T extends Object>(
    Expression<T> Function($$TemplateExercisesTableAnnotationComposer a) f,
  ) {
    final $$TemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.templateExercises,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TemplateExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.templateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool templateExercisesRefs})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => ExercisesCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => ExercisesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (templateExercisesRefs) db.templateExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templateExercisesRefs)
                    await $_getPrefetchedDataByColumns<
                      Exercise,
                      $ExercisesTable,
                      TemplateExercise,
                      $TemplateExercisesTable
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._templateExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExercisesTableReferences(
                            db,
                            table,
                            p0,
                          ).templateExercisesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'exercise_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool templateExercisesRefs})
    >;
typedef $$BlocksTableCreateCompanionBuilder = BlocksCompanion Function({
  Value<int> id,
  required String name,
  required DateTime startDate,
  required int weeks,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$BlocksTableUpdateCompanionBuilder = BlocksCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> startDate,
  Value<int> weeks,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$BlocksTableReferences
    extends BaseReferences<_$AppDatabase, $BlocksTable, Block> {
  $$BlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BlockWeeksTable, List<BlockWeek>>
  _blockWeeksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.blockWeeks,
    aliasName: 'blocks__id__block_weeks__block_id',
  );

  $$BlockWeeksTableProcessedTableManager get blockWeeksRefs {
    final manager = $$BlockWeeksTableTableManager(
      $_db,
      $_db.blockWeeks,
    ).filter((f) => f.blockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blockWeeksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutTemplatesTable, List<WorkoutTemplate>>
  _workoutTemplatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutTemplates,
    aliasName: 'blocks__id__workout_templates__block_id',
  );

  $$WorkoutTemplatesTableProcessedTableManager get workoutTemplatesRefs {
    final manager = $$WorkoutTemplatesTableTableManager(
      $_db,
      $_db.workoutTemplates,
    ).filter((f) => f.blockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutTemplatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScheduleDaysTable, List<ScheduleDay>>
  _scheduleDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduleDays,
    aliasName: 'blocks__id__schedule_days__block_id',
  );

  $$ScheduleDaysTableProcessedTableManager get scheduleDaysRefs {
    final manager = $$ScheduleDaysTableTableManager(
      $_db,
      $_db.scheduleDays,
    ).filter((f) => f.blockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_scheduleDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlannedSessionsTable, List<PlannedSession>>
  _plannedSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedSessions,
    aliasName: 'blocks__id__planned_sessions__block_id',
  );

  $$PlannedSessionsTableProcessedTableManager get plannedSessionsRefs {
    final manager = $$PlannedSessionsTableTableManager(
      $_db,
      $_db.plannedSessions,
    ).filter((f) => f.blockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _plannedSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BlocksTableFilterComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableFilterComposer({
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

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeks => $composableBuilder(
    column: $table.weeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> blockWeeksRefs(
    Expression<bool> Function($$BlockWeeksTableFilterComposer f) f,
  ) {
    final $$BlockWeeksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockWeeks,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockWeeksTableFilterComposer(
            $db: $db,
            $table: $db.blockWeeks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutTemplatesRefs(
    Expression<bool> Function($$WorkoutTemplatesTableFilterComposer f) f,
  ) {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scheduleDaysRefs(
    Expression<bool> Function($$ScheduleDaysTableFilterComposer f) f,
  ) {
    final $$ScheduleDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleDays,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleDaysTableFilterComposer(
            $db: $db,
            $table: $db.scheduleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> plannedSessionsRefs(
    Expression<bool> Function($$PlannedSessionsTableFilterComposer f) f,
  ) {
    final $$PlannedSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedSessions,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedSessionsTableFilterComposer(
            $db: $db,
            $table: $db.plannedSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeks => $composableBuilder(
    column: $table.weeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get weeks =>
      $composableBuilder(column: $table.weeks, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> blockWeeksRefs<T extends Object>(
    Expression<T> Function($$BlockWeeksTableAnnotationComposer a) f,
  ) {
    final $$BlockWeeksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockWeeks,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockWeeksTableAnnotationComposer(
            $db: $db,
            $table: $db.blockWeeks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutTemplatesRefs<T extends Object>(
    Expression<T> Function($$WorkoutTemplatesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scheduleDaysRefs<T extends Object>(
    Expression<T> Function($$ScheduleDaysTableAnnotationComposer a) f,
  ) {
    final $$ScheduleDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleDays,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> plannedSessionsRefs<T extends Object>(
    Expression<T> Function($$PlannedSessionsTableAnnotationComposer a) f,
  ) {
    final $$PlannedSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedSessions,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.plannedSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlocksTable,
          Block,
          $$BlocksTableFilterComposer,
          $$BlocksTableOrderingComposer,
          $$BlocksTableAnnotationComposer,
          $$BlocksTableCreateCompanionBuilder,
          $$BlocksTableUpdateCompanionBuilder,
          (Block, $$BlocksTableReferences),
          Block,
          PrefetchHooks Function({
            bool blockWeeksRefs,
            bool workoutTemplatesRefs,
            bool scheduleDaysRefs,
            bool plannedSessionsRefs,
          })
        > {
  $$BlocksTableTableManager(_$AppDatabase db, $BlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> weeks = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BlocksCompanion(
                id: id,
                name: name,
                startDate: startDate,
                weeks: weeks,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime startDate,
                required int weeks,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BlocksCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                weeks: weeks,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BlocksTable, Block>(table),
                  $$BlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                blockWeeksRefs = false,
                workoutTemplatesRefs = false,
                scheduleDaysRefs = false,
                plannedSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (blockWeeksRefs) db.blockWeeks,
                    if (workoutTemplatesRefs) db.workoutTemplates,
                    if (scheduleDaysRefs) db.scheduleDays,
                    if (plannedSessionsRefs) db.plannedSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (blockWeeksRefs)
                        await $_getPrefetchedDataByColumns<
                          Block,
                          $BlocksTable,
                          BlockWeek,
                          $BlockWeeksTable
                        >(
                          currentTable: table,
                          referencedTable: $$BlocksTableReferences
                              ._blockWeeksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BlocksTableReferences(
                                db,
                                table,
                                p0,
                              ).blockWeeksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'block_id',
                          typedResults: items,
                        ),
                      if (workoutTemplatesRefs)
                        await $_getPrefetchedDataByColumns<
                          Block,
                          $BlocksTable,
                          WorkoutTemplate,
                          $WorkoutTemplatesTable
                        >(
                          currentTable: table,
                          referencedTable: $$BlocksTableReferences
                              ._workoutTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BlocksTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutTemplatesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'block_id',
                          typedResults: items,
                        ),
                      if (scheduleDaysRefs)
                        await $_getPrefetchedDataByColumns<
                          Block,
                          $BlocksTable,
                          ScheduleDay,
                          $ScheduleDaysTable
                        >(
                          currentTable: table,
                          referencedTable: $$BlocksTableReferences
                              ._scheduleDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BlocksTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleDaysRefs,
                          currentColumn: 'id',
                          referencedColumn: 'block_id',
                          typedResults: items,
                        ),
                      if (plannedSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Block,
                          $BlocksTable,
                          PlannedSession,
                          $PlannedSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BlocksTableReferences
                              ._plannedSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BlocksTableReferences(
                                db,
                                table,
                                p0,
                              ).plannedSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'block_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlocksTable,
      Block,
      $$BlocksTableFilterComposer,
      $$BlocksTableOrderingComposer,
      $$BlocksTableAnnotationComposer,
      $$BlocksTableCreateCompanionBuilder,
      $$BlocksTableUpdateCompanionBuilder,
      (Block, $$BlocksTableReferences),
      Block,
      PrefetchHooks Function({
        bool blockWeeksRefs,
        bool workoutTemplatesRefs,
        bool scheduleDaysRefs,
        bool plannedSessionsRefs,
      })
    >;
typedef $$BlockWeeksTableCreateCompanionBuilder = BlockWeeksCompanion Function({
  Value<int> id,
  required int blockId,
  required int weekNumber,
  Value<String> phase,
  required int mainSets,
  Value<String> rir,
  Value<String> runPrescription,
  Value<String> conditioningPrescription,
});
typedef $$BlockWeeksTableUpdateCompanionBuilder = BlockWeeksCompanion Function({
  Value<int> id,
  Value<int> blockId,
  Value<int> weekNumber,
  Value<String> phase,
  Value<int> mainSets,
  Value<String> rir,
  Value<String> runPrescription,
  Value<String> conditioningPrescription,
});

final class $$BlockWeeksTableReferences
    extends BaseReferences<_$AppDatabase, $BlockWeeksTable, BlockWeek> {
  $$BlockWeeksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BlocksTable _blockIdTable(_$AppDatabase db) =>
      db.blocks.createAlias('block_weeks__block_id__blocks__id');

  $$BlocksTableProcessedTableManager get blockId {
    final $_column = $_itemColumn<int>('block_id')!;

    final manager = $$BlocksTableTableManager(
      $_db,
      $_db.blocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BlockWeeksTableFilterComposer
    extends Composer<_$AppDatabase, $BlockWeeksTable> {
  $$BlockWeeksTableFilterComposer({
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

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mainSets => $composableBuilder(
    column: $table.mainSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get runPrescription => $composableBuilder(
    column: $table.runPrescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditioningPrescription => $composableBuilder(
    column: $table.conditioningPrescription,
    builder: (column) => ColumnFilters(column),
  );

  $$BlocksTableFilterComposer get blockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableFilterComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockWeeksTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockWeeksTable> {
  $$BlockWeeksTableOrderingComposer({
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

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mainSets => $composableBuilder(
    column: $table.mainSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get runPrescription => $composableBuilder(
    column: $table.runPrescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditioningPrescription => $composableBuilder(
    column: $table.conditioningPrescription,
    builder: (column) => ColumnOrderings(column),
  );

  $$BlocksTableOrderingComposer get blockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableOrderingComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockWeeksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockWeeksTable> {
  $$BlockWeeksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<int> get mainSets =>
      $composableBuilder(column: $table.mainSets, builder: (column) => column);

  GeneratedColumn<String> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<String> get runPrescription => $composableBuilder(
    column: $table.runPrescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditioningPrescription => $composableBuilder(
    column: $table.conditioningPrescription,
    builder: (column) => column,
  );

  $$BlocksTableAnnotationComposer get blockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockWeeksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockWeeksTable,
          BlockWeek,
          $$BlockWeeksTableFilterComposer,
          $$BlockWeeksTableOrderingComposer,
          $$BlockWeeksTableAnnotationComposer,
          $$BlockWeeksTableCreateCompanionBuilder,
          $$BlockWeeksTableUpdateCompanionBuilder,
          (BlockWeek, $$BlockWeeksTableReferences),
          BlockWeek,
          PrefetchHooks Function({bool blockId})
        > {
  $$BlockWeeksTableTableManager(_$AppDatabase db, $BlockWeeksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockWeeksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockWeeksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockWeeksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> blockId = const Value.absent(),
                Value<int> weekNumber = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<int> mainSets = const Value.absent(),
                Value<String> rir = const Value.absent(),
                Value<String> runPrescription = const Value.absent(),
                Value<String> conditioningPrescription = const Value.absent(),
              }) => BlockWeeksCompanion(
                id: id,
                blockId: blockId,
                weekNumber: weekNumber,
                phase: phase,
                mainSets: mainSets,
                rir: rir,
                runPrescription: runPrescription,
                conditioningPrescription: conditioningPrescription,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int blockId,
                required int weekNumber,
                Value<String> phase = const Value.absent(),
                required int mainSets,
                Value<String> rir = const Value.absent(),
                Value<String> runPrescription = const Value.absent(),
                Value<String> conditioningPrescription = const Value.absent(),
              }) => BlockWeeksCompanion.insert(
                id: id,
                blockId: blockId,
                weekNumber: weekNumber,
                phase: phase,
                mainSets: mainSets,
                rir: rir,
                runPrescription: runPrescription,
                conditioningPrescription: conditioningPrescription,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BlockWeeksTable, BlockWeek>(table),
                  $$BlockWeeksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({blockId = false}) {
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
                    if (blockId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.blockId,
                        referencedTable: $$BlockWeeksTableReferences
                            ._blockIdTable(db),
                        referencedColumn: $$BlockWeeksTableReferences
                            ._blockIdTable(db)
                            .id,
                      ) as T;
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

typedef $$BlockWeeksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockWeeksTable,
      BlockWeek,
      $$BlockWeeksTableFilterComposer,
      $$BlockWeeksTableOrderingComposer,
      $$BlockWeeksTableAnnotationComposer,
      $$BlockWeeksTableCreateCompanionBuilder,
      $$BlockWeeksTableUpdateCompanionBuilder,
      (BlockWeek, $$BlockWeeksTableReferences),
      BlockWeek,
      PrefetchHooks Function({bool blockId})
    >;
typedef $$WorkoutTemplatesTableCreateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      Value<int> id,
      required int blockId,
      required String name,
      required int sortOrder,
    });
typedef $$WorkoutTemplatesTableUpdateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      Value<int> id,
      Value<int> blockId,
      Value<String> name,
      Value<int> sortOrder,
    });

final class $$WorkoutTemplatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutTemplatesTable, WorkoutTemplate> {
  $$WorkoutTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BlocksTable _blockIdTable(_$AppDatabase db) =>
      db.blocks.createAlias('workout_templates__block_id__blocks__id');

  $$BlocksTableProcessedTableManager get blockId {
    final $_column = $_itemColumn<int>('block_id')!;

    final manager = $$BlocksTableTableManager(
      $_db,
      $_db.blocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TemplateExercisesTable, List<TemplateExercise>>
  _templateExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.templateExercises,
        aliasName: 'workout_templates__id__template_exercises__template_id',
      );

  $$TemplateExercisesTableProcessedTableManager get templateExercisesRefs {
    final manager = $$TemplateExercisesTableTableManager(
      $_db,
      $_db.templateExercises,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _templateExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$BlocksTableFilterComposer get blockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableFilterComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> templateExercisesRefs(
    Expression<bool> Function($$TemplateExercisesTableFilterComposer f) f,
  ) {
    final $$TemplateExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateExercises,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateExercisesTableFilterComposer(
            $db: $db,
            $table: $db.templateExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$BlocksTableOrderingComposer get blockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableOrderingComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableAnnotationComposer({
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$BlocksTableAnnotationComposer get blockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> templateExercisesRefs<T extends Object>(
    Expression<T> Function($$TemplateExercisesTableAnnotationComposer a) f,
  ) {
    final $$TemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.templateExercises,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TemplateExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.templateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTemplatesTable,
          WorkoutTemplate,
          $$WorkoutTemplatesTableFilterComposer,
          $$WorkoutTemplatesTableOrderingComposer,
          $$WorkoutTemplatesTableAnnotationComposer,
          $$WorkoutTemplatesTableCreateCompanionBuilder,
          $$WorkoutTemplatesTableUpdateCompanionBuilder,
          (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
          WorkoutTemplate,
          PrefetchHooks Function({bool blockId, bool templateExercisesRefs})
        > {
  $$WorkoutTemplatesTableTableManager(
    _$AppDatabase db,
    $WorkoutTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> blockId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => WorkoutTemplatesCompanion(
                id: id,
                blockId: blockId,
                name: name,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int blockId,
                required String name,
                required int sortOrder,
              }) => WorkoutTemplatesCompanion.insert(
                id: id,
                blockId: blockId,
                name: name,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutTemplatesTable, WorkoutTemplate>(table),
                  $$WorkoutTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({blockId = false, templateExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (templateExercisesRefs) db.templateExercises,
                  ],
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
                        if (blockId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.blockId,
                            referencedTable: $$WorkoutTemplatesTableReferences
                                ._blockIdTable(db),
                            referencedColumn: $$WorkoutTemplatesTableReferences
                                ._blockIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (templateExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutTemplate,
                          $WorkoutTemplatesTable,
                          TemplateExercise,
                          $TemplateExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutTemplatesTableReferences
                              ._templateExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).templateExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'template_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTemplatesTable,
      WorkoutTemplate,
      $$WorkoutTemplatesTableFilterComposer,
      $$WorkoutTemplatesTableOrderingComposer,
      $$WorkoutTemplatesTableAnnotationComposer,
      $$WorkoutTemplatesTableCreateCompanionBuilder,
      $$WorkoutTemplatesTableUpdateCompanionBuilder,
      (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
      WorkoutTemplate,
      PrefetchHooks Function({bool blockId, bool templateExercisesRefs})
    >;
typedef $$TemplateExercisesTableCreateCompanionBuilder =
    TemplateExercisesCompanion Function({
      Value<int> id,
      required int templateId,
      required int exerciseId,
      required int position,
      required LogType logType,
      Value<bool> isWarmup,
      Value<String> repsText,
      Value<int?> repsMin,
      Value<int?> repsMax,
      Value<int> restSec,
      Value<String> tip,
      Value<int?> fixedSets,
    });
typedef $$TemplateExercisesTableUpdateCompanionBuilder =
    TemplateExercisesCompanion Function({
      Value<int> id,
      Value<int> templateId,
      Value<int> exerciseId,
      Value<int> position,
      Value<LogType> logType,
      Value<bool> isWarmup,
      Value<String> repsText,
      Value<int?> repsMin,
      Value<int?> repsMax,
      Value<int> restSec,
      Value<String> tip,
      Value<int?> fixedSets,
    });

final class $$TemplateExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TemplateExercisesTable,
          TemplateExercise
        > {
  $$TemplateExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutTemplatesTable _templateIdTable(_$AppDatabase db) => db
      .workoutTemplates
      .createAlias('template_exercises__template_id__workout_templates__id');

  $$WorkoutTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager = $$WorkoutTemplatesTableTableManager(
      $_db,
      $_db.workoutTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('template_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TemplateExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableFilterComposer({
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LogType, LogType, String> get logType =>
      $composableBuilder(
        column: $table.logType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repsText => $composableBuilder(
    column: $table.repsText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsMin => $composableBuilder(
    column: $table.repsMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsMax => $composableBuilder(
    column: $table.repsMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tip => $composableBuilder(
    column: $table.tip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fixedSets => $composableBuilder(
    column: $table.fixedSets,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutTemplatesTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logType => $composableBuilder(
    column: $table.logType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repsText => $composableBuilder(
    column: $table.repsText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsMin => $composableBuilder(
    column: $table.repsMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsMax => $composableBuilder(
    column: $table.repsMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tip => $composableBuilder(
    column: $table.tip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fixedSets => $composableBuilder(
    column: $table.fixedSets,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutTemplatesTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LogType, String> get logType =>
      $composableBuilder(column: $table.logType, builder: (column) => column);

  GeneratedColumn<bool> get isWarmup =>
      $composableBuilder(column: $table.isWarmup, builder: (column) => column);

  GeneratedColumn<String> get repsText =>
      $composableBuilder(column: $table.repsText, builder: (column) => column);

  GeneratedColumn<int> get repsMin =>
      $composableBuilder(column: $table.repsMin, builder: (column) => column);

  GeneratedColumn<int> get repsMax =>
      $composableBuilder(column: $table.repsMax, builder: (column) => column);

  GeneratedColumn<int> get restSec =>
      $composableBuilder(column: $table.restSec, builder: (column) => column);

  GeneratedColumn<String> get tip =>
      $composableBuilder(column: $table.tip, builder: (column) => column);

  GeneratedColumn<int> get fixedSets =>
      $composableBuilder(column: $table.fixedSets, builder: (column) => column);

  $$WorkoutTemplatesTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplateExercisesTable,
          TemplateExercise,
          $$TemplateExercisesTableFilterComposer,
          $$TemplateExercisesTableOrderingComposer,
          $$TemplateExercisesTableAnnotationComposer,
          $$TemplateExercisesTableCreateCompanionBuilder,
          $$TemplateExercisesTableUpdateCompanionBuilder,
          (TemplateExercise, $$TemplateExercisesTableReferences),
          TemplateExercise,
          PrefetchHooks Function({bool templateId, bool exerciseId})
        > {
  $$TemplateExercisesTableTableManager(
    _$AppDatabase db,
    $TemplateExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<LogType> logType = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<String> repsText = const Value.absent(),
                Value<int?> repsMin = const Value.absent(),
                Value<int?> repsMax = const Value.absent(),
                Value<int> restSec = const Value.absent(),
                Value<String> tip = const Value.absent(),
                Value<int?> fixedSets = const Value.absent(),
              }) => TemplateExercisesCompanion(
                id: id,
                templateId: templateId,
                exerciseId: exerciseId,
                position: position,
                logType: logType,
                isWarmup: isWarmup,
                repsText: repsText,
                repsMin: repsMin,
                repsMax: repsMax,
                restSec: restSec,
                tip: tip,
                fixedSets: fixedSets,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateId,
                required int exerciseId,
                required int position,
                required LogType logType,
                Value<bool> isWarmup = const Value.absent(),
                Value<String> repsText = const Value.absent(),
                Value<int?> repsMin = const Value.absent(),
                Value<int?> repsMax = const Value.absent(),
                Value<int> restSec = const Value.absent(),
                Value<String> tip = const Value.absent(),
                Value<int?> fixedSets = const Value.absent(),
              }) => TemplateExercisesCompanion.insert(
                id: id,
                templateId: templateId,
                exerciseId: exerciseId,
                position: position,
                logType: logType,
                isWarmup: isWarmup,
                repsText: repsText,
                repsMin: repsMin,
                repsMax: repsMax,
                restSec: restSec,
                tip: tip,
                fixedSets: fixedSets,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemplateExercisesTable, TemplateExercise>(table),
                  $$TemplateExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false, exerciseId = false}) {
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
                    if (templateId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.templateId,
                        referencedTable: $$TemplateExercisesTableReferences
                            ._templateIdTable(db),
                        referencedColumn: $$TemplateExercisesTableReferences
                            ._templateIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$TemplateExercisesTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$TemplateExercisesTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
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

typedef $$TemplateExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplateExercisesTable,
      TemplateExercise,
      $$TemplateExercisesTableFilterComposer,
      $$TemplateExercisesTableOrderingComposer,
      $$TemplateExercisesTableAnnotationComposer,
      $$TemplateExercisesTableCreateCompanionBuilder,
      $$TemplateExercisesTableUpdateCompanionBuilder,
      (TemplateExercise, $$TemplateExercisesTableReferences),
      TemplateExercise,
      PrefetchHooks Function({bool templateId, bool exerciseId})
    >;
typedef $$ScheduleDaysTableCreateCompanionBuilder =
    ScheduleDaysCompanion Function({
      Value<int> id,
      required int blockId,
      required int weekday,
      required DayKind kind,
      Value<int?> templateId,
    });
typedef $$ScheduleDaysTableUpdateCompanionBuilder =
    ScheduleDaysCompanion Function({
      Value<int> id,
      Value<int> blockId,
      Value<int> weekday,
      Value<DayKind> kind,
      Value<int?> templateId,
    });

final class $$ScheduleDaysTableReferences
    extends BaseReferences<_$AppDatabase, $ScheduleDaysTable, ScheduleDay> {
  $$ScheduleDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BlocksTable _blockIdTable(_$AppDatabase db) =>
      db.blocks.createAlias('schedule_days__block_id__blocks__id');

  $$BlocksTableProcessedTableManager get blockId {
    final $_column = $_itemColumn<int>('block_id')!;

    final manager = $$BlocksTableTableManager(
      $_db,
      $_db.blocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduleDaysTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleDaysTable> {
  $$ScheduleDaysTableFilterComposer({
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

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DayKind, DayKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  $$BlocksTableFilterComposer get blockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableFilterComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleDaysTable> {
  $$ScheduleDaysTableOrderingComposer({
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

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  $$BlocksTableOrderingComposer get blockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableOrderingComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleDaysTable> {
  $$ScheduleDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DayKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  $$BlocksTableAnnotationComposer get blockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleDaysTable,
          ScheduleDay,
          $$ScheduleDaysTableFilterComposer,
          $$ScheduleDaysTableOrderingComposer,
          $$ScheduleDaysTableAnnotationComposer,
          $$ScheduleDaysTableCreateCompanionBuilder,
          $$ScheduleDaysTableUpdateCompanionBuilder,
          (ScheduleDay, $$ScheduleDaysTableReferences),
          ScheduleDay,
          PrefetchHooks Function({bool blockId})
        > {
  $$ScheduleDaysTableTableManager(_$AppDatabase db, $ScheduleDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> blockId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<DayKind> kind = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
              }) => ScheduleDaysCompanion(
                id: id,
                blockId: blockId,
                weekday: weekday,
                kind: kind,
                templateId: templateId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int blockId,
                required int weekday,
                required DayKind kind,
                Value<int?> templateId = const Value.absent(),
              }) => ScheduleDaysCompanion.insert(
                id: id,
                blockId: blockId,
                weekday: weekday,
                kind: kind,
                templateId: templateId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScheduleDaysTable, ScheduleDay>(table),
                  $$ScheduleDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({blockId = false}) {
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
                    if (blockId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.blockId,
                        referencedTable: $$ScheduleDaysTableReferences
                            ._blockIdTable(db),
                        referencedColumn: $$ScheduleDaysTableReferences
                            ._blockIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ScheduleDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleDaysTable,
      ScheduleDay,
      $$ScheduleDaysTableFilterComposer,
      $$ScheduleDaysTableOrderingComposer,
      $$ScheduleDaysTableAnnotationComposer,
      $$ScheduleDaysTableCreateCompanionBuilder,
      $$ScheduleDaysTableUpdateCompanionBuilder,
      (ScheduleDay, $$ScheduleDaysTableReferences),
      ScheduleDay,
      PrefetchHooks Function({bool blockId})
    >;
typedef $$PlannedSessionsTableCreateCompanionBuilder =
    PlannedSessionsCompanion Function({
      Value<int> id,
      required int blockId,
      required int weekNumber,
      required DateTime date,
      required DayKind kind,
      Value<int?> templateId,
    });
typedef $$PlannedSessionsTableUpdateCompanionBuilder =
    PlannedSessionsCompanion Function({
      Value<int> id,
      Value<int> blockId,
      Value<int> weekNumber,
      Value<DateTime> date,
      Value<DayKind> kind,
      Value<int?> templateId,
    });

final class $$PlannedSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PlannedSessionsTable, PlannedSession> {
  $$PlannedSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BlocksTable _blockIdTable(_$AppDatabase db) =>
      db.blocks.createAlias('planned_sessions__block_id__blocks__id');

  $$BlocksTableProcessedTableManager get blockId {
    final $_column = $_itemColumn<int>('block_id')!;

    final manager = $$BlocksTableTableManager(
      $_db,
      $_db.blocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlannedSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedSessionsTable> {
  $$PlannedSessionsTableFilterComposer({
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

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DayKind, DayKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  $$BlocksTableFilterComposer get blockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableFilterComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedSessionsTable> {
  $$PlannedSessionsTableOrderingComposer({
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

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  $$BlocksTableOrderingComposer get blockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableOrderingComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedSessionsTable> {
  $$PlannedSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DayKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  $$BlocksTableAnnotationComposer get blockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.blocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.blocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlannedSessionsTable,
          PlannedSession,
          $$PlannedSessionsTableFilterComposer,
          $$PlannedSessionsTableOrderingComposer,
          $$PlannedSessionsTableAnnotationComposer,
          $$PlannedSessionsTableCreateCompanionBuilder,
          $$PlannedSessionsTableUpdateCompanionBuilder,
          (PlannedSession, $$PlannedSessionsTableReferences),
          PlannedSession,
          PrefetchHooks Function({bool blockId})
        > {
  $$PlannedSessionsTableTableManager(
    _$AppDatabase db,
    $PlannedSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> blockId = const Value.absent(),
                Value<int> weekNumber = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DayKind> kind = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
              }) => PlannedSessionsCompanion(
                id: id,
                blockId: blockId,
                weekNumber: weekNumber,
                date: date,
                kind: kind,
                templateId: templateId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int blockId,
                required int weekNumber,
                required DateTime date,
                required DayKind kind,
                Value<int?> templateId = const Value.absent(),
              }) => PlannedSessionsCompanion.insert(
                id: id,
                blockId: blockId,
                weekNumber: weekNumber,
                date: date,
                kind: kind,
                templateId: templateId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlannedSessionsTable, PlannedSession>(table),
                  $$PlannedSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({blockId = false}) {
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
                    if (blockId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.blockId,
                        referencedTable: $$PlannedSessionsTableReferences
                            ._blockIdTable(db),
                        referencedColumn: $$PlannedSessionsTableReferences
                            ._blockIdTable(db)
                            .id,
                      ) as T;
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

typedef $$PlannedSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlannedSessionsTable,
      PlannedSession,
      $$PlannedSessionsTableFilterComposer,
      $$PlannedSessionsTableOrderingComposer,
      $$PlannedSessionsTableAnnotationComposer,
      $$PlannedSessionsTableCreateCompanionBuilder,
      $$PlannedSessionsTableUpdateCompanionBuilder,
      (PlannedSession, $$PlannedSessionsTableReferences),
      PlannedSession,
      PrefetchHooks Function({bool blockId})
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int?> blockId,
  Value<int?> templateId,
  required String templateName,
  Value<int?> weekNumber,
  required String planJson,
  required SessionStatus status,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<int> cursorExercise,
  Value<int> cursorSet,
  Value<DateTime?> lastSetAt,
  Value<DateTime?> restEndsAt,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int?> blockId,
  Value<int?> templateId,
  Value<String> templateName,
  Value<int?> weekNumber,
  Value<String> planJson,
  Value<SessionStatus> status,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> cursorExercise,
  Value<int> cursorSet,
  Value<DateTime?> lastSetAt,
  Value<DateTime?> restEndsAt,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'sessions__id__set_logs__session_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
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

  ColumnFilters<int> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planJson => $composableBuilder(
    column: $table.planJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cursorExercise => $composableBuilder(
    column: $table.cursorExercise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cursorSet => $composableBuilder(
    column: $table.cursorSet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSetAt => $composableBuilder(
    column: $table.lastSetAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
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

  ColumnOrderings<int> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planJson => $composableBuilder(
    column: $table.planJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cursorExercise => $composableBuilder(
    column: $table.cursorExercise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cursorSet => $composableBuilder(
    column: $table.cursorSet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSetAt => $composableBuilder(
    column: $table.lastSetAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumn<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planJson =>
      $composableBuilder(column: $table.planJson, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get cursorExercise => $composableBuilder(
    column: $table.cursorExercise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cursorSet =>
      $composableBuilder(column: $table.cursorSet, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSetAt =>
      $composableBuilder(column: $table.lastSetAt, builder: (column) => column);

  GeneratedColumn<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => column,
  );

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({bool setLogsRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> blockId = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                Value<String> templateName = const Value.absent(),
                Value<int?> weekNumber = const Value.absent(),
                Value<String> planJson = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> cursorExercise = const Value.absent(),
                Value<int> cursorSet = const Value.absent(),
                Value<DateTime?> lastSetAt = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                blockId: blockId,
                templateId: templateId,
                templateName: templateName,
                weekNumber: weekNumber,
                planJson: planJson,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                cursorExercise: cursorExercise,
                cursorSet: cursorSet,
                lastSetAt: lastSetAt,
                restEndsAt: restEndsAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> blockId = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                required String templateName,
                Value<int?> weekNumber = const Value.absent(),
                required String planJson,
                required SessionStatus status,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> cursorExercise = const Value.absent(),
                Value<int> cursorSet = const Value.absent(),
                Value<DateTime?> lastSetAt = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                blockId: blockId,
                templateId: templateId,
                templateName: templateName,
                weekNumber: weekNumber,
                planJson: planJson,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                cursorExercise: cursorExercise,
                cursorSet: cursorSet,
                lastSetAt: lastSetAt,
                restEndsAt: restEndsAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, Session>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedDataByColumns<
                      Session,
                      $SessionsTable,
                      SetLog,
                      $SetLogsTable
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._setLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableReferences(db, table, p0).setLogsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool setLogsRefs})
    >;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  required int sessionId,
  required int exerciseId,
  required int exerciseIndex,
  required int setIndex,
  Value<double?> loadKg,
  Value<int?> reps,
  Value<double?> distanceM,
  Value<int?> durationSec,
  Value<bool> isWarmup,
  required DateTime createdAt,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> exerciseId,
  Value<int> exerciseIndex,
  Value<int> setIndex,
  Value<double?> loadKg,
  Value<int?> reps,
  Value<double?> distanceM,
  Value<int?> durationSec,
  Value<bool> isWarmup,
  Value<DateTime> createdAt,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLog> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('set_logs__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
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

  ColumnFilters<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseIndex => $composableBuilder(
    column: $table.exerciseIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
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

  ColumnOrderings<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseIndex => $composableBuilder(
    column: $table.exerciseIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseIndex => $composableBuilder(
    column: $table.exerciseIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<double> get loadKg =>
      $composableBuilder(column: $table.loadKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isWarmup =>
      $composableBuilder(column: $table.isWarmup, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLog,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLog, $$SetLogsTableReferences),
          SetLog,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> exerciseIndex = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<double?> loadKg = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> distanceM = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                exerciseIndex: exerciseIndex,
                setIndex: setIndex,
                loadKg: loadKg,
                reps: reps,
                distanceM: distanceM,
                durationSec: durationSec,
                isWarmup: isWarmup,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int exerciseId,
                required int exerciseIndex,
                required int setIndex,
                Value<double?> loadKg = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> distanceM = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                required DateTime createdAt,
              }) => SetLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                exerciseIndex: exerciseIndex,
                setIndex: setIndex,
                loadKg: loadKg,
                reps: reps,
                distanceM: distanceM,
                durationSec: durationSec,
                isWarmup: isWarmup,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SetLogsTable, SetLog>(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SetLogsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SetLogsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
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

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLog,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLog, $$SetLogsTableReferences),
      SetLog,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$CardioLogsTableCreateCompanionBuilder = CardioLogsCompanion Function({
  Value<int> id,
  required CardioType type,
  required DateTime date,
  Value<double?> km,
  required int durationSec,
  Value<int?> paceSecPerKm,
  Value<int?> rpe,
  Value<String?> notes,
  Value<int?> blockId,
  Value<int?> weekNumber,
});
typedef $$CardioLogsTableUpdateCompanionBuilder = CardioLogsCompanion Function({
  Value<int> id,
  Value<CardioType> type,
  Value<DateTime> date,
  Value<double?> km,
  Value<int> durationSec,
  Value<int?> paceSecPerKm,
  Value<int?> rpe,
  Value<String?> notes,
  Value<int?> blockId,
  Value<int?> weekNumber,
});

class $$CardioLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CardioLogsTable> {
  $$CardioLogsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<CardioType, CardioType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paceSecPerKm => $composableBuilder(
    column: $table.paceSecPerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardioLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardioLogsTable> {
  $$CardioLogsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paceSecPerKm => $composableBuilder(
    column: $table.paceSecPerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardioLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardioLogsTable> {
  $$CardioLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CardioType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get km =>
      $composableBuilder(column: $table.km, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paceSecPerKm => $composableBuilder(
    column: $table.paceSecPerKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );
}

class $$CardioLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardioLogsTable,
          CardioLog,
          $$CardioLogsTableFilterComposer,
          $$CardioLogsTableOrderingComposer,
          $$CardioLogsTableAnnotationComposer,
          $$CardioLogsTableCreateCompanionBuilder,
          $$CardioLogsTableUpdateCompanionBuilder,
          (
            CardioLog,
            BaseReferences<_$AppDatabase, $CardioLogsTable, CardioLog>,
          ),
          CardioLog,
          PrefetchHooks Function()
        > {
  $$CardioLogsTableTableManager(_$AppDatabase db, $CardioLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardioLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardioLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardioLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<CardioType> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> km = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<int?> paceSecPerKm = const Value.absent(),
                Value<int?> rpe = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> blockId = const Value.absent(),
                Value<int?> weekNumber = const Value.absent(),
              }) => CardioLogsCompanion(
                id: id,
                type: type,
                date: date,
                km: km,
                durationSec: durationSec,
                paceSecPerKm: paceSecPerKm,
                rpe: rpe,
                notes: notes,
                blockId: blockId,
                weekNumber: weekNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required CardioType type,
                required DateTime date,
                Value<double?> km = const Value.absent(),
                required int durationSec,
                Value<int?> paceSecPerKm = const Value.absent(),
                Value<int?> rpe = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> blockId = const Value.absent(),
                Value<int?> weekNumber = const Value.absent(),
              }) => CardioLogsCompanion.insert(
                id: id,
                type: type,
                date: date,
                km: km,
                durationSec: durationSec,
                paceSecPerKm: paceSecPerKm,
                rpe: rpe,
                notes: notes,
                blockId: blockId,
                weekNumber: weekNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardioLogsTable, CardioLog>(table),
                  BaseReferences<_$AppDatabase, $CardioLogsTable, CardioLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardioLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardioLogsTable,
      CardioLog,
      $$CardioLogsTableFilterComposer,
      $$CardioLogsTableOrderingComposer,
      $$CardioLogsTableAnnotationComposer,
      $$CardioLogsTableCreateCompanionBuilder,
      $$CardioLogsTableUpdateCompanionBuilder,
      (CardioLog, BaseReferences<_$AppDatabase, $CardioLogsTable, CardioLog>),
      CardioLog,
      PrefetchHooks Function()
    >;
typedef $$AssessmentResultsTableCreateCompanionBuilder =
    AssessmentResultsCompanion Function({
      Value<int> id,
      Value<int?> blockId,
      Value<int?> weekNumber,
      required DateTime date,
      required String testKey,
      required double value,
    });
typedef $$AssessmentResultsTableUpdateCompanionBuilder =
    AssessmentResultsCompanion Function({
      Value<int> id,
      Value<int?> blockId,
      Value<int?> weekNumber,
      Value<DateTime> date,
      Value<String> testKey,
      Value<double> value,
    });

class $$AssessmentResultsTableFilterComposer
    extends Composer<_$AppDatabase, $AssessmentResultsTable> {
  $$AssessmentResultsTableFilterComposer({
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

  ColumnFilters<int> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testKey => $composableBuilder(
    column: $table.testKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssessmentResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssessmentResultsTable> {
  $$AssessmentResultsTableOrderingComposer({
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

  ColumnOrderings<int> get blockId => $composableBuilder(
    column: $table.blockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testKey => $composableBuilder(
    column: $table.testKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssessmentResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssessmentResultsTable> {
  $$AssessmentResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get testKey =>
      $composableBuilder(column: $table.testKey, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AssessmentResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssessmentResultsTable,
          AssessmentResult,
          $$AssessmentResultsTableFilterComposer,
          $$AssessmentResultsTableOrderingComposer,
          $$AssessmentResultsTableAnnotationComposer,
          $$AssessmentResultsTableCreateCompanionBuilder,
          $$AssessmentResultsTableUpdateCompanionBuilder,
          (
            AssessmentResult,
            BaseReferences<
              _$AppDatabase,
              $AssessmentResultsTable,
              AssessmentResult
            >,
          ),
          AssessmentResult,
          PrefetchHooks Function()
        > {
  $$AssessmentResultsTableTableManager(
    _$AppDatabase db,
    $AssessmentResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssessmentResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssessmentResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssessmentResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> blockId = const Value.absent(),
                Value<int?> weekNumber = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> testKey = const Value.absent(),
                Value<double> value = const Value.absent(),
              }) => AssessmentResultsCompanion(
                id: id,
                blockId: blockId,
                weekNumber: weekNumber,
                date: date,
                testKey: testKey,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> blockId = const Value.absent(),
                Value<int?> weekNumber = const Value.absent(),
                required DateTime date,
                required String testKey,
                required double value,
              }) => AssessmentResultsCompanion.insert(
                id: id,
                blockId: blockId,
                weekNumber: weekNumber,
                date: date,
                testKey: testKey,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssessmentResultsTable, AssessmentResult>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AssessmentResultsTable,
                    AssessmentResult
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssessmentResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssessmentResultsTable,
      AssessmentResult,
      $$AssessmentResultsTableFilterComposer,
      $$AssessmentResultsTableOrderingComposer,
      $$AssessmentResultsTableAnnotationComposer,
      $$AssessmentResultsTableCreateCompanionBuilder,
      $$AssessmentResultsTableUpdateCompanionBuilder,
      (
        AssessmentResult,
        BaseReferences<
          _$AppDatabase,
          $AssessmentResultsTable,
          AssessmentResult
        >,
      ),
      AssessmentResult,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$BlocksTableTableManager get blocks =>
      $$BlocksTableTableManager(_db, _db.blocks);
  $$BlockWeeksTableTableManager get blockWeeks =>
      $$BlockWeeksTableTableManager(_db, _db.blockWeeks);
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(_db, _db.workoutTemplates);
  $$TemplateExercisesTableTableManager get templateExercises =>
      $$TemplateExercisesTableTableManager(_db, _db.templateExercises);
  $$ScheduleDaysTableTableManager get scheduleDays =>
      $$ScheduleDaysTableTableManager(_db, _db.scheduleDays);
  $$PlannedSessionsTableTableManager get plannedSessions =>
      $$PlannedSessionsTableTableManager(_db, _db.plannedSessions);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$CardioLogsTableTableManager get cardioLogs =>
      $$CardioLogsTableTableManager(_db, _db.cardioLogs);
  $$AssessmentResultsTableTableManager get assessmentResults =>
      $$AssessmentResultsTableTableManager(_db, _db.assessmentResults);
}
