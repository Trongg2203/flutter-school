import 'dart:convert';

String generateFakeJWT() {
  // Tạo header
  final header = jsonEncode({
    "alg": "HS256",
    "typ": "JWT"
  });

  // Tạo payload chứa quyền hạn user
  final payload = jsonEncode({
    "user_id": 123,
    "role": "admin",
    "exp": DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000
  });

  // Mã hóa Base64 URL (loại bỏ '=' ở cuối chuỗi)
  String encodeBase64(String data) {
    return base64Url.encode(utf8.encode(data)).replaceAll('=', '');
  }

  // Tạo token giả (không có signature thật)
  String token = "${encodeBase64(header)}.${encodeBase64(payload)}.fake_signature";

  return token;
}

void main() {
  String fakeJWT = generateFakeJWT();
  print(fakeJWT);
}
