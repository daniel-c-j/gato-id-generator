import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gato_id_generator/src/core/constants/_constants.dart';
import 'package:gato_id_generator/src/presentation/generate/view/components/generate_button.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../_common_widgets/custom_appbar.dart';
import 'components/generated_history.dart';
import 'components/id/gato_id_card.dart';

class GenerateScreen extends StatelessWidget {
  const GenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WidgetsToImageController();

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Generate".tr(), withBackIcon: true),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: WidgetsToImage(controller: controller, child: GatoIdCard()),
                  ),
                  GAP_W4,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SaveGeneratedButton(controller: controller),
                        GAP_W8,
                        const GenerateButton(),
                      ],
                    ),
                  ),
                  GAP_H24,
                  const GeneratedHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
