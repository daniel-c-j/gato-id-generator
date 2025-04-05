import 'package:flutter/material.dart';

import '../../../../../core/constants/_constants.dart';
import '../../../../../util/context_shortcut.dart';

class GatoIdContent extends StatelessWidget {
  const GatoIdContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "ID: ",
              textAlign: TextAlign.left,
              style: kTextStyle(context).bodyMedium,
            ),
            Text(
              "1729-2421-0323-9242",
              textAlign: TextAlign.left,
              style: kTextStyle(context).bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
            ),
          ],
        ),
        GAP_H4,
        Text(
          "Name: Biscuit Junior \n"
          "Date of Birth: 02-10-2016 \n"
          "Gender: Male \n"
          "Occupation: Cave diver \n",
          textAlign: TextAlign.left,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            "Made in: 02-04-2022",
            textAlign: TextAlign.right,
            style: kTextStyle(context).bodySmall,
          ),
        ),
      ],
    );
  }
}
