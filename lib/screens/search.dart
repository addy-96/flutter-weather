import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/const.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key});

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  final _citySearchController = TextEditingController();
  Weather? weather;
  bool isSearching = false;
  bool hasResult = false;
  String? errorMessage;

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  void _onSearch() async {
    setState(() {
      isSearching = true;
      errorMessage = null;
    });

    String city = _citySearchController.text.trim();

    if (city.isEmpty) {
      setState(() {
        isSearching = false;
        errorMessage = 'Please enter a city name.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name.')),
      );
      return;
    }

    final _wp = WeatherFactory(OPEN_WEATHER_API_KEY);
    try {
      weather = await _wp.currentWeatherByCityName(city);

      if (weather == null) {
        setState(() {
          isSearching = false;
          hasResult = false;
          errorMessage = 'City not found.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('City not found.')),
        );
      } else {
        setState(() {
          isSearching = false;
          hasResult = true;
        });
        log(weather!.temperature.toString());
        log(weather!.areaName.toString());
      }
    } catch (e) {
      setState(() {
        isSearching = false;
        hasResult = false;
        errorMessage = 'An error occurred: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Widget _getAreaName() {
    return Text(
      '${weather!.areaName} ${weather!.country}',
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Widget _getFormatedDate() {
    return Text(
      DateFormat.yMMMEd().format(
        weather!.date!,
      ),
      style: const TextStyle(fontSize: 30),
    );
  }

  Widget _getTemperature() {
    return Text(
      '${weather!.temperature!.celsius!.toInt()}° C',
      style: const TextStyle(fontSize: 100),
    );
  }

  Widget _getDetailCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [
              Colors.purple,
              Colors.blue,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
          child: Column(
            children: [
              Text(
                weather!.weatherDescription!.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    'Minimum Temperature  ${weather!.tempMin}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    'Maximum Temperature  ${weather!.tempMax}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Wind Speed ${weather!.windSpeed}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String val) {
    return Image.network('https://openweathermap.org/img/wn/${val}@4x.png');
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isSearching) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (hasResult) {
      content = Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getAreaName(),
            const SizedBox(height: 30),
            _getFormatedDate(),
            const SizedBox(height: 40),
            _getTemperature(),
            _getWeatherIcon(weather!.weatherIcon.toString()),
            const Spacer(),
            _getDetailCard()
          ],
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  controller: _citySearchController,
                  decoration: const InputDecoration(
                      hintText: 'Enter the City Name',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              child: TextButton(
                onPressed: _onSearch,
                child: const Text('Search'),
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const SearchCity()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: content,
    );
  }
}
