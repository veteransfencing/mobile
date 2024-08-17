import 'interface.dart';

Future<bool> accountCheck(String code) async {
  try {
    final api = Interface.create(path: '/device/account/check', data: {'code': code});
    var content = await api.post();
    if (content.containsKey('status') && content['status'] == 'ok') {
      return true;
    }
  } on NetworkError {
    // pass on the exception, just return false
  }
  return false;
}
