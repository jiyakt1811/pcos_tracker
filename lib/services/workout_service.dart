import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkoutService {
  static const String _baseUrl = 'http://localhost:8000/api';

  Future<List<Map<String, dynamic>>> getPCOSFriendlyWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/workouts'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load workouts');
      }
    } catch (e) {
      // Return mock data if API fails
      return [
        {
          'name': 'PCOS-Friendly Cardio',
          'instructions': [
            'Warm up with 5 minutes of light jogging',
            'Perform 3 sets of 30-second high knees',
            'Do 3 sets of 20 jumping jacks',
            'Complete 3 sets of 15 mountain climbers',
            'Cool down with 5 minutes of walking',
          ],
          'duration': '30 minutes',
          'difficulty': 'Beginner',
        },
        {
          'name': 'Strength Training',
          'instructions': [
            'Warm up with 5 minutes of stretching',
            'Perform 3 sets of 12 squats',
            'Do 3 sets of 10 lunges per leg',
            'Complete 3 sets of 15 glute bridges',
            'Finish with 3 sets of 10 calf raises',
          ],
          'duration': '25 minutes',
          'difficulty': 'Beginner',
        },
        {
          'name': 'Yoga for PCOS',
          'instructions': [
            'Start with 5 minutes of deep breathing',
            'Perform 3 rounds of sun salutations',
            'Hold each yoga pose for 30 seconds',
            'Include poses like child\'s pose, cat-cow, and bridge',
            'End with 5 minutes of meditation',
          ],
          'duration': '20 minutes',
          'difficulty': 'Beginner',
        },
      ];
    }
  }
} 