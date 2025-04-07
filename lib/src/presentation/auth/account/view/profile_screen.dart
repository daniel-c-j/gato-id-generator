import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_appbar.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_button.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/generic_snackbar.dart';
import 'package:gato_id_generator/src/presentation/auth/account/bloc/profile_bloc.dart';
import 'package:gato_id_generator/src/presentation/auth/account/view/components/profile_statistics.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/constants/_constants.dart';
import '../../../../util/context_shortcut.dart';
import '../../../_common_widgets/hud_overlay.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ProfileBloc>().getUser();

    // * Worst-scenario countermeasure
    if (user == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        context.pop();
      });

      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Profile".tr(), withBackIcon: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(BoxIcons.bxs_user_circle, size: 80),
                  Text(
                    user.email!,
                    style: kTextStyle(context).titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                  ),
                  Text("Unique Id: ${user.uid}"),
                  GAP_H16,
                  BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
                    // Showing HUD
                    if (state is ProfileLoading) context.read<HudControllerCubit>().show();

                    return CustomButton(
                      msg: "Sign out".tr(),
                      onTap: () {
                        context.read<ProfileBloc>().add(
                              ProfileSignOut(
                                onSuccess: () {
                                  // Need to close HUD in the callback since this screen will be popped out
                                  // immediately.
                                  context.read<HudControllerCubit>().hide();
                                  showTextSnackBar(context, txt: "Signed Out!");
                                },
                                onError: (e, st) => showErrorSnackBar(context, error: e),
                              ),
                            );
                      },
                      buttonColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.logout_outlined, color: Colors.black, size: 18),
                          GAP_W6,
                          Text(
                            "Sign out".tr(),
                            style: kTextStyle(context).bodyMedium?.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            GAP_H32,
            const ProfileStatistics(),
            GAP_H32,
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                msg: "Delete Account".tr(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onTap: () {
                  showUnimplementedSnackBar(context);
                },
                buttonColor: Colors.red,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete, size: 18),
                    GAP_W6,
                    Text("Delete Account".tr()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
