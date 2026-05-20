import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/pomodoro_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  // Configurable durations
  int focusMinutes = 25;
  int shortBreakMinutes = 5;
  int longBreakMinutes = 15;

  late int _remainingTime;
  Timer? _timer;
  bool _isRunning = false;
  String _sessionType = 'focus';
  
  final PomodoroService _pomodoroService = PomodoroService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _remainingTime = focusMinutes * 60;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    // Pre-load audio to ensure it's ready
    _audioPlayer.setSource(UrlSource('https://actions.google.com/sounds/v1/alarms/beep_short.ogg')).catchError((e) => debugPrint("Audio Load Error: $e"));
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _pulseController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _pulseController.stop();
          _handleSessionComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _remainingTime = _getInitialTime(_sessionType);
    });
  }

  int _getInitialTime(String type) {
    switch (type) {
      case 'short_break': return shortBreakMinutes * 60;
      case 'long_break': return longBreakMinutes * 60;
      default: return focusMinutes * 60;
    }
  }

  void _switchSession(String type) {
    _pauseTimer();
    setState(() {
      _sessionType = type;
      _remainingTime = _getInitialTime(type);
    });
  }

  Future<void> _playAlert() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource('https://actions.google.com/sounds/v1/alarms/beep_short.ogg'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _handleSessionComplete() async {
    await _playAlert();

    await _pomodoroService.saveSession(
      durationMinutes: _getInitialTime(_sessionType) ~/ 60,
      type: _sessionType,
    );

    if (mounted) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getColorForType(_sessionType).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded, size: 60, color: _getColorForType(_sessionType)),
              ),
              const SizedBox(height: 20),
              const Text('Session Ended', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'You completed your ${_sessionType.replaceAll('_', ' ')} session. Take a moment to breathe.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _audioPlayer.stop();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColorForType(_sessionType),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text('GREAT JOB', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
              ],
            ),
            const SizedBox(height: 30),
            _buildSettingItem(
              title: 'Focus Duration',
              value: '$focusMinutes min',
              icon: Icons.timer_rounded,
              onTap: () {}, // Could implement duration picker later
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: 'Test Alert Sound',
              value: 'Tap to preview',
              icon: Icons.volume_up_rounded,
              onTap: () => _playAlert(),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: 'Vibration',
              value: 'Enabled',
              icon: Icons.vibration_rounded,
              onTap: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({required String title, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6B4EE6)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(value, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = _getColorForType(_sessionType);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.05),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildSessionSelector(theme),
              const Spacer(),
              _buildTimerCircle(theme, primaryColor),
              const Spacer(),
              _buildControls(theme, primaryColor),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionSelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _selectorTab('Focus', 'focus', theme),
          _selectorTab('Short', 'short_break', theme),
          _selectorTab('Long', 'long_break', theme),
        ],
      ),
    );
  }

  Widget _selectorTab(String label, String type, ThemeData theme) {
    final isSelected = _sessionType == type;
    final color = _getColorForType(type);
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchSession(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[500],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCircle(ThemeData theme, Color color) {
    double progress = _remainingTime / _getInitialTime(_sessionType);
    
    return ScaleTransition(
      scale: _pulseController,
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 60,
              spreadRadius: 30,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: color.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(_remainingTime),
                  style: TextStyle(
                    fontSize: 88,
                    fontWeight: FontWeight.w100,
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  _sessionType == 'focus' ? 'STAY FOCUSED' : 'REST TIME',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 4,
                    color: color.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(ThemeData theme, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(
          onTap: _resetTimer,
          icon: Icons.replay_rounded,
          color: Colors.grey[400]!,
        ),
        const SizedBox(width: 32),
        GestureDetector(
          onTap: _isRunning ? _pauseTimer : _startTimer,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Icon(
              _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 32),
        _controlButton(
          onTap: _showSettings,
          icon: Icons.settings_rounded,
          color: Colors.grey[400]!,
        ),
      ],
    );
  }

  Widget _controlButton({required VoidCallback onTap, required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'focus': return const Color(0xFF6B4EE6); // Royal Purple
      case 'short_break': return const Color(0xFF4ECDC4); // Fresh Mint
      case 'long_break': return const Color(0xFF5AB9EA); // Sky Blue
      default: return Colors.deepPurple;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
