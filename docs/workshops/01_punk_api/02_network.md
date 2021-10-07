# 02- Network

## Goal

The main goal of this step is to start manipulating pure dart objects, to retrieve Json data via an Http call, to separate the business logic from the UI / widget layer.

You are going to:

- add and use third party dependency in Flutter project
- use `http` package to make API call
- decode Json data in object model
- create business objects independent of the graphic layer (widgets tree)
- test pure dart objects with [Mockito](https://pub.dev/packages/mockito)

At the end of this step, you will have all tests passed for `BeerRepository`

## HTTP package

First you need to add third party dependency to make HTTP calls. Adding a dependency can be done via pubspec.yml at the root of the project.

- add `http` package

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.0

  http: ^0.13.4
```

::: warning
In the YAML format, the indentation is important, if you don't respect it you will have errors.
:::

- fetch third party package, either via your IDE or in command line

```shell script
flutter pub get
```

::: tip Package registry

[pub.dev](https://pub.dev/) is the official dart packages registry, you can find a lot of useful packages. Each package
defines example, installing documentation and more...

example: [http](https://pub.dev/packages/http/example)

:::

## Beer model

For this workshop we will use the public [Punk API](https://punkapi.com/documentation/v2) to retrieve data.

example of URL we are going to use: `https://api.punkapi.com/v2/beers?page=1&per_page=10`. Each object has a lot of properties, we only need the following properties:

```json
{
  "id": 1,
  "name": "Buzz",
  "tagline": "A Real Bitter Experience.",
  "description": "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.",
  "image_url": "https://images.punkapi.com/v2/keg.png"
}
```

- create a `models` folder and a `beer.dart` file inside

```
./lib
├── app.dart
├── models
│└── beer.dart
└── routes
    └── master
        ├── master_route.dart
        └── widgets

```

- create a class `Beer`

  - use named parameters
  - `id` `name` and `imageUrl` are required and cannot be nullable
  - `tagline` and `description` are optional and can be nullable
  - decorate this class as immutable 👉 `import 'package:meta/meta.dart';`

Example:

:::tip
You can find more documentation about [classes](https://dart.dev/guides/language/language-tour#classes) and
[parameters](https://dart.dev/guides/language/language-tour#parameters) in the [dart.dev](https://dart.dev/) website.

I recommend that you use [immutability](https://en.wikipedia.org/wiki/Immutable_object) for everything concerning model objects at minimum. In my opinion, this is a pattern that is even more important in frontend development.
If you look at the Flutter SDK code, you will find many examples ([Widget](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/framework.dart#L476),
[ThemeData](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/theme_data.dart#L192), ...), I will encourage you in this way during this workshop.
:::

```dart
@immutable
class User {
  final String firstname;
  final String? lastname;

  User({required this.firstname, this.lastname});

  User copyWith({String? firstname, String? lastname}) {
    return User(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
    );
  }
}

void main() {
  var user = User(firstname: 'Nartawak');
  var updatedUser = user.copyWith(firstname: 'updated');
}
```

- add named constructor `fromJson` to create Beer object from json data.

```dart
class Beer {
  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      imageURL: json['image_url'] as String,
    );
  }
}
```

## FetchDataException

- create a `exceptions` folder and a `custom_exceptions.dart` file inside

```
./lib
├── app.dart
├── exceptions
│└── custom_exceptions.dart
├── models
│└── beer.dart
└── routes
    └── master
        ├── master_route.dart
        └── widgets
```

- create a class `FetchDataException` that implements `Exception`

```dart
class FetchDataException implements Exception {
  final _message;
  final _prefix = 'Error during HTTP call: ';

  FetchDataException([this._message]);

  String toString() {
    return "$_prefix$_message";
  }
}
```

## BeerRepository

- create a `repositories` folder and a `beer_repository.dart` file inside

```
./lib
├── app.dart
├── models
│└── beer.dart
├── repositories
│└── beer_repository.dart
└── routes
    └── master
        ├── master_route.dart
        └── widgets
```

- create a class `BeersRepository`

  - this object should define a `http.Client` class property initialize when creating this object
  - `http.Client` class property is required and cannot be null
  - decorate this class as immutable

- expose a function `getBeers`
  - the function take 2 arguments (pageNumber and itemsPerPage) with default values
  - example of URL: `https://api.punkapi.com/v2/beers?page=1&per_page=10`
  - when the response status code is different from 200, return `Future.error(FetchDataException('message')`
  - the function must validate the tests provided :point_down:

::: tip
Use [documentation](https://flutter.dev/docs/cookbook/networking/background-parsing) to manage API call
:::

```dart
  Future<List<Beer>> getBeers({
    int pageNumber = 1,
    int itemsPerPage = 10,
  }) async {
    // TODO: make API call and decode json in List<Beer>
    return null;
  }
```

:::tip

Although I prefer to have the test files next to the production files, this is not the approach with Flutter.
All the test files should be in the `test` folder, however I keep the same tree structure as in the `lib` folder.

```
./test
├── repositories
 └── beer_repository_test.dart
```

:::

## test BeerRepository file

You need to install 2 packages as `dev_dependencies` to test this file:

- [build_runner](https://pub.dev/packages/build_runner): A build system for Dart code generation and modular compilation.
- [mockito](https://pub.dev/packages?q=mockito): A mock framework inspired by Mockito (Java) with APIs for Fakes, Mocks, behavior verification, and stubbing.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:punk_api/02_network/exceptions/custom_exceptions.dart';
import 'package:punk_api/02_network/repositories/beer_repository.dart';

import 'beer_repository_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late Client mockClient;
  late BeersRepository beersRepository;
  var urlToCall = Uri.https(
    '$kApiBaseUrl',
    '$kBeerResource',
    {'page': '1', 'per_page': '10'},
  );

  setUp(() {
    mockClient = MockClient();
    beersRepository = BeersRepository(client: mockClient);
  });

  group(
    'getBeers',
            () {
      test(
        'should throw a FetchDataException when response.statusCode is not 200',
                () async {
          when(mockClient.get(urlToCall)).thenAnswer(
                    (_) async => Response("mock_body", 400),
          );

          expect(
            beersRepository.getBeers(),
            // You can find full list of matchers => https://api.flutter.dev/flutter/package-matcher_matcher/package-matcher_matcher-library.html
            throwsA(
              predicate((dynamic e) => e is FetchDataException),
            ),
          );
        },
      );

      test(
        'should return a list of beer with one beer',
                () async {
          const mockJson =
                  "[{\"id\":1,\"name\":\"Buzz\",\"tagline\":\"A Real Bitter Experience.\",\"description\":\"A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.\",\"image_url\":\"https:\/\/images.punkapi.com\/v2\/keg.png\"}]";
          when(mockClient.get(urlToCall)).thenAnswer(
                    (_) async => Response(mockJson, 200),
          );

          final beers = await beersRepository.getBeers();
          expect(beers, isList);
          expect(beers!.length, 1);

          final first = beers[0];
          expect(first.id, 1);
          expect(first.name, 'Buzz');
        },
      );
    },
  );
}

```
