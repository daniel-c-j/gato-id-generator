import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/data/model/gato_id_stat.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_button.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/generic_snackbar.dart';
import 'package:gato_id_generator/src/presentation/generate/bloc/generated_gato_id_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/_constants.dart';
import '../../../../util/context_shortcut.dart';

class GeneratedHistory extends StatelessWidget {
  const GeneratedHistory({super.key});

  static const double listTileHeight = 70;

  @override
  Widget build(BuildContext context) {
    final gatoStat = context.watch<GeneratedGatoIdBloc>().latestStat;
    return FutureBuilder(
      future: gatoStat,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final stat = snapshot.data as GatoIdStat;
        final savedImagesCount = stat.savedImages.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    "Generated IDs (${stat.savedImages.length})",
                    style: kTextStyle(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  CustomButton(
                    msg: "Delete all",
                    buttonColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(60),
                    padding: const EdgeInsets.all(8),
                    onTap: () {
                      showUnimplementedSnackBar(context);
                    },
                    child: const Icon(Icons.delete_sweep),
                  ),
                ],
              ),
            ),
            GAP_H8,
            const Divider(thickness: 0.75, height: 0, indent: 12, endIndent: 12),
            GAP_H8,
            SizedBox(
              height: listTileHeight * (savedImagesCount + 1),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: savedImagesCount,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final imageData = stat.savedImages[index].entries.first;
                  final fileName = imageData.key;

                  final date = fileName.substring(0, 10);
                  final id = fileName.substring(11, 30);

                  return Dismissible(
                    key: Key(fileName),
                    confirmDismiss: (direction) {
                      showUnimplementedSnackBar(context);
                      return Future.value(false);
                    },
                    child: SizedBox(
                      height: listTileHeight,
                      child: ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(id),
                        subtitle: Text(date),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final filePath = imageData.value;
                              final path = filePath.replaceFirst("file://", "");
                              return GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: (filePath.contains("http"))
                                      ? CachedNetworkImage(
                                          imageUrl: filePath,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Image.file(
                                          File(path),
                                          fit: BoxFit.fitWidth,
                                        ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
