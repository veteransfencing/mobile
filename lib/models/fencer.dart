class Fencer {
  String id;
  String lastName;
  String firstName;
  String country;
  String countryShort;

  Fencer(this.id)
      : lastName = '',
        firstName = '',
        country = '',
        countryShort = '';

  Fencer.fromJson(Map<String, dynamic> doc)
      : id = (doc['id'] ?? '') as String,
        lastName = (doc['lastName'] ?? '') as String,
        firstName = (doc['firstName'] ?? '') as String,
        country = (doc['country'] ?? '') as String,
        countryShort = doc['countryShort'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'lastName': lastName,
        'firstName': firstName,
        'country': country,
        'countryShort': countryShort,
      };

  String fullName() {
    return "$lastName, $firstName";
  }
}
