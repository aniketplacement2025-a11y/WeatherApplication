import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _fetchWeather() async {
    if (_cityController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city';
        _weather = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _weather = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Enter City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchWeather,
                child: const Text('Get Weather'),
              ),
              const SizedBox(height: 20),
              _buildWeatherDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDisplay() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        style: TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.center,
      );
    }

    if (_weather == null) {
      return const Text(
        'Enter a city to get the weather',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: [
        Text(_weather!.city, style: Theme.of(context).textTheme.headlineMedium),
        Image.network(_weather!.iconUrl),
        Text(
          '${_weather!.temperature}°C',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          _weather!.condition,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
