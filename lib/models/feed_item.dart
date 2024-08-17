// A FeedItem is the single element that is shown in the FeedList and stored in FeedBlocks.

enum FeedType {
  notification(1),
  news(2),
  message(3),
  result(4),
  ranking(5),
  friends(6);

  final int value;
  const FeedType(this.value);
  static FeedType fromValue(int val) {
    switch (val) {
      case 1:
        return FeedType.notification;
      case 2:
        return FeedType.news;
      case 3:
        return FeedType.message;
      case 4:
        return FeedType.result;
      case 5:
        return FeedType.ranking;
      case 6:
        return FeedType.friends;
      default:
        return FeedType.notification;
    }
  }
}

class FeedItem {
  var id = '';
  var type = FeedType.notification;
  var title = '';
  var content = '';
  var url = '';
  var user = '';
  DateTime published = DateTime.now();
  DateTime mutated = DateTime.now();

  FeedItem(
      {this.id = '',
      this.type = FeedType.notification,
      this.title = '',
      this.content = '',
      this.url = '',
      this.user = '',
      DateTime? published,
      DateTime? mutated})
      : published = published ?? DateTime.now(),
        mutated = mutated ?? DateTime.now();

  FeedItem.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        type = FeedType.fromValue(int.tryParse(json['type'] ?? '1') ?? 1),
        title = json['title'] ?? '',
        content = json['content'] ?? '',
        url = json['url'] ?? '',
        user = json['user'] ?? '',
        published = DateTime.parse(json['published'] ?? '2000-01-01'),
        mutated = DateTime.parse(json['mutated'] ?? '2000-01-01');

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.value.toString(),
        'title': title,
        'content': content,
        'url': url,
        'user': user,
        'published': published.toIso8601String(),
        'mutated': mutated.toIso8601String()
      };
}
