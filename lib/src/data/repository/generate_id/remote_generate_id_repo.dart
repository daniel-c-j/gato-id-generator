import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:gato_id_generator/src/data/model/gato_id_content.dart';
import 'package:gato_id_generator/src/data/model/gato_id_stat.dart';
import 'package:gato_id_generator/src/domain/repository/generate_id_repo.dart';
import 'package:gato_id_generator/src/util/date_format.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/_core.dart';
import '../../../core/constants/_constants.dart';
import '../../../core/exceptions/_exceptions.dart';

class RemoteGenerateIdRepo implements GenerateIdRepo {
  RemoteGenerateIdRepo(this._firestore, this._apiService);
  final FirebaseFirestore _firestore;
  final ApiService _apiService;

  final _faker = getIt<Faker>();

  /// Generate [GatoId] object.
  @override
  GatoId generate() {
    return GatoId(
      uid: _generateId,
      name: _name,
      isMale: _isMale,
      doB: _doB,
      occupation: _occupation,
      madeIn: DateTime.now(),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAllGeneratedImages({required String uid}) async {
    try {
      final QuerySnapshot images = await _firestore.collection('users').doc(uid).collection('image').get();

      // Assuming the data is in the format {String: String}
      final tempList = <Map<String, dynamic>>[];
      for (var imageData in images.docs) {
        final data = imageData.data();
        if (data is Map<String, dynamic>) tempList.add(data);
      }

      return tempList;
    } catch (e) {
      return [];
    }
  }
  // TODO delete

  @override
  FutureOr<GatoIdStat> getLatestStats({required String uid}) async {
    final generatedCount = await _getGeneratedCountStats(uid);
    final savedImages = await getAllGeneratedImages(uid: uid);

    savedImages.sort((a, b) => a.entries.first.value.compareTo(b.entries.first.value));
    return GatoIdStat(
      generatedCount: generatedCount,
      savedImages: savedImages,
    );
  }

  @override
  Future<void> incrementAndSaveStats({required String uid}) async {
    await _firestore.collection('users').doc(uid).set({
      DBKeys.GENERATED_ID_COUNT: await _getGeneratedCountStats(uid) + 1,
    });
  }

  Future<int> _getGeneratedCountStats(String uid) async {
    try {
      final docStats = await _firestore.collection('users').doc(uid).get();
      return docStats.data()?[DBKeys.GENERATED_ID_COUNT] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> saveGenerated(String uuid, Uint8List value, {required String uid}) async {
    if (await Permission.storage.request().isGranted) {
      final formattedName = "${DateTime.now().formatTime}-$uuid";

      // Generate & Save image
      final result = await ImageGallerySaverPlus.saveImage(
        value,
        name: "$formattedName-${uid.replaceFirst("@", "")}",
      );

      // Post image file
      final imageUrl = await _apiService.post(
        url: NetConsts.URL_SAVED_GATO_IMG_API,
        data: FormData.fromMap({
          "reqtype": "fileupload",
          "fileToUpload": await MultipartFile.fromFile(result["filePath"].replaceFirst("file://", ""))
        }),
      );

      // Post image file's url
      return await _firestore
          .collection('users')
          .doc(uid)
          .collection('image')
          .doc()
          .set({formattedName: imageUrl.data});
    }

    throw const AccessNotGrantedException();
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
