/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class AnnouncementRead
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AnnouncementRead._({
    this.id,
    required this.announcementId,
    required this.userId,
    required this.readAt,
  });

  factory AnnouncementRead({
    int? id,
    required int announcementId,
    required _i1.UuidValue userId,
    required DateTime readAt,
  }) = _AnnouncementReadImpl;

  factory AnnouncementRead.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnnouncementRead(
      id: jsonSerialization['id'] as int?,
      announcementId: jsonSerialization['announcementId'] as int,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      readAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
    );
  }

  static final t = AnnouncementReadTable();

  static const db = AnnouncementReadRepository._();

  @override
  int? id;

  int announcementId;

  _i1.UuidValue userId;

  DateTime readAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AnnouncementRead]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnnouncementRead copyWith({
    int? id,
    int? announcementId,
    _i1.UuidValue? userId,
    DateTime? readAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AnnouncementRead',
      if (id != null) 'id': id,
      'announcementId': announcementId,
      'userId': userId.toJson(),
      'readAt': readAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AnnouncementRead',
      if (id != null) 'id': id,
      'announcementId': announcementId,
      'userId': userId.toJson(),
      'readAt': readAt.toJson(),
    };
  }

  static AnnouncementReadInclude include() {
    return AnnouncementReadInclude._();
  }

  static AnnouncementReadIncludeList includeList({
    _i1.WhereExpressionBuilder<AnnouncementReadTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnnouncementReadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnnouncementReadTable>? orderByList,
    AnnouncementReadInclude? include,
  }) {
    return AnnouncementReadIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnnouncementRead.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AnnouncementRead.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnnouncementReadImpl extends AnnouncementRead {
  _AnnouncementReadImpl({
    int? id,
    required int announcementId,
    required _i1.UuidValue userId,
    required DateTime readAt,
  }) : super._(
         id: id,
         announcementId: announcementId,
         userId: userId,
         readAt: readAt,
       );

  /// Returns a shallow copy of this [AnnouncementRead]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnnouncementRead copyWith({
    Object? id = _Undefined,
    int? announcementId,
    _i1.UuidValue? userId,
    DateTime? readAt,
  }) {
    return AnnouncementRead(
      id: id is int? ? id : this.id,
      announcementId: announcementId ?? this.announcementId,
      userId: userId ?? this.userId,
      readAt: readAt ?? this.readAt,
    );
  }
}

class AnnouncementReadUpdateTable
    extends _i1.UpdateTable<AnnouncementReadTable> {
  AnnouncementReadUpdateTable(super.table);

  _i1.ColumnValue<int, int> announcementId(int value) => _i1.ColumnValue(
    table.announcementId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> readAt(DateTime value) => _i1.ColumnValue(
    table.readAt,
    value,
  );
}

class AnnouncementReadTable extends _i1.Table<int?> {
  AnnouncementReadTable({super.tableRelation})
    : super(tableName: 'announcement_read') {
    updateTable = AnnouncementReadUpdateTable(this);
    announcementId = _i1.ColumnInt(
      'announcementId',
      this,
    );
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    readAt = _i1.ColumnDateTime(
      'readAt',
      this,
    );
  }

  late final AnnouncementReadUpdateTable updateTable;

  late final _i1.ColumnInt announcementId;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnDateTime readAt;

  @override
  List<_i1.Column> get columns => [
    id,
    announcementId,
    userId,
    readAt,
  ];
}

class AnnouncementReadInclude extends _i1.IncludeObject {
  AnnouncementReadInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AnnouncementRead.t;
}

class AnnouncementReadIncludeList extends _i1.IncludeList {
  AnnouncementReadIncludeList._({
    _i1.WhereExpressionBuilder<AnnouncementReadTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnnouncementRead.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AnnouncementRead.t;
}

class AnnouncementReadRepository {
  const AnnouncementReadRepository._();

  /// Returns a list of [AnnouncementRead]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AnnouncementRead>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnnouncementReadTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnnouncementReadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnnouncementReadTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AnnouncementRead>(
      where: where?.call(AnnouncementRead.t),
      orderBy: orderBy?.call(AnnouncementRead.t),
      orderByList: orderByList?.call(AnnouncementRead.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AnnouncementRead] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AnnouncementRead?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnnouncementReadTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnnouncementReadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnnouncementReadTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AnnouncementRead>(
      where: where?.call(AnnouncementRead.t),
      orderBy: orderBy?.call(AnnouncementRead.t),
      orderByList: orderByList?.call(AnnouncementRead.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AnnouncementRead] by its [id] or null if no such row exists.
  Future<AnnouncementRead?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AnnouncementRead>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AnnouncementRead]s in the list and returns the inserted rows.
  ///
  /// The returned [AnnouncementRead]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AnnouncementRead>> insert(
    _i1.Session session,
    List<AnnouncementRead> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AnnouncementRead>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AnnouncementRead] and returns the inserted row.
  ///
  /// The returned [AnnouncementRead] will have its `id` field set.
  Future<AnnouncementRead> insertRow(
    _i1.Session session,
    AnnouncementRead row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnnouncementRead>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AnnouncementRead]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AnnouncementRead>> update(
    _i1.Session session,
    List<AnnouncementRead> rows, {
    _i1.ColumnSelections<AnnouncementReadTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AnnouncementRead>(
      rows,
      columns: columns?.call(AnnouncementRead.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnnouncementRead]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnnouncementRead> updateRow(
    _i1.Session session,
    AnnouncementRead row, {
    _i1.ColumnSelections<AnnouncementReadTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnnouncementRead>(
      row,
      columns: columns?.call(AnnouncementRead.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnnouncementRead] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AnnouncementRead?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AnnouncementReadUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AnnouncementRead>(
      id,
      columnValues: columnValues(AnnouncementRead.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AnnouncementRead]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AnnouncementRead>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AnnouncementReadUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AnnouncementReadTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnnouncementReadTable>? orderBy,
    _i1.OrderByListBuilder<AnnouncementReadTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AnnouncementRead>(
      columnValues: columnValues(AnnouncementRead.t.updateTable),
      where: where(AnnouncementRead.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnnouncementRead.t),
      orderByList: orderByList?.call(AnnouncementRead.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AnnouncementRead]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AnnouncementRead>> delete(
    _i1.Session session,
    List<AnnouncementRead> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AnnouncementRead>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AnnouncementRead].
  Future<AnnouncementRead> deleteRow(
    _i1.Session session,
    AnnouncementRead row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnnouncementRead>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AnnouncementRead>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnnouncementReadTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AnnouncementRead>(
      where: where(AnnouncementRead.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnnouncementReadTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AnnouncementRead>(
      where: where?.call(AnnouncementRead.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
