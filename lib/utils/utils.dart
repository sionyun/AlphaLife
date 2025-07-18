import 'package:flutter/material.dart';

void openPage(BuildContext c, Widget page) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => page));
