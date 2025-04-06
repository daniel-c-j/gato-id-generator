import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/_core.dart';
import '../../../../util/context_shortcut.dart';
import '../../../_common_widgets/custom_button.dart';

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
                  PRIMARY_COLOR_L0,
                  PRIMARY_COLOR_L1,
                  PRIMARY_COLOR_L2,
                ]
              : const [
                  PRIMARY_COLOR_D0,
                  PRIMARY_COLOR_D1,
                  PRIMARY_COLOR_D2,
                ],
        ),
        boxShadow: const [
          // BoxShadow(color: Colors.black, offset: Offset(0, 1.5), blurRadius: 2),
        ],
      ),
      child: CustomButton(
        msg: "Generate ID",
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        buttonColor: Colors.transparent,
        child: Text(
          "Generate ID",
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: kTextStyle(context).bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class SaveGeneratedButton extends StatelessWidget {
  const SaveGeneratedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: const [
            Color.fromARGB(255, 15, 217, 119),
            Color.fromARGB(255, 36, 150, 40),
          ],
        ),
        boxShadow: const [
          // BoxShadow(color: Colors.black, offset: Offset(0, 1.5), blurRadius: 2),
        ],
      ),
      child: CustomButton(
        msg: "Save",
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        buttonColor: Colors.transparent,
        child: Text(
          "Save",
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: kTextStyle(context).bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
