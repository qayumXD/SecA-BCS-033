import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/pomodoro_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final PomodoroService _pomodoroService = PomodoroService();
  int _dailyFocusMinutes = 0;
  List<Map<String, dynamic>> _sessions = [];
  Map<DateTime, int> _weeklyStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final minutes = await _pomodoroService.getDailyFocusMinutes();
      final sessions = await _pomodoroService.fetchSessions();
      final weekly = await _pomodoroService.getWeeklyFocusStats();
      setState(() {
        _dailyFocusMinutes = minutes;
        _sessions = sessions;
        _weeklyStats = weekly;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading stats: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Insights', style: theme.textTheme.headlineLarge),
                        IconButton(
                          onPressed: _loadData,
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSummaryCard(theme),
                    const SizedBox(height: 40),
                    _buildSectionHeader('WEEKLY PROGRESS', Icons.auto_graph_rounded),
                    const SizedBox(height: 16),
                    _buildWeeklyChart(theme),
                    const SizedBox(height: 40),
                    _buildSectionHeader('RECENT SESSIONS', Icons.history_rounded),
                    const SizedBox(height: 16),
                    _buildSessionList(theme),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL FOCUS TODAY',
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_dailyFocusMinutes',
                style: const TextStyle(color: Colors.white, fontSize: 72, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text(
                'MIN',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(ThemeData theme) {
    final sortedDates = _weeklyStats.keys.toList()..sort();
    
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()} min',
                  TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        DateFormat('E').format(sortedDates[value.toInt()]).toUpperCase(),
                        style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(sortedDates.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: _weeklyStats[sortedDates[index]]?.toDouble() ?? 0,
                  color: theme.colorScheme.primary,
                  width: 14,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  double _getMaxY() {
    double max = 60.0;
    for (var val in _weeklyStats.values) {
      if (val > max) max = val.toDouble();
    }
    return max + (max * 0.2);
  }

  Widget _buildSessionList(ThemeData theme) {
    if (_sessions.isEmpty) {
      return Container(
        height: 150,
        alignment: Alignment.center,
        child: Text('No history found', style: TextStyle(color: Colors.grey[400])),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        final type = session['type'] as String;
        final duration = session['duration_minutes'] as int;
        final createdAt = DateTime.parse(session['created_at'] as String).toLocal();
        final color = _getColorForType(type);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_getIconForType(type), color: color, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d • h:mm a').format(createdAt),
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                '${duration}m',
                style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'focus': return Icons.timer_rounded;
      case 'short_break': return Icons.coffee_rounded;
      case 'long_break': return Icons.bedtime_rounded;
      default: return Icons.timer;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'focus': return const Color(0xFF6B4EE6);
      case 'short_break': return const Color(0xFF4ECDC4);
      case 'long_break': return const Color(0xFF5AB9EA);
      default: return Colors.grey;
    }
  }
}
