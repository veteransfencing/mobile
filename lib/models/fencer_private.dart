class FencerPrivate {
  String id;
  String lastName;
  String firstName;
  String country;
  String gender;
  DateTime dateOfBirth;
  String picture;

  FencerPrivate()
      : id = '',
        lastName = '',
        firstName = '',
        country = '',
        gender = 'M',
        picture = '',
        dateOfBirth = DateTime(1000, 1, 1);

  FencerPrivate.fromJson(Map<String, dynamic> doc)
      : id = doc['id'] as String,
        lastName = doc['lastName'] as String,
        firstName = doc['firstName'] as String,
        country = doc['country'] as String,
        dateOfBirth = DateTime.parse(doc['dateOfBirth'] ?? '1000-01-01'),
        picture = doc['picture'] ?? 'N',
        gender = doc['gender'] ?? 'M';

  Map<String, dynamic> toJson() => {
        'id': id,
        'lastName': lastName,
        'firstName': firstName,
        'country': country,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'picture': picture
      };

  String fullName() {
    return "$lastName, $firstName";
  }
}
