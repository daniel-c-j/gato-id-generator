// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// For testing purpose only
@visibleForTesting
bool forceShowHUD = false;

/// Cubit for Head-Up Display controller. Typical usage:
/// ```dart
/// context.read<HudControllerCubit>().show();
/// context.read<HudControllerCubit>().hide();
/// ```
class HudControllerCubit extends Cubit<bool> {
  HudControllerCubit() : super(false);

  void show() => emit(true);
  void hide() => emit(false);
}

/// A Head-Up display overlay that aims to be lightweight by utilizing state management with riverpod,
/// and lightweight fade-in animation. This widget should be wrapped on top of a widget that needs
/// to show the HUD overlay.
class HudOverlay extends StatelessWidget {
  const HudOverlay({
    super.key,
    required this.child,
    this.withDelay = true,
  });

  final Widget child;

  /// Intended for testing purpose.
  final bool withDelay;

  static const loadingHudKey = Key("hud-loading");
  static const bgHudKey = Key("hud-bg");

  // Not using a getter, to be easily configured if there's a need for arguments.
  Widget _showOverlayBackground() {
    return Center(
      key: bgHudKey, // ! Whatever the widget is, this key needs to be adapted.
      child: Container(color: Colors.black.withAlpha(120)),
    );
  }

  Widget _showOverlayContent() {
    return const Center(
      key: loadingHudKey, // ! Whatever the widget is, this key needs to be adapted.
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The content of the widget
        child,
        // Use StatefulBuilder as a Lightweight component.
        StatefulBuilder(
          builder: (context, setState) {
            /// Triggers the sizedBox widget return.
            bool shouldRender = false;

            return AbsorbPointer(
              absorbing: true,
              child: IgnorePointer(
                ignoring: true,
                child: BlocBuilder<HudControllerCubit, bool>(builder: (BuildContext context, bool show) {
                  final duration = Duration(milliseconds: (withDelay) ? 800 : 0);

                  // If not in testing, the condition below will apply.
                  if (!forceShowHUD) {
                    // Returns nothing when animation ends and show is false.
                    if (!show && !shouldRender) return const SizedBox.shrink();
                  }

                  return AnimatedOpacity(
                    opacity: (show) ? 1 : 0,
                    onEnd: () {
                      shouldRender = show;
                      if (!shouldRender) setState(() {});
                    },
                    duration: duration,
                    child: Stack(
                      children: [
                        _showOverlayBackground(),
                        _showOverlayContent(),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ],
    );
  }
}
