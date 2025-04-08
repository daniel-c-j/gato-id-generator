import 'package:flutter/foundation.dart';

/// Generated statistic values.
class GatoIdStat {
  const GatoIdStat({
    required this.generatedCount,
    required this.savedImages,
  });

  final int generatedCount;
  final List<String> savedImages;

  @override
  bool operator ==(covariant GatoIdStat other) {
    if (identical(this, other)) return true;

    return other.generatedCount == generatedCount && listEquals(other.savedImages, savedImages);
  }

  @override
  int get hashCode => generatedCount.hashCode ^ savedImages.hashCode;

  @override
  String toString() => 'GatoIdStat(generatedCount: $generatedCount, savedImages: $savedImages)';
}
