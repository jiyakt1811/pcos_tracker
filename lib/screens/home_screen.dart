import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/period.dart';
import '../services/auth_service.dart';
import '../services/period_service.dart';
import 'calendar_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final PeriodService periodService;

  const HomeScreen({
    super.key,
    required this.authService,
    required this.periodService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final nextPeriod = widget.periodService.getNextPeriodDate();
    final dateFormat = DateFormat('MMMM d, y');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.authService.signOut();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today: ${dateFormat.format(DateTime.now())}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Next period expected on:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          dateFormat.format(nextPeriod),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await widget.periodService.addPeriod(
                        Period(startDate: DateTime.now()),
                      );
                      setState(() {});
                    },
                    child: const Text('Mark Period Start'),
                  ),
                ),
              ],
            ),
          ),
          // Calendar Tab
          CalendarScreen(periodService: widget.periodService),
          // History Tab
          HistoryScreen(periodService: widget.periodService),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
} 