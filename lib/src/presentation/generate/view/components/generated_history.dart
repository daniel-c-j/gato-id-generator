import 'package:flutter/material.dart';

import '../../../../core/constants/_constants.dart';
import '../../../../util/context_shortcut.dart';

class GeneratedHistory extends StatelessWidget {
  const GeneratedHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Generated IDs (8)",
            style: kTextStyle(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        GAP_H2,
        const Divider(thickness: 0.75, height: 0, indent: 12, endIndent: 12),
        SizedBox(
          height: 40 * 10, // TODO
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(index.toString()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
