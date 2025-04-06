import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/core/_core.dart';
import 'package:marqueer/marqueer.dart';

import '../../../core/constants/_constants.dart';
import '../../../util/context_shortcut.dart';
import '../../_common_widgets/custom_appbar.dart';
import 'components/generate_button.dart';

bool _isUpdateChecked = false;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Tap again to exit".tr())),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(
                title: "Gato Id Generator",
                withThemeIcon: true,
                withBackIcon: false,
              ),
              GAP_H12,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'And thus, Artificial Intelligence answered, \n'
                  '"Cats are charmingly quirky companions, blending playfulness with an air of independence."',
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: kTextStyle(context).bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              GAP_H12,
              const GatoLine(),
              GAP_H12,
              const HomeGenerateButton(),
              GAP_H12,
              const GatoLine(autoStartAfter: Duration(milliseconds: 800)),
              GAP_H12,
            ],
          ),
        ),
      ),
    );
  }
}

class GatoLine extends StatelessWidget {
  const GatoLine({super.key, this.autoStartAfter, this.color});

  final Duration? autoStartAfter;
  final Color? color;
// TODO replace this with cat result picture or meme.
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? kColor(context).surfaceDim,
        gradient: LinearGradient(
          colors: (context.watch<PlatformBrightnessBloc>().state == Brightness.dark)
              ? [
                  PRIMARY_COLOR_D0,
                  PRIMARY_COLOR_D1,
                  PRIMARY_COLOR_D2,
                ]
              : [
                  PRIMARY_COLOR_L0,
                  PRIMARY_COLOR_L1,
                  PRIMARY_COLOR_L2,
                ],
        ),
      ),
      child: SizedBox(
        height: 20,
        child: Marqueer(
          interaction: false,
          autoStart: true,
          autoStartAfter: autoStartAfter ?? Duration.zero,
          child: const Text(" GATO "),
        ),
      ),
    );
  }
}
