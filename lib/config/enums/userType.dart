enum UserType { STUDENT, TEACHER, PARENT, ADMIN }

class UserTypeHelper {
  static String getValue(UserType userType) {
    switch (userType) {
      case UserType.PARENT:
        return "PARENT";
      case UserType.STUDENT:
        return "STUDENT";
      case UserType.TEACHER:
        return "TEACHER";
      case UserType.ADMIN:
        return "ADMIN";
      default:
        return 'ADMIN';
    }
  }

  static UserType getEnum(String userType) {
    if (userType == getValue(UserType.PARENT)) {
      return UserType.PARENT;
    } else if (userType == getValue(UserType.STUDENT)) {
      return UserType.STUDENT;
    } else if (userType == getValue(UserType.TEACHER)) {
      return UserType.TEACHER;
    } else {
      return UserType.ADMIN;
    }
  }
}
