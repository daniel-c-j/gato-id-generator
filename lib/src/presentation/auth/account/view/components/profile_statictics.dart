import 'package:flutter/material.dart';

import '../../../../../core/constants/_constants.dart';
import '../../../../../util/context_shortcut.dart';

class ProfileStatictics extends StatelessWidget {
  const ProfileStatictics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bar_chart, size: 20),
            GAP_W8,
            Text(
              "Statistics",
              textAlign: TextAlign.left,
              style: kTextStyle(context).bodyLarge?.copyWith(
                    height: 0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        GAP_H4,
        const Divider(thickness: 0.75, height: 0),
        GAP_H4,
        Text("Gato Id generated: 8"),
        Text("Gato Id saved: 3"),
      ],
    );
  }
}
