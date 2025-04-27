import 'package:flutter/material.dart';
import '../models/pcos_prediction_request.dart';
import '../services/pcos_prediction_service.dart';
import '../widgets/pcos_prediction_form.dart';

class PCOSPredictionScreen extends StatefulWidget {
  const PCOSPredictionScreen({super.key});

  @override
  State<PCOSPredictionScreen> createState() => _PCOSPredictionScreenState();
}

class _PCOSPredictionScreenState extends State<PCOSPredictionScreen> {
  final _service = PCOSPredictionService();
  bool _isLoading = false;
  String? _prediction;
  String? _error;

  Future<void> _handlePrediction(PCOSPredictionRequest request) async {
    setState(() {
      _isLoading = true;
      _prediction = null;
      _error = null;
    });

    try {
      final result = await _service.predictPCOS(request);
      setState(() {
        _prediction = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to get prediction. Please try again.';
        _isLoading = false;
      });
    }
  }

  Widget _buildPredictionResult() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_prediction == null) {
      return const Center(
        child: Text(
          'Fill in the form to get a prediction',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    final isPositive = _prediction!.toLowerCase().contains('positive');
    final color = isPositive ? Colors.red : Colors.green;
    final icon = isPositive ? Icons.warning : Icons.check_circle;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Prediction Result',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _prediction!,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _prediction = null;
              });
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCOS Predictor'),
      ),
      body: _prediction == null
          ? PCOSPredictionForm(onSubmit: _handlePrediction)
          : _buildPredictionResult(),
    );
  }
} 