import 'package:dio/dio.dart';
import 'package:gato_id_generator/src/core/constants/local_db_constants.dart';
import 'package:gato_id_generator/src/core/constants/network_constants.dart';
import 'package:gato_id_generator/src/data/model/gato_id.dart';
import 'package:faker/faker.dart';
import 'package:hive_ce/hive.dart';
import 'dart:math';

import '../../core/_core.dart';

class GenerateIdRepo {
  GenerateIdRepo(this._generatedImage, this._generatedStats, this._apiService);
  final ApiService _apiService;
  final Box<String> _generatedImage;
  final Box<int> _generatedStats;

  // * Will not use singleton nor dependency Injection for now.
  final _faker = Faker();

  /// Generate [GatoId] object.
  Future<GatoId> generate() async {
    return GatoId(
      uid: _generateId,
      name: _name,
      doB: _doB,
      occupation: _occupation,
      madeIn: DateTime.now(),
    );
  }

  List<String> getAllGeneratedImages() {
    return _generatedImage.values.toList();
  }

  Future<void> saveGenerated(String uuid, String path) async {
    await _generatedImage.put(uuid, path);
  }

  Future<void> incrementAndSaveStats() async {
    final generatedCount = _generatedStats.get(DBKeys.STATS_GENERATED) ?? 0;
    await _generatedStats.put(DBKeys.STATS_GENERATED, generatedCount + 1);
  }

  /// Generate string ID in 16 characters-length format, such as:
  /// 0000-0000-0000-0000, and utilizes hex digits.
  String get _generateId {
    final random = getIt<Random>();
    String id = '';
    for (var i = 0; i < 16; i++) {
      final randomNum = random.nextInt(16);
      id += randomNum.toRadixString(16).padLeft(1, '0').toUpperCase();
    }
    return '${id.substring(0, 4)}-${id.substring(4, 8)}-${id.substring(8, 12)}-${id.substring(12, 16)}';
  }

  /// Generate random name.
  String get _name => _faker.person.name();

  /// Generate random `DateTime` object, between `1990-1-1` until `now`.
  DateTime get _doB => _faker.date.dateTimeBetween(DateTime(1990, 1, 1), DateTime.now());

  /// Generate random job/occupation title string.
  String get _occupation => _faker.job.title();
}
