import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_type.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

enum TransactionType { IN, OUT }

TransactionType _typeFromJson(dynamic json) {
  if (json is String) {
    final str = json.toUpperCase();
    if (str == 'IN' || str == 'INCOME') return TransactionType.IN;
    if (str == 'OUT' || str == 'EXPENSE') return TransactionType.OUT;
  }
  return TransactionType.OUT;
}

enum TransactionCategory {
  sale,
  payment_received,
  purchase,
  payment_paid,
  expense,
  salary,
  other
}

TransactionCategory _categoryFromJson(dynamic json) {
  if (json is String) {
    if (json == 'daily_sale_summary') return TransactionCategory.sale;
    if (json == 'daily_purchase_summary') return TransactionCategory.purchase;
    return TransactionCategory.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TransactionCategory.other,
    );
  }
  return TransactionCategory.other;
}

enum PartyType { customer, supplier }

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    // @JsonKey(fromJson: _typeFromJson) required TransactionType type,
    // @JsonKey(fromJson: _categoryFromJson) required TransactionCategory category,
    @TransactionTypeConverter() required TransactionType type,
    @TransactionCategoryConverter() required TransactionCategory category,
    required double amount,
    required PaymentType paymentType,
    String? partyId,
    PartyType? partyType,
    @Default(0.0) double totalAmount,
    @Default(0.0) double paidAmount,
    @Default(0.0) double balanceAmount,
    @Default(false) bool isCredit,
    required DateTime date,
    String? note,
    required DateTime createdAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

class TransactionTypeConverter
    implements JsonConverter<TransactionType, dynamic> {
  const TransactionTypeConverter();

  @override
  TransactionType fromJson(dynamic json) => _typeFromJson(json);

  @override
  dynamic toJson(TransactionType object) => object.name;
}

class TransactionCategoryConverter
    implements JsonConverter<TransactionCategory, dynamic> {
  const TransactionCategoryConverter();

  @override
  TransactionCategory fromJson(dynamic json) => _categoryFromJson(json);

  @override
  dynamic toJson(TransactionCategory object) => object.name;
}
