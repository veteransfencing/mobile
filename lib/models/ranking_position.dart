class RankingPosition {
  int position;
  String lastName;
  String firstName;
  String country;
  double points;
  String id;

  RankingPosition(this.id, this.position, this.lastName, this.firstName, this.country, this.points);

  RankingPosition.fromJson(Map<String, dynamic> doc)
      : id = doc['id'] as String,
        lastName = doc['name'] as String,
        firstName = doc['firstName'] as String,
        country = doc['country'] as String,
        position = doc['pos'] as int,
        points = (doc['points'] as num).toDouble();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': lastName,
        'firstName': firstName,
        'country': country,
        'pos': position,
        'points': points,
      };
}
