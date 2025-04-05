import 'package:flutter/material.dart';

import '../../../../../util/context_shortcut.dart';

class GatoIdImage extends StatelessWidget {
  const GatoIdImage({super.key});

  @override
  Widget build(BuildContext context) {
    final innerConstraint = kScreenWidth(context) * 0.3;

    return SizedBox(
      width: kScreenWidth(context) * 0.325,
      child: Stack(
        children: [
          Image.asset(
            "assets/images/gato/pollo.jpg",
            fit: BoxFit.cover,
            width: innerConstraint,
            height: innerConstraint,
            opacity: AlwaysStoppedAnimation(0.6),
          ),
          Image.asset(
            "assets/images/gato/pollo.jpg",
            width: innerConstraint,
            height: innerConstraint,
          ),
        ],
      ),
    );
  }
}
