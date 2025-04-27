import 'package:table_calendar/table_calendar.dart';
import '../models/period_data.dart';

class PeriodTrackerService {
  static final PeriodTrackerService _instance = PeriodTrackerService._internal();
  factory PeriodTrackerService() => _instance;
  PeriodTrackerService._internal();

  Future<PeriodData?> getPeriodData() async {
    return await PeriodData.loadPeriodData();
  }

  Future<void> savePeriodData(PeriodData data) async {
    await PeriodData.savePeriodData(data);
  }

  Map<DateTime, List<PeriodEvent>> getEvents(PeriodData? periodData) {
    if (periodData == null) return {};

    final events = <DateTime, List<PeriodEvent>>{};
    
    // Add period start date
    events[periodData.startDate] = [PeriodEvent.periodStart];
    
    // Add period end date
    events[periodData.periodEndDate] = [PeriodEvent.periodEnd];
    
    // Add next period date
    events[periodData.nextPeriodDate] = [PeriodEvent.nextPeriod];
    
    // Add ovulation date
    events[periodData.ovulationDate] = [PeriodEvent.ovulation];
    
    // Add fertile window
    for (var date = periodData.fertileWindowStart;
        date.isBefore(periodData.fertileWindowEnd.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      events[date] = [PeriodEvent.fertileWindow];
    }

    return events;
  }
}

enum PeriodEvent {
  periodStart,
  periodEnd,
  nextPeriod,
  ovulation,
  fertileWindow,
} 