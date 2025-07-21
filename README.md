# Flutter Weather App

A simple Flutter application that displays current weather information based on your location or a searched city. The app uses the OpenWeatherMap API and supports Android, iOS, Linux, macOS, Windows, and Web platforms.

## Features

- Get current weather for your device's location
- Search weather by city name
- Displays temperature, weather description, min/max temperature, wind speed, and weather icon
- Error handling for location and network issues

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An OpenWeatherMap API key ([Sign up here](https://openweathermap.org/appid))

### Installation

1. Clone this repository:
    ```sh
    git clone https://github.com/yourusername/flutter-weather.git
    cd flutter-weather
    ```

2. Add your OpenWeatherMap API key to [`lib/const.dart`](lib/const.dart):
    ```dart
    const String OPEN_WEATHER_API_KEY = 'YOUR_API_KEY_HERE';
    ```

3. Install dependencies:
    ```sh
    flutter pub get
    ```

### Running the App

- For Android/iOS:
    ```sh
    flutter run
    ```
- For desktop/web:
    ```sh
    flutter run -d linux   # or macos, windows, web-server
    ```

## Project Structure

- `lib/` - Main Dart code
    - `main.dart` - App entry point
    - `const.dart` - Constants (API key)
    - `screens/` - UI screens (`home_page.dart`, `search.dart`)
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` - Platform-specific code

## Dependencies

- [weather](https://pub.dev/packages/weather)
- [location](https://pub.dev/packages/location)
- [intl](https://pub.dev/packages/intl)
- [flutter](https://flutter.dev)
