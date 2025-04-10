// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/generic_snackbar.dart';
import 'package:go_router/go_router.dart';

import 'package:gato_id_generator/src/core/theme/colors.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../util/context_shortcut.dart';
import '../../../_common_widgets/custom_button.dart';

// TODO move to data layer
enum AnimalType {
  cat,
  dog,
}

class HomeGenerateButton extends StatelessWidget {
  const HomeGenerateButton({super.key, required this.enabled, required this.type});

  final bool enabled;
  final AnimalType type;

  static const double width = 145;
  static const double height = 200;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: (enabled)
            ? const [BoxShadow(blurRadius: 3, color: PRIMARY_COLOR_D2)]
            : const [BoxShadow(blurRadius: 1.5)],
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (!enabled) return;
                showTextSnackBar(context, txt: "Tap the button below, not the gato.".tr());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  (type == AnimalType.dog) ? "assets/images/gato/marco.jpg" : "assets/images/gato/pollo.jpg",
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: CustomButton(
                msg: "Generate ID".tr(),
                onTap: () async {
                  if (!enabled) return;
                  await context.pushNamed(AppRoute.generate.name);
                },
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                buttonColor: kColor(context).surfaceDim,
                child: Text(
                  "GENERATE".tr(),
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: kTextStyle(context)
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.5),
                ),
              ),
            ),
            // show overlay if not enabled.
            if (!enabled)
              Positioned(
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    if (!enabled) {
                      showTextSnackBar(context, txt: "Not yet brother! Maybe next update :)".tr());
                      return;
                    }
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withAlpha(60),
                    ),
                    child: SizedBox(
                      width: width,
                      child: Center(
                        child: Text(
                          "Not available yet.".tr(),
                          style: kTextStyle(context).bodyMedium?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
