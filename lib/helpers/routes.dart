import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/pages/LoginPage.dart';
import 'package:pos_app/pages/Market/MarketPosHomePage.dart';
import 'package:pos_app/pages/PinCodePage.dart';
import 'package:pos_app/pages/Resto/RestoReservationsPage.dart';
import 'package:pos_app/pages/Resto/RestoPosHomePage.dart';
import 'package:pos_app/pages/Resto/RestoPrintPage.dart';
import 'package:pos_app/pages/Resto/RestoProductsPage.dart';
import 'package:pos_app/pages/ServerSettingsPage.dart';
import 'package:pos_app/pages/SplashScreenPage.dart';
final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: "splashScreen",
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreenPage();
      },
      routes: <GoRoute>[
        GoRoute(
          path: 'loginPage',
          name:'loginPage',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'pinCodePage',
          builder: (BuildContext context, GoRouterState state) {
            return const PinCodePage();
          },
        ),
        GoRoute(
          path: 'serverSettings',
          builder: (BuildContext context, GoRouterState state) {
            return const ServerSettingsPage();
          },
        ),
        GoRoute(
          path: 'marketHome',
          builder: (BuildContext context, GoRouterState state) {
            return const MarketPosHomePage();
          },
        ),
        GoRoute(
          path: 'restoHome',
          builder: (BuildContext context, GoRouterState state) {
            return const RestoHomePage();
          },
        ),
        GoRoute(
          path: 'productsPage',
          builder: (BuildContext context, GoRouterState state) {
            TblDkTable table= state.extra as TblDkTable;
            return RestoProductsPage(
                table: table
            );
          },
        ),
        GoRoute(
          path: 'reservationsPage',
          builder: (BuildContext context, GoRouterState state) {
            TblDkTable? table= state.extra as TblDkTable?;
            return RestoReservationsPage(
                  table:table
                );
          },
        ),
        GoRoute(
          path: 'printPage',
          builder: (BuildContext context, GoRouterState state) {
            return const RestoPrintPage();
          },
        ),
      ]
),

  ],
);