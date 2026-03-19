import 'package:dio/dio.dart';
import '../models/dosen_model.dart';

class DosenRepository {
  final Dio _dio = Dio();

  Future<List<DosenModel>> getDosenList() async {
    final response = await _dio.get(
      'https://jsonplaceholder.typicode.com/users',
      options: Options(headers: {'Accept': 'application/json'}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => DosenModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dosen: ${response.statusCode}');
    }
  }
}