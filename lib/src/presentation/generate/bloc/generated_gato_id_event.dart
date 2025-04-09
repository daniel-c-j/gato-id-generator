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
}
