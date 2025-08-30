class SensorReading {
  final int id;
  final DateTime insertedAt;
  final double? temperature;
  final double? humidity;
  final double? ph;
  final double? tds;
  final double? soilMoisture;

  SensorReading({
    required this.id,
    required this.insertedAt,
    this.temperature,
    this.humidity,
    this.ph,
    this.tds,
    this.soilMoisture,
  });

  factory SensorReading.fromMap(Map<String, dynamic> map) {
    return SensorReading(
      id: (map['id'] as num).toInt(),
      insertedAt: map['inserted_at'] is String
          ? DateTime.parse(map['inserted_at'] as String)
          : (map['inserted_at'] as DateTime),
      temperature: (map['temperature'] as num?)?.toDouble(),
      humidity: (map['humidity'] as num?)?.toDouble(),
      ph: (map['ph'] as num?)?.toDouble(),
      tds: (map['tds'] as num?)?.toDouble(),
      soilMoisture: (map['soil_moisture'] as num?)?.toDouble(),
    );
  }
}
