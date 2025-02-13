import 'package:flutter/material.dart';

class WidgetHoverBuilder extends StatefulWidget {
  final Widget Function(bool isHover) builder;
  const WidgetHoverBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<WidgetHoverBuilder> createState() => _WidgetHoverBuilderState();
}

class _WidgetHoverBuilderState extends State<WidgetHoverBuilder> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (details) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (details) => setState(() {
        setState(() {
          isHover = false;
        });
      }),
      child: widget.builder(isHover),
    );
  }
}


class WidgetInkWellTransparent extends StatelessWidget {
  const WidgetInkWellTransparent({
    super.key,
    this.onTap,
    required this.child,
    this.borderRadius,
    this.radius,
    this.hoverColor,
    this.onTapDown,
  });

  final Color? hoverColor;
  final Widget child;
  final VoidCallback? onTap;
  final dynamic onTapDown;
  final BorderRadius? borderRadius;
  final double? radius;

  BorderRadius get _borderRadius =>
      borderRadius ?? BorderRadius.circular(radius ?? 999);

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return child;
    // return Material(
    //   color: Colors.transparent,
    //   shape: RoundedRectangleBorder(borderRadius: _borderRadius),
    //   child: InkWell(
    //     borderRadius: _borderRadius,
    //     onTap: onTap,
    //     onTapDown: onTapDown,
    //     // hoverColor: hoverColor ??
    //     //     (coreConfig.coreThemes.hoverColor != null
    //     //         ? coreConfig.coreThemes.hoverColor!()
    //     //         : hoverColor),
    //     child: child,
    //   ),
    // );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: ColoredBox(color: Colors.transparent, child: child),
      ),
    );
  }
}
