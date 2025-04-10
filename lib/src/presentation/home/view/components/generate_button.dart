// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gato_id_generator/src/core/theme/colors.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../util/context_shortcut.dart';
import '../../../_common_widgets/custom_button.dart';

// TODO remove to data layer
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
                kSnackBar(context).clearSnackBars();
                kSnackBar(context).showSnackBar(
                  const SnackBar(content: Text("Tap the button below, not the gato.")),
                );
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
                msg: "Generate ID",
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
                  "GENERATE",
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: kTextStyle(context)
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.5),
                ),
              ),
            ),
            // Overlay if not enabled.
            if (!enabled)
              Positioned(
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    if (!enabled) {
                      kSnackBar(context).clearSnackBars();
                      kSnackBar(context).showSnackBar(
                          const SnackBar(content: Text("Not yet brother! Maybe next update :)")));
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
