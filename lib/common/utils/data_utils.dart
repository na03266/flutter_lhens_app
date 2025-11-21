import 'dart:convert';

class DataUtils {
  static String datetimeParse(String value) {
    return DateTime.parse(
      value,
    ).toLocal().toString().split(' ')[0].replaceAll('-', '. ');
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);
    return encoded;
  }
}
