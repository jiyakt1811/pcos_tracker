import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/period_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final PeriodService periodService;

  const OnboardingScreen({super.key, required this.periodService});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _cycleController = TextEditingController(text: '28');
  final _periodController = TextEditingController(text: '5');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Let\'s personalize your experience',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _cycleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Average Cycle Length (days)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _periodController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Average Period Length (days)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final cycleLength = int.parse(_cycleController.text);
                final periodLength = int.parse(_periodController.text);
                
                await widget.periodService.saveCycleSettings(
                  cycleLength,
                  periodLength,
                );

                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        periodService: widget.periodService,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cycleController.dispose();
    _periodController.dispose();
    super.dispose();
  }
} 