import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location_alarm/location_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new LocationApp());
  });
}
