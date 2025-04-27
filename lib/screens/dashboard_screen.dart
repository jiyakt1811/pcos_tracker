import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'period_tracker_screen.dart';
import '../features/pcos_prediction/screens/pcos_prediction_screen.dart';
import 'workout_plans_screen.dart';
import 'personalized_workout_screen.dart';
import 'personalized_diet_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCOS Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDashboardCard(
            context,
            'Period Tracker',
            Icons.calendar_today,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PeriodTrackerScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            'PCOD Predictor',
            Icons.analytics,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PCOSPredictionScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            'Diet Plan',
            Icons.restaurant,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon!')),
            ),
          ),
          _buildDashboardCard(
            context,
            'Workout Plan',
            Icons.fitness_center,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WorkoutPlansScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            'Personalized Workout',
            Icons.person,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PersonalizedWorkoutScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            'Personalized Diet',
            Icons.restaurant_menu,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PersonalizedDietScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 