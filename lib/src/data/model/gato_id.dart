// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_ce/hive.dart';

import 'package:gato_id_generator/src/core/constants/local_db_constants.dart';

part 'gato_id.g.dart';

@HiveType(typeId: DBKeys.GATO_ID_HIVE)
class GatoId {
  const GatoId({
    required this.uid,
    required this.name,
    required this.doB,
    required this.occupation,
    required this.madeIn,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final DateTime doB;
  @HiveField(3)
  final String occupation;
  @HiveField(4)
  final DateTime madeIn;

  @override
  bool operator ==(covariant GatoId other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.doB == doB &&
        other.occupation == occupation &&
        other.madeIn == madeIn;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ name.hashCode ^ doB.hashCode ^ occupation.hashCode ^ madeIn.hashCode;
  }
}
