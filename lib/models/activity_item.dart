class ActivityItem {
  final String text;
  final String time;

  const ActivityItem({
    required this.text,
    required this.time,
  });

  static const List<ActivityItem> defaultActivities = [
    ActivityItem(text: '「回声匣子」录音棚企划准备中。。。。', time: '刚刚'),
  ];
}
