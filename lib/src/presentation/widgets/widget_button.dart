import 'package:app/src/constants/constants.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

class WidgetAppButton extends StatelessWidget {
  final bool enable;
  final bool loading;
  final String label;
  final Widget? icon;
  final VoidCallback? onTap;
  const WidgetAppButton({
    super.key,
    this.enable = true,
    this.loading = false,
    required this.label,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enable || loading ? null : onTap,
        child: Ink(
          height: 44.sw,
          padding: EdgeInsets.symmetric(horizontal: 24.sw),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: enable ? appColorText : appColorElement),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appColorPrimary,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        SizedBox(
                          width: 8.sw
                        )
                      ],
                      Text(
                        label,
                        style: w400TextStyle(
                            color: appColorBackground, fontSize: 14.sw),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
