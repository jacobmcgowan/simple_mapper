import 'package:simple_mapper/simple_mapper.dart';
import 'package:simple_mapper/src/duplicate_map_error.dart';
import 'package:simple_mapper/src/map_does_not_exist_error.dart';
import 'package:simple_mapper/src/map_exception.dart';
import 'package:test/test.dart';

import 'mocks/company_a.dart';
import 'mocks/company_b.dart';
import 'mocks/employee_a.dart';
import 'mocks/employee_b.dart';

bool isType<T>(Type type) => type == T;

void main() {
  group('Test addMap', () {
    test('Add valid map', () {
      // Arrange - NOOP
      // Act
      final mapper = Mapper()
          .addMap<CompanyB, CompanyA>((source, mapper, [params]) => CompanyB());

      // Assert
      expect(mapper.hasMap(CompanyB, CompanyA), isTrue);
    });

    test('Duplicate map error', () {
      // Arrange
      final mapper = Mapper()
          .addMap<CompanyB, CompanyA>((source, mapper, [params]) => CompanyB());

      // Act - NOOP
      // Assert
      expect(
        () => mapper.addMap<CompanyB, CompanyA>(
          (source, mapper, [params]) => CompanyB(),
        ),
        throwsA(
          predicate((dynamic e) =>
              e is DuplicateMapError &&
              e.destination == CompanyB &&
              e.source == CompanyA),
        ),
      );
    });
  });

  group('Test hasMap', () {
    test('Map exists', () {
      // Arrange
      final mapper = Mapper()
          .addMap<CompanyB, CompanyA>((source, mapper, [params]) => CompanyB());

      // Act
      final hasMap = mapper.hasMap(CompanyB, CompanyA);

      // Assert
      expect(hasMap, isTrue);
    });

    test('Map does not exist', () {
      // Arrange
      final mapper = Mapper();

      // Act
      final hasMap = mapper.hasMap(CompanyB, CompanyA);

      // Assert
      expect(hasMap, isFalse);
    });
  });

  group('Test map', () {
    late Mapper mapper;

    setUp(() {
      mapper = Mapper()
          .addMap<CompanyB, CompanyA>(
            (source, mapper, [params]) => CompanyB(
              id: source.id,
              name: source.name,
              employees: source.employees
                  ?.map(
                    (employee) => mapper.map<EmployeeB, EmployeeA>(employee),
                  )
                  .toList(),
            ),
          )
          .addMap<CompanyB?, CompanyA?>(
            (source, mapper, [params]) => CompanyB(
                id: source?.id,
                name: source?.name,
                employees: source?.employees
                    ?.map(
                      (employee) => mapper.map<EmployeeB, EmployeeA>(employee),
                    )
                    .toList()),
          )
          .addMap<EmployeeB, EmployeeA>(
            (source, mapper, [params]) => EmployeeB(
              id: source.id,
              companyId: params != null ? params['companyId'] : null,
              name: source.name,
              startDate: source.startDate,
              timeEmployed: source.startDate == null || source.endDate == null
                  ? null
                  : source.endDate!.difference(source.startDate!),
              company: mapper.map<CompanyB?, CompanyA?>(source.company),
            ),
          )
          .addMap<EmployeeA, EmployeeB>(
            ((source, mapper, [params]) => throw Exception('Not today')),
          );
    });

    test('Simple map', () {
      // Arrange
      final companyA = CompanyA(id: 1, name: 'ABC');

      // Act
      final companyB = mapper.map<CompanyB, CompanyA>(companyA);

      // Assert
      expect(companyB, isNotNull);
      expect(companyB.id, equals(companyA.id));
      expect(companyB.name, equals(companyA.name));
    });

    test('Conditional map', () {
      // Arrange
      final now = DateTime.now();
      final duration = Duration(days: 30);
      final employeeA = EmployeeA(
        startDate: now.subtract(duration),
      );
      final employeeC = EmployeeA(
        startDate: now.subtract(duration),
        endDate: now,
      );

      // Act
      final employeeB = mapper.map<EmployeeB, EmployeeA>(employeeA);
      final employeeD = mapper.map<EmployeeB, EmployeeA>(employeeC);

      // Assert
      expect(employeeB, isNotNull);
      expect(employeeD, isNotNull);
      expect(employeeB.timeEmployed, isNull);
      expect(employeeD.timeEmployed, equals(duration));
    });

    test('Map child', () {
      // Arrange
      final employeeA = EmployeeA(company: CompanyA(id: 1, name: 'ABC'));

      // Act
      final employeeB = mapper.map<EmployeeB, EmployeeA>(employeeA);

      // Assert
      expect(employeeB, isNotNull);
      expect(employeeB.company, isNotNull);
      expect(employeeB.company!.id, employeeA.company!.id);
      expect(employeeB.company!.name, employeeA.company!.name);
    });

    test('Map children', () {
      // Arrange
      final companyA = CompanyA(
        employees: <EmployeeA>[EmployeeA(id: 1, name: 'John Smith')],
      );

      // Act
      final companyB = mapper.map<CompanyB, CompanyA>(companyA);

      // Assert
      expect(companyB, isNotNull);
      expect(companyB.employees, isNotNull);
      expect(companyB.employees!.length, equals(companyA.employees!.length));
      expect(companyB.employees![0]!.id, equals(companyA.employees![0].id));
      expect(companyB.employees![0]!.name, equals(companyA.employees![0].name));
    });

    test('Map params', () {
      // Arrange
      final companyId = 2;
      final employeeA = EmployeeA(id: 1);

      // Act
      final employeeB = mapper.map<EmployeeB, EmployeeA>(employeeA, {
        'companyId': companyId,
      });

      // Assert
      expect(employeeB, isNotNull);
      expect(employeeB.id, equals(employeeA.id));
      expect(employeeB.companyId, equals(companyId));
    });

    test('Map null', () {
      // Arrange - NOOP
      // Act
      final companyB = mapper.map<CompanyB?, CompanyA?>(null);

      // Assert
      expect(companyB, isNull);
    });

    test('Map does not exist', () {
      // Arrange - NOOP
      // Act - NOOP
      // Assert
      expect(
        () => mapper.map<CompanyA, CompanyB?>(null),
        throwsA(
          predicate(
            (dynamic e) =>
                e is MapDoesNotExistError &&
                isType<CompanyA>(e.destination) &&
                isType<CompanyB?>(e.source),
          ),
        ),
      );
    });

    test('Map exception', () {
      // Arrange
      final employeeB = EmployeeB();

      // Act - NOOP
      // Assert
      expect(() => mapper.map<EmployeeA, EmployeeB>(employeeB),
          throwsA(TypeMatcher<MapException>()));
    });
  });
}
