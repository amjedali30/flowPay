// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      type: _typeFromJson(json['type']),
      category: _categoryFromJson(json['category']),
      amount: (json['amount'] as num).toDouble(),
      paymentType: $enumDecode(_$PaymentTypeEnumMap, json['paymentType']),
      partyId: json['partyId'] as String?,
      partyType: $enumDecodeNullable(_$PartyTypeEnumMap, json['partyType']),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      balanceAmount: (json['balanceAmount'] as num?)?.toDouble() ?? 0.0,
      isCredit: json['isCredit'] as bool? ?? false,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'category': _$TransactionCategoryEnumMap[instance.category]!,
      'amount': instance.amount,
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType]!,
      'partyId': instance.partyId,
      'partyType': _$PartyTypeEnumMap[instance.partyType],
      'totalAmount': instance.totalAmount,
      'paidAmount': instance.paidAmount,
      'balanceAmount': instance.balanceAmount,
      'isCredit': instance.isCredit,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PaymentTypeEnumMap = {
  PaymentType.cash: 'cash',
  PaymentType.upi: 'upi',
  PaymentType.bank: 'bank',
  PaymentType.credit: 'credit',
};

const _$PartyTypeEnumMap = {
  PartyType.customer: 'customer',
  PartyType.supplier: 'supplier',
};

const _$TransactionTypeEnumMap = {
  TransactionType.IN: 'IN',
  TransactionType.OUT: 'OUT',
};

const _$TransactionCategoryEnumMap = {
  TransactionCategory.sale: 'sale',
  TransactionCategory.payment_received: 'payment_received',
  TransactionCategory.purchase: 'purchase',
  TransactionCategory.payment_paid: 'payment_paid',
  TransactionCategory.expense: 'expense',
  TransactionCategory.salary: 'salary',
  TransactionCategory.other: 'other',
};
