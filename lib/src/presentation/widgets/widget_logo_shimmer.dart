import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class WidgetLogoAdsSpeed extends StatelessWidget {
  final double? width;
  final Color? color;

  const WidgetLogoAdsSpeed({
    super.key,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetAppSVG(
      assetsvg('app_logo'),
      width: width ?? 220.sw,
      color: color,
    );
  }
}

class WidgetLogoShimmer extends StatelessWidget {
  final double? width;
  final Color? baseColor; 
  final Color? highlightColor;
  const WidgetLogoShimmer({super.key, this.width, this.baseColor, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Shimmer.fromColors(
        baseColor: baseColor ?? AppColors.instance.shimmerBaseColor,
        highlightColor: highlightColor ?? AppColors.instance.shimerHighlightColor,
        child: WidgetLogoAdsSpeed(width: width),
      ),
    );
  }
}
