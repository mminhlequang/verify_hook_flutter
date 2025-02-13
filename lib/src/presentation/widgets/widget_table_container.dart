import 'dart:math';

import 'package:internal_core/internal_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:app/src/constants/constants.dart';

import 'widget_copyable.dart';
import 'widget_hover_builder.dart';
import 'widgets.dart';

class WidgetTableContainer extends StatelessWidget {
  final Widget header;
  final Widget data;
  final double? width;
  const WidgetTableContainer({
    super.key,
    required this.header,
    required this.data,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 42.sw),
            child: data,
          ),
        ),
        WidgetRowHeader(
          child: header,
        ),
      ],
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: appColorElement),
        borderRadius: BorderRadius.circular(16.sw),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.sw),
        child: width != null && width! > context.width
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: child,
                ),
              )
            : child,
      ),
    );
  }
}

class WidgetRowHeader extends StatelessWidget {
  final Widget child;
  const WidgetRowHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.sw,
      decoration: BoxDecoration(
        color: appColorElement,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sw)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 20.sw,
              spreadRadius: 4.sw,
              offset: Offset(0, 4.sw))
        ],
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 4),
      child: child,
    );
  }
}

class WidgetRowItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Function()? onTap;
  final bool ignoringChild;
  const WidgetRowItem({
    super.key,
    this.ignoringChild = true,
    required this.child,
    this.index = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: WidgetHoverBuilder(builder: (isHover) {
        return Container(
          decoration: BoxDecoration(
              color: isHover && onTap != null
                  ? appColorText.withOpacity(.05)
                  : index % 2 != 0
                      ? appColorBackground
                      : appColorElement.withOpacity(.2),
              border: Border.all(width: 0.4, color: appColorBackground)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          // child: onTap != null
          //     ? IgnorePointer(
          //         ignoring: ignoringChild,
          //         child: child,
          //       )
          //     : child,
          child: child,
        );
      }),
    );
  }
}

enum CellDataType { string, bol, date }

class WidgetRowValue extends StatefulWidget {
  //For display
  final int flex;
  final Alignment alignment;
  final int maxLines;
  // String? // Widget
  final dynamic value;
  final String? subValue;
  final bool isLabel;
  final dynamic valueEdit;

  // String? // Widget
  final dynamic valueHover;

  //For edit
  final double inputWidth;
  final int inputMaxLines;
  final ValueChanged? callback;
  final CellDataType cellDataType;
  final String? label;
  final TextStyle? textStyle;

  const WidgetRowValue({
    super.key,
    required this.value,
    this.valueEdit,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
    this.inputWidth = 400,
    this.maxLines = 1,
    this.inputMaxLines = 5,
    this.callback,
    this.cellDataType = CellDataType.string,
    this.label,
    this.valueHover,
    this.textStyle,
  })  : isLabel = false,
        subValue = null;

  const WidgetRowValue.label({
    super.key,
    required this.value,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
    this.subValue,
  })  : isLabel = true,
        valueHover = null,
        valueEdit = null,
        maxLines = 2,
        inputMaxLines = 1,
        inputWidth = 400,
        callback = null,
        label = null,
        cellDataType = CellDataType.string,
        textStyle = null;

  @override
  State<WidgetRowValue> createState() => _WidgetRowValueState();
}

class _WidgetRowValueState extends State<WidgetRowValue> {
  final GlobalKey<WidgetOverlayActionsState> globalKey = GlobalKey();
  var hide;
  bool isHover = false;

  static TextStyle get textStyleLabel => w400TextStyle(fontSize: 12.sw);
  static TextStyle get textStyleSubLabel => w300TextStyle(fontSize: 8.sw);
  static TextStyle get textStyleValue => w300TextStyle(height: 1.6);

  @override
  Widget build(BuildContext context) {
    Widget childW = const SizedBox();
    switch (widget.cellDataType) {
      case CellDataType.string:
        childW = SizedBox(
          width:
              min(widget.inputWidth, MediaQuery.of(context).size.width * .85),
          child: WidgetTextField(
            label: widget.label,
            maxLines: widget.inputMaxLines,
            controller: TextEditingController(
              text: widget.valueEdit ?? widget.value.toString(),
            )..selection =
                TextSelection.collapsed(offset: widget.value.toString().length),
            autoFocus: true,
            onSubmitted: (value) {
              hide();
              widget.callback?.call(value);
            },
          ),
        );
        break;
      case CellDataType.bol:
        childW = WidgetCheck(
          status: widget.value,
          label: widget.label ?? '',
          callback: (value) {
            hide();
            widget.callback?.call(value);
          },
        );

        break;
      default:
    }
    return Expanded(
      flex: widget.flex,
      child: Align(
        alignment: widget.alignment,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: WidgetOverlayActions(
            key: globalKey,
            gestureType: GestureType.none,
            child: InkWell(
              onTap: widget.value is Widget
                  ? null
                  : () {
                      Clipboard.setData(ClipboardData(
                        text: widget.value is Widget
                            ? ''
                            : widget.value.toString(),
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Text copied success!",
                            style: w300TextStyle(color: appColorBackground),
                          ),
                          duration: const Duration(milliseconds: 500),
                          backgroundColor: appColorText,
                        ),
                      );
                    },
              onDoubleTap: () {
                globalKey.currentState?.showMenu();
              },
              onHover: (value) {
                if (widget.valueHover != null) {
                  setState(() {
                    isHover = value;
                  });
                }
              },
              child: PortalTarget(
                visible: isHover,
                anchor: const Aligned(
                    follower: Alignment.bottomCenter,
                    target: Alignment.topCenter,
                    offset: Offset(0, -8)),
                portalFollower: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
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
                      child: widget.valueHover is Widget
                          ? widget.valueHover
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                widget.valueHover.toString(),
                                maxLines: widget.maxLines,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleValue,
                              ),
                            ),
                    ),
                    Transform.rotate(
                      angle: pi / 4,
                      child: Container(
                        height: 16,
                        width: 16,
                        color: appColorBackground,
                      ),
                    )
                  ],
                ),
                child: widget.value is Widget
                    ? widget.value
                    : widget.isLabel
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.value.toString(),
                                maxLines: widget.maxLines,
                                overflow: TextOverflow.ellipsis,
                                style: textStyleLabel,
                              ),
                              if (widget.subValue != null)
                                Text(
                                  widget.subValue.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleSubLabel,
                                )
                            ],
                          )
                        : Text(
                            widget.value.toString(),
                            maxLines: widget.maxLines,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??  textStyleValue,
                          ),
              ),
            ),
            builder: (child, size, childPosition, pointerPosition,
                animationValue, hide) {
              this.hide = hide;
              return Positioned(
                left: childPosition.dx - 12,
                top: childPosition.dy - size.height,
                child: WidgetPopupContainer(
                  alignmentTail: Alignment.topLeft,
                  paddingTail: const EdgeInsets.only(left: 28),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: childW,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class WidgetRowValueEditale extends StatefulWidget {
  final int flex;
  final Alignment alignment;
  final int maxLines;
  final String? value;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter>? inputFormatters;
  const WidgetRowValueEditale({
    super.key,
    required this.value,
    required this.onChanged,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
    this.maxLines = 1,
    this.inputFormatters,
  });

  @override
  State<WidgetRowValueEditale> createState() => _WidgetRowValueEditaleState();
}

class _WidgetRowValueEditaleState extends State<WidgetRowValueEditale> {
  TextStyle get textStyleValue =>
      w400TextStyle(color: hexColor('#9499AD'), fontSize: 14.sw, height: 1);
  TextEditingController? controller;
  FocusNode focusNode = FocusNode();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus && isEditing) {
        setState(() {
          isEditing = false;
        });
        widget.onChanged(controller!.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: GestureDetector(
        onDoubleTap: () {
          controller = TextEditingController();
          setState(() {
            isEditing = !isEditing;
          });
          focusNode.requestFocus();
        },
        child: isEditing
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextField(
                  inputFormatters: widget.inputFormatters,
                  focusNode: focusNode,
                  controller: controller,
                  style: textStyleValue,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: appColorPrimary, width: .8))),
                ),
              )
            : Align(
                alignment: widget.alignment,
                child: WidgetTextCopyable(
                  widget.value ?? "",
                  maxLines: widget.maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: textStyleValue,
                ),
              ),
      ),
    );
  }
}

class WidgetRowValueShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final int flex;
  final Alignment alignment;
  const WidgetRowValueShimmer({
    super.key,
    this.width,
    this.height,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: WidgetAppShimmer(
          width: width ?? 60.sw,
          height: height ?? 16.sw,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class WidgetPaginateTable extends StatelessWidget {
  final int currentPage;
  final int currentRow;
  final int? numberOfPages;
  final Function() onPrePressed;
  final Function() onNextPressed;
  final Function(int) onChangedRow;
  final Function(int)? onChangedPage;
  final bool isEnableNext;

  const WidgetPaginateTable({
    super.key,
    this.isEnableNext = false,
    required this.currentPage,
    required this.currentRow,
    required this.onPrePressed,
    required this.onNextPressed,
    required this.onChangedRow,
    this.onChangedPage,
    this.numberOfPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WidgetOverlayActions(
          gestureType: numberOfPages == null || numberOfPages == 0
              ? GestureType.none
              : GestureType.onTap,
          child: Container(
            decoration: BoxDecoration(
                color: appColorElement,
                borderRadius: BorderRadius.circular(16.sw)),
            child: SizedBox(
              height: 42.sw,
              child: Row(
                children: [
                  WidgetInkWellTransparent(
                      onTap: currentPage == 1 ? null : onPrePressed,
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_left,
                          color: currentPage == 1
                              ? appColorText.withOpacity(.45)
                              : appColorText,
                        ),
                      )),
                  Text(
                    '${'Page'.tr()} $currentPage',
                    style: w300TextStyle(),
                  ),
                  WidgetInkWellTransparent(
                    onTap: isEnableNext ? onNextPressed : null,
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_right,
                        color: !isEnableNext
                            ? appColorText.withOpacity(.45)
                            : appColorText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          builder: (
            Widget child,
            Size size,
            Offset position,
            rightClickPosition,
            double animationValue,
            Function hide,
          ) {
            if (numberOfPages == null) return const SizedBox();
            return Positioned(
              left: position.dx,
              top: position.dy - (30 * min(numberOfPages!, 10) + 22) - 8,
              child: Transform.scale(
                scale: animationValue,
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: size.width,
                  height: (30 * min(numberOfPages!, 10) + 22),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: appColorElement,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: appColorText.withOpacity(.1),
                        offset: const Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(numberOfPages!, (index) => index + 1)
                              .map(
                                (e) => WidgetRippleButton(
                                  onTap: () {
                                    hide();
                                    onChangedPage?.call(e);
                                  },
                                  // hoverColor: Colors.white12,
                                  child: Container(
                                    width: size.width,
                                    height: 30,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      '${'Page'.tr()} $e',
                                      style: w300TextStyle(),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 16.sw),
        WidgetOverlayActions(
          child: Container(
            decoration: BoxDecoration(
                color: appColorElement,
                borderRadius: BorderRadius.circular(16.sw)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 42,
            child: Row(
              children: [
                Text(
                  '$currentRow ${'rows'.tr()}',
                  style: w300TextStyle(),
                ),
                Icon(Icons.arrow_drop_down, color: appColorText),
              ],
            ),
          ),
          builder: (
            Widget child,
            Size size,
            Offset position,
            rightClickPosition,
            double animationValue,
            Function hide,
          ) {
            return Positioned(
              left: position.dx,
              top: position.dy - (30 * 5 + 22) - 8,
              child: Transform.scale(
                scale: animationValue,
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: size.width,
                  height: (30 * 5 + 22),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: appColorElement,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: appColorText.withOpacity(.1),
                        offset: const Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [10, 20, 30, 40, 50]
                          .map(
                            (e) => WidgetRippleButton(
                              onTap: () {
                                hide();
                                onChangedRow(e);
                              },
                              // hoverColor: Colors.white12,
                              child: Container(
                                width: size.width,
                                height: 30,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '$e ${'rows'.tr()}',
                                  style: w300TextStyle(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
