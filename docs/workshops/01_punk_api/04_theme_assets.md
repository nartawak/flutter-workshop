# 04- Theme / Assets

## Goal

The main goal of this step is to start manipulating embedded assets (images, fonts), and themes (light and dark) used by material widgets

You are going to:

- use `TextStyle` with embedded font
- use `Image` with embedded asset
- use `ThemeData` to create light and dark theme
- use `ThemeMode` to switch between light and dark mode

At the end of this step, you will have built this :point_down:

<figure style="text-align: center;">
    <img src="./resources/04_theme_assets_goal.gif" alt="04_theme_assets_goal.gif" style="display: inline;width: 40%"/>
</figure>

## Embedded assets

During the development of a front-end application, some assets are retrieved dynamically via Http calls for example, but we also need to have static assets (image, font, json, ...).
Static assets are important in terms of performance, no need to wait for the return of one or more network calls to be able to display a widget.

:::warning
The more static assets you have, more the size of the application will grow. You must therefore be careful on this point.
:::

### Images

For now, we have displayed images from the Rest API with the widget `Image.network('url')`. Now, we are going to use
`Image.asset` to display embedded image.

- download this image
  <a download="punkapi.png" href="/04_theme_assets_download/images/punkapi.png" title="punkapi">
  punkapi.png
  </a>

- create a `assets/images` directory and add this image inside

```
├── README.md
├── android
├── assets
|    └── images
|        └── punkapi.png
├── build
├── coverage
├── ios
├── lib
├── pubspec.lock
├── pubspec.yaml
├── punk_api.iml
└── test
```

- specifying asset in the `pubspec.yaml`.

::: tip
Adding an asset in the project file structure is not enough to embed an asset in the Android or iOS application. As mentioned
in the [documentation](https://flutter.dev/docs/development/ui/assets-and-images#specifying-assets), you need to declare it in the `pubspec.yaml`.
:::

:::warning
When adding assets, you need to rerun the Flutter application with command line or your IDE.
Hot restart or hot reload does not re-trigger a native build of the application. Assets will not be embedded in the application.
:::

```yaml
# ...
flutter:
  uses-material-design: true
  assets:
    # I often choose to add all assets in dedicated directory,
    # this avoids having to maintain an exhaustive list.
    - assets/images/
# ...
```

In the previous step, we use 2 widgets in the `master_route.dart` file:

- `MasterRouteStateful`
- `MasterRouteFutureBuilder`

We only keep the `MasterRouteFutureBuilder`, so you can delete `MasterRouteStateful` and rename `MasterRouteFutureBuilder` to `MasterRoute` adn clean the tests

- In the `MasterRoute` widget, update the title of `AppBar` by replacing `Text` widget with a `Row`. Add as children of the `Row`, the following widgets in order:
  - image punkapi.png
  - title
  - image punkapi.png

```dart

final image = Image.asset(
  'assets/images/punkapi.png',
  height: 40,
  width: 30,
  fit: BoxFit.fitHeight,
);
```

- add a new test in the `master_route_test.dart` where you can use the golden testing to validate the `AppBar`

::: tip Golden testing
When you create a test with golden testing, you need to run the `flutter test` command with the `--update-golden` option to generate the png file.
Each time you modify the widget that you test with golden test, you need to re-run the command with this option to generate a new png.

[Learn more](https://medium.com/flutter-community/flutter-golden-tests-compare-widgets-with-snapshots-27f83f266cea)
:::

```dart
testWidgets('should golden test the AppBar', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MasterRoute(
        beersRepository: beersRepository,
      ),
    ),
  );

  final appBarFinder = find.byType(AppBar);
  expect(appBarFinder, findsOneWidget);

  await expectLater(appBarFinder, matchesGoldenFile('app_bar.png'));
});
```

### Fonts

- download this 2 fonts
  <a download="NerkoOne-Regular.ttf" href="/04_theme_assets_download/fonts/NerkoOne-Regular.ttf" title="NerkoOne-Regular">
  NerkoOne-Regular
  </a>,
  <a download="Roboto-Regular.ttf" href="/04_theme_assets_download/fonts/Roboto-Regular.ttf" title="Roboto-Regular">
  Roboto-Regular
  </a>

- create a `assets/fonts` directory and add these fonts inside

```
├── README.md
├── android
├── assets
|   ├── fonts
|   |   ├── NerkoOne-Regular.ttf
|   |   └── Roboto-Regular.ttf
|   └── images
|       └── punkapi.png
├── build
├── coverage
├── ios
├── lib
├── pubspec.lock
├── pubspec.yaml
├── punk_api.iml
└── test
```

- specifying fonts in the `pubspec.yaml`

::: tip
Like assets, [fonts have to be specifying](https://flutter.dev/docs/cookbook/design/fonts#2-declare-the-font-in-the-pubspec) in pubspec.yaml file.

You can also use the `google_fonts` [package](https://pub.dev/packages/google_fonts) to use front from [fonts.google.com](https://fonts.google.com/) in your project.
:::

```yaml
flutter:
  uses-material-design: true
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
    - family: Nerko_One
      fonts:
        - asset: assets/fonts/NerkoOne-Regular.ttf
```

- use `Nerko_one` font familly like below in the title `Text` widget in the `AppBar`

```dart
Text(
  'Punk API',
  style: const TextStyle(
    fontFamily: 'Nerko_One',
    fontSize: 40,
  ),
);
```

- update the golden test, we previously created, it should be failed!!

- open `punkapi_card.dart` file

- use `Roboto` both for the name and the tagline
  - name must have 17 as fontSize and must be bold
  - tagline must have 13 as fontSize

```dart
// you can create a TextStyle that mutualize common configuration
const labelStyle = const TextStyle(
  fontFamily: 'Roboto',
);
```

```dart
final name = Text(
    beer.name,
    // use the common TextStyle by creating a new instance and define only specific values
    style: labelStyle.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
);
```

```dart
final tagline = Text(
    beer.name,
    style: labelStyle.copyWith(
      fontSize: 13,
    ),
);
```

- create `should golden test the PunkApiCard` in the `punkapi_card_test.dart` file
  - generate the png file
  - delete the `should display image` test, golden test cover this use case

## Theme

```xml
<dict>
    <key>UIUserInterfaceStyle</key>
    <string>Dark</string>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <true/>
</dict>
```
