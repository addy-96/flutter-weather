import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/const.dart';
import 'package:weather_app/screens/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _weatherFactory = WeatherFactory(OPEN_WEATHER_API_KEY);
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLocationAndWeather();
  }

  Future<void> _fetchLocationAndWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final location = Location();
      final serviceEnabled = await _checkLocationService(location);
      final permissionGranted = await _checkLocationPermission(location);

      if (!serviceEnabled || permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location services or permissions not available.';
        });
        return;
      }

      final locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location data is null.';
        });
        return;
      }

      final weather = await _weatherFactory.currentWeatherByLocation(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (weather == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Weather data not found.';
        });
        return;
      }

      setState(() {
        _weather = weather;
        _isLoading = false;
      });

      log(weather.temperature.toString());
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching weather data: $e';
      });
      log(e.toString());
    }
  }

  Future<bool> _checkLocationService(Location location) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  Future<PermissionStatus> _checkLocationPermission(Location location) async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }
    return permission;
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
          child:
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)));
    }

    if (_weather == null) {
      return const Center(child: Text('No weather data available.'));
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getAreaName(),
            const SizedBox(height: 30),
            _getFormattedDate(),
            const SizedBox(height: 40),
            _getTemperature(),
            _getWeatherIcon(_weather!.weatherIcon.toString()),
            const SizedBox(height: 20),
            _getDetailCard(),
          ],
        ),
      ),
    );
  }

  Widget _getAreaName() {
    return Text(
      '${_weather!.areaName} ${_weather!.country}',
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Widget _getFormattedDate() {
    return Text(
      DateFormat.yMMMEd().format(_weather!.date!),
      style: const TextStyle(fontSize: 30),
    );
  }

  Widget _getTemperature() {
    return Text(
      '${_weather!.temperature!.celsius!.toInt()}° C',
      style: const TextStyle(fontSize: 100),
    );
  }

  Widget _getDetailCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Text(
                _weather!.weatherDescription!.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Min Temp: ${_weather!.tempMin}',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Max Temp: ${_weather!.tempMax}',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Wind Speed: ${_weather!.windSpeed}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String iconCode) {
    final iconUrl = 'https://openweathermap.org/img/wn/$iconCode@4x.png';
    return Image.network(iconUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const HomePage()),
              );
            },
            icon: const Icon(Icons.replay_outlined, size: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SearchCity()),
              );
            },
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }
}
