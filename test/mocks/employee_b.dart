import 'company_b.dart';

class EmployeeB {
  EmployeeB({
    this.id,
    this.name,
    this.startDate,
    this.timeEmployed,
    this.company
  });

  int id;
  String name;
  DateTime startDate;
  Duration timeEmployed;
  CompanyB company;
}
