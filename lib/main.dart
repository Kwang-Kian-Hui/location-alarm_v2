// @dart=2.9
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/initial_launch_notifier.dart';
import 'package:location_alarm/location_app.dart';
import 'package:location_alarm/shared/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CountryCodes.init();
  initialLaunch = await checkIfInitialLaunch();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ProviderScope(child: LocationApp()));
  });
}
