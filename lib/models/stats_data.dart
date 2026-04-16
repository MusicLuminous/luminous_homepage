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
    final activityCount = 2; // 神都回响进省赛啦 + 回声匣子企划
    return StatsData(
      runDays: days.toString(),
      activityCount: activityCount.toString(),
    );
  }
}