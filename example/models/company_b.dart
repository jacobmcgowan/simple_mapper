import 'employee_b.dart';

class CompanyB {
  CompanyB({
    this.id,
    this.name,
    this.employees
  });

  int id;
  String name;
  List<EmployeeB> employees;

  @override
  String toString() {
    var employeesString = employees
      ?.map((employee) => employee.toString())
      ?.join(', ');

    if (employeesString != null) {
      employeesString = '[ $employeesString ]';
    }

    return '<CompanyB>{ id: $id, name: $name, employees: $employeesString }';
  }
}
