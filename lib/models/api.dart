import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'msiswa.dart';

class BaseUrl {
  static String get base => kIsWeb ? 'http://localhost/biodata' : 'http://10.0.2.2/biodata';

  static String get data => '$base/list.php';
  static String get tambah => '$base/create.php';
  static String get lihat => '$base/details.php';
  static String get edit => '$base/update.php';
  static String get hapus => '$base/delete.php';
}

class ApiService {
  Future<List<SiswaModel>> getSiswa() async {
    final uri = Uri.parse(BaseUrl.data).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    final data = _decode(response);
    if (data is! List) throw const ApiException('Format data dari server tidak valid.');
    return data.map((item) => SiswaModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  Future<void> createSiswa(Map<String, String> body) => _send(BaseUrl.tambah, body);

  Future<void> updateSiswa(Map<String, String> body) => _send(BaseUrl.edit, body);

  Future<void> deleteSiswa(int id) => _send(BaseUrl.hapus, {'id': '$id'});

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Server mengembalikan status ${response.statusCode}.');
    }
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['success'] == false) throw const ApiException('Permintaan ke server gagal.');
      return data;
    } on FormatException {
      throw const ApiException('Respons server bukan JSON yang valid.');
    }
  }

  Future<void> _send(String url, Map<String, String> body) async {
    final response = await http.post(Uri.parse(url), body: body).timeout(const Duration(seconds: 10));
    _decode(response);
  }
}

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}