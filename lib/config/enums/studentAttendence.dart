enum StudentAttendence{
  Remaining,Absent,Present
}
class StudentAttendanceHelper{
    static String getValue(StudentAttendence type) {
    switch (type) {
      case StudentAttendence.Remaining:
        return "Remaining";
      case StudentAttendence.Absent:
        return "Absent";
      case StudentAttendence.Present:
        return "Present";
      default:
        return 'Remaining';
    }
  }

  static StudentAttendence getEnum(String type) {
    switch (type) {
      case "Present":
        return StudentAttendence.Present;
      case "Absent":
        return StudentAttendence.Absent;
      case "Remaining":
        return StudentAttendence.Remaining;
      default:
        return StudentAttendence.Remaining;
    }
  }
}