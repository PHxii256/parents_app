class Child {
  final String name;
  final String grade;

  Child({
    required this.name,
    required this.grade,
  });
}

class Profile {
  final String name;
  final String primaryPhone;
  final String secondaryPhone;
  final List<Child> children;

  Profile({
    required this.name,
    required this.primaryPhone,
    required this.secondaryPhone,
    required this.children,
  });
}