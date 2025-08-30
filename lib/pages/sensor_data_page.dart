import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/sensor_repository.dart';
import '../models/sensor_reading.dart';

class SensorDataPage extends StatelessWidget {
  const SensorDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SensorRepository();
    final df = DateFormat('MMM d, yyyy – HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Data')),
      body: StreamBuilder<List<SensorReading>>(
        stream: repo.streamReadings(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final readings = snapshot.data!;
          if (readings.isEmpty) {
            return const Center(child: Text('No sensor data yet.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await repo.fetchLatest(); // not strictly needed for stream
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: readings.length,
              itemBuilder: (context, i) {
                final r = readings[i];
                return Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(df.format(r.insertedAt),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        _row('🌡 Temperature', r.temperature, '°C'),
                        _row('💧 Humidity', r.humidity, '%'),
                        _row('🧪 pH', r.ph, ''),
                        _row('🧂 TDS', r.tds, 'ppm'),
                        _row('🌱 Soil Moisture', r.soilMoisture, '%'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, double? value, String unit) {
    final text = value == null ? 'N/A' : value.toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('$text${unit.isEmpty ? '' : ' $unit'}',
              style: const TextStyle(fontFeatures: [])),
        ],
      ),
    );
  }
}
