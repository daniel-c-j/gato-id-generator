import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/presentation/generate/bloc/generated_gato_id_bloc.dart';
import 'package:gato_id_generator/src/util/date_format.dart';

import '../../../../../core/constants/_constants.dart';
import '../../../../../util/context_shortcut.dart';

class GatoIdContent extends StatelessWidget {
  const GatoIdContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneratedGatoIdBloc, GeneratedGatoIdState>(
      builder: (context, state) {
        if (state is GeneratedGatoIdLoading) return const SizedBox.shrink();

        final gatoId = context.watch<GeneratedGatoIdBloc>().currentGatoId;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "ID: ".tr(),
                  textAlign: TextAlign.left,
                  style: kTextStyle(context).bodyMedium,
                ),
                Text(
                  // TODO use shimmer/skeletonizer instead
                  gatoId?.uid ?? "1729-2421-0323-9242",
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
              (gatoId != null)
                  ? "${"Name:".tr()} ${gatoId.name} \n"
                      "${"Date of Birth:".tr()} ${gatoId.doB.formatTime} \n"
                      "${"Gender:".tr()} ${(gatoId.isMale) ? "Male".tr() : "Female".tr()} \n"
                      "${"Occupation:".tr()} ${gatoId.occupation} \n"

//
                  : "${"Name:".tr()} Biscuit Junior \n"
                      "${"Date of Birth:".tr()} 02-10-2016 \n"
                      "${"Gender:".tr()} ${"Male".tr()} \n"
                      "${"Occupation:".tr()} Cave diver \n",
              textAlign: TextAlign.left,
              style: kTextStyle(context).bodySmall,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "${"Made in:".tr()} ${gatoId?.madeIn.formatTime ?? "02-04-2022"}",
                    textAlign: TextAlign.right,
                    style: kTextStyle(context).bodySmall,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
