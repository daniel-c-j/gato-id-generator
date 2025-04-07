// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Statistic values to be displayed in [ProfileScreen].
class GatoIdStat {
  const GatoIdStat({
    required this.generatedCount,
    required this.savedCount,
  });

  final int generatedCount;
  final int savedCount;

  @override
  bool operator ==(covariant GatoIdStat other) {
    if (identical(this, other)) return true;

    return other.generatedCount == generatedCount && other.savedCount == savedCount;
  }

  @override
  int get hashCode => generatedCount.hashCode ^ savedCount.hashCode;

  @override
  String toString() => 'GatoIdStat(generatedCount: $generatedCount, savedCount: $savedCount)';
}
