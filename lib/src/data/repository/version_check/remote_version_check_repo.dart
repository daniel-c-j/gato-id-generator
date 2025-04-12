import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:version/version.dart';

import '../../../core/constants/_constants.dart';
import '../../../core/_core.dart';
import '../../model/version_check.dart';
import '../../../domain/repository/version_repo.dart';

class RemoteVersionCheckRepo implements VersionCheckRepo {
  const RemoteVersionCheckRepo(this._apiService);

  final ApiService _apiService;

  // ! Fetched data is expected to be in this particular format:
  // ! {"requiredV": "1.2.0", "latestV": "1.2.5"}
  // ! See VERSION.json for example.
  /// Fetch formatted version data.
  @override
  Future<VersionCheck> getVersionCheck() async {
    final response = await fetchLatestVersion();
    return _parseVersionFromResponse(response);
  }

  /// Fetch raw latest version data.
  Future<Response> fetchLatestVersion() async {
    return await _apiService.get(url: NetConsts.URL_CHECK_VERSION);
  }

  VersionCheck _parseVersionFromResponse(Response resp) {
    final mappedResp = json.decode(resp.data as String);
    final latestVer = _parseToVersion(mappedResp['latestV']);
    final currentVer = _parseToVersion(AppInfo.CURRENT_VERSION);
    final requiredToUpdateVer = _parseToVersion(mappedResp['requiredV']);

    return VersionCheck(
      latestVersion: latestVer,
      canUpdate: latestVer > currentVer,
      mustUpdate: requiredToUpdateVer > currentVer,
      requiredToUpdateVer: requiredToUpdateVer,
    );
  }

  Version _parseToVersion(String raw) => Version.parse(raw);

  @visibleForTesting
  VersionCheck parseVersionFromResponse(Response resp) => _parseVersionFromResponse(resp);

  @visibleForTesting
  Version parseToVersion(String raw) => _parseToVersion(raw);
}
