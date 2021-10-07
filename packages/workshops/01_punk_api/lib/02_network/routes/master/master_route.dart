import 'package:flutter/material.dart';
import 'package:punk_api/02_network/repositories/beer_repository.dart';
import 'package:punk_api/02_network/routes/master/widgets/punkapi_card.dart';

class MasterRoute extends StatefulWidget {
  final BeersRepository beersRepository;

  MasterRoute({required this.beersRepository});

  @override
  _MasterRouteState createState() => _MasterRouteState();
}

class _MasterRouteState extends State<MasterRoute> {
  List _mockList() {
    return List.filled(10, null);
  }

  @override
  void initState() {
    super.initState();

    widget.beersRepository
        .getBeers()
        .then((value) => print(value))
        .catchError((error) => {print(error)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punk API'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._mockList()
                .map(
                  (e) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: PunkApiCard(),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
