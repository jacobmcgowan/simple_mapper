import 'package:simple_mapper/simple_mapper.dart';

import 'models/company_a.dart';
import 'models/company_b.dart';
import 'models/employee_a.dart';
import 'models/employee_b.dart';

main() {
  var now = DateTime.now();
  var mapper = Mapper()
    .addMap<CompanyB, CompanyA>((source, mapper) => CompanyB(
      id: source.id,
      name: source.name,
      employees: source.employees
        ?.map((employee) => mapper.map<EmployeeB, EmployeeA>(employee))
        ?.toList()
    ))
    .addMap<EmployeeB, EmployeeA>((source, mapper) => EmployeeB(
      id: source.id,
      name: source.name,
      startDate: source.startDate,
      timeEmployed: source.startDate == null || source.endDate == null ?
        null :
        source.endDate.difference(source.startDate),
      company: mapper.map<CompanyB, CompanyA>(source.company)
    ));
  var companyA = CompanyA(
    id: 1,
    name: 'ABC',
    employees: <EmployeeA>[
      EmployeeA(
        id: 1,
        name: 'John Smith',
        startDate: now.subtract(Duration(days: 30)),
        endDate: now
      )
    ]
  );

  print(companyA);
  print('mapped to');
  print(mapper.map<CompanyB, CompanyA>(companyA));
}
