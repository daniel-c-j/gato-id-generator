import 'package:bloc/bloc.dart';

import '../_core.dart';
import '../exceptions/_exceptions.dart';

class AppBlocObserver extends BlocObserver {
  final _errorLogger = getIt<ErrorLogger>();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _errorLogger.log("${bloc.toString()}/n${error.toString()}", stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
