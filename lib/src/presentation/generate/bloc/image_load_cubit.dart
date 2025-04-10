import 'package:bloc/bloc.dart';

/// To improve flexibility in the UX from the [GeneratedGatoIdBloc], this cubit exists.
class ImageIsLoadedCubit extends Cubit<bool> {
  ImageIsLoadedCubit() : super(false);

  set value(bool val) => emit(val);
}
