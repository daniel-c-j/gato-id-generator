import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../core/_core.dart';
import '../../util/context_shortcut.dart';
import '../home/view/components/theme_icon_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.withThemeIcon,
    required this.withBackIcon,
  });

  final String title;
  final bool withThemeIcon;
  final bool withBackIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              height: 64,
              width: double.maxFinite,
              child: Row(
                spacing: 8,
                children: [
                  if (withBackIcon) const BackIconButton(),
                  Builder(builder: (context) {
                    final isLight = context.watch<PlatformBrightnessBloc>().state == Brightness.light;
                    return GradientText(
                      title,
                      style: kTextStyle(context).titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
                    );
                  }),
                  const Spacer(),
                  if (withThemeIcon) const ThemeIconButton(),
                ],
              ),
            ),
          ),
        ),
        const Divider(thickness: 0.75, height: 0, indent: 12, endIndent: 12),
      ],
    );
  }
}

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  static const buttonKey = Key("BackIconButton");

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      key: buttonKey,
      msg: "Back".tr(),
      padding: const EdgeInsets.all(10),
      buttonColor: Colors.transparent,
      borderRadius: BorderRadius.circular(60),
      onTap: () {
        context.pop();
      },
      child: Icon(
        Icons.arrow_back,
        color: kColor(context).inverseSurface,
      ),
    );
  }
}
