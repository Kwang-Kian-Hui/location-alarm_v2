import 'dart:convert';
import 'package:http/http.dart';
import 'package:location_alarm/application/network.dart';
import 'package:location_alarm/application/place_and_suggestion.dart';

class GooglePlaceApiProvider{
  final sessionToken;
  final client = Client();
  static final apiKey = '[Places-API-KEY]';

  GooglePlaceApiProvider(this.sessionToken);

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    Network n = new Network("http://ip-api.com/json");
    String locationSTR = (await n.getData());
    var locationx = jsonDecode(locationSTR);
    String countryCode = locationx["countryCode"];
    var uri = Uri.parse('');
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request = '$baseURL?input=$input&components=country:$countryCode&key=$apiKey&sessiontoken=$sessionToken';
    try{
      uri = Uri.parse(request);
    }
    on FormatException catch(e) {
      print('$e');
    }

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    var uri = Uri.parse('');
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';

    try{
      uri = Uri.parse(request);
    }
    on FormatException catch(e) {
      print('$e');
    }
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place('', '', '', '');
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}