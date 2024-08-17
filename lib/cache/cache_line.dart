import 'package:evf/util/timestamp.dart';

class CacheLine {
  String timestamp = '';
  String path = '';
  DateTime date = DateTime.now();
  DateTime policy = DateTime.now();

  CacheLine({required this.path, required this.policy}) {
    date = DateTime.now();
    timestamp = makeTimestamp(date);
  }

  CacheLine.fromJson(Map<String, dynamic> values) {
    timestamp = values['ts'].toString();
    path = values['path'].toString();
    // unmake the timestamp so we get milliseconds
    date = unmakeTimestamp(timestamp);
    policy = DateTime.parse(values['policy'] as String);
  }

  Map<String, dynamic> toJson() => {
        'ts': timestamp,
        'path': path,
        'policy': policy.toIso8601String(),
      };
}
