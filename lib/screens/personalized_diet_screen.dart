import 'package:flutter/material.dart';
import '../services/diet_service.dart';

class PersonalizedDietScreen extends StatefulWidget {
  const PersonalizedDietScreen({super.key});

  @override
  State<PersonalizedDietScreen> createState() => _PersonalizedDietScreenState();
}

class _PersonalizedDietScreenState extends State<PersonalizedDietScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dietService = DietService();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final List<String> _selectedSymptoms = [];
  final List<String> _selectedPreferences = [];
  final List<String> _selectedAllergies = [];
  bool _isLoading = false;
  String? _generatedPlan;

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

  final List<String> _foodPreferences = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Low-Carb',
    'Mediterranean',
    'Keto-Friendly'
  ];

  final List<String> _commonAllergies = [
    'Nuts',
    'Dairy',
    'Eggs',
    'Soy',
    'Gluten',
    'Shellfish',
    'Fish'
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _generatePlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _generatedPlan = null;
    });

    try {
      final plan = await _dietService.generateDietPlan(
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        symptoms: _selectedSymptoms,
        foodPreferences: _selectedPreferences,
        allergies: _selectedAllergies,
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
        title: const Text('Personalized Diet Plan'),
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
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 200) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  final height = double.tryParse(value);
                  if (height == null || height < 100 || height > 250) {
                    return 'Please enter a valid height';
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
              const SizedBox(height: 16),
              const Text(
                'Food Preferences:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _foodPreferences.map((preference) {
                  final isSelected = _selectedPreferences.contains(preference);
                  return FilterChip(
                    label: Text(preference),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPreferences.add(preference);
                        } else {
                          _selectedPreferences.remove(preference);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Allergies/Restrictions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commonAllergies.map((allergy) {
                  final isSelected = _selectedAllergies.contains(allergy);
                  return FilterChip(
                    label: Text(allergy),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAllergies.add(allergy);
                        } else {
                          _selectedAllergies.remove(allergy);
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
                    : const Text('Generate Diet Plan'),
              ),
              if (_generatedPlan != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Your Personalized Diet Plan:',
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