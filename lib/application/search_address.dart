import 'package:flutter/material.dart';
import 'package:location_alarm/application/place_and_suggestion.dart';
import 'package:location_alarm/infrastructure/google_places_api_provider.dart';

class SearchAddress extends SearchDelegate<Suggestion> {
  final sessionToken;
  SearchAddress(this.sessionToken) {
    apiClient = GooglePlaceApiProvider(sessionToken);
  }

  late GooglePlaceApiProvider apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion('', ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: query == "" ? null : apiClient.fetchSuggestions(query),
        builder: (context, AsyncSnapshot<List<Suggestion>> snapshot) {
          if (query == '') {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Enter your address'),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data![index].description),
                onTap: () {
                  close(context, snapshot.data![index]);
                },
              ),
              itemCount: snapshot.data!.length,
            );
          } else {
            return const Center(
              child: Text('Loading...'),
            );
          }
        });
  }
}
