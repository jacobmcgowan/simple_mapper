import 'package:simple_mapper/simple_mapper.dart';
import 'package:simple_mapper/src/map_exception.dart';
import 'package:simple_mapper/src/map_expression.dart';

/// Configuration to map the [TSource] type to the [TDestination] type.
class MapConfiguration<TDestination, TSource> {
  /// Creates an instance of [MapConfiguration].
  MapConfiguration(this.expression) : assert(expression != null);

  /// The expresion that defines how to map the types.
  final MapExpression<TDestination, TSource> expression;

  /// Maps the [source].
  ///
  /// Provides the calling [mapper] so child members can be mapped as well.
  ///
  /// If needed, additional parameters can be passed to [params].
  TDestination map(TSource source, Mapper mapper, [Map params]) {
    try {
      return source == null ? null : expression(source, mapper, params);
    } catch (exception) {
      throw MapException(exception);
    }
  }
}
