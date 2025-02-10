import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:forui/forui.dart';
import 'package:meta/meta.dart';

part 'focused_outline.style.dart';

/// An outline around a focused widget that does not affect its layout.
///
/// See:
/// * https://forui.dev/docs/foundation/focused-outline for working examples.
/// * [FFocusedOutlineStyle] for customizing an outline.
class FFocusedOutline extends SingleChildRenderObjectWidget {
  /// The style.
  final FFocusedOutlineStyle? style;

  /// True if the [child] should be outlined.
  final bool focused;

  /// Creates a [FFocusedOutline].
  const FFocusedOutline({
    required this.focused,
    required super.child,
    this.style,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _Outline(style ?? context.theme.style.focusedOutlineStyle, focused: focused);

  @override
  // ignore: library_private_types_in_public_api
  void updateRenderObject(BuildContext context, _Outline renderObject) {
    renderObject
      ..style = style ?? context.theme.style.focusedOutlineStyle
      ..focused = focused;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('style', style))
      ..add(FlagProperty('focused', value: focused, ifTrue: 'focused'));
  }
}

class _Outline extends RenderProxyBox {
  FFocusedOutlineStyle _style;
  bool _focused;

  _Outline(this._style, {required bool focused}) : _focused = focused;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);
    if (focused) {
      context.canvas.drawPath(
        Path()
          ..addRRect(
            RRect.fromRectAndCorners(
              (offset & child!.size).inflate(_style.spacing),
              topLeft: _style.borderRadius.topLeft,
              topRight: _style.borderRadius.topRight,
              bottomLeft: _style.borderRadius.bottomLeft,
              bottomRight: _style.borderRadius.bottomRight,
            ),
          ),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = _style.color
          ..strokeWidth = _style.width,
      );
    }
  }

  @override
  Rect get paintBounds => _focused ? child!.paintBounds.inflate(_style.spacing) : super.paintBounds;

  FFocusedOutlineStyle get style => _style;

  set style(FFocusedOutlineStyle value) {
    if (style != value) {
      _style = value;
      markNeedsPaint();
    }
  }

  bool get focused => _focused;

  set focused(bool value) {
    if (focused != value) {
      _focused = value;
      markNeedsPaint();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('style', style))
      ..add(FlagProperty('focused', value: focused, ifTrue: 'focused'));
  }
}

/// The [FFocusedOutline]'s style.
class FFocusedOutlineStyle with Diagnosticable, _$FFocusedOutlineStyleFunctions {
  /// The outline's color.
  @override
  final Color color;

  /// The border radius.
  @override
  final BorderRadius borderRadius;

  /// The outline's width. Defaults to 1.
  ///
  /// ## Contract
  /// Throws [AssertionError] if the width is not positive.
  @override
  final double width;

  /// The spacing between the outline and the outlined widget. Defaults to 2.
  @override
  final double spacing;

  /// Creates a [FFocusedOutlineStyle].
  const FFocusedOutlineStyle({
    required this.color,
    required this.borderRadius,
    this.width = 1,
    this.spacing = 3,
  }) : assert(0 < width, 'The width must be greater than 0.');
}
