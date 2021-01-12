import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/core/network/service/transaction/transaction_service.dart';
import 'package:geldstroom/shared/common/config/env.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  group('TransactionService', () {
    Dio dio;
    TransactionService service;
    DioAdapterMock dioAdapterMock;

    setUp(() {
      DotEnv().env = {'mode': 'test'};
      dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
      dioAdapterMock = DioAdapterMock();
      dio.httpClientAdapter = dioAdapterMock;
      service = TransactionService(dio);
    });

    test('getBalance when successful', () async {
      final payload = {
        'income': 20000,
        'expense': 10000,
      };
      final httpResponse = buildResponseBody(payload: payload);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final dto = GetBalanceDto.weekly();
      final result = await service.getBalance(dto);
      result.fold(
        (l) {
          expect(l, null);
        },
        (r) {
          expect(r, TransactionTotal.fromJson(payload));
        },
      );
    });

    test('getBalance when failure', () async {
      final httpResponse = buildResponseBody(
        payload: null,
        statusCode: null,
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final dto = GetBalanceDto.weekly();
      final result = await service.getBalance(dto);
      result.fold(
        (l) {
          expect(l, ServerError.networkError());
        },
        (r) {
          expect(r, null);
        },
      );
    });
  });
}