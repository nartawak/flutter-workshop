import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:punk_api/08_bloc/punkapi_theme.dart';
import 'package:punk_api/08_bloc/repositories/beer_repository.dart';
import 'package:punk_api/08_bloc/routes/detail/detail_route.dart';
import 'package:punk_api/08_bloc/routes/master/master_route.dart';

class PunkApiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
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
