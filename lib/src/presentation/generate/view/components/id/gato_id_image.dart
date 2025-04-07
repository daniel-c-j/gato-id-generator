import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/core/app/di.dart';
import 'package:gato_id_generator/src/core/constants/network_constants.dart';
import 'package:gato_id_generator/src/presentation/generate/bloc/generated_gato_id_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../../util/context_shortcut.dart';

class GatoIdImage extends StatelessWidget {
  const GatoIdImage({super.key});

  Widget get _loadingIndicator => Center(
        child: const SizedBox.square(
          dimension: 48,
          child: CircularProgressIndicator(),
        ),
      );

  Widget get _errorIndicator => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            BoxIcons.bxs_cat,
            color: Colors.red,
            shadows: [BoxShadow(blurRadius: 3)],
          ),
          Text("Error fetching image", textAlign: TextAlign.center),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final innerConstraint = kScreenWidth(context) * 0.275;
    // Bigger a little bit so that image don't have to be way to blurry.
    final innerConstraintInt = (innerConstraint * 2.5).round();

    return SizedBox(
      width: kScreenWidth(context) * 0.325,
      child: BlocBuilder<GeneratedGatoIdBloc, GeneratedGatoIdState>(builder: (context, state) {
        // Will be renewed each state update/screen enters.
        final imageUuid = getIt<Random>().nextDouble().toString();

        if (state is GeneratedGatoIdLoading) return _loadingIndicator;

        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: NetConsts.URL_GATO_IMG,
              width: innerConstraint,
              height: innerConstraint,
              fit: BoxFit.cover,
              placeholder: (context, url) => _loadingIndicator,
              errorWidget: (context, url, error) => _errorIndicator,
              maxHeightDiskCache: innerConstraintInt,
              maxWidthDiskCache: innerConstraintInt,
              memCacheHeight: innerConstraintInt,
              memCacheWidth: innerConstraintInt,
              cacheKey: imageUuid,
            ),
            // Overlay
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withAlpha(45)),
              child: SizedBox(
                width: innerConstraint,
                height: innerConstraint,
              ),
            ),
            CachedNetworkImage(
              imageUrl: NetConsts.URL_GATO_IMG,
              width: innerConstraint,
              height: innerConstraint,
              placeholder: (context, url) => _loadingIndicator,
              errorWidget: (context, url, error) => _errorIndicator,
              maxHeightDiskCache: innerConstraintInt,
              maxWidthDiskCache: innerConstraintInt,
              memCacheHeight: innerConstraintInt,
              memCacheWidth: innerConstraintInt,
              cacheKey: imageUuid,
            ),
          ],
        );
      }),
    );
  }
}
