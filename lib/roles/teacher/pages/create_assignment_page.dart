import 'package:flutter/material.dart';

class CreateAssignmentPage extends StatelessWidget {
  const CreateAssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Assignment creation form coming soon...'),
          ],
        ),
      ),
    );
  }
}


