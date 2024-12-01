import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/AuthBloc.dart';
import 'package:pos_app/bloc/CartItemsBloc.dart';
import 'package:pos_app/bloc/RestoProductsPageCubit.dart';
import 'package:pos_app/bloc/RestoReservationsPageCubit.dart';
import 'package:pos_app/bloc/SplashScreenPageCubit.dart';
import 'package:pos_app/helpers/TAppTheme.dart';
import 'package:pos_app/helpers/routes.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/bloc/RestoPosHomePageCubit.dart';
import 'package:pos_app/bloc/LanguageBloc.dart';
import 'package:pos_app/bloc/ServerSettingsCubit.dart';
import 'package:pos_app/bloc/UserProfileBloc.dart';
import 'package:pos_app/helpers/localization.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider<GlobalVarsProvider>(
    key: UniqueKey(),
    create: (context) => GlobalVarsProvider(),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>RestoPosHomePageCubit(Provider.of<GlobalVarsProvider>(context,listen: false))..loadRestoPosHomePage()),
        BlocProvider(create: (context)=>SplashScreenPageCubit(Provider.of<GlobalVarsProvider>(context,listen: false))..loadSplashScreenPage()),
        BlocProvider(create: (context)=>RestoReservationPageCubit(Provider.of<GlobalVarsProvider>(context,listen: false))),
        BlocProvider(create: (context)=>RestoPosProductsPageCubit(Provider.of<GlobalVarsProvider>(context,listen: false))..loadRestoPosProductsPage()),
        BlocProvider(create: (_)=>UserProfileCubit()..loadUserProfile()),
        BlocProvider(create: (_)=>ServerSettingsCubit()..loadServerSettings()),
        BlocProvider(create: (_) => LanguageBloc()..add(LanguageLoadStarted())),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (context) => CartItemBloc(Provider.of<GlobalVarsProvider>(context,listen: false)))
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (context) => ThemeNotifier(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeNotifier>(context);
        return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp.router(
                title: 'Flutter Demo',
                theme: themeProvider.getTheme(),
                locale: languageState.locale,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  TkMaterialLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ru', 'RU'),
                  Locale('tk', 'TM'),
                ],
                routeInformationParser: router.routeInformationParser,
                routeInformationProvider: router.routeInformationProvider,
                routerDelegate: router.routerDelegate,
              );
            });

      },
    );
  }
}
