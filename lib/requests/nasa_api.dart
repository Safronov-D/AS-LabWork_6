import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class NasaApi {
  static const String _baseUrl = 'https://api.nasa.gov/mars-photos/api/v1';
  static const String _apiKey = 'AdwTujYaYoQWyniDJmXUxBqRl4epqWzpdYhxcioR';

  Future<List<Photo>> fetchPhotos() async {
    final uri = Uri.parse('$_baseUrl/rovers/spirit/photos?sol=50&api_key=$_apiKey');
    
    // Добавляем User-Agent
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'NASA-Rover-App/1.0'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> photosJson = data['photos'];
      
      if (photosJson.isEmpty) {
        throw Exception('No photos found for Spirit rover on sol 50');
      }
      
      return photosJson.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos: ${response.statusCode}');
    }
  }
}