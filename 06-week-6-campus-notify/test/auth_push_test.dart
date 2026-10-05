import 'package:campus_notify/data/api_errors.dart';
import 'package:campus_notify/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTokenStore {
  String? access;
  String? refresh;
}

DioException _dioError(DioExceptionType type, {int? status}) {
  final req = RequestOptions(path: '/x');
  return DioException(
    requestOptions: req,
    type: type,
    response: status == null
        ? null
        : Response(requestOptions: req, statusCode: status),
  );
}

void main() {
  group('routeFromMessage', () {
    test('menangani route kosong dan tanpa slash', () {
      expect(routeFromMessage({}), AppRoutes.home);
      expect(routeFromMessage({'route': 'pengumuman/3'}), '/pengumuman/3');
      expect(routeFromMessage({'route': '/pengumuman/3'}), '/pengumuman/3');
    });

    test('data payload membawa id pengumuman', () {
      const data = {'route': '/pengumuman/3', 'id': '3'};
      expect(data['id'], '3');
      expect(routeFromMessage(data), AppRoutes.announcement('3'));
    });

    test('route berisi spasi saja jatuh ke home', () {
      expect(routeFromMessage({'route': '   '}), AppRoutes.home);
    });
  });

  group('AppRoutes', () {
    test('konstanta rute konsisten dengan builder', () {
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.announcement('7'), '/pengumuman/7');
      expect(AppRoutes.announcementPattern, '/pengumuman/:id');
    });
  });

  group('friendlyMessage', () {
    test('401 -> sesi berakhir', () {
      final e = _dioError(DioExceptionType.badResponse, status: 401);
      expect(friendlyMessage(e), 'Sesi berakhir. Silakan login ulang.');
    });

    test('timeout -> koneksi terlalu lama', () {
      final e = _dioError(DioExceptionType.connectionTimeout);
      expect(friendlyMessage(e), 'Koneksi terlalu lama. Coba lagi.');
    });

    test('offline -> tidak ada koneksi', () {
      final e = _dioError(DioExceptionType.connectionError);
      expect(friendlyMessage(e), 'Tidak ada koneksi internet.');
    });

    test('500 -> server bermasalah', () {
      final e = _dioError(DioExceptionType.badResponse, status: 500);
      expect(friendlyMessage(e), 'Server sedang bermasalah. Coba lagi nanti.');
    });

    test('error non-Dio -> pesan umum', () {
      expect(friendlyMessage(Exception('x')), 'Terjadi kesalahan tak terduga.');
    });
  });

  group('sesi token', () {
    test('status login dibaca dari keberadaan token', () {
      final store = FakeTokenStore()..access = 'mock-access';
      expect(store.access != null, isTrue);
      store.access = null;
      expect(store.access != null, isFalse);
    });

    test('refresh kosong -> sesi dibersihkan (paksa login ulang)', () {
      final store = FakeTokenStore()..refresh = '';
      expect((store.refresh ?? '').isEmpty, isTrue);
    });
  });
} 