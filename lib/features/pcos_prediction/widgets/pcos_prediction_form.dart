import 'package:flutter/material.dart';
import '../models/pcos_prediction_request.dart';

class PCOSPredictionForm extends StatefulWidget {
  final Function(PCOSPredictionRequest) onSubmit;

  const PCOSPredictionForm({super.key, required this.onSubmit});

  @override
  State<PCOSPredictionForm> createState() => _PCOSPredictionFormState();
}

class _PCOSPredictionFormState extends State<PCOSPredictionForm> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();

  bool _weightGain = false;
  bool _hairGrowth = false;
  bool _skinDarkening = false;
  bool _hairLoss = false;
  bool _pimple = false;
  bool _fastFood = false;
  bool _regExercise = false;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);
      final waist = double.parse(_waistController.text);
      final hip = double.parse(_hipController.text);
      
      final bmi = weight / ((height / 100) * (height / 100));
      final waistHipRatio = waist / hip;

      final request = PCOSPredictionRequest(
        age: int.parse(_ageController.text),
        weight: weight,
        height: height,
        bmi: bmi,
        weightGain: _weightGain,
        hairGrowth: _hairGrowth,
        skinDarkening: _skinDarkening,
        hairLoss: _hairLoss,
        pimple: _pimple,
        fastFood: _fastFood,
        regExercise: _regExercise,
        waistHipRatio: waistHipRatio,
      );

      widget.onSubmit(request);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isDecimal = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isDecimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (isDecimal) {
            try {
              final num = double.parse(value);
              if (num <= 0) {
                return '$label must be greater than 0';
              }
            } catch (e) {
              return 'Please enter a valid number';
            }
          } else {
            try {
              final num = int.parse(value);
              if (num <= 0) {
                return '$label must be greater than 0';
              }
            } catch (e) {
              return 'Please enter a valid number';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    void Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              'Age',
              _ageController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                try {
                  final age = int.parse(value);
                  if (age < 13 || age > 50) {
                    return 'Age must be between 13 and 50';
                  }
                } catch (e) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
            _buildTextField('Weight (kg)', _weightController, isDecimal: true),
            _buildTextField('Height (cm)', _heightController, isDecimal: true),
            _buildTextField('Waist (cm)', _waistController, isDecimal: true),
            _buildTextField('Hip (cm)', _hipController, isDecimal: true),
            _buildCheckbox('Weight Gain', _weightGain, (value) {
              setState(() => _weightGain = value!);
            }),
            _buildCheckbox('Hair Growth', _hairGrowth, (value) {
              setState(() => _hairGrowth = value!);
            }),
            _buildCheckbox('Skin Darkening', _skinDarkening, (value) {
              setState(() => _skinDarkening = value!);
            }),
            _buildCheckbox('Hair Loss', _hairLoss, (value) {
              setState(() => _hairLoss = value!);
            }),
            _buildCheckbox('Pimple', _pimple, (value) {
              setState(() => _pimple = value!);
            }),
            _buildCheckbox('Fast Food', _fastFood, (value) {
              setState(() => _fastFood = value!);
            }),
            _buildCheckbox('Regular Exercise', _regExercise, (value) {
              setState(() => _regExercise = value!);
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Predict'),
            ),
          ],
        ),
      ),
    );
  }
} 