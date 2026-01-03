import 'package:flutter/material.dart';
import '../app_dimens.dart';
import '../app_radius.dart';

class AppButtonStyles {
  AppButtonStyles._();

  /// Default button size
  static const buttonSize = Size(AppDimens.buttonWidth, AppDimens.buttonHeight);

  /// Button border radius
  static final buttonRadius = BorderRadius.circular(AppRadius.button);
}
