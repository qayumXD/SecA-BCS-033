import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_service.dart';

class PomodoroService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DatabaseService _localDb = DatabaseService();

  bool get isGuest => _supabase.auth.currentUser == null;

  // Save a completed session
  Future<void> saveSession({
    required int durationMinutes,
    required String type, // 'focus', 'short_break', 'long_break'
    bool completed = true,
  }) async {
    if (isGuest) {
      await _localDb.insertSession({
        'type': type,
        'duration_minutes': durationMinutes,
      });
    } else {
      final user = _supabase.auth.currentUser;
      await _supabase.from('pomodoro_sessions').insert({
        'user_id': user!.id,
        'duration_minutes': durationMinutes,
        'type': type,
        'completed': completed,
      });
    }
  }

  // Fetch all sessions for the current user
  Future<List<Map<String, dynamic>>> fetchSessions() async {
    if (isGuest) {
      return await _localDb.getSessions();
    } else {
      final user = _supabase.auth.currentUser;
      final response = await _supabase
          .from('pomodoro_sessions')
          .select()
          .eq('user_id', user!.id)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    }
  }

  // Get daily focus time
  Future<int> getDailyFocusMinutes() async {
    if (isGuest) {
      return await _localDb.getDailyFocusMinutes();
    } else {
      final user = _supabase.auth.currentUser;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day).toIso8601String();

      final response = await _supabase
          .from('pomodoro_sessions')
          .select('duration_minutes')
          .eq('user_id', user!.id)
          .eq('type', 'focus')
          .gte('created_at', today);

      int total = 0;
      for (var row in response) {
        total += (row['duration_minutes'] as int);
      }
      return total;
    }
  }

  // Get focus minutes for each of the last 7 days
  Future<Map<DateTime, int>> getWeeklyFocusStats() async {
    if (isGuest) {
      return await _localDb.getWeeklyFocusStats();
    } else {
      final user = _supabase.auth.currentUser;
      final now = DateTime.now();
      final sevenDaysAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6)).toIso8601String();

      final response = await _supabase
          .from('pomodoro_sessions')
          .select('duration_minutes, created_at')
          .eq('user_id', user!.id)
          .eq('type', 'focus')
          .gte('created_at', sevenDaysAgo);

      Map<DateTime, int> stats = {};
      for (int i = 0; i < 7; i++) {
        final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        stats[date] = 0;
      }

      for (var row in response) {
        final createdAt = DateTime.parse(row['created_at'] as String);
        final date = DateTime(createdAt.year, createdAt.month, createdAt.day);
        if (stats.containsKey(date)) {
          stats[date] = (stats[date] ?? 0) + (row['duration_minutes'] as int);
        }
      }
      return stats;
    }
  }
}
