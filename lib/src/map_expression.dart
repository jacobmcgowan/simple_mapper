import 'package:simple_mapper/simple_mapper.dart';

/// An expression that defines how to map the [TDestination] type to the
/// [TSource] type.
///
/// The calling [mapper] can be used to map child members.
///
/// If additional parameters can be passed as a [Map] to [params] if needed.
typedef MapExpression<TDestination, TSource> = TDestination Function(
  TSource source,
  Mapper mapper, [
  Map? params,
]);
