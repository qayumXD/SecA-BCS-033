import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/submission.dart';

class SubmissionService {
  SubmissionService(this._client);

  final SupabaseClient _client;

  Stream<List<Submission>> watchSubmissions() {
    return _client
        .from('submissions')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((rows) {
          return rows
              .map((row) => Submission.fromJson(row))
              .toList();
        });
  }

  Future<List<Submission>> fetchSubmissions() async {
    final rows = await _client
        .from('submissions')
        .select()
        .order('created_at', ascending: false);

    return (rows as List)
        .map((row) => Submission.fromJson(row))
        .toList();
  }

  Future<Submission> createSubmission(Submission submission) async {
    final row = await _client
        .from('submissions')
        .insert(submission.toJson())
        .select()
        .single();

    return Submission.fromJson(row);
  }

  Future<Submission> updateSubmission(Submission submission) async {
    if (submission.id == null) throw Exception('ID required for update');
    
    final row = await _client
        .from('submissions')
        .update(submission.toJson())
        .eq('id', submission.id!)
        .select()
        .single();

    return Submission.fromJson(row);
  }

  Future<void> deleteSubmission(int id) async {
    await _client.from('submissions').delete().eq('id', id);
  }
}
