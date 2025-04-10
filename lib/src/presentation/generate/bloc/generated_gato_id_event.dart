// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'generated_gato_id_bloc.dart';

@immutable
abstract class GeneratedGatoIdEvent {}

class GenerateGatoId implements GeneratedGatoIdEvent {
  GenerateGatoId({
    required this.onSuccess,
    required this.onError,
  });

  final VoidCallback onSuccess;
  final void Function(Object? e, StackTrace st) onError;

  @override
  String toString() => 'GenerateGatoId(onSuccess: $onSuccess, onError: $onError)';

  @override
  bool operator ==(covariant GenerateGatoId other) {
    if (identical(this, other)) return true;

    return other.onSuccess == onSuccess && other.onError == onError;
  }

  @override
  int get hashCode => onSuccess.hashCode ^ onError.hashCode;
}

class SaveGeneratedGatoId implements GeneratedGatoIdEvent {
  SaveGeneratedGatoId({
    required this.value,
    required this.onSuccess,
    required this.onError,
  });

  final Uint8List value;
  final VoidCallback onSuccess;
  final void Function(Object? e, StackTrace st) onError;

  @override
  bool operator ==(covariant SaveGeneratedGatoId other) {
    if (identical(this, other)) return true;

    return other.value == value && other.onSuccess == onSuccess && other.onError == onError;
  }

  @override
  int get hashCode => value.hashCode ^ onSuccess.hashCode ^ onError.hashCode;

  @override
  String toString() => 'SaveGeneratedGatoId(value: $value, onSuccess: $onSuccess, onError: $onError)';
}

class DeleteGeneratedGatoId implements GeneratedGatoIdEvent {
  DeleteGeneratedGatoId({
    required this.id,
    required this.onSuccess,
    required this.onError,
  });

  final String id;
  final VoidCallback onSuccess;
  final void Function(Object? e, StackTrace st) onError;

  @override
  String toString() => 'DeleteGeneratedGatoId(id: $id, onSuccess: $onSuccess, onError: $onError)';

  @override
  bool operator ==(covariant DeleteGeneratedGatoId other) {
    if (identical(this, other)) return true;

    return other.id == id && other.onSuccess == onSuccess && other.onError == onError;
  }

  @override
  int get hashCode => id.hashCode ^ onSuccess.hashCode ^ onError.hashCode;
}
