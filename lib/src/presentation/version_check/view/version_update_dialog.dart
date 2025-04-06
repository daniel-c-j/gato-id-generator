import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../_common_widgets/custom_button.dart';
import '../../../core/constants/_constants.dart';
import '../../../core/_core.dart';
import '../../../util/context_shortcut.dart';
import '../../../data/model/version_check.dart';

/// Content of the version update dialog.
class VersionUpdateDialog extends StatelessWidget {
  const VersionUpdateDialog(this.versionCheck, {super.key});

  final VersionCheck versionCheck;

  static Future<void> show(BuildContext context, VersionCheck ver) async {
    return await showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.all(16),
        content: VersionUpdateDialog(ver),
      ),
    );
  }

  static Future<void> showErrorInstead(BuildContext context, {required Object? e}) async {
    kSnackBar(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text("Check version error: ${e.toString()}"),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${"New update".tr()} v${versionCheck.latestVersion} ${versionCheck.mustUpdate ? "is required".tr() : ""}",
          textAlign: TextAlign.center,
          style: kTextStyle(context).titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        const Divider(),
        GAP_H4,
        Text(
          "There is a new improved version of this app.".tr(),
          textAlign: TextAlign.center,
          style: kTextStyle(context).bodyMedium,
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        GAP_H16,
        CustomButton(
          msg: "Go to download page".tr(),
          buttonColor: PRIMARY_COLOR_D0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: () async => await launchUrlString(NetConsts.URL_UPDATE_VERSION),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.system_update_alt,
                color: Colors.white,
                size: 18,
              ),
              GAP_W8,
              Text(
                "Download".tr(),
                style: kTextStyle(context).bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        GAP_H6,
        CustomButton(
          msg: "Later".tr(),
          isOutlined: true,
          borderWidth: 1.25,
          borderColor: PRIMARY_COLOR_D0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No thanks".tr(),
                style: kTextStyle(context).bodyMedium?.copyWith(color: kColor(context).inverseSurface),
              ),
            ],
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
