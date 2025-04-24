import 'dart:convert';
import 'package:dahorta_app/models/collection_point.dart';
import 'package:dahorta_app/models/product.dart';
import 'package:dahorta_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const _baseUrl =
      'http://10.0.2.2:8000/api'; // Android: use 10.0.2.2 para localhost
  static final _storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> setToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool auth = false,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (auth) 'Authorization': 'Bearer ${await getToken()}',
    };
    final body = jsonEncode(data);
    return http.post(uri, headers: headers, body: body);
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool auth = false,
  }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    // Configuração do header, incluindo token de autenticação, se necessário
    final headers = {
      'Content-Type': 'application/json',
      if (auth) 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
    };
    final body = jsonEncode(
      data,
    ); // Aqui você envia os dados convertidos para JSON

    try {
      final response = await http.put(url, headers: headers, body: body);
      return response;
    } catch (e) {
      rethrow; // Lançando o erro para ser tratado no chamador
    }
  }

  static Future<http.Response> get(String endpoint, {bool auth = false}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      'Accept': 'application/json',
      if (auth) 'Authorization': 'Bearer ${await getToken()}',
    };

    return http.get(uri, headers: headers);
  }

  static Future<List<Product>> fetchProducts() async {
    final res = await get('/products', auth: true);

    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    }

    throw Exception('Erro ao buscar produtos');
  }

  static Future<List<CollectionPoint>> fetchCollectionPoints() async {
    final res = await get('/collection-points', auth: true);

    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      return jsonList.map((json) => CollectionPoint.fromJson(json)).toList();
    }

    throw Exception('Erro ao buscar pontos de coleta');
  }

  static Future<User> fetchProfile() async {
    final res = await get('/user', auth: true);
    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erro ao carregar perfil');
    }
  }
}
