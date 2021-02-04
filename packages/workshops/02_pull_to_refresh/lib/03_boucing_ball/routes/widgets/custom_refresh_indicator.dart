import 'package:flutter/material.dart';
import 'package:pull_to_refresh/03_boucing_ball/routes/widgets/bouncing_balls.dart';

typedef RefreshCallback = Future<void> Function();

const _kEffectDuration = const Duration(milliseconds: 200);

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  CustomRefreshIndicator({
    @required this.child,
    @required this.onRefresh,
  })  : assert(child != null),
        assert(onRefresh != null);

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with TickerProviderStateMixin<CustomRefreshIndicator> {
  static final Animatable<double> _zeroToOneTween =
      Tween<double>(begin: 0.0, end: 1.0);

  static final Animatable<Offset> _zeroToTwo = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 0.15),
  );

  AnimationController _scaleController;
  AnimationController _slideController;

  Animation<double> _scaleFactor;
  Animation<Offset> _slideOffset;

  bool _isBouncingBallDisplaying = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_zeroToOneTween);
    _scaleController.value = 0;

    _slideController = AnimationController(vsync: this);
    _slideOffset = _slideController.drive(_zeroToTwo);
    _slideController.value = 0;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _show() {
    setState(() {
      _isBouncingBallDisplaying = true;
    });

    Future.wait([
      _scaleController.animateTo(1, duration: _kEffectDuration),
      _slideController.animateTo(1, duration: _kEffectDuration),
    ]).then((_) {
      final Future<void> refreshResult = widget.onRefresh();
      refreshResult.whenComplete(() {
        _dismiss();
      });
    });
  }

  void _dismiss() {
    Future.wait([
      _scaleController.animateTo(0, duration: _kEffectDuration),
      _slideController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
      )
    ]).then((_) {
      setState(() {
        _isBouncingBallDisplaying = false;
      });
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    if (notification is ScrollStartNotification &&
        notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.extentBefore == 0) {
      _show();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          if (_isBouncingBallDisplaying)
            Positioned(
              top: 20,
              child: ScaleTransition(
                scale: _scaleFactor,
                child: BouncingBalls(),
              ),
            ),
          SlideTransition(
            position: _slideOffset,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
