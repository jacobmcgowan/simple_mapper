import 'package:simple_mapper/simple_mapper.dart';
import 'package:simple_mapper/src/duplicate_map_error.dart';
import 'package:simple_mapper/src/map_does_not_exist_error.dart';
import 'package:simple_mapper/src/map_exception.dart';
import 'package:test/test.dart';

import 'mocks/company_a.dart';
import 'mocks/company_b.dart';
import 'mocks/employee_a.dart';
import 'mocks/employee_b.dart';

void main() {
  group('Test addMap', () {
    test('Add valid map', () {
      // Arrange - NOOP
      // Act
      var mapper = Mapper()
        .addMap<CompanyB, CompanyA>((source, mapper) => CompanyB());

      // Assert
      expect(mapper.hasMap(CompanyB, CompanyA), isTrue);
    });

    test('Duplicate map error', () {
      // Arrange
      var mapper = Mapper()
        .addMap<CompanyB, CompanyA>((source, mapper) => CompanyB());

      // Act - NOOP
      // Assert
      expect(
        () => mapper.addMap<CompanyB, CompanyA>((source, mapper) => CompanyB()),
        throwsA(predicate((e) => e is DuplicateMapError &&
          e.destination == CompanyB &&
          e.source == CompanyA))
      );
    });
  });

  group('Test hasMap', () {
    test('Map exists', () {
      // Arrange
      var mapper = Mapper()
        .addMap<CompanyB, CompanyA>((source, mapper) => CompanyB());

      // Act
      var hasMap = mapper.hasMap(CompanyB, CompanyA);

      // Assert
      expect(hasMap, isTrue);
    });

    test('Map does not exist', () {
      // Arrange
      var mapper = Mapper();

      // Act
      var hasMap = mapper.hasMap(CompanyB, CompanyA);

      // Assert
      expect(hasMap, isFalse);
    });
  });

  group('Test map', () {
    Mapper mapper;

    setUp(() {
      mapper = Mapper()
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
        ))
        .addMap<EmployeeA, EmployeeB>((source, mapper) => throw Exception('Not today'));
    });

    test('Simple map', () {
      // Arrange
      var companyA = CompanyA(
        id: 1,
        name: 'ABC'
      );

      // Act
      var companyB = mapper.map<CompanyB, CompanyA>(companyA);

      // Assert
      expect(companyB, isNotNull);
      expect(companyB.id, equals(companyA.id));
      expect(companyB.name, equals(companyA.name));
    });

    test('Conditional map', () {
      // Arrange
      var now = DateTime.now();
      var duration = Duration(days: 30);
      var employeeA = EmployeeA(
        startDate: now.subtract(duration),
      );
      var employeeC = EmployeeA(
        startDate: now.subtract(duration),
        endDate: now
      );

      // Act
      var employeeB = mapper.map<EmployeeB, EmployeeA>(employeeA);
      var employeeD = mapper.map<EmployeeB, EmployeeA>(employeeC);

      // Assert
      expect(employeeB, isNotNull);
      expect(employeeD, isNotNull);
      expect(employeeB.timeEmployed, isNull);
      expect(employeeD.timeEmployed, equals(duration));
    });

    test('Map child', () {
      // Arrange
      var employeeA = EmployeeA(
        company: CompanyA(
          id: 1,
          name: 'ABC'
        )
      );

      // Act
      var employeeB = mapper.map<EmployeeB, EmployeeA>(employeeA);

      // Assert
      expect(employeeB, isNotNull);
      expect(employeeB.company, isNotNull);
      expect(employeeB.company.id, employeeA.company.id);
      expect(employeeB.company.name, employeeA.company.name);
    });

    test('Map children', () {
      // Arrange
      var companyA = CompanyA(
        employees: <EmployeeA>[
          EmployeeA(
            id: 1,
            name: 'John Smith'
          )
        ]
      );

      // Act
      var companyB = mapper.map<CompanyB, CompanyA>(companyA);

      // Assert
      expect(companyB, isNotNull);
      expect(companyB.employees, isNotNull);
      expect(companyB.employees.length, equals(companyA.employees.length));
      expect(companyB.employees[0].id, equals(companyA.employees[0].id));
      expect(companyB.employees[0].name, equals(companyA.employees[0].name));
    });

    test('Map null', () {
      // Arrange - NOOP
      // Act
      var companyB = mapper.map<CompanyB, CompanyA>(null);

      // Assert
      expect(companyB, isNull);
    });

    test('Map does not exist', () {
      // Arrange - NOOP
      // Act - NOOP
      // Assert
      expect(
        () => mapper.map<CompanyA, CompanyB>(null),
        throwsA(predicate((e) => e is MapDoesNotExistError &&
          e.destination == CompanyA &&
          e.source == CompanyB))
      );
    });

    test('Map exception', () {
      // Arrange
      var employeeB = EmployeeB();

      // Act - NOOP
      // Assert
      expect(
        () => mapper.map<EmployeeA, EmployeeB>(employeeB),
        throwsA(TypeMatcher<MapException>())
      );
    });
  });
}
