import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather.dart';
class WeatherService {
  final String _apiKey = '3b083b0cded6401e977121311252609';
  final String _baseUrl = 'http://api.weatherapi.com/v1/current.json';

  Future<Weather> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?key=$_apiKey&q=$city'));

      if (response.statusCode == 200) {
        return Weather.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get weather data. Please try again.');
      }
    } catch (e) {
      throw Exception('An error occurred. Please check your connection.');
    }
  }
}