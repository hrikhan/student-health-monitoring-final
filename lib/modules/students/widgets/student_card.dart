import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.name,
    required this.bpm,
  });

  final String name;
  final int bpm;

  String get status {
    if (bpm >= 100) return 'High';
    if (bpm < 60) return 'Low';
    return 'Normal';
  }

  Color get statusColor {
    if (bpm >= 100) return Colors.redAccent;
    if (bpm < 60) return Colors.orangeAccent;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.15),
          child: Icon(Icons.person, color: statusColor),
        ),
        title: Text(name),
        subtitle: Text('BPM: $bpm'),
        trailing: Chip(
          label: Text(status),
          backgroundColor: statusColor.withOpacity(0.15),
          labelStyle: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
