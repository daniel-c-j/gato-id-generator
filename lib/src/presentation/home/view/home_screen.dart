import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../version_check/bloc/version_check_bloc.dart';
import 'components/theme_icon_button.dart';

bool _isUpdateChecked = false;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VersionCheckBloc(),
      child: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Tap again to exit".tr())),
        child: Scaffold(
          body: Builder(builder: (context) {
            if (!_isUpdateChecked) {
              // SchedulerBinding.instance.addPostFrameCallback((_) {
              //   context.read<VersionCheckBloc>().add(
              //         CheckVersionData(onSuccess: (_) {
              //           // TODO
              //         }, onError: (_, __) {
              //           // TODO
              //         }),
              //       );

              //   _isUpdateChecked = true;
              // });
            }

            return ThemeIconButton();
          }),
        ),
      ),
    );
  }
}
