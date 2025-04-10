import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/core/exceptions/app_exception.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/generic_snackbar.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/hud_overlay.dart';
import 'package:gato_id_generator/src/presentation/generate/bloc/generated_gato_id_bloc.dart';
import 'package:gato_id_generator/src/util/delay.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../../core/_core.dart';
import '../../../../util/context_shortcut.dart';
import '../../../_common_widgets/custom_button.dart';
import '../../bloc/image_load_cubit.dart';

/// Button to generate new card id.
class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = context.watch<PlatformBrightnessBloc>().state == Brightness.light;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: (isLight)
              ? const [
                  PRIMARY_COLOR_D0,
                  PRIMARY_COLOR_D1,
                  PRIMARY_COLOR_D2,
                ]
              : const [
                  PRIMARY_COLOR_L0,
                  PRIMARY_COLOR_L1,
                  PRIMARY_COLOR_L2,
                ],
        ),
      ),
      child: CustomButton(
        msg: "Generate ID".tr(),
        onTap: () {
          final bloc = context.read<GeneratedGatoIdBloc>();
          if (bloc.state is GeneratedGatoIdSaving || bloc.state is GeneratedGatoIdLoading) return;
          bloc.add(
            GenerateGatoId(
              onSuccess: () {},
              onError: (e, st) {
                showErrorSnackBar(context, error: e);
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        buttonColor: Colors.transparent,
        child: Text(
          "Generate ID".tr(),
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: kTextStyle(context).bodyMedium?.copyWith(color: kColor(context).surface),
        ),
      ),
    );
  }
}

/// Button to save the generated card id.
class SaveGeneratedButton extends StatelessWidget {
  const SaveGeneratedButton({super.key, required this.controller});

  final WidgetsToImageController controller;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GeneratedGatoIdBloc>();
    final imageIsLoaded = context.watch<ImageIsLoadedCubit>().state;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: (!imageIsLoaded ||
                  (bloc.currentGatoId == null ||
                      bloc.state is GeneratedGatoIdLoading ||
                      bloc.state is GeneratedGatoIdSaving))
              ? const [
                  Color.fromARGB(120, 15, 217, 119),
                  Color.fromARGB(120, 36, 150, 40),
                ]
              : const [
                  Color.fromARGB(255, 15, 217, 119),
                  Color.fromARGB(255, 36, 150, 40),
                ],
        ),
      ),
      child: CustomButton(
        msg: "Save".tr(),
        onTap: () async {
          if (!imageIsLoaded) return;
          if (bloc.currentGatoId == null) return; // Does nothing if yet generate a thing.
          if (bloc.state is GeneratedGatoIdSaving || bloc.state is GeneratedGatoIdLoading) return;

          context.read<HudControllerCubit>().show();
          final value = await controller.capture();

          // ignore: use_build_context_synchronously
          if (value == null) return showErrorSnackBar(context, error: const SaveImageFailedException());

          bloc.add(
            SaveGeneratedGatoId(
              value: value,
              onSuccess: () {
                // Indicating that the card is saved, and the button should not be enabled until
                // generating new one.
                SchedulerBinding.instance.addPostFrameCallback((_) async {
                  await delay(true, 300); // Waits a little bit
                  // ignore: use_build_context_synchronously
                  context.read<ImageIsLoadedCubit>().value = false;
                });

                context.read<HudControllerCubit>().hide();
              },
              onError: (e, st) {
                context.read<HudControllerCubit>().hide();
                showErrorSnackBar(context, error: e);
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        buttonColor: Colors.transparent,
        child: Text(
          "Save".tr(),
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: kTextStyle(context).bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
