import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/core/routing/app_router.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

import '../../../../../util/context_shortcut.dart';

/// See profile of the currentUser if authenticated.
class ProfileIconButton extends StatelessWidget {
  const ProfileIconButton({super.key});

  static const buttonKey = Key("ProfileIconButton");

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      key: buttonKey,
      msg: "Go to profile".tr(),
      padding: const EdgeInsets.all(10),
      buttonColor: Colors.transparent,
      borderRadius: BorderRadius.circular(60),
      onTap: () {
        context.pushNamed(AppRoute.profile.name);
      },
      child: Icon(
        Icons.person_4,
        color: kColor(context).inverseSurface,
      ),
    );
  }
}
