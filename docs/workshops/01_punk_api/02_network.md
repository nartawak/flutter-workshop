# 02- Network

## Goal

The main goal of this step is to start manipulating pure dart objects, to retrieve Json data via an Http call, to separate the business logic from the UI / widget layer.

You are going to:

- add and use third party dependency in Flutter project
- use `http` package to make API call
- decode Json data in object model
- create business objects independent of the graphic layer (widgets tree)
- test pure dart objects

At the end of this step, you will have built this :point_down:

<figure style="text-align: center;">
    <img src="./resources/02_network_goal.gif" alt="02_network_goal.gif" style="display: inline;width: 40%"/>
</figure>

## HTTP package

First you need to add third party dependency to make HTTP calls. Adding a dependency can be done via pubspec.yml at the root of the project.

- add `http` package

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.0

  http: ^0.12.2
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

example of URL we are going to use: `https://api.punkapi.com/v2/beers?page=1&per_page=10`. Each object have a lot of properties, we only need the following properties:

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
  - `id` `name` and `imageUrl` are required and cannot be null
  - decorate this class as immutable
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

```dart
  Future<List<Beer>> getBeers() async {
    // TODO: make API call and decode json in List<Beer>
    return null;
  }
```

::: tip
Use [documentation](https://flutter.dev/docs/cookbook/networking/background-parsing) to manage API call
:::
