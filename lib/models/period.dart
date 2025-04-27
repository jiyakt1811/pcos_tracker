class Period {
  final DateTime startDate;
  final DateTime? endDate;

  Period({required this.startDate, this.endDate});

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
} 