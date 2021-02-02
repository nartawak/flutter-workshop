import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:punk_api/05_navigation/punkapi_theme.dart';
import 'package:punk_api/05_navigation/repositories/beer_repository.dart';
import 'package:punk_api/05_navigation/routes/detail/detail_route.dart';
import 'package:punk_api/05_navigation/routes/master/master_route.dart';

class PunkApiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      // home: MasterRoute(
      //   beersRepository: BeersRepository(
      //     client: http.Client(),
      //   ),
      // ),
      initialRoute: MasterRoute.routeName,
      routes: <String, WidgetBuilder>{
        MasterRoute.routeName: (_) => MasterRoute(
              beersRepository: BeersRepository(
                client: http.Client(),
              ),
            ),
        DetailRoute.routeName: (_) => DetailRoute(),
      },
    );
  }
}
