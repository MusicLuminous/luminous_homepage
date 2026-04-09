class StatsData {
  final String runDays;
  final String activityCount;
  final String courseCount;

  const StatsData({
    required this.runDays,
    required this.activityCount,
    required this.courseCount,
  });

  factory StatsData.defaultData() {
    return const StatsData(
      runDays: '27',
      activityCount: '1',
      courseCount: '0',
    );
  }
}
