import 'package:bloc/bloc.dart';
import '../exceptions/_exceptions.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._errorLogger);

  final ErrorLogger _errorLogger;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _errorLogger.log("${bloc.toString()}/n${error.toString()}", stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
