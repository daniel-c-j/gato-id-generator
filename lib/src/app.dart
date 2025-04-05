import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/_constants.dart';
import 'core/_core.dart';
import 'presentation/common_widgets/hud_overlay.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final goRouter = getIt<GoRouter>();

    // Force removal of splash screen.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PlatformBrightnessBloc>(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<HudControllerCubit>(),
        )
      ],
      child: BlocBuilder<PlatformBrightnessBloc, Brightness>(
        builder: (context, brightness) {
          return MaterialApp.router(
            title: AppInfo.TITLE,
            restorationScopeId: "app",
            onGenerateTitle: (context) => AppInfo.TITLE,
            debugShowCheckedModeBanner: false,
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            color: (brightness == Brightness.light) ? Colors.white : Colors.black,
            themeMode: (brightness == Brightness.light) ? ThemeMode.light : ThemeMode.dark,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            routerConfig: goRouter,
            // routeInformationParser: goRouter.routeInformationParser,
            // routeInformationProvider: goRouter.routeInformationProvider,
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          );
        },
      ),
    );
  }
}
