import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/_core.dart';
import '../../../../util/context_shortcut.dart';
import '../../../_common_widgets/custom_button.dart';

/// Change the theme of the app.
class ThemeIconButton extends StatelessWidget {
  const ThemeIconButton({super.key});

  static const buttonKey = Key("ThemeIconButton");

  @override
  Widget build(BuildContext context) {
    // PlatformBrightnessBloc provider scope is global.
    final mode = context.watch<PlatformBrightnessBloc>().state;

    return CustomButton(
      key: buttonKey,
      msg: "Switch dark/light theme".tr(),
      padding: const EdgeInsets.all(10),
      buttonColor: Colors.transparent,
      borderRadius: BorderRadius.circular(60),
      onTap: () async {
        final value = (mode == Brightness.light) ? Brightness.dark : Brightness.light;
        context.read<PlatformBrightnessBloc>().add(BrightnessChange(to: value));
      },
      child: Icon(
        BoxIcons.bx_brightness_half,
        color: kColor(context).inverseSurface,
      ),
    );
  }
}
