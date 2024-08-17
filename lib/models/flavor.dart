import 'package:firebase_core/firebase_core.dart';

abstract class Flavor {
  // flavor based configuration use a getter
  String get apiUrl => '';
  Duration get schedule => const Duration(seconds: 1);
  Duration get status => const Duration(seconds: 1);
  FirebaseOptions get fcm;
}
