import 'package:simple_mapper/src/duplicate_map_error.dart';
import 'package:simple_mapper/src/map_configuration.dart';
import 'package:simple_mapper/src/map_does_not_exist_error.dart';
import 'package:simple_mapper/src/map_expression.dart';

/// Handles mapping between differnt types.
class Mapper {
  /// Creates an instance of [Mapper].
  Mapper() : _maps = <Type, Map<Type, MapConfiguration>>{};

  final Map<Type, Map<Type, MapConfiguration>> _maps;

  /// Checks if the mapper has a map for the [destination] and [source] types.
  bool hasMap(Type destination, Type source) =>
      _maps.containsKey(destination) &&
      _maps[destination]!.containsKey(source) &&
      _maps[destination]![source] != null;

  /// Adds an expression that defines how to map from a [TSource] to a
  /// [TDestination] type.
  Mapper addMap<TDestination, TSource>(
      MapExpression<TDestination, TSource> expression) {
    if (!_maps.containsKey(TDestination)) {
      _maps[TDestination] = <Type, MapConfiguration>{};
    }

    if (_maps[TDestination]!.containsKey(TSource)) {
      throw DuplicateMapError(TDestination, TSource);
    }

    _maps[TDestination]![TSource] =
        MapConfiguration<TDestination, TSource>(expression);

    return this;
  }

  /// Maps the [source].
  TDestination map<TDestination, TSource>(TSource source, [Map? params]) {
    if (hasMap(TDestination, TSource)) {
      return _maps[TDestination]![TSource]!.map(source, this, params);
    }

    throw MapDoesNotExistError(TDestination, TSource);
  }
}
