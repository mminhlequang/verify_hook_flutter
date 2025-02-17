import 'package:flutter/material.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:temp_package_name/src/constants/constants.dart';

import 'widgets/trx_screen.dart';

class VerifyPortalScreen extends StatefulWidget {
  final String? platformId;
  final String? identifierCode;
  final String? networkCode;
  const VerifyPortalScreen({
    super.key,
    this.platformId,
    this.identifierCode,
    this.networkCode,
  });

  @override
  State<VerifyPortalScreen> createState() => _VerifyPortalScreenState();
}

class _VerifyPortalScreenState extends State<VerifyPortalScreen> {
  late CryptoNetwork network =
      CryptoNetwork.fromString(widget.networkCode ?? '');
  @override
  Widget build(BuildContext context) {
    print(widget.networkCode);
    print(widget.identifierCode);
    print(widget.platformId);
    print(network);
    Widget child;
    if (!network.isSupported) {
      child = const _WidgetNotSupport();
    } else {
      switch (network) {
        case CryptoNetwork.TRX:
          child = TRXScreen(
            platformId: widget.platformId,
            identifierCode: widget.identifierCode,
          );
        default:
          child = const _WidgetNotSupport();
      }
    }

    return Scaffold(
      body: child,
    );
  }
}

class _WidgetNotSupport extends StatelessWidget {
  const _WidgetNotSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Not support yet',
          style: w500TextStyle(fontSize: 20.sw),
        ),
      ),
    );
  }
}
