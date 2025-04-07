import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/presentation/generate/view/components/generate_button.dart';

import '../../_common_widgets/custom_appbar.dart';
import 'components/generated_history.dart';
import 'components/id/gato_id.dart';

class GenerateScreen extends StatelessWidget {
  const GenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Generate".tr(), withBackIcon: true),
          const Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: GatoIdCard(),
                  ),
                  GAP_W4,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SaveGeneratedButton(),
                        GAP_W8,
                        GenerateButton(),
                      ],
                    ),
                  ),
                  GAP_H24,
                  GeneratedHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
