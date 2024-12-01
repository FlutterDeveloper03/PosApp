// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/helpers/TAppTheme.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  State<ChangeThemeButtonWidget> createState() => _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  bool isDarkMode=false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeNotifier>(context);
    return (themeProvider.getTheme()==themeProvider.darkTheme)? IconButton(
      onPressed: () {
        final provider = Provider.of<ThemeNotifier>(context, listen: false);
        provider.setLightMode();
      },
      icon:const Icon(Icons.light_mode)
    )
    :IconButton(
        onPressed: () {
      final provider = Provider.of<ThemeNotifier>(context, listen: false);
      provider.setDarkMode();
    },
    icon:const Icon(Icons.dark_mode)
    );
  }
}