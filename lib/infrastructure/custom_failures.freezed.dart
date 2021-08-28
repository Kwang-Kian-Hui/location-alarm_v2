// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'custom_failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CustomFailuresTearOff {
  const _$CustomFailuresTearOff();

  NoConnection noConnection() {
    return const NoConnection();
  }

  Unknown unknown() {
    return const Unknown();
  }
}

/// @nodoc
const $CustomFailures = _$CustomFailuresTearOff();

/// @nodoc
mixin _$CustomFailures {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noConnection,
    required TResult Function() unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noConnection,
    TResult Function()? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoConnection value) noConnection,
    required TResult Function(Unknown value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoConnection value)? noConnection,
    TResult Function(Unknown value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomFailuresCopyWith<$Res> {
  factory $CustomFailuresCopyWith(
          CustomFailures value, $Res Function(CustomFailures) then) =
      _$CustomFailuresCopyWithImpl<$Res>;
}

/// @nodoc
class _$CustomFailuresCopyWithImpl<$Res>
    implements $CustomFailuresCopyWith<$Res> {
  _$CustomFailuresCopyWithImpl(this._value, this._then);

  final CustomFailures _value;
  // ignore: unused_field
  final $Res Function(CustomFailures) _then;
}

/// @nodoc
abstract class $NoConnectionCopyWith<$Res> {
  factory $NoConnectionCopyWith(
          NoConnection value, $Res Function(NoConnection) then) =
      _$NoConnectionCopyWithImpl<$Res>;
}

/// @nodoc
class _$NoConnectionCopyWithImpl<$Res>
    extends _$CustomFailuresCopyWithImpl<$Res>
    implements $NoConnectionCopyWith<$Res> {
  _$NoConnectionCopyWithImpl(
      NoConnection _value, $Res Function(NoConnection) _then)
      : super(_value, (v) => _then(v as NoConnection));

  @override
  NoConnection get _value => super._value as NoConnection;
}

/// @nodoc

class _$NoConnection extends NoConnection {
  const _$NoConnection() : super._();

  @override
  String toString() {
    return 'CustomFailures.noConnection()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is NoConnection);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noConnection,
    required TResult Function() unknown,
  }) {
    return noConnection();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noConnection,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoConnection value) noConnection,
    required TResult Function(Unknown value) unknown,
  }) {
    return noConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoConnection value)? noConnection,
    TResult Function(Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection(this);
    }
    return orElse();
  }
}

abstract class NoConnection extends CustomFailures {
  const factory NoConnection() = _$NoConnection;
  const NoConnection._() : super._();
}

/// @nodoc
abstract class $UnknownCopyWith<$Res> {
  factory $UnknownCopyWith(Unknown value, $Res Function(Unknown) then) =
      _$UnknownCopyWithImpl<$Res>;
}

/// @nodoc
class _$UnknownCopyWithImpl<$Res> extends _$CustomFailuresCopyWithImpl<$Res>
    implements $UnknownCopyWith<$Res> {
  _$UnknownCopyWithImpl(Unknown _value, $Res Function(Unknown) _then)
      : super(_value, (v) => _then(v as Unknown));

  @override
  Unknown get _value => super._value as Unknown;
}

/// @nodoc

class _$Unknown extends Unknown {
  const _$Unknown() : super._();

  @override
  String toString() {
    return 'CustomFailures.unknown()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Unknown);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noConnection,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noConnection,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoConnection value) noConnection,
    required TResult Function(Unknown value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoConnection value)? noConnection,
    TResult Function(Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class Unknown extends CustomFailures {
  const factory Unknown() = _$Unknown;
  const Unknown._() : super._();
}
