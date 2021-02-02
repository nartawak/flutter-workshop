import 'package:flutter/material.dart';
import 'package:punk_api/05_navigation/models/beer.dart';

// class DetailRoute extends StatelessWidget {
//   final Beer beer;
//
//   DetailRoute({
//     Key key,
//     this.beer,
//   })  : assert(beer != null),
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(beer.name),
//       ),
//       body: Center(
//         child: Text('Detail route'),
//       ),
//     );
//   }
// }

class DetailRoute extends StatelessWidget {
  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    final Beer beer = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(beer.name),
      ),
      body: Center(
        child: Text('Detail route'),
      ),
    );
  }
}
