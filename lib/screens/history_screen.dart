import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/period_service.dart';

class HistoryScreen extends StatelessWidget {
  final PeriodService periodService;

  const HistoryScreen({super.key, required this.periodService});

  @override
  Widget build(BuildContext context) {
    final periods = periodService.getPeriods();
    final dateFormat = DateFormat('MMMM d, y');

    return Scaffold(
      body: periods.isEmpty
          ? const Center(
              child: Text('No period history yet'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: periods.length,
              itemBuilder: (context, index) {
                final period = periods[index];
                final cycleLength = index < periods.length - 1
                    ? period.startDate
                        .difference(periods[index + 1].startDate)
                        .inDays
                        .abs()
                    : null;

                return Card(
                  child: ListTile(
                    title: Text('Period Start: ${dateFormat.format(period.startDate)}'),
                    subtitle: cycleLength != null
                        ? Text('Cycle Length: $cycleLength days')
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implement period editing
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Period editing coming soon!'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
} 