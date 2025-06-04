import 'package:flutter/material.dart';

double calculateFontSize(double screenWidth) {
  const double baseWidth = 650.0; // baseline screen width
  const double baseFontSize = 12.0; // base font size at baseline width
  const double scalingFactor = 0.15; // how much the font grows per pixel

  double fontSize = baseFontSize + (screenWidth - baseWidth) * scalingFactor;

  // Optional: Set minimum and maximum font size limits
  fontSize = fontSize.clamp(8.0, 16.0); // Minimum 12, maximum 24

  return fontSize;
}

double responsiveAspectRatio(double screenWidth) {
  double aspectRatioBaseWidth = 400.0; // baseline screen width
  double aspectRatioBase = 2.0; // baseline aspect ratio
  double aspectRatioScalingFactor =
      0.005; // how much the aspect ratio grows per pixel of screen width

  double aspectRatio =
      aspectRatioBase +
      (screenWidth - aspectRatioBaseWidth) * aspectRatioScalingFactor;
  aspectRatio = aspectRatio.clamp(
    1.5,
    3.0,
  ); // Optional clamping for very small or large screens

  return aspectRatio;
}

double responsiveBarWidth(double screenWidth) {
  double baseBarWidth = 3.0; // Default bar width

  // Decrease the bar width for smaller screens and increase for larger screens
  double barWidth = baseBarWidth + (screenWidth - 400) * 0.01;
  barWidth = barWidth.clamp(
    2.0,
    6.0,
  ); // Ensure the width is within a reasonable range

  return barWidth;
}

double responsiveDotSize(double screenWidth) {
  double baseDotSize = 4.0; // Default dot size

  // Decrease dot size for smaller screens and increase for larger screens
  double dotSize = baseDotSize + (screenWidth - 400) * 0.02;
  dotSize = dotSize.clamp(
    3.0,
    8.0,
  ); // Ensure dot size is within a reasonable range

  return dotSize;
}

Color getContrastingTextColor(Color background) {
  // Uses luminance to determine brightness
  final double luminance = background.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}
