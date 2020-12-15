# 03- ListView

## Goal

The main goal of this step is to start manipulating layout widgets, refactoring code by creating a widget that can be used more than once.

You are going to:

- use `StatefulWidget` and lifecycle hooks
- use `FutureBuilder` to display UI base on `Future`
- use `ListView` widget
- test a more complex widget with asynchronous fetching data

At the end of this step, you will have built this :point_down:

<figure style="text-align: center;">
    <img src="./resources/03_listview_goal.gif" alt="03_listview_goal.gif" style="display: inline;width: 40%"/>
</figure>

## StatefulWidget

> Stateful widgets maintain state that might change during the lifetime of the widget. Implementing a stateful widget requires at least two classes: a StatefulWidget that creates an instance of a State class. The StatefulWidget object is, itself, immutable and can be thrown away and regenerated, but the State object persists over the lifetime of the widget.

<figure style="text-align: center;">
    <img src="./resources/03_listview_stateful_widget_lifecycle.png" alt="03_listview_stateful_widget_lifecycle.png" style="display: inline;width: 100%"/>
</figure>

## Approaches for fetching asynchronous data

It is possible to use 2 different approaches to retrieve external and asynchronous data to a widget.

### use StatefulWidget

I do the parallel with frameworks often known in web development, component oriented, such as React, Vue or Angular.
When a component is initialized, an HTTP call is triggered, and during the asynchronous return, the state of the component is updated to display the data received.

It is possible to do exactly the same approach with Flutter. **Only the `StatefulWidget` allows using `State` and lifecycle hooks.**

### use FutureBuilder or StreamBuilder

Flutter offers 2 builders widgets that allow you to build a tree of widgets based on asynchronous data.

- FutureBuilder takes a Future as an input
- StreamBuilder takes a Stream as input

**The primary advantage of these widgets is that they often allow you to create StatelessWidget instead of StatefulWidget. The code is often less verbose and more easily testable.**

:::tip
Copy the `MasterRoute` in the same file. Name the first `MasterRouteStateful` and the second `MasterRouteFutureBuilder`.
This will allow us to keep and compare the 2 solutions we are going to implement
:::

## MasterRouteStateful

- add `BeersRepository` as final property of `MasterRouteStateful`

- create a constructor, `beersRepository` is required and cannot be null

- convert `MasterRouteStateful` in `StatefulWidget`

- add 3 properties in State

  - \_beers: list of `Beer`
  - \_isError: boolean, default value to false
  - \_isLoading: boolean, default value to true

- override `initState` and call `getBeers` in these hook.

::: tip
It is often good practice to create a private function rather than do all the processing in the `initState`.
It also allows to create an `async` function and to be able to use the keyword `await`

```dart
  @override
  void initState() {
    super.initState();
    _fetchBeers();
  }
```

:::

- Manage the state via `setState` function in `_fetchBeers` function

```dart
// Fetch data success
setState(() {
    _isError = false;
    _isLoading = false;
    _beers = beers;
});

// Fetch data error
setState(() {
  _isError = true;
  _isLoading = false;
  _beers = [];
});
```

- create a `_displayBody` that displays body according to state:
  - if error display a centered text 'An error occurred'
  - if loading display a centered `CircularProgressIndicator`
  - use \_beers instead of `_mockList` to create the column's children

```dart
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
```

## PunkApiCard

- open `PunkApiCard` widget

- add Beer as final property, initialize it by constructor, it is required and cannot be null

- remove red color to the red container and add decoration

```dart
Container(
  height: 100,
  padding: const EdgeInsets.all(10),
  decoration: const BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        offset: const Offset(0.0, 1.0),
        blurRadius: 6.0,
      ),
    ],
  ),
);
```

- add an `Image.network` with `beer.imageURL` as child to the green container et remove the decoration configuration.

- replace the yellow container with a column with 2 `Text`

  - beer.name
  - beer.tagline

- adjust padding and alignment on the column

## Tests

- Create tests files:
  - punkapi_card_test.dart
  - master_route_test.dart

```
test
├── app_test.dart
├── repositories
│   └── beer_repository_test.dart
└── routes
    └── master
        ├── master_route_test.dart
        └── widgets
            └── punkapi_card_test.dart

```

### punkapi_card_test.dart

- add `network_image_mock` dependency in the `dev_dependency` in the **pubspec.yaml**

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^4.1.3
  network_image_mock: ^1.0.2
```

::: tip
You need to use this package to test widget that use Image widget

> Since you are here you probably already know that calling Image.network results in 400 response in Flutter widget tests. The reason for this is that default HTTP client in tests always return a 400.

[Learn more](https://pub.dev/packages/network_image_mock)
:::

```dart

const mockBeerName = 'beer_name';
const mockBeerTagline = 'beer_tagline';
final mockBeer = Beer(
  id: 1,
  name: mockBeerName,
  tagline: mockBeerTagline,
  imageURL: 'https://images.punkapi.com/v2/keg.png',
);

final cardKey = GlobalKey();

void main() {
  group('PunkApiCard', () {
    testWidgets('should display image', (WidgetTester tester) async {

      // to mock Http in test with Image widget
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: PunkApiCard(
              key: cardKey,
              beer: mockBeer,
            ),
          ),
        );

        // you can find widget by key.
        // since we must wrap PunkApiCard with MaterialApp because it depends on it (see InheritedWidget), you can have a lot of widget in the widget tree.
        // The target of a widget can be made by type, or via a large number of matchers, but with a key you are sure to target the one you want to test.
        final cardFinder = find.byKey(cardKey);
        expect(cardFinder, findsOneWidget);

        expect(
            // with find.descendant you can target a widget in a particular subtree
            find.descendant(
              of: cardFinder,
              matching: find.byType(Image),
            ),
            findsOneWidget);
      });
    });

    testWidgets('should display beer name and tagline inside Column',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: PunkApiCard(
              key: cardKey,
              beer: mockBeer,
            ),
          ),
        );

        final cardFinder = find.byKey(cardKey);
        expect(cardFinder, findsOneWidget);

        var columnFinder = find.descendant(
          of: cardFinder,
          matching: find.byType(Column),
        );
        expect(columnFinder, findsOneWidget);

        expect(
          find.descendant(
            of: columnFinder,
            matching: find.text(mockBeerName),
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: columnFinder,
            matching: find.text(mockBeerTagline),
          ),
          findsOneWidget,
        );
      });
    });
  });
}

```

### master_route_test.dart

```dart
// ignore: must_be_immutable
class MockBeerRepository extends Mock implements BeersRepository {}

void main() {
  BeersRepository beersRepository;

  setUp(() {
    beersRepository = MockBeerRepository();
  });

  group('MasterRouteStateful', () {
    testWidgets(
        'should call beersRepository.getBeers on initState lifecycle hook',
        (WidgetTester tester) async {
      when(
        beersRepository.getBeers(),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteStateful(
            beersRepository: beersRepository,
          ),
        ),
      );

      verify(
        beersRepository.getBeers(pageNumber: 1, itemsPerPage: 80),
      ).called(1);
    });

    testWidgets(
        'should display CircularProgressIndicator when beersRepository.getBeers is not resolved',
        (WidgetTester tester) async {
          // Completer comes from dart:async package and allows to create Future
      Completer completer = Completer();
      when(
        beersRepository.getBeers(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteStateful(
            beersRepository: beersRepository,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'should display an error message when beersRepository.getBeers rejects an FetchDataException',
        (WidgetTester tester) async {
      when(
        beersRepository.getBeers(
          pageNumber: 1,
          itemsPerPage: 80,
        ),
      ).thenAnswer((_) => Future.error(FetchDataException()));

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteStateful(
            beersRepository: beersRepository,
          ),
        ),
      );

      // beersRepository.getBeers Future is resolved after the first call of the build method.
      // if you need ro recall the build function, to up to date the widget tree, you need to explicitly call pumpAndSettle function before expecting
      await tester.pumpAndSettle();

      expect(find.text('An error occurred'), findsOneWidget);
    });

    testWidgets(
        'should display ListView with 1 PunkApiCard when beersRepository.getBeers resolved with a list of 1 Beer',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        Completer completer = Completer<List<Beer>>();
        when(beersRepository.getBeers(pageNumber: 1, itemsPerPage: 80))
            .thenAnswer((_) => completer.future);

        await tester.pumpWidget(
          MaterialApp(
            home: MasterRouteStateful(
              beersRepository: beersRepository,
            ),
          ),
        );

        completer.complete([
          Beer(
              id: 1,
              name: 'mock_name',
              imageURL: 'https://images.punkapi.com/v2/keg.png',
              tagline: 'mock_tagline'),
        ]);
        await tester.pumpAndSettle();

        var listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        expect(
          find.descendant(of: listFinder, matching: find.byType(PunkApiCard)),
          findsOneWidget,
        );
      });
    });
  });
}

```

## MasterRouteFutureBuilder

- - add `BeersRepository` as final property of `MasterRouteFutureBuilder`

- create a constructor, `beersRepository` is required and cannot be null

- replace the body configuration of `Scaffold` with `FutureBuilder`

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punk API'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: beersRepository.getBeers(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            // TODO: manage error
          }

          if (!snapshot.hasData) {
            // TODO: manage loading
          }

          // TODO: manage list
          return null;
        },
      ),
    );
  }
```

- Replace the Todo, to have the same behavior as with `MasterRouteStateful`

- create the tests for the `MasterRouteFutureBuilder` by taking example from `MasterRouteStateful`

## ListView

Like mentionned in previous step, `Column` and `SingleChildScrollView` are not designed to display long list, we are going to use ListView which is made for.

- replace `SingleChildScrollView` with `ListView`

```dart
  ListView.builder(
    itemCount: beers.length,
    itemBuilder: (_, index) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: PunkApiCard(beer: beers[index]),
      );
    },
  );
```

::: warning ListView

ListView have a constructor with children configuration (`ListView(children: [],)`), prefer ListView.builder named constructor for big list.

See documention:

> This constructor is appropriate for list views with a large (or infinite) number of children because the builder is called only for those children that are actually visible.

:::
