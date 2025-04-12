import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/presentation/about/components/about_icon_button.dart';
import 'package:gato_id_generator/src/presentation/auth/account/bloc/profile_bloc.dart';
import 'package:gato_id_generator/src/presentation/auth/account/view/components/profile_icon_button.dart';
import 'package:gato_id_generator/src/presentation/home/view/components/theme_icon_button.dart';
import 'package:gato_id_generator/src/presentation/version_check/bloc/version_check_bloc.dart';
import 'package:marqueer/marqueer.dart';

import '../../../core/constants/_constants.dart';
import '../../../data/model/app_user/app_user.dart';
import '../../../util/context_shortcut.dart';
import '../../_common_widgets/custom_appbar.dart';
import '../../version_check/view/version_update_dialog.dart';
import 'components/generate_button.dart';

bool _isUpdateChecked = false;

/// This is needed since local `watchUser()` is always start from null, and authstate currently does not
/// update the UI if it solely depends on synchronous `getUser()`, so one possible approach is by using
/// synchronous `getUser()` first to eliminate false-null value, then followed by `watchUser()`.
bool _isFirstTime = true;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const mottoKey = Key("HomeScreenMotto");
  static const gatoKey = Key("HomeScreenGatoKey");
  static const dogKey = Key("HomeScreenDogKeyy");

  @override
  Widget build(BuildContext context) {
    if (!_isUpdateChecked) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _isUpdateChecked = true; // Flagging.

        final event = CheckVersionData(onSuccess: (ver) async {
          context.read<VersionCheckBloc>().close();

          if (!ver.canUpdate) return;
          return await VersionUpdateDialog.show(context, ver);
          //
        }, onError: (e, __) async {
          context.read<VersionCheckBloc>().close();
          return await VersionUpdateDialog.showErrorInstead(context, e: e);
        });

        context.read<VersionCheckBloc>().add(event);
      });
    }

    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Tap again to exit".tr())),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                title: "Gato Id Generator".tr(),
                withBackIcon: false,
                additionalActions: [
                  const ThemeIconButton(),
                  const AboutIconButton(),
                  StreamBuilder<AppUser?>(
                    stream: context.watch<ProfileBloc>().watchUser(),
                    builder: (context, snapshot) {
                      late final AppUser? user;
                      // When it's the first time, it's better to get the value synchronously
                      if (_isFirstTime) {
                        user = context.watch<ProfileBloc>().getUser();
                        _isFirstTime = false;
                      } else {
                        // After that, everything will depends on authStateChange.
                        user = snapshot.data;
                      }

                      if (user != null) return const ProfileIconButton();
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              GAP_H12,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'And thus, Artificial Intelligence answered, \n'
                  '"Cats are charmingly quirky companions, '
                  'blending playfulness with an air of independence."',
                  key: mottoKey,
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
                          HomeGenerateButton(enabled: true, type: AnimalType.cat, buttonKey: gatoKey),
                          HomeGenerateButton(enabled: false, type: AnimalType.dog, buttonKey: dogKey),
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

/// Widget showing marquee-like automatically scrolling gato ids.
class GatoLine extends StatelessWidget {
  const GatoLine({super.key, this.autoStartAfter, this.color, this.reverse = false});

  final Duration? autoStartAfter;
  final Color? color;
  final bool reverse;

  static const double height = 150;

  @override
  Widget build(BuildContext context) {
    final images = [
      for (var i = 0; i < 8; i++)
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Image.asset(
            "./assets/images/id/0${i + 1}.png",
            width: 240,
            height: height,
            opacity: const AlwaysStoppedAnimation(0.6),
          ),
        )
    ];
    // * To make the images appear randomly.
    images.shuffle();

    return SizedBox(
      height: height,
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
