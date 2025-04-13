// coverage:ignore-file
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/_core.dart';
import '../../../core/constants/_constants.dart';
import '../../../util/context_shortcut.dart';
import '../../_common_widgets/custom_button.dart';

/// Widget about the guy coding this app (－.－)... zzz
class ContactDev extends StatelessWidget {
  const ContactDev({super.key});

  /// Generate predefined CustomButton.
  Widget _getContact(Widget icon, String title, {required String url}) {
    return CustomButton(
      msg: url,
      buttonColor: PRIMARY_COLOR_D1,
      onTap: () async {
        await launchUrlString(url);
      },
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          GAP_W6,
          Text(
            title,
            style: kTextStyle(NavigationService.currentContext).bodySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        Text(
          "Contact".tr(),
          textAlign: TextAlign.center,
          style: kTextStyle(context).bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        GAP_H4,
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _getContact(
              const Icon(Icons.alternate_email, size: 18, color: Colors.white),
              "dcj.dandy800@passinbox.com",
              url: "mailto:dcj.dandy800@passinbox.com",
            ),
            _getContact(
              const Icon(BoxIcons.bxl_github, size: 18, color: Colors.white),
              "Daniel-C-J",
              url: "https://github.com/Daniel-C-J",
            ),
            _getContact(
              Image.asset(
                'assets/images/contact/ko-fi.webp',
                fit: BoxFit.cover,
                height: 18,
              ),
              "danielcj",
              url: "https://ko-fi.com/danielcj",
            ),
          ],
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
