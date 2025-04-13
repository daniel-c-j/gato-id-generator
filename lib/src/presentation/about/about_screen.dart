// coverage:ignore-file
import 'package:flutter/material.dart';

import 'components/contact_dev.dart';
import 'components/license_dev.dart';

import '../../core/_core.dart';
import '../../core/constants/_constants.dart';
import '../../util/context_shortcut.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // So that the leading back arrow appears.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            Image.asset(
              "assets/images/icon/icon.png",
              width: 85,
              height: 85,
              color: kColor(context).inverseSurface,
            ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            Text(
              AppInfo.TITLE,
              textAlign: TextAlign.center,
              style: kTextStyle(context).titleLarge?.copyWith(
                    color: PRIMARY_COLOR_L0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'v${AppInfo.CURRENT_VERSION}',
              textAlign: TextAlign.center,
              style: kTextStyle(context).bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            GAP_H4,
            Text(
              AppInfo.DESCRIPTION,
              textAlign: TextAlign.center,
              style: kTextStyle(context).bodySmall,
            ),
            Divider(
              indent: kScreenWidth(context) * 0.1,
              endIndent: kScreenWidth(context) * 0.1,
            ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            const ContactDev(),
            Divider(
              indent: kScreenWidth(context) * 0.1,
              endIndent: kScreenWidth(context) * 0.1,
            ),
            const LicenseDev(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          ],
        ),
      ),
    );
  }
}
