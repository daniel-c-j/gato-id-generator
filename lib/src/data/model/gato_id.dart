// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_ce/hive.dart';

import 'package:gato_id_generator/src/core/constants/local_db_constants.dart';

part 'gato_id.g.dart';

@HiveType(typeId: DBKeys.GATO_ID_HIVE)
class GatoId {
  const GatoId({
    required this.uid,
    required this.imageUrl,
    required this.name,
    required this.doB,
    required this.occupation,
    required this.madeIn,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String imageUrl;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final DateTime doB;
  @HiveField(4)
  final String occupation;
  @HiveField(5)
  final DateTime madeIn;

  @override
  String toString() {
    return 'GatoId(uid: $uid, imageUrl: $imageUrl, name: $name, doB: $doB, occupation: $occupation, madeIn: $madeIn)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'imageUrl': imageUrl,
      'name': name,
      'doB': doB.millisecondsSinceEpoch,
      'occupation': occupation,
      'madeIn': madeIn.millisecondsSinceEpoch,
    };
  }

  factory GatoId.fromMap(Map<String, dynamic> map) {
    return GatoId(
      uid: map['uid'] as String,
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      doB: DateTime.fromMillisecondsSinceEpoch(map['doB'] as int),
      occupation: map['occupation'] as String,
      madeIn: DateTime.fromMillisecondsSinceEpoch(map['madeIn'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory GatoId.fromJson(String source) => GatoId.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant GatoId other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.imageUrl == imageUrl &&
        other.name == name &&
        other.doB == doB &&
        other.occupation == occupation &&
        other.madeIn == madeIn;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        imageUrl.hashCode ^
        name.hashCode ^
        doB.hashCode ^
        occupation.hashCode ^
        madeIn.hashCode;
  }

  GatoId copyWith({
    String? uid,
    String? imageUrl,
    String? name,
    DateTime? doB,
    String? occupation,
    DateTime? madeIn,
  }) {
    return GatoId(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      doB: doB ?? this.doB,
      occupation: occupation ?? this.occupation,
      madeIn: madeIn ?? this.madeIn,
    );
  }
}
