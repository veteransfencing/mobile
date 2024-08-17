import 'interface.dart';

Future<String> accountVerify(String email) async {
  try {
    final api = Interface.create(path: '/device/account/verify', data: {'email': email});
    var content = await api.post();
    if (content.containsKey('status')) {
      return content['status'] as String;
    }
  } on NetworkError {
    // pass on the exception, just return false
  }
  return 'error';
}
