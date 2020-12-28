import 'package:flutter/material.dart';

class BouncingBalls extends StatefulWidget {
  @override
  _BouncingBallsState createState() => _BouncingBallsState();
}

class _BouncingBallsState extends State<BouncingBalls>
    with SingleTickerProviderStateMixin {
  AnimationController bouncingController;

  @override
  void initState() {
    super.initState();

    try {
      bouncingController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0.5,
        upperBound: 1.5,
        value: 1,
      )..repeat(reverse: true).orCancel;
    } on TickerCanceled {
      // TODO: manage error
    }
  }

  @override
  void dispose() {
    bouncingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 100),
      painter: BouncingBallsPainter(animation: bouncingController),
    );
  }
}

class BouncingBallsPainter extends CustomPainter {
  static const firstColor = Color(0xFFFFAD9E);
  static const secondColor = Color(0xFFEB908F);

  static const _radius = 12.0;
  static const _spaceBetweenBalls = 30;

  final Animation<double> animation;

  BouncingBallsPainter({
    @required this.animation,
  })  : assert(animation != null),
        super(repaint: animation);

  double nextOffsetDx(Offset previous) {
    assert(previous != null);

    return previous.dx + _radius + _spaceBetweenBalls;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.teal;

    final paddingLeft = (size.width - 5 * _radius - 4 * _spaceBetweenBalls) / 2;
    final animatedHeight = size.height / 2 * animation.value;

    final first = Offset(
      paddingLeft + _radius / 2,
      animatedHeight,
    );
    final second = Offset(nextOffsetDx(first), animatedHeight);
    final third = Offset(nextOffsetDx(second), animatedHeight);
    final fourth = Offset(nextOffsetDx(third), animatedHeight);
    final fifth = Offset(nextOffsetDx(fourth), animatedHeight);
    [
      first,
      second,
      third,
      fourth,
      fifth,
    ].forEach((offset) {
      canvas.drawCircle(offset, _radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
