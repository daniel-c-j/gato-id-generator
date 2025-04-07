import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:gato_id_generator/src/core/constants/local_db_constants.dart';
import 'package:gato_id_generator/src/data/model/gato_id.dart';
import 'package:faker/faker.dart';
import 'package:gato_id_generator/src/data/model/gato_id_stat.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import '../../core/_core.dart';

// TODO abstraction
class GenerateIdRepo {
  GenerateIdRepo(this._generatedImage, this._generatedStats);
  final Box<String> _generatedImage;
  final Box<int> _generatedStats;

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

  List<String> getAllGeneratedImages({required String uid}) => _generatedImage.values.where((String value) {
        return value.contains(uid);
      }).toList();

  /// Will save the current Gato Id card as an image.
  ///
  /// [uuid] is the unique card Id,
  /// [value] is the image data, and
  /// [uid] is the current authenticated user id.
  Future<void> saveGenerated(String uuid, Uint8List value, {required String uid}) async {
    final savedKey = "${uid}_$uuid";

    // Check for access permission
    final hasAccess = await Gal.hasAccess();
    // Request access permission
    if (!hasAccess) await Gal.requestAccess();
    await Gal.putImageBytes(value, name: uuid);

    final path = "";
    return await _generatedImage.put(savedKey, path);
  }

  /// Get the latest [GatoIdStat].
  GatoIdStat getLatestStats({required String uid}) {
    final generatedCount = _getGeneratedCountStats(uid);
    final savedCount = getAllGeneratedImages(uid: uid).length;
    return GatoIdStat(generatedCount: generatedCount, savedCount: savedCount);
  }

  String _getGeneratedCountKey(String uid) => "${uid}_${DBKeys.STATS_GENERATED}";

  /// Track how many times user generate gato ID.
  Future<void> incrementAndSaveStats({required String uid}) async {
    return await _generatedStats.put(_getGeneratedCountKey(uid), _getGeneratedCountStats(uid) + 1);
  }

  /// Get the latest generated count number according with the given user id.
  int _getGeneratedCountStats(String uid) => _generatedStats.get(_getGeneratedCountKey(uid)) ?? 0;

  Future<String> _getPossiblePaths() async {
    List<String> paths = [];

    String basePath;

    // Get the external storage directory for pictures

    Directory? externalDir = await getExternalStorageDirectory();

    if (externalDir != null) {
      basePath = '${externalDir.path}/Pictures/';

      // Check for existing files

      for (int i = 0;; i++) {
        String filePath = '$basePath$name${i == 0 ? '' : i}$extension';

        if (await File(filePath).exists()) {
          paths.add(filePath);
        } else {
          // Stop when we find a non-existing file

          paths.add(filePath);

          break;
        }
      }
    }

    // Get the internal storage directory for pictures

    Directory appDocDir = await getApplicationDocumentsDirectory();

    basePath = '${appDocDir.path}/Pictures/';

    // Add the file path directly

    paths.add('$basePath$name$extension');

    return paths;
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

  /// Generate random bool.
  bool get _isMale => _faker.randomGenerator.boolean();

  /// Generate random `DateTime` object, between `1990-1-1` until `now`.
  DateTime get _doB => _faker.date.dateTimeBetween(DateTime(1990, 1, 1), DateTime.now());

  /// Generate random job/occupation title string.
  String get _occupation => _faker.job.title();
}
