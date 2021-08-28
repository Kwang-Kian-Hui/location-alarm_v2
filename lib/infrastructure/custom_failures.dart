import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_failures.freezed.dart';

@freezed
class CustomFailures with _$CustomFailures {
  const CustomFailures._();
  const factory CustomFailures.noConnection() = NoConnection;
  const factory CustomFailures.unknown() = Unknown;
}