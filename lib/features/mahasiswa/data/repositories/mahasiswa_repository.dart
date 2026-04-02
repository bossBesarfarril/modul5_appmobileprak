import 'package:dio/dio.dart';
import 'package:riverpod_modul3/core/network/dio_client.dart';
import '../models/mahasiswa_model.dart';

class MahasiswaRepository {
  final DioClient _dioClient;

  MahasiswaRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<MahasiswaModel>> getMahasiswaList() async {
    try {
      // Menggunakan endpoint /users sebagai dummy data Mahasiswa
      final Response response = await _dioClient.dio.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => MahasiswaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal memuat data mahasiswa: ${e.response?.statusCode} - ${e.message}');
    }
  }
}