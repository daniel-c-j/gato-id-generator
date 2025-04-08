import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/presentation/generate/bloc/generated_gato_id_bloc.dart';

import '../../../../../core/constants/_constants.dart';
import '../../../../../util/context_shortcut.dart';

class ProfileStatistics extends StatelessWidget {
  const ProfileStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final stat = context.watch<GeneratedGatoIdBloc>().latestStat;
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
        Text("Gato Id generated: ${stat.generatedCount}"),
        Text("Gato Id saved:  ${stat.savedImages.length}"),
      ],
    );
  }
}
