import 'dart:convert';
import 'dart:ui';

import 'package:bytecare_mobile/models/api_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:bytecare_mobile/services/bytecare_api.dart';

class MockClient extends Mock implements http.Client {}

void performFullApiTest(Uri host) {
  group('apiTest', () {
    test('apiSignup', () async {
      final client = MockClient();
      final api = ByteCareAPI(host, client);

      when(client.get('127.0.0.1:5000/api/auth/signup'))
          .thenAnswer((_) async => http.Response(jsonEncode(
        { 'id': '209293fn8rengiug' }
      ), 200));

      expect(
        await api.signup(
          emailAddress: 'jesseb727@gmail.com',
          password: 'this15Myp@SSworD..<',
        ),
        ApiResult(code: 200, hasError: false, data: '209293fn8rengiug'),
      );
    });
    test('apiLogin', () async {
      final client = MockClient();
      final api = ByteCareAPI(host, client);
      when(client.get('127.0.0.1:5000/api/auth/login'))
          .thenAnswer((_) async => http.Response('', 200));

      expect(
        await api.login(
          emailAddress: 'jesseb727@gmail.com',
          password: 'this15Myp@SSworD..<',
        ),
        ApiResult(code: 200),
      );
    });
  });
}
