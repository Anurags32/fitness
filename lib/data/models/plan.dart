class Plan {
  final int? id;
  final String title;
  final String level;
  final String time; 
  final String room;
  final String trainer;
  final String? date; 

  Plan({
    this.id,
    required this.title,
    required this.level,
    required this.time,
    required this.room,
    required this.trainer,
    this.date,
  });

  factory Plan.fromJson(Map<String, dynamic> j) => Plan(
    id: j['id'] is int ? j['id'] : int.tryParse('${j['id']}'),
    title: j['title'] ?? '',
    level: j['level'] ?? '',
    time: j['time'] ?? '',
    room: j['room'] ?? '',
    trainer: j['trainer'] ?? '',
    date: j['date']?.toString(),
  );

  Map<String, dynamic> toJsonForPost() => {
    'title': title,
    'level': level,
    'time': time,
    'room': room,
    'trainer': trainer,
  };
}
