import 'package:flutter/material.dart';

import 'package:dotto/components/color_fun.dart';

Widget createProgressIndicator() {
  return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: customFunColor,
      ));
}
