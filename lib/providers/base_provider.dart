import 'package:evf/environment.dart';
import 'package:evf/util/random_string.dart';
import 'package:flutter/foundation.dart';

class BaseProvider extends ChangeNotifier {
  final String uuid;

  BaseProvider() : uuid = getRandomString(20);

  void debug(String txt) {
    Environment.debug("$uuid: $txt");
  }
}
