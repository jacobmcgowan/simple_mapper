class EmployeeB {
  EmployeeB({
    this.id,
    this.companyId,
    this.name,
    this.startDate,
    this.timeEmployed,
  });

  int? id;
  int? companyId;
  String? name;
  DateTime? startDate;
  Duration? timeEmployed;

  @override
  String toString() =>
      '<EmployeeB>{ id: $id, companyId: $companyId, name: $name, startDate: $startDate, timeEmployeed: $timeEmployed }';
}
