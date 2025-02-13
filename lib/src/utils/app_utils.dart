import 'package:app/src/constants/constants.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:internal_core/internal_core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'utils.dart';

bool isFileHaveExtByPath(String path, {List<String>? exts}) {
  final ext = p.extension(path);
  if (exts?.isNotEmpty == true) {
    return exts!.any((e) => ext.endsWith(e));
  }
  return ext.isNotEmpty;
}

bool appIsBottomSheetOpen = false;
appOpenBottomSheet(
  Widget child, {
  bool isDismissible = true,
  bool enableDrag = true,
}) async {
  appIsBottomSheetOpen = true;
  var r = await showMaterialModalBottomSheet(
    enableDrag: enableDrag,
    context: appContext,
    builder: (_) => Padding(
      padding: MediaQuery.viewInsetsOf(_),
      child: child,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isDismissible: isDismissible,
    backgroundColor: Colors.white,
    useRootNavigator: true,
  );
  appIsBottomSheetOpen = false;
  return r;
}

bool appIsDialogOpen = false;
appOpenDialog(Widget child, {bool barrierDismissible = true}) async {
  appIsDialogOpen = true;
  var r = await showGeneralDialog(
    barrierLabel: "popup",
    barrierColor: Colors.black.withOpacity(.5),
    barrierDismissible: barrierDismissible,
    transitionDuration: const Duration(milliseconds: 300),
    context: appContext,
    pageBuilder: (context, anim1, anim2) {
      return child;
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  );
  appIsDialogOpen = false;
  return r;
}

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

appChangedTheme() {
  AppPrefs.instance.isDarkTheme = !AppPrefs.instance.isDarkTheme;
  WidgetsFlutterBinding.ensureInitialized().performReassemble();
}

enum AppSnackBarType { error, success, notitfication }

appCatchLog(e) {
  appDebugPrint('[catchLog] $e');
}

showSnackBar({context, required msg, Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: w300TextStyle(color: appColorBackground),
      ),
      duration: duration ?? const Duration(seconds: 1),
      backgroundColor: appColorText,
    ),
  );
}

bool isImageByMime(type) {
  switch (type) {
    case 'image/jpeg':
    case 'image/png':
      return true;
    default:
      return false;
  }
}

String get timestampId => "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
appTopRightNotification({
  BuildContext? context,
  String? message,
  AppTopRightNotificationType type = AppTopRightNotificationType.error,
}) {
  try {
    ElegantNotification notification;

    switch (type) {
      case AppTopRightNotificationType.success:
        notification = ElegantNotification.success(
          background: appColorBackground,
          toastDuration: const Duration(seconds: 3),
          progressIndicatorBackground: appColorElement,
          width: 400.sw,
          title: Text(
            'Success',
            style: w500TextStyle(fontSize: 16),
          ),
          description: Text(
            message ?? "Operation successful!",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: w400TextStyle(),
          ),
        );
        break;
      case AppTopRightNotificationType.info:
        notification = ElegantNotification.info(
          width: 400.sw,
          background: appColorBackground,
          toastDuration: const Duration(seconds: 2),
          progressIndicatorBackground: appColorElement,
          title: Text(
            'Information',
            style: w500TextStyle(fontSize: 16),
          ),
          description: Text(
            message ?? "New information!",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: w400TextStyle(),
          ),
        );
        break;
      case AppTopRightNotificationType.error:
      default:
        notification = ElegantNotification.error(
          width: 400.sw,
          toastDuration: const Duration(seconds: 5),
          background: appColorBackground,
          progressIndicatorBackground: appColorElement,
          title: Text(
            'Warning',
            style: w500TextStyle(fontSize: 16),
          ),
          description: Text(
            message ?? "An error occurred!",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: w400TextStyle(),
          ),
        );
    }

    notification.show(context ?? appContext);
  } catch (_) {}
}

enum AppTopRightNotificationType {
  error,
  success,
  info,
}

AppStatus appStatus(dynamic status) {
  if (status is int) {
    switch (status) {
      case 1:
        return AppStatus.active;
      case 2:
        return AppStatus.disable;
      case 3:
        return AppStatus.needPay;
      case 4:
        return AppStatus.closed;
      case 5:
        return AppStatus.grace;
      case 6:
        return AppStatus.restricted;
      default:
        return AppStatus.unknown;
    }
  }

  switch (status.toString().toLowerCase()) {
    case 'active':
      return AppStatus.active;
    case 'disable':
      return AppStatus.disable;
    case 'need pay':
      return AppStatus.needPay;
    case 'closed':
      return AppStatus.closed;
    case 'grace':
      return AppStatus.grace;
    case 'restricted':
      return AppStatus.restricted;
    default:
      return AppStatus.unknown;
  }
}
