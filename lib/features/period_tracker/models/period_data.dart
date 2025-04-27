import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PeriodData {
  final DateTime startDate;
  final int cycleLength;
  final int periodLength;

  PeriodData({
    required this.startDate,
    required this.cycleLength,
    required this.periodLength,
  });

  DateTime get nextPeriodDate => startDate.add(Duration(days: cycleLength));
  DateTime get periodEndDate => startDate.add(Duration(days: periodLength));
  DateTime get ovulationDate => startDate.add(Duration(days: (cycleLength / 2).floor()));
  DateTime get fertileWindowStart => ovulationDate.subtract(const Duration(days: 5));
  DateTime get fertileWindowEnd => ovulationDate.add(const Duration(days: 1));

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'cycleLength': cycleLength,
    'periodLength': periodLength,
  };

  factory PeriodData.fromJson(Map<String, dynamic> json) => PeriodData(
    startDate: DateTime.parse(json['startDate']),
    cycleLength: json['cycleLength'],
    periodLength: json['periodLength'],
  );

  static Future<void> savePeriodData(PeriodData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('periodData', jsonEncode(data.toJson()));
  }

  static Future<PeriodData?> loadPeriodData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('periodData');
    if (data != null) {
      try {
        final json = Map<String, dynamic>.from(jsonDecode(data));
        return PeriodData.fromJson(json);
      } catch (e) {
        print('Error parsing period data: $e');
        return null;
      }
    }
    return null;
  }
} 