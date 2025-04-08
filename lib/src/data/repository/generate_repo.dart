import 'dart:typed_data';

import 'package:gato_id_generator/src/core/constants/local_db_constants.dart';
import 'package:gato_id_generator/src/core/exceptions/app_exception.dart';
import 'package:gato_id_generator/src/data/model/gato_id_content.dart';
import 'package:faker/faker.dart';
import 'package:gato_id_generator/src/data/model/gato_id_stat.dart';
import 'package:gato_id_generator/src/util/date_format.dart';
import 'package:hive_ce/hive.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

import '../../core/_core.dart';

// TODO abstraction
class GenerateIdRepo {
  GenerateIdRepo(this._savedId, this._generatedIdCount);
  final Box<String> _savedId;
  final Box<int> _generatedIdCount;

  // * Will not use singleton nor dependency Injection for now.
  final _faker = Faker();

  /// Generate [GatoId] object.
  Future<GatoId> generate() async {
    return GatoId(
      uid: _generateId,
      name: _name,
      isMale: _isMale,
      doB: _doB,
      occupation: _occupation,
      madeIn: DateTime.now(), // TODO use timestamp when remote
    );
  }

  List<String> getAllGeneratedImages({required String uid}) {
    final keys = getAllGeneratedImageKeysOf(uid: uid);
    final List<String> tempList = [];

    for (String key in keys) {
      final value = _savedId.get(key);
      if (value != null) tempList.add(value);
    }

    return tempList;
  }

  /// Filter the keys that is related with the current uid.
  List<String> getAllGeneratedImageKeysOf({required String uid}) {
    final keys = _savedId.keys.toList();
    return [
      for (var key in keys)
        if (key is String && key.contains(uid)) key
    ];
  }

  /// Returns individual saved card image.
  String? getSavedImage(String key) => _savedId.get(key);

  /// Will save the current Gato Id card as an image.
  ///
  /// [uuid] is the unique card Id,
  /// [value] is the image data, and
  /// [uid] is the current authenticated user id.
  Future<void> saveGenerated(String uuid, Uint8List value, {required String uid}) async {
    if (await Permission.storage.request().isGranted) {
      final savedKey = "${uid}_$uuid";
      final result = await ImageGallerySaverPlus.saveImage(
        value,
        name: "${DateTime.now().formatTime}-$uuid-${uid.replaceFirst("@", "")}",
      );
      return await _savedId.put(savedKey, result["filePath"]);
    }

    throw const AccessNotGrantedException();
  }

  /// Get the latest [GatoIdStat].
  GatoIdStat getLatestStats({required String uid}) {
    final generatedCount = _getGeneratedCountStats(uid);
    final savedImages = getAllGeneratedImages(uid: uid);
    savedImages.sort();
    return GatoIdStat(generatedCount: generatedCount, savedImages: savedImages);
  }

  /// Get generated count key according to the current authenticated user.
  String _getGeneratedCountKey(String uid) => "${uid}_${DBKeys.GENERATED_ID_COUNT}";

  /// Track how many times user generate gato ID.
  Future<void> incrementAndSaveStats({required String uid}) async {
    return await _generatedIdCount.put(_getGeneratedCountKey(uid), _getGeneratedCountStats(uid) + 1);
  }

  /// Get the latest generated count number according with the given user id.
  int _getGeneratedCountStats(String uid) => _generatedIdCount.get(_getGeneratedCountKey(uid)) ?? 0;

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

  /// Generate random bool.
  bool get _isMale => _faker.randomGenerator.boolean();

  /// Generate random `DateTime` object, between `1990-1-1` until `now`.
  DateTime get _doB => _faker.date.dateTimeBetween(DateTime(1990, 1, 1), DateTime.now());

  /// Generate random job/occupation title string.
  String get _occupation => _faker.job.title();
}
