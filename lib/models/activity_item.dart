class ActivityItem {
  final String text;
  final String time;

  const ActivityItem({
    required this.text,
    required this.time,
  });

  static const List<ActivityItem> defaultActivities = [
    ActivityItem(text: '神都回响进省赛啦！', time: '2026 年 4 月 8 日'),
    ActivityItem(text: '「回声匣子」录音棚企划准备中。。。。', time: '2026 年 4 月 1 日'),
  ];
}
