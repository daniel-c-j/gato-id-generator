import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/presentation/auth/account/bloc/profile_bloc.dart';
import 'package:gato_id_generator/src/presentation/auth/account/view/components/profile_icon_button.dart';
import 'package:gato_id_generator/src/presentation/home/view/components/theme_icon_button.dart';
import 'package:marqueer/marqueer.dart';

import '../../../core/constants/_constants.dart';
import '../../../data/model/app_user/app_user.dart';
import '../../../util/context_shortcut.dart';
import '../../_common_widgets/custom_appbar.dart';
import 'components/generate_button.dart';

bool _isUpdateChecked = false;

/// This is needed since local `watchUser()` is always start from null, and authstate currently does not
/// update the UI if it solely depends on synchronous `getUser()`, so one possible approach is by using
/// synchronous `getUser()` first to eliminate false-null value, then followed by `watchUser()`.
bool _isFirstTime = true;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_isUpdateChecked) {
      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   context.read<VersionCheckBloc>().add(
      //         CheckVersionData(onSuccess: (_) {
      //           // TODO
      //         }, onError: (_, __) {
      //           // TODO
      //         }),
      //       );

      //   _isUpdateChecked = true;
      // context.read<VersionCheckBloc>().close();

      // });
    }

    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Tap again to exit".tr())),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: context.watch<ProfileBloc>().watchUser(),
                builder: (context, snapshot) {
                  late final AppUser? user;
                  if (_isFirstTime) {
                    user = context.watch<ProfileBloc>().getUser();
                    _isFirstTime = false;
                  } else {
                    user = snapshot.data;
                  }

                  return CustomAppBar(
                    title: "Gato Id Generator",
                    withBackIcon: false,
                    additionalActions: [
                      const ThemeIconButton(),
                      if (user != null) const ProfileIconButton(),
                    ],
                  );
                },
              ),
              GAP_H12,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'And thus, Artificial Intelligence answered, \n'
                  '"Cats are charmingly quirky companions, blending playfulness with an air of independence."',
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: kTextStyle(context).bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              GAP_H12,
              const Stack(
                children: [
                  Column(
                    children: [
                      GatoLine(),
                      GAP_H12,
                      GatoLine(reverse: true, autoStartAfter: Duration(milliseconds: 1200)),
                      GAP_H12,
                      GatoLine(autoStartAfter: Duration(milliseconds: 1200)),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 135.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HomeGenerateButton(enabled: true, type: AnimalType.cat),
                          HomeGenerateButton(enabled: false, type: AnimalType.dog),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              GAP_H12,
            ],
          ),
        ),
      ),
    );
  }
}

class GatoLine extends StatelessWidget {
  const GatoLine({super.key, this.autoStartAfter, this.color, this.reverse = false});

  final Duration? autoStartAfter;
  final Color? color;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final images = [
      for (var i = 0; i < 8; i++)
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Image.asset(
            "./assets/images/id/0${i + 1}.png",
            width: 240,
            height: 150,
            opacity: const AlwaysStoppedAnimation(0.6),
          ),
        )
    ];
    // To make the images appear randomly.
    images.shuffle();

    return SizedBox(
      height: 150,
      child: Marqueer(
        interaction: false,
        autoStart: true,
        infinity: true,
        direction: (reverse) ? MarqueerDirection.rtl : MarqueerDirection.ltr,
        autoStartAfter: autoStartAfter ?? Duration.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: images,
        ),
      ),
    );
  }
}
