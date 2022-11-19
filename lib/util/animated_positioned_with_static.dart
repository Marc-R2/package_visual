import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// From Framework implicit_animations.dart
/// Modified to use a static position and a animated position

/// Animated version of [Positioned] which automatically transitions the child's
/// position over a given duration whenever the given position changes.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=hC3s2YdtWt8}
///
/// Only works if it's the child of a [Stack].
///
/// This widget is a good choice if the _size_ of the child would end up
/// changing as a result of this animation. If the size is intended to remain
/// the same, with only the _position_ changing over time, then consider
/// [SlideTransition] instead. [SlideTransition] only triggers a repaint each
/// frame of the animation, whereas [AnimatedStaticPositioned] will trigger a relayout
/// as well.
///
/// Here's an illustration of what using this widget looks like, using a [curve]
/// of [Curves.fastOutSlowIn].
/// {@animation 250 266 https://flutter.github.io/assets-for-api-docs/assets/widgets/animated_positioned.mp4}
///
/// For the animation, you can choose a [curve] as well as a [duration] and the
/// widget will automatically animate to the new target position. If you require
/// more control over the animation (e.g. if you want to stop it mid-animation),
/// consider using a [PositionedTransition] instead, which takes a provided
/// [Animation] as an argument. While that allows you to fine-tune the animation,
/// it also requires more development overhead as you have to manually manage
/// the lifecycle of the underlying [AnimationController].
///
/// {@tool dartpad}
/// The following example transitions an AnimatedPositioned
/// between two states. It adjusts the `height`, `width`, and
/// [Positioned] properties when tapped.
///
/// ** See code in examples/api/lib/widgets/implicit_animations/animated_positioned.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [AnimatedPositionedDirectional], which adapts to the ambient
///    [Directionality] (the same as this widget, but for animating
///    [PositionedDirectional]).
class AnimatedStaticPositioned extends ImplicitlyAnimatedWidget {
  /// Creates a widget that animates its position implicitly.
  ///
  /// Only two out of the three horizontal values ([animatedLeft], [animatedRight],
  /// [width]), and only two out of the three vertical values ([animatedTop],
  /// [animatedBottom], [height]), can be set. In each case, at least one of
  /// the three must be null.
  ///
  /// The [curve] and [duration] arguments must not be null.
  const AnimatedStaticPositioned({
    super.key,
    required this.child,
    this.animatedLeft,
    this.staticLeft,
    this.animatedTop,
    this.staticTop,
    this.animatedRight,
    this.staticRight,
    this.animatedBottom,
    this.staticBottom,
    this.width,
    this.height,
    super.curve,
    required super.duration,
    super.onEnd,
  })  : assert(animatedLeft == null || animatedRight == null || width == null),
        assert(animatedTop == null || animatedBottom == null || height == null);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The offset of the child's left edge from the left of the stack.
  final double? animatedLeft;

  final double? staticLeft;

  /// The offset of the child's top edge from the top of the stack.
  final double? animatedTop;

  final double? staticTop;

  /// The offset of the child's right edge from the right of the stack.
  final double? animatedRight;

  final double? staticRight;

  /// The offset of the child's bottom edge from the bottom of the stack.
  final double? animatedBottom;

  final double? staticBottom;

  /// The child's width.
  ///
  /// Only two out of the three horizontal values ([animatedLeft], [animatedRight], [width]) can
  /// be set. The third must be null.
  final double? width;

  /// The child's height.
  ///
  /// Only two out of the three vertical values ([animatedTop], [animatedBottom], [height]) can
  /// be set. The third must be null.
  final double? height;

  @override
  AnimatedWidgetBaseState<AnimatedStaticPositioned> createState() =>
      _AnimatedPositionedState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('left', animatedLeft, defaultValue: null))
      ..add(DoubleProperty('top', animatedTop, defaultValue: null))
      ..add(DoubleProperty('right', animatedRight, defaultValue: null))
      ..add(DoubleProperty('bottom', animatedBottom, defaultValue: null))
      ..add(DoubleProperty('width', width, defaultValue: null))
      ..add(DoubleProperty('height', height, defaultValue: null));
  }
}

class _AnimatedPositionedState
    extends AnimatedWidgetBaseState<AnimatedStaticPositioned> {
  Tween<double>? _left;
  Tween<double>? _top;
  Tween<double>? _right;
  Tween<double>? _bottom;
  Tween<double>? _width;
  Tween<double>? _height;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _left = visitor(
      _left,
      widget.animatedLeft,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _top = visitor(
      _top,
      widget.animatedTop,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _right = visitor(
      _right,
      widget.animatedRight,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _bottom = visitor(
      _bottom,
      widget.animatedBottom,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _width = visitor(
      _width,
      widget.width,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _height = visitor(
      _height,
      widget.height,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  double? add(double? a, double? b) {
    if (a == null && b == null) return null;
    if (b == null) return a;
    if (a == null) return b;
    return a + b;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: add(widget.staticLeft, _left?.evaluate(animation)),
      top: add(widget.staticTop, _top?.evaluate(animation)),
      right: add(widget.staticRight, _right?.evaluate(animation)),
      bottom: add(widget.staticBottom, _bottom?.evaluate(animation)),
      width: _width?.evaluate(animation),
      height: _height?.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description
      ..add(ObjectFlagProperty<Tween<double>>.has('left', _left))
      ..add(ObjectFlagProperty<Tween<double>>.has('top', _top))
      ..add(ObjectFlagProperty<Tween<double>>.has('right', _right))
      ..add(ObjectFlagProperty<Tween<double>>.has('bottom', _bottom))
      ..add(ObjectFlagProperty<Tween<double>>.has('width', _width))
      ..add(ObjectFlagProperty<Tween<double>>.has('height', _height));
  }
}
