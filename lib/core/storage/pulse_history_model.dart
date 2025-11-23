class PulseHistoryModel {
  PulseHistoryModel({
    required this.bpm,
    required this.timestamp,
  });

  final int bpm;
  final DateTime timestamp;

  Map<String, dynamic> toMap() => {
        'bpm': bpm,
        'timestamp': timestamp.toIso8601String(),
      };

  factory PulseHistoryModel.fromMap(Map<String, dynamic> map) {
    return PulseHistoryModel(
      bpm: map['bpm'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
