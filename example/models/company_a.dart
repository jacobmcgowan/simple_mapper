import 'employee_a.dart';

class CompanyA {
  CompanyA({
    this.id,
    this.name,
    this.employees
  });

  int id;
  String name;
  List<EmployeeA> employees;

  @override
  String toString() {
    var employeesString = employees
      ?.map((employee) => employee.toString())
      ?.join(', ');

    if (employeesString != null) {
      employeesString = '[ $employeesString ]';
    }

    return '<CompanyA>{ id: $id, name: $name, employees: $employeesString }';
  }
}
