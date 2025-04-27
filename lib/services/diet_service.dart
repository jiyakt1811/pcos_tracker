import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer;
import '../config/api_keys.dart';

class DietService {
  late final GenerativeModel _model;

  DietService() {
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: ApiKeys.geminiApiKey,
      );
      
      // Test the model initialization
      model.countTokens([Content.text('Test message')]).then((count) {
        developer.log('Diet model initialized successfully. Token count: $count');
      }).catchError((error) {
        developer.log('Error testing diet model: $error');
      });
      
      _model = model;
    } catch (e) {
      developer.log('Error initializing diet model: $e', error: e);
      rethrow;
    }
  }

  Future<String> generateDietPlan({
    required int age,
    required double weight,
    required double height,
    required List<String> symptoms,
    required List<String> foodPreferences,
    required List<String> allergies,
  }) async {
    try {
      final prompt = '''
        You are a nutritionist specializing in PCOS management. Create a detailed, personalized diet plan with the following specifications:

        User Profile:
        - Age: $age years
        - Weight: $weight kg
        - Height: $height cm
        - PCOS Symptoms: ${symptoms.join(', ')}
        - Food Preferences: ${foodPreferences.join(', ')}
        - Allergies/Restrictions: ${allergies.join(', ')}

        Please provide a comprehensive diet plan that includes:

        1. Daily Caloric Requirements:
           - Calculate BMR and daily caloric needs
           - Macronutrient distribution (protein, carbs, fats)
           - Meal timing recommendations

        2. Meal Plan Structure:
           - Breakfast options (2-3 choices)
           - Lunch options (2-3 choices)
           - Dinner options (2-3 choices)
           - Healthy snacks (2-3 options)
           - Portion sizes for each meal

        3. PCOS-Specific Recommendations:
           - Foods to include for hormone balance
           - Foods to avoid
           - Blood sugar management tips
           - Anti-inflammatory options

        4. Supplementation Guidelines:
           - Essential nutrients for PCOS
           - Natural supplements to consider
           - Timing of supplements

        5. Hydration and Lifestyle Tips:
           - Daily water intake goals
           - Herbal tea recommendations
           - Meal prep tips
           - Eating out guidelines

        Format the response with clear sections, bullet points, and proper spacing.
        Make sure all recommendations are PCOS-friendly and consider the user's preferences and restrictions.
        Include specific food items, quantities, and timing.
      ''';

      developer.log('Starting diet plan generation...');
      developer.log('Prompt length: ${prompt.length} characters');
      
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
      
      developer.log('Diet plan response received');
      developer.log('Response text present: ${response.text != null}');
      
      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }
      
      return response.text!;
    } catch (e, stackTrace) {
      developer.log(
        'Error generating diet plan',
        error: e,
        stackTrace: stackTrace,
      );
      
      // Return a default diet plan if API fails
      return '''
        Error: Unable to generate personalized diet plan at this time.
        Please try again later or contact support.
        
        Error details: $e
        
        In the meantime, here's a general PCOS-friendly diet plan:
        
        Breakfast Options:
        • Oatmeal with berries and nuts
        • Greek yogurt parfait with low-glycemic fruits
        • Vegetable omelet with whole grain toast
        
        Lunch Options:
        • Quinoa bowl with grilled chicken and vegetables
        • Mediterranean salad with olive oil dressing
        • Lentil soup with mixed greens
        
        Dinner Options:
        • Baked salmon with roasted vegetables
        • Turkey stir-fry with brown rice
        • Chickpea curry with cauliflower rice
        
        Healthy Snacks:
        • Apple slices with almond butter
        • Mixed nuts and seeds
        • Carrot sticks with hummus
        
        General Guidelines:
        • Eat every 3-4 hours
        • Include protein with each meal
        • Choose complex carbohydrates
        • Include healthy fats
        • Stay hydrated (8-10 glasses of water daily)
        
        Foods to Avoid:
        • Processed sugars
        • Refined carbohydrates
        • Excessive caffeine
        • Artificial sweeteners
        
        Remember to:
        • Consult with your healthcare provider
        • Monitor portion sizes
        • Keep a food diary
        • Listen to your body's hunger cues
      ''';
    }
  }
} 