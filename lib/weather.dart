class Weather {
  final String city;
  final double temperature;
  final String condition;
  final String iconUrl;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['location']['name'],
      temperature: json['current']['temp_c'].toDouble(),
      condition: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
    );
  }
}
