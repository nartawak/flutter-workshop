import 'package:flutter/material.dart';
import 'package:punk_api/03_listview/models/beer.dart';
import 'package:punk_api/03_listview/repositories/beer_repository.dart';
import 'package:punk_api/03_listview/routes/master/widgets/punkapi_card.dart';

class MasterRouteStateful extends StatefulWidget {
  final BeersRepository beersRepository;

  MasterRouteStateful({required this.beersRepository});

  @override
  _MasterRouteStatefulState createState() => _MasterRouteStatefulState();
}

class _MasterRouteStatefulState extends State<MasterRouteStateful> {
  List<Beer>? _beers = [];
  bool _isError = false;
  bool _isLoading = true;

  Widget _displayBody() {
    if (_isError) {
      return Center(
        child: Text('An error occurred'),
      );
    }

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: _beers!.length,
      itemBuilder: (_, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: PunkApiCard(beer: _beers![index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punk API'),
        centerTitle: true,
      ),
      body: _displayBody(),
    );
  }

  void _fetchBeers() async {
    try {
      final beers = await widget.beersRepository.getBeers(itemsPerPage: 80);
      setState(() {
        _isError = false;
        _isLoading = false;
        _beers = beers;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
        _beers = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBeers();
  }
}

class MasterRouteFutureBuilder extends StatelessWidget {
  final BeersRepository beersRepository;

  MasterRouteFutureBuilder({required this.beersRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punk API'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: beersRepository.getBeers(itemsPerPage: 80),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final beers = snapshot.data;

          return ListView.builder(
            itemCount: (beers as List).length,
            itemBuilder: (_, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: PunkApiCard(beer: beers[index]),
              );
            },
          );
        },
      ),
    );
  }
}
