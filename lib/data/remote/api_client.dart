import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

// class ApiClient {
//   final Dio _dio = Dio();

//   ApiClient() {
//     _dio.options.baseUrl = 'http://192.168.0.133:8080/api';
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         final token = GetStorage().read('jwt');
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//     ));
//   }

//   Dio get client => _dio;
// }

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.0.104:8080/api',
      validateStatus: (status) {
        // Ici on ne throw pas sur les 400, on gère nous-mêmes
        return status != null && status < 500;
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = GetStorage().read('jwt');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  Dio get client => _dio;
}
