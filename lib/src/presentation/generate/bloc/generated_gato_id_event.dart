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
