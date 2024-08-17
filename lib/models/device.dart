class Device {
  String deviceId;

  Device({required String id}) : deviceId = id;

  Device.fromJson(Map<String, dynamic> values)
      : deviceId = values['id'] as String;

  Map<String, String> toJson() => {'id': deviceId};
}
