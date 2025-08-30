import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sensor_reading.dart';

class SensorRepository {
  final _client = Supabase.instance.client;

  // Live stream (updates when new rows are inserted)
  Stream<List<SensorReading>> streamReadings({int? limit}) {
    var query = _client
        .from('sensor_readings')
        .stream(primaryKey: ['id'])
        .order('inserted_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.map((rows) => rows.map(SensorReading.fromMap).toList());
  }

  // One-time fetch (e.g., pull-to-refresh)
  Future<List<SensorReading>> fetchLatest({int limit = 50}) async {
    final data = await _client
        .from('sensor_readings')
        .select()
        .order('inserted_at', ascending: false)
        .limit(limit);

    return (data as List)
        .map((e) => SensorReading.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
