import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:punk_api/04_theme_assets/punkapi_theme.dart';
import 'package:punk_api/04_theme_assets/repositories/beer_repository.dart';
import 'package:punk_api/04_theme_assets/routes/master/master_route.dart';

class PunkApiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: MasterRoute(
        beersRepository: BeersRepository(
          client: http.Client(),
        ),
      ),
    );
  }
}
