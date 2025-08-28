import 'package:flutter/material.dart';

class GradebookPage extends StatelessWidget {
  const GradebookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gradebook')),
      body: const Center(
        child: Text('Grade entries will appear here...'),
      ),
    );
  }
}


