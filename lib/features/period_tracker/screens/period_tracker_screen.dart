import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/period_data.dart';
import '../services/period_tracker_service.dart';
import '../../../services/period_service.dart';

class PeriodTrackerScreen extends StatefulWidget {
  final PeriodService periodService;

  const PeriodTrackerScreen({
    Key? key,
    required this.periodService,
  }) : super(key: key);

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  late final PeriodTrackerService _service;
  PeriodData? _periodData;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final _cycleLengthController = TextEditingController(text: '28');
  final _periodLengthController = TextEditingController(text: '5');

  @override
  void initState() {
    super.initState();
    _service = PeriodTrackerService();
    _loadPeriodData();
  }

  Future<void> _loadPeriodData() async {
    final data = await _service.getPeriodData();
    setState(() {
      _periodData = data;
    });
  }

  Future<void> _savePeriodData() async {
    if (_selectedDay == null) return;

    final data = PeriodData(
      startDate: _selectedDay!,
      cycleLength: int.parse(_cycleLengthController.text),
      periodLength: int.parse(_periodLengthController.text),
    );

    await _service.savePeriodData(data);
    setState(() {
      _periodData = data;
    });
  }

  Widget _buildEventMarker(PeriodEvent event) {
    switch (event) {
      case PeriodEvent.periodStart:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        );
      case PeriodEvent.periodEnd:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.circle,
          ),
        );
      case PeriodEvent.nextPeriod:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
        );
      case PeriodEvent.ovulation:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        );
      case PeriodEvent.fertileWindow:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  Widget _buildEventList(DateTime day) {
    final events = _service.getEvents(_periodData)[day] ?? [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: events.map((event) => _buildEventMarker(event)).toList(),
    );
  }

  Widget _buildPeriodInfo() {
    if (_periodData == null) {
      return const Center(
        child: Text('No period data available. Please select a start date.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Next Period: ${_periodData!.nextPeriodDate.toString().split(' ')[0]}'),
          Text('Ovulation: ${_periodData!.ovulationDate.toString().split(' ')[0]}'),
          Text('Fertile Window: ${_periodData!.fertileWindowStart.toString().split(' ')[0]} - ${_periodData!.fertileWindowEnd.toString().split(' ')[0]}'),
          const SizedBox(height: 16),
          const Text('Legend:'),
          Row(
            children: [
              _buildEventMarker(PeriodEvent.periodStart),
              const Text(' Period Start'),
              const SizedBox(width: 16),
              _buildEventMarker(PeriodEvent.periodEnd),
              const Text(' Period End'),
            ],
          ),
          Row(
            children: [
              _buildEventMarker(PeriodEvent.nextPeriod),
              const Text(' Next Period'),
              const SizedBox(width: 16),
              _buildEventMarker(PeriodEvent.ovulation),
              const Text(' Ovulation'),
            ],
          ),
          Row(
            children: [
              _buildEventMarker(PeriodEvent.fertileWindow),
              const Text(' Fertile Window'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) => _service.getEvents(_periodData)[day] ?? [],
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
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                return _buildEventList(date);
              },
            ),
          ),
          if (_selectedDay != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _cycleLengthController,
                    decoration: const InputDecoration(
                      labelText: 'Cycle Length (days)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _periodLengthController,
                    decoration: const InputDecoration(
                      labelText: 'Period Length (days)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _savePeriodData,
                    child: const Text('Save Period Data'),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: _buildPeriodInfo(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cycleLengthController.dispose();
    _periodLengthController.dispose();
    super.dispose();
  }
} 