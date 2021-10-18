import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkIfInitialLaunch() async {
  final pref = await SharedPreferences.getInstance();
  bool firstLaunch = await pref.getInt('initialLaunch') != 1 ? true : false;
  pref.setInt('initialLaunch', 1);
  return firstLaunch;
}