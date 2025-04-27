import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class PersonalizedWorkoutScreen extends StatefulWidget {
  const PersonalizedWorkoutScreen({super.key});

  @override
  State<PersonalizedWorkoutScreen> createState() => _PersonalizedWorkoutScreenState();
}

class _PersonalizedWorkoutScreenState extends State<PersonalizedWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _geminiService = GeminiService();
  final _ageController = TextEditingController();
  final _durationController = TextEditingController();
  String _fitnessLevel = 'Beginner';
  String _focus = 'General Fitness';
  final List<String> _selectedSymptoms = [];
  bool _isLoading = false;
  String? _generatedPlan;

  final List<String> _fitnessLevels = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _focusAreas = [
    'General Fitness',
    'Weight Management',
    'Stress Relief',
    'Hormone Balance',
    'Strength Building'
  ];
  final List<String> _symptoms = [
    'Irregular Periods',
    'Weight Gain',
    'Insulin Resistance',
    'Fatigue',
    'Mood Swings',
    'Acne',
    'Hair Loss',
    'Excess Hair Growth'
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _generatePlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _generatedPlan = null;
    });

    try {
      final plan = await _geminiService.generateWorkoutPlan(
        age: int.parse(_ageController.text),
        fitnessLevel: _fitnessLevel,
        symptoms: _selectedSymptoms,
        duration: int.parse(_durationController.text),
        focus: _focus,
      );

      setState(() {
        _generatedPlan = plan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Workout Plan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 13 || age > 100) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _fitnessLevel,
                  decoration: const InputDecoration(
                    labelText: 'Fitness Level',
                    border: OutlineInputBorder(),
                  ),
                  items: _fitnessLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _fitnessLevel = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _focus,
                  decoration: const InputDecoration(
                    labelText: 'Focus Area',
                    border: OutlineInputBorder(),
                  ),
                  items: _focusAreas.map((area) {
                    return DropdownMenuItem(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _focus = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Workout Duration (minutes)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workout duration';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration < 10 || duration > 120) {
                    return 'Duration should be between 10 and 120 minutes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'PCOS Symptoms (Select all that apply):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _symptoms.map((symptom) {
                  final isSelected = _selectedSymptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _generatePlan,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Generate Workout Plan'),
              ),
              if (_generatedPlan != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Your Personalized Workout Plan:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_generatedPlan!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 