import 'package:flutter/material.dart';
import '../setup/index.dart';

class WidgetRippleButton extends StatelessWidget {
  const WidgetRippleButton({
    super.key,
    this.color,
    this.borderRadius = const BorderRadius.only(),
    this.elevation = 0,
    this.onTap,
    this.child,
    this.shadowColor,
    this.enable = true,
    this.hoverColor,
  });

  final bool enable;
  final Color? color;
  final Color? shadowColor;
  final double elevation;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final Widget? child;
  final Color? hoverColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shadowColor: shadowColor ?? appColorText.withOpacity(.1),
      color: color ?? hexColor('#F0F1F6'),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.none,
      child: InkWell(
        borderRadius: borderRadius,
        hoverColor: hoverColor,
        onTap: enable && onTap != null
            ? () {
                appHaptic();
                onTap!.call();
              }
            : null,
        child: child,

      ),
    );
  }
}
