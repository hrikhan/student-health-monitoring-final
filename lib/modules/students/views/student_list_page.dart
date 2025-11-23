import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/student_card.dart';

class Student {
  const Student({required this.name, required this.bpm});
  final String name;
  final int bpm;
}

class StudentListPage extends StatelessWidget {
  StudentListPage({super.key});

  final List<Student> dummyStudents = const [
    Student(name: 'Student 1', bpm: 72),
    Student(name: 'Student 2', bpm: 80),
    Student(name: 'Student 3', bpm: 95),
    Student(name: 'Student 4', bpm: 65),
    Student(name: 'Student 5', bpm: 110),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('students'.tr, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('dummy_student_list_title'.tr),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: dummyStudents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final student = dummyStudents[index];
                return StudentCard(name: student.name, bpm: student.bpm);
              },
            ),
          ),
        ],
      ),
    );
  }
}
