import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/presentation/generate/view/components/id/gato_id_content.dart';
import 'package:gato_id_generator/src/presentation/generate/view/components/id/gato_id_image.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../../core/constants/_constants.dart';
import '../../../../../util/context_shortcut.dart';

class GatoIdCard extends StatelessWidget {
  const GatoIdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: kColor(context).surfaceDim,
        borderRadius: BorderRadius.circular(kScreenWidth() * 0.05),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 2),
        ],
      ),
      child: SizedBox(
        width: kScreenWidth(context),
        height: kScreenWidth(context) * 0.575,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            children: [
              const GatoIdTitle(),
              GAP_H4,
              const Divider(thickness: 0.75, height: 0, indent: 12, endIndent: 12),
              GAP_H12,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GatoIdImage(),
                  const Expanded(child: GatoIdContent()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GatoIdTitle extends StatelessWidget {
  const GatoIdTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(BoxIcons.bxs_cat, size: 20),
        GAP_W8,
        Text(
          "Gato ID",
          style: kTextStyle(context).titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 0,
              ),
        ),
      ],
    );
  }
}
