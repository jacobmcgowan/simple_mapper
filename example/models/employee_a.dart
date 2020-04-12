import 'company_a.dart';

class EmployeeA {
  EmployeeA({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.company
  });

  int id;
  String name;
  DateTime startDate;
  DateTime endDate;
  CompanyA company;

  @override
  String toString() => '<EmployeeA>{ id: $id, name: $name, startDate: $startDate, endDate: $endDate, company: $company }';
}
