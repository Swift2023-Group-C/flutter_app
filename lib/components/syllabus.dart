class Syllabus {
  final int lessonId;
  final int timetableId;
  final String lessonName;

  Syllabus(this.lessonId, this.timetableId, this.lessonName);

  int getTimetableId() {
    return timetableId;
  }
}
