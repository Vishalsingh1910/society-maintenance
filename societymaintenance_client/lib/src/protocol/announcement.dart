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

abstract class Announcement implements _i1.SerializableModel {
  Announcement._({
    this.id,
    required this.title,
    required this.body,
    required this.createdByUserId,
    required this.createdAt,
    this.attachmentUrl,
  });

  factory Announcement({
    int? id,
    required String title,
    required String body,
    required _i1.UuidValue createdByUserId,
    required DateTime createdAt,
    String? attachmentUrl,
  }) = _AnnouncementImpl;

  factory Announcement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Announcement(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      createdByUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdByUserId'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      attachmentUrl: jsonSerialization['attachmentUrl'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String body;

  _i1.UuidValue createdByUserId;

  DateTime createdAt;

  String? attachmentUrl;

  /// Returns a shallow copy of this [Announcement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Announcement copyWith({
    int? id,
    String? title,
    String? body,
    _i1.UuidValue? createdByUserId,
    DateTime? createdAt,
    String? attachmentUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Announcement',
      if (id != null) 'id': id,
      'title': title,
      'body': body,
      'createdByUserId': createdByUserId.toJson(),
      'createdAt': createdAt.toJson(),
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnnouncementImpl extends Announcement {
  _AnnouncementImpl({
    int? id,
    required String title,
    required String body,
    required _i1.UuidValue createdByUserId,
    required DateTime createdAt,
    String? attachmentUrl,
  }) : super._(
         id: id,
         title: title,
         body: body,
         createdByUserId: createdByUserId,
         createdAt: createdAt,
         attachmentUrl: attachmentUrl,
       );

  /// Returns a shallow copy of this [Announcement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Announcement copyWith({
    Object? id = _Undefined,
    String? title,
    String? body,
    _i1.UuidValue? createdByUserId,
    DateTime? createdAt,
    Object? attachmentUrl = _Undefined,
  }) {
    return Announcement(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdAt: createdAt ?? this.createdAt,
      attachmentUrl: attachmentUrl is String?
          ? attachmentUrl
          : this.attachmentUrl,
    );
  }
}
