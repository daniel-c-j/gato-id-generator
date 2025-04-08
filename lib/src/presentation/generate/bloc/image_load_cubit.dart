import 'package:bloc/bloc.dart';

class ImageIsLoadedCubit extends Cubit<bool> {
  ImageIsLoadedCubit() : super(false);

  set value(bool val) => emit(val);
}
