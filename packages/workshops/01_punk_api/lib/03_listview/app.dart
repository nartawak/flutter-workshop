import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:punk_api/03_listview/repositories/beer_repository.dart';
import 'package:punk_api/03_listview/routes/master/master_route.dart';

class PunkApiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MasterRouteStateful(
      //   beersRepository: BeersRepository(
      //     client: http.Client(),
      //   ),
      // ),
      home: MasterRouteFutureBuilder(
        beersRepository: BeersRepository(
          client: http.Client(),
        ),
      ),
    );
  }
}
