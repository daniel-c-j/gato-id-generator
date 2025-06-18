import 'package:bloc/bloc.dart';
import '../exceptions/_exceptions.dart';

class AppBlocObserver extends BlocObserver {
  /// Custom [BlocObserver] that focuses on collection errors and delivering it to
  /// the global error handler.
  const AppBlocObserver(this._errorLogger);

  final ErrorLogger _errorLogger;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _errorLogger.log("${bloc.toString()}/n/n${error.toString()}", stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
