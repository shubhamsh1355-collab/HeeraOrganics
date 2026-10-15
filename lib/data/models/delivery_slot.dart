class DeliverySlot {
  final String id;
  final String dateLabel; // 'Today', 'Tomorrow', '16 Oct'
  final String timeWindow; // '6:00 AM - 8:30 AM', '5:00 PM - 8:00 PM'
  final bool isMorningHarvest;
  final bool isAvailable;

  const DeliverySlot({
    required this.id,
    required this.dateLabel,
    required this.timeWindow,
    this.isMorningHarvest = true,
    this.isAvailable = true,
  });

  String get fullLabel => '$dateLabel, $timeWindow';
}
