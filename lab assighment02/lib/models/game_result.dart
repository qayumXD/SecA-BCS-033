class GameResult {
  const GameResult({
    this.id,
    required this.guess,
    required this.status,
    required this.timestamp,
  });

  final int? id;
  final int guess;
  final String status;
  final DateTime timestamp;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'guess': guess,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory GameResult.fromMap(Map<String, Object?> map) {
    return GameResult(
      id: map['id'] as int?,
      guess: map['guess'] as int,
      status: map['status'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
