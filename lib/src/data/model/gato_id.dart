class GatoId {
  const GatoId({
    required this.uid,
    required this.name,
    required this.doB,
    required this.occupation,
    required this.madeIn,
  });

  final String uid;
  final String name;
  final DateTime doB;
  final String occupation;
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
