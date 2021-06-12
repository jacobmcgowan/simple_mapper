import 'package:simple_mapper/simple_mapper.dart';

import 'models/company_a.dart';
import 'models/company_b.dart';
import 'models/employee_a.dart';
import 'models/employee_b.dart';

void main() {
  var now = DateTime.now();
  var mapper = Mapper()
      .addMap<CompanyB, CompanyA>(
        (source, mapper, [params]) => CompanyB(
          id: source.id,
          name: source.name,

          // Use the mapper to map children.
          employees: source.employees
              ?.map(
                (employee) => mapper.map<EmployeeB, EmployeeA>(employee, {
                  'companyId': source.id,
                }),
              )
              .toList(),
        ),
      )
      .addMap<EmployeeB, EmployeeA>(
        (source, mapper, [params]) => EmployeeB(
          id: source.id,

          // EmployeeA doesn't have companyId so we pass it through params.
          companyId: params!['companyId'] ?? 0,
          name: source.name,
          startDate: source.startDate,
          timeEmployed: source.startDate == null || source.endDate == null
              ? null
              : source.endDate!.difference(source.startDate!),
        ),
      );

  var companyA = CompanyA(
    id: 1,
    name: 'ABC',
    employees: <EmployeeA>[
      EmployeeA(
        id: 1,
        name: 'John Smith',
        startDate: now.subtract(Duration(days: 30)),
        endDate: now,
      )
    ],
  );

  print(companyA);
  print('mapped to');
  print(mapper.map<CompanyB, CompanyA>(companyA));
}
