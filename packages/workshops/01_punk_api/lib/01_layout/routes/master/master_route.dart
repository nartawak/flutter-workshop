import 'package:flutter/material.dart';
import 'package:punk_api/01_layout/routes/master/widgets/punkapi_card.dart';

class MasterRoute extends StatelessWidget {
  List _mockList() {
    return List.filled(10, null);
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
