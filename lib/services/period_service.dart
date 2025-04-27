import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/period.dart';
import 'package:flutter/material.dart';
import '../screens/period_tracker_screen.dart';

class PeriodService {
  static const String _periodsKey = 'periods';
  static const String _cycleLengthKey = 'cycleLength';
  static const String _periodLengthKey = 'periodLength';
  static const String _periodEventsKey = 'period_events';
  
  final SharedPreferences _prefs;

  PeriodService(this._prefs);

  Future<void> saveCycleSettings(int cycleLength, int periodLength) async {
    await _prefs.setInt(_cycleLengthKey, cycleLength);
    await _prefs.setInt(_periodLengthKey, periodLength);
  }

  int getCycleLength() {
    return _prefs.getInt(_cycleLengthKey) ?? 28;
  }

  int getPeriodLength() {
    return _prefs.getInt(_periodLengthKey) ?? 5;
  }

  Future<void> addPeriod(Period period) async {
    final periods = getPeriods();
    periods.add(period);
    await _savePeriods(periods);
  }

  List<Period> getPeriods() {
    final periodsJson = _prefs.getStringList(_periodsKey) ?? [];
    return periodsJson
        .map((json) => Period.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  DateTime getNextPeriodDate() {
    final periods = getPeriods();
    if (periods.isEmpty) return DateTime.now();
    
    final lastPeriod = periods.first;
    return lastPeriod.startDate.add(Duration(days: getCycleLength()));
  }

  Future<void> _savePeriods(List<Period> periods) async {
    final periodsJson = periods
        .map((period) => jsonEncode(period.toJson()))
        .toList();
    await _prefs.setStringList(_periodsKey, periodsJson);
  }

  Future<Map<DateTime, List<PeriodEvent>>> getPeriodEvents() async {
    final eventsJson = _prefs.getString(_periodEventsKey);
    if (eventsJson == null) return {};

    try {
      final Map<String, dynamic> decoded = Map<String, dynamic>.from(
        Map<String, dynamic>.from(
          const JsonDecoder().convert(eventsJson),
        ),
      );

      return decoded.map(
        (key, value) => MapEntry(
          DateTime.parse(key),
          (value as List)
              .map((e) => PeriodEvent(
                    title: e['title'],
                    description: e['description'],
                  ))
              .toList(),
        ),
      );
    } catch (e) {
      debugPrint('Error loading period events: $e');
      return {};
    }
  }

  Future<void> addPeriodEvent(DateTime date, PeriodEvent event) async {
    final events = await getPeriodEvents();
    final dateKey = DateTime(date.year, date.month, date.day);

    if (!events.containsKey(dateKey)) {
      events[dateKey] = [];
    }

    events[dateKey]!.add(event);

    await _saveEvents(events);
  }

  Future<void> deletePeriodEvent(DateTime date, PeriodEvent event) async {
    final events = await getPeriodEvents();
    final dateKey = DateTime(date.year, date.month, date.day);

    if (events.containsKey(dateKey)) {
      events[dateKey]!.removeWhere(
        (e) => e.title == event.title && e.description == event.description,
      );

      if (events[dateKey]!.isEmpty) {
        events.remove(dateKey);
      }

      await _saveEvents(events);
    }
  }

  Future<void> _saveEvents(Map<DateTime, List<PeriodEvent>> events) async {
    final encoded = events.map(
      (key, value) => MapEntry(
        key.toIso8601String(),
        value
            .map((e) => {
                  'title': e.title,
                  'description': e.description,
                })
            .toList(),
      ),
    );

    await _prefs.setString(
      _periodEventsKey,
      const JsonEncoder().convert(encoded),
    );
  }
} 