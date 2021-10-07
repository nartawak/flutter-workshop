import 'package:flutter/material.dart';
import 'package:punk_api/06_detail/punkapi_theme.dart';

MaterialApp getMaterialAppLightThemeWrapper({required Widget child}) {
  return MaterialApp(
    theme: lightTheme,
    home: child,
  );
}

MaterialApp getMaterialAppDarkThemeWrapper({required Widget child}) {
  return MaterialApp(
    theme: darkTheme,
    home: child,
  );
}
