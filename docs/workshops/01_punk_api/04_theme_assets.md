# 04- Theme / Assets

## Goal

The main goal of this step is to start manipulating layout widgets, refactoring code by creating a widget that can be used more than once.

You are going to:

- TODO

At the end of this step, you will have built this :point_down:

<figure style="text-align: center;">
    <img src="./resources/03_listview_goal.gif" alt="03_listview_goal.gif" style="display: inline;width: 40%"/>
</figure>

## Assets

```dart

  final image = Image.asset(
      'assets/images/punkapi.png',
      height: 40,
      width: 30,
      fit: BoxFit.fitHeight,
    );

  Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            Text(
              'Punk API',
              style: const TextStyle(
                fontFamily: 'Nerko_One',
                fontSize: 40,
              ),
            ),
            image,
          ],
        ),
        centerTitle: true,
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
