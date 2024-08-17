import 'package:evf/models/fencer_private.dart';
import 'package:intl/intl.dart';

import 'interface.dart';

Future<String> accountLink(FencerPrivate fencer, bool forceCreate) async {
  try {
    final api = Interface.create(path: '/device/account/link', data: {
      'fencer': {
        'lastName': fencer.lastName,
        'firstName': fencer.firstName,
        'gender': fencer.gender,
        'country': fencer.country,
        'dateOfBirth': DateFormat('yyyy-MM-dd').format(fencer.dateOfBirth),
        'forceCreate': forceCreate ? 'Y' : 'N'
      }
    });
    var content = await api.post();
    if (content.containsKey('status')) {
      return content['status'] as String;
    }
  } on NetworkError {
    // pass on the exception, just return false
  }
  return 'error';
}
