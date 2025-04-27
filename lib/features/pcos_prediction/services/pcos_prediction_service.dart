import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pcos_prediction_request.dart';

class PCOSPredictionService {
  static final PCOSPredictionService _instance = PCOSPredictionService._internal();
  factory PCOSPredictionService() => _instance;
  PCOSPredictionService._internal();

  Future<String> predictPCOS(PCOSPredictionRequest request) async {
    const baseUrl = 'http://localhost:3001';
    
    // Convert the request to a properly formatted JSON
    final jsonData = {
      'age': request.age,
      'weight': request.weight.toDouble(),
      'height': request.height.toDouble(),
      'bmi': request.bmi.toDouble(),
      'weight_gain': request.weightGain,
      'hair_growth': request.hairGrowth,
      'skin_darkening': request.skinDarkening,
      'hair_loss': request.hairLoss,
      'pimple': request.pimple,
      'fast_food': request.fastFood,
      'reg_exercise': request.regExercise,
      'waist_hip_ratio': request.waistHipRatio.toDouble(),
    };

    print('Sending request with data: ${jsonEncode(jsonData)}');

    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonData),
    );

    print('Received response: ${response.body}');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final prediction = result['prediction'] == 1 ? 'Positive' : 'Negative';
      final confidence = (result['confidence'] * 100).toStringAsFixed(2);
      return 'Prediction: $prediction\nConfidence: $confidence%';
    } else {
      throw Exception('Failed to get prediction: ${response.body}');
    }
  }
} 