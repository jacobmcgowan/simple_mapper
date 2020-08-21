import 'company_a.dart';

class EmployeeA {
  EmployeeA({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.company,
  });

  int id;
  String name;
  DateTime startDate;
  DateTime endDate;
  CompanyA company;
}
