import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/constants/_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../util/context_shortcut.dart';
import '../../../_common_widgets/custom_button.dart';

class HomeGenerateButton extends StatelessWidget {
  const HomeGenerateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              kSnackBar(context).showSnackBar(
                SnackBar(content: Text("Tap the button below, not the gato.")),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset("assets/images/gato/pollo.jpg", fit: BoxFit.fitWidth),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: CustomButton(
              msg: "Generate ID",
              onTap: () async {
                await context.pushNamed(AppRoute.generate.name);
              },
              elevation: 3,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              buttonColor: kColor(context).surfaceDim,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(BoxIcons.bxs_cat, size: 20),
                      GAP_W8,
                      Text(
                        "GENERATE",
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: kTextStyle(context)
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
