import 'company_b.dart';

class EmployeeB {
  EmployeeB({
    this.id,
    this.companyId,
    this.name,
    this.startDate,
    this.timeEmployed,
    this.company,
  });

  int? id;
  int? companyId;
  String? name;
  DateTime? startDate;
  Duration? timeEmployed;
  CompanyB? company;
}
