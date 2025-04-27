import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer;
import '../config/api_keys.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: ApiKeys.geminiApiKey,
      );
      
      // Test the model initialization
      model.countTokens([Content.text('Test message')]).then((count) {
        developer.log('Model initialized successfully. Token count: $count');
      }).catchError((error) {
        developer.log('Error testing model: $error');
      });
      
      _model = model;
    } catch (e) {
      developer.log('Error initializing Gemini model: $e', error: e);
      rethrow;
    }
  }

  Future<String> generateWorkoutPlan({
    required int age,
    required String fitnessLevel,
    required List<String> symptoms,
    required int duration,
    required String focus,
  }) async {
    try {
      final prompt = '''
        You are a fitness expert specializing in PCOS management. Create a detailed, personalized workout plan with the following specifications:

        User Profile:
        - Age: $age years
        - Fitness Level: $fitnessLevel
        - PCOS Symptoms: ${symptoms.join(', ')}
        - Workout Duration: $duration minutes
        - Primary Focus: $focus

        Please provide a comprehensive workout plan that includes:

        1. Warm-up (5-10 minutes):
           - List specific warm-up exercises
           - Include duration for each exercise
           - Add modifications if needed

        2. Main Workout:
           - List exercises in order
           - Specify sets and reps
           - Include rest periods
           - Add modifications for PCOS symptoms
           - Include form tips

        3. Cool-down (5-10 minutes):
           - List stretching exercises
           - Include breathing exercises
           - Add relaxation techniques

        4. Safety Guidelines:
           - List important precautions
           - Include modifications for symptoms
           - Add warning signs to watch for

        5. Expected Benefits:
           - List specific benefits
           - Include timeline for results
           - Add tips for tracking progress

        Format the response with clear sections, bullet points, and proper spacing.
        Make sure all exercises are PCOS-friendly and suitable for the specified fitness level.
        Keep the response concise but informative.
      ''';

      developer.log('Starting Gemini API request...');
      developer.log('Prompt length: ${prompt.length} characters');
      
      // First, check if we can get a token count
      final tokenCount = await _model.countTokens([Content.text(prompt)]);
      developer.log('Prompt token count: $tokenCount');
      
      final content = [Content.text(prompt)];
      developer.log('Sending request to Gemini API...');
      
      final response = await _model.generateContent(
        content,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );
      
      developer.log('Response received from Gemini API');
      developer.log('Response text present: ${response.text != null}');
      
      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }
      
      return response.text!;
    } catch (e, stackTrace) {
      developer.log(
        'Error generating workout plan',
        error: e,
        stackTrace: stackTrace,
      );
      
      // Return a more detailed error message
      return '''
        Error: Unable to generate personalized workout plan at this time.
        Please try again later or contact support.
        
        Error details: $e
        
        In the meantime, here's a general PCOS-friendly workout plan:
        
        Warm-up (5-10 minutes):
        • Light cardio (walking, cycling)
        • Dynamic stretches
        • Joint mobility exercises
        
        Main Workout:
        • Bodyweight squats: 3 sets of 12 reps
        • Lunges: 3 sets of 10 reps per leg
        • Glute bridges: 3 sets of 15 reps
        • Plank: 3 sets of 30 seconds
        • Bird dogs: 3 sets of 10 reps per side
        
        Cool-down (5-10 minutes):
        • Gentle stretching
        • Deep breathing exercises
        • Relaxation techniques
        
        Remember to:
        • Stay hydrated
        • Listen to your body
        • Take breaks when needed
        • Consult with your healthcare provider before starting any new exercise program
      ''';
    }
  }
} 