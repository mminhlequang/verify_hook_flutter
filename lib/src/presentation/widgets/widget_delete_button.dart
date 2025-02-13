import 'dart:math';

import 'package:app/src/constants/constants.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WidgetDeleteButton extends StatefulWidget {
  final VoidCallback callback;
  const WidgetDeleteButton({super.key, required this.callback});

  @override
  State<WidgetDeleteButton> createState() => _WidgetDeleteButtonState();
}

class _WidgetDeleteButtonState extends State<WidgetDeleteButton> {
  @override
  Widget build(BuildContext context) {
    return WidgetOverlayActions(
      builder:
          (child, size, childPosition, pointerPosition, animationValue, hide) {
        // Tính toán vị trí cho popup
        final popupPosition = Offset(
          childPosition.dx - 280.sw / 2 + size.width / 2,
          childPosition.dy - size.height,
        );

        return Positioned(
          left: popupPosition.dx,
          top: popupPosition.dy,
          child: Stack(
            alignment: Alignment.topCenter, // Thay đổi alignment
            children: [
              Container(
                width: 280.sw,
                margin: const EdgeInsets.only(top: 8), // Thay đổi margin
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 6),
                      blurRadius: 20,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Are you sure\nThat you want delete it?',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: w400TextStyle(fontSize: 16),
                        ),
                      ),
                      const Gap(12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WidgetRippleButton(
                            onTap: () {
                              hide();
                            },
                            color: appColorElement,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: w400TextStyle(),
                              ),
                            ),
                          ),
                          const Gap(12),
                          WidgetRippleButton(
                            onTap: () async {
                              await hide();
                              widget.callback();
                            },
                            color: appColorText,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              child: Text(
                                'Yes',
                                style: w400TextStyle(color: appColorBackground),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Transform.rotate(
                angle: -pi / 4, // Đảo ngược góc xoay
                child: Container(
                  height: 16,
                  width: 16,
                  color: appColorBackground,
                ),
              )
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          CupertinoIcons.delete_simple,
          color: appColorText,
          size: 16.sw,
        ),
      ),
    );
  }
}
