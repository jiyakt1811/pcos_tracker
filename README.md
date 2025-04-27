# PCOS Tracker App

A comprehensive Flutter application for managing PCOS (Polycystic Ovary Syndrome) symptoms and tracking health metrics.

## Features

- **User Authentication**: Secure login and signup system
- **Period Tracking**: Track menstrual cycles and symptoms
- **PCOS Prediction**: AI-powered PCOS risk assessment
- **Personalized Workout Plans**: AI-generated workout plans tailored for PCOS management
- **Diet Planning**: Customized diet recommendations for PCOS
- **Symptom Logging**: Track various PCOS-related symptoms
- **Progress Monitoring**: Track health improvements over time

## Getting Started

### Prerequisites

- Flutter (latest version)
- Dart SDK
- Google Chrome (for web testing)
- Android Studio/VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/pcos_tracker.git
   ```

2. Navigate to the project directory:
   ```bash
   cd pcos_tracker
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Create a `lib/config/api_keys.dart` file and add your API keys:
   ```dart
   class ApiKeys {
     static const String geminiApiKey = 'your_gemini_api_key';
   }
   ```

5. Run the app:
   ```bash
   flutter run -d chrome
   ```

## Project Structure

```
lib/
├── main.dart
├── config/
├── models/
├── screens/
├── services/
└── widgets/
```

## Technologies Used

- Flutter
- Dart
- Google Gemini AI
- SharedPreferences for local storage
- Provider for state management

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Google for Gemini AI API
- All contributors who help improve this app
# pcos_tracker
