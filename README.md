Maps objects of different types to other objects using configured expressions.
The goal of this library is to simplify and reduce code needed to map objects.

## Usage

### Simple 1-to-1 mapping

Map configurations can be added by passing a callback that takes the source
object and calling mapper as arguments and returns the destination object.

```dart
var mapper = Mapper()
  .addMap<CompanyB, CompanyA>((source, mapper) => CompanyB(
      id: source.id,
      name: source.name,
    ));
  
var companyA = CompanyA(
  id: 1,
  name: 'ABC',
);

var companyB = mapper.map<CompanyB, CompanyA>(companyA);
```

### Mapping children

The mapper can be used in the callback to map children.

```dart
var mapper = Mapper()
  .addMap<CompanyB, CompanyA>((source, mapper, [params]) => CompanyB(
    id: source.id,
    name: source.name,
    employees: source.employees
      ?.map((employee) => mapper.map<EmployeeB, EmployeeA>(employee))
      ?.toList(),
  ))
  .addMap<EmployeeB, EmployeeA>((source, mapper, [params]) => EmployeeB(
    id: source.id,
    name: source.name,
    startDate: source.startDate,
    timeEmployed: source.startDate == null || source.endDate == null ?
      null :
      source.endDate.difference(source.startDate),
    company: mapper.map<CompanyB, CompanyA>(source.company),
  ));
```

### Mapping null

The callback is only executed if the source is not null; so null checking in the
expression is unnecessary. When null is passed to the `map` method, null is
returned.

```dart
var company = mapper.map<CompanyB, CompanyA>(null);
print(company == null); // true
```

### Mapping additional parameters

In some cases the source may not contain all of the data that you want to map
to the destination. In these cases you can pass additional parameters.

```dart
var mapper = Mapper()
  .addMap<CompanyB, CompanyA>((source, mapper, [params]) => CompanyB(
    id: source.id,
    name: source.name,
    employees: source.employees
      ?.map((employee) => mapper.map<EmployeeB, EmployeeA>(employee, {
        'companyId': source.id,
      }))
      ?.toList(),
  ))
  .addMap<EmployeeB, EmployeeA>((source, mapper, [params]) => EmployeeB(
    id: source.id,
    companyId: params != null ? params['companyId'] : null,
    name: source.name,
    startDate: source.startDate,
    timeEmployed: source.startDate == null || source.endDate == null ?
      null :
      source.endDate.difference(source.startDate),
  ));
```
