import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(surface: Colors.white),
);
