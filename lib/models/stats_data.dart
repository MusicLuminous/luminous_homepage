class StatsData {
  final String runDays;
  final String activityCount;

  const StatsData({
    required this.runDays,
    required this.activityCount,
  });

  factory StatsData.defaultData() {
    final startDate = DateTime(2026, 4, 10);
    final today = DateTime.now();
    final days = today.difference(startDate).inDays;
    return StatsData(
      runDays: days.toString(),
      activityCount: '1',
    );
  }
}