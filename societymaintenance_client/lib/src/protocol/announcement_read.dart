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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AnnouncementRead implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int announcementId;

  _i1.UuidValue userId;

  DateTime readAt;

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
