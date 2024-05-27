class TimeTableCourse {
  final int lessonId;
  final String title;
  final List<int> resourseIds;
  final bool cancel;
  bool sup;

  TimeTableCourse(this.lessonId, this.title, this.resourseIds,
      {this.cancel = false, this.sup = false});

  @override
  String toString() {
    return "$lessonId $title $resourseIds";
  }
}
