# location_alarm

Old API key id present in the google_places_api_provider.dart and AndroidManifest files are replaced with a placeholder string.
Keys are regenerated for respective APIs.



Credits: 
1) Google Places autocomplete 
Profile: https://medium.com/@yshean
Solution/Help source: https://medium.com/comerge/location-search-autocomplete-in-flutter-84f155d44721
Thanks to Yong Shean for the robust guide in setting up Google Places autocomplete, allowing me to greatly reduce the time needed to develop that feature into my app.


2) Improvement made to method of country code retrieval
Profile: https://stackoverflow.com/users/3736063/malek-tubaisaht
Solution/Help source: https://stackoverflow.com/questions/57977167/device-country-in-flutter
Thanks to Malek Tubaisaht for providing a solution to a related question on Stackoverflow, allowing me to get the country code of the device's current location.

Previously, country code retrieved is from locale class which retrieves the country code of the primary language selected for the device, not the location.

