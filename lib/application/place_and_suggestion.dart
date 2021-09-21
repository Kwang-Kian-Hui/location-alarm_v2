class Place {
  String streetNumber;
  String street;
  String city;
  String zipCode;

  Place(
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  );

  @override
  String toString() {
    return '$streetNumber, $street, $city, $zipCode)';
    // place.streetnumber place.street place.city place.zipcode 
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString(){
    return 'Suggestion(description: $description, placeId: $placeId';
  }
}