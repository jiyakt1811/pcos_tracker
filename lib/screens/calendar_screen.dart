import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/period_service.dart';

class CalendarScreen extends StatefulWidget {
  final PeriodService periodService;

  const CalendarScreen({super.key, required this.periodService});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final periods = widget.periodService.getPeriods();
    final nextPeriod = widget.periodService.getNextPeriodDate();
    final periodLength = widget.periodService.getPeriodLength();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          calendarStyle: const CalendarStyle(
            markersMaxCount: 1,
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              // Check if date is in any period
              bool isInPeriod = periods.any((period) {
                final endDate = period.endDate ?? 
                    period.startDate.add(Duration(days: periodLength));
                return date.isAfter(period.startDate.subtract(const Duration(days: 1))) && 
                    date.isBefore(endDate.add(const Duration(days: 1)));
              });

              // Check if date is in predicted next period
              bool isInPredictedPeriod = date.isAfter(nextPeriod.subtract(const Duration(days: 1))) && 
                  date.isBefore(nextPeriod.add(Duration(days: periodLength)));

              if (isInPeriod) {
                return Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  width: 8,
                  height: 8,
                );
              } else if (isInPredictedPeriod) {
                return Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink,
                  ),
                  width: 8,
                  height: 8,
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
} 