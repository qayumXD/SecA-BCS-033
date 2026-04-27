import 'dart:math';

import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/game_result.dart';
import 'history_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _guessController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _targetNumber = Random().nextInt(100) + 1;

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  String _evaluateGuess(int guess) {
    if (guess == _targetNumber) {
      return 'Correct';
    }
    if (guess > _targetNumber) {
      return 'Too High';
    }
    return 'Too Low';
  }

  Future<void> _submitGuess() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final guess = int.parse(_guessController.text.trim());
    final status = _evaluateGuess(guess);

    await DatabaseHelper.instance.insertResult(
      GameResult(
        guess: guess,
        status: status,
        timestamp: DateTime.now(),
      ),
    );

    if (!mounted) {
      return;
    }

    final bool? startNewGame = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(guess: guess, status: status),
      ),
    );

    if (startNewGame == true) {
      setState(() {
        _targetNumber = Random().nextInt(100) + 1;
      });
      _guessController.clear();
    }
  }

  String? _validateGuess(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Please enter your guess.';
    }

    final number = int.tryParse(input);
    if (number == null) {
      return 'Please enter a valid number.';
    }

    if (number < 1 || number > 100) {
      return 'Enter a number between 1 and 100.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Guessing Game'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: 'History',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Guess a number from 1 to 100',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _guessController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your guess',
                  ),
                  validator: _validateGuess,
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: _submitGuess,
                  child: const Text('Check Guess'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  },
                  icon: const Icon(Icons.table_rows),
                  label: const Text('View History'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
