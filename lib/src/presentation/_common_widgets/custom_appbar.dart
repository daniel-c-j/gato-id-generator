import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../core/_core.dart';
import '../../util/context_shortcut.dart';

/// Pre-defined appbar with some configurations.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.withBackIcon,
    this.additionalActions = const [],
  });

  final String title;
  final bool withBackIcon;
  final List<Widget> additionalActions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      scrolledUnderElevation: 0,
      actions: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                height: 0,
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
                      ...additionalActions,
                    ],
                  ),
                ),
              ),
              const Divider(thickness: 0.75, height: 0),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 64);
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
      child: const SizedBox.square(
        dimension: 22,
        child: Stack(
          children: [
            Positioned(
              left: -1.5,
              bottom: -0.5,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
