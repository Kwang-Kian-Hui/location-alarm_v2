// @dart=2.9
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:location_alarm/location_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CountryCodes.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ProviderScope(child: LocationApp()));
  });
}
