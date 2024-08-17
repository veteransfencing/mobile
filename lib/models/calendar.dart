// The basic Calendar model to display items in the calendar

class Calendar {
  String id;
  String url;
  String feed;
  String title;
  String content;
  String location;
  String country;
  DateTime startDate;
  DateTime endDate;
  DateTime mutated;

  Calendar(this.id, this.title, this.content, this.location, this.country, this.url, this.feed, this.startDate,
      this.endDate, this.mutated);

  Calendar.fromJson(Map<String, dynamic> doc)
      : id = doc['id'] ?? '',
        title = doc['title'] ?? '',
        content = doc['content'] ?? '',
        location = doc['location'] ?? '',
        country = doc['country'] ?? '',
        url = doc['url'] ?? '',
        feed = doc['feed'] ?? '',
        startDate = DateTime.parse(doc['startDate'] ?? '2000-01-01'),
        endDate = DateTime.parse(doc['endDate'] ?? '2000-01-01'),
        mutated = DateTime.parse(doc['mutated'] ?? '2000-01-01');

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'location': location,
        'country': country,
        'url': url,
        'start': startDate.toIso8601String(),
        'end': endDate.toIso8601String(),
        'mutated': mutated.toIso8601String()
      };
}
