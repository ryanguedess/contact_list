import 'package:contact_list/ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/home_page.dart';

void main() {

  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}
