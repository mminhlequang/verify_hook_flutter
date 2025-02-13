import 'package:app/src/constants/constants.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WidgetDialogContainer extends StatelessWidget {
  final Widget child;
  final String? heroTag;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  const WidgetDialogContainer(
      {super.key,
      required this.child,
      this.heroTag,
      this.width,
      this.height,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Material(
        color: Colors.black26,
        child: Center(
          child: Hero(
            tag: heroTag ?? 'WidgetFormCreateSubjects',
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin:   EdgeInsets.all(24.sw ),
                  padding:  padding ??   EdgeInsets.all(32.sw),
                  width: width ?? 680,
                  height: height,
                  decoration: BoxDecoration(
                      color: appColorBackground,
                      borderRadius: BorderRadius.circular(26.sw)),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
