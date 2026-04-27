import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.guess,
    required this.status,
  });

  final int guess;
  final String status;

  String get _title {
    switch (status) {
      case 'Correct':
        return 'Correct Guess!';
      case 'Too High':
        return 'Your Guess Is Too High';
      default:
        return 'Your Guess Is Too Low';
    }
  }

  Color _statusColor(BuildContext context) {
    switch (status) {
      case 'Correct':
        return Colors.green;
      case 'Too High':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                status == 'Correct' ? Icons.check_circle : Icons.info,
                size: 84,
                color: color,
              ),
              const SizedBox(height: 16),
              Text(
                _title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your guess: $guess',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, status == 'Correct');
                },
                child: Text(status == 'Correct' ? 'Start New Game' : 'Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
