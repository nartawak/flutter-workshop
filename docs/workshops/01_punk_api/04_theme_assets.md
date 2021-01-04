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

For now, we have displayed images from the Rest API with the widget `Image.network('url')`.

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

- In the `master_route.dart`, update the title of `AppBar` by replacing `Text` widget with a `Row`. Add as children of the `Row`, the following widgets in order:
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

### Fonts

<a download="NerkoOne-Regular.ttf" href="/04_theme_assets_download/fonts/NerkoOne-Regular.ttf" title="NerkoOne-Regular">
    NerkoOne-Regular
</a>
<br/>
<a download="Roboto-Regular.ttf" href="/04_theme_assets_download/fonts/Roboto-Regular.ttf" title="Roboto-Regular">
    Roboto-Regular
</a>

```dart
Text(
  'Punk API',
  style: const TextStyle(
    fontFamily: 'Nerko_One',
    fontSize: 40,
  ),
);
```

```dart
const labelStyle = TextStyle(
  fontFamily: 'Roboto',
);
```

```dart
  Text(
    beer.name,
    style: labelStyle.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
  );
```

```dart
  Text(
    beer.name,
    style: labelStyle.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.bold,
    ),
  );
```

## Theme

```xml
<dict>
    <key>UIUserInterfaceStyle</key>
    <string>Dark</string>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <true/>
</dict>
```
