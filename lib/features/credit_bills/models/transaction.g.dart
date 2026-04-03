// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      type: const TransactionTypeConverter().fromJson(json['type']),
      category: const TransactionCategoryConverter().fromJson(json['category']),
      amount: (json['amount'] as num).toDouble(),
      paymentType: $enumDecode(_$PaymentTypeEnumMap, json['paymentType']),
      partyId: json['partyId'] as String?,
      partyType: $enumDecodeNullable(_$PartyTypeEnumMap, json['partyType']),
      creditPartyId: json['creditPartyId'] as String?,
      creditPartyType:
          $enumDecodeNullable(_$PartyTypeEnumMap, json['creditPartyType']),
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
      'type': const TransactionTypeConverter().toJson(instance.type),
      'category':
          const TransactionCategoryConverter().toJson(instance.category),
      'amount': instance.amount,
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType]!,
      'partyId': instance.partyId,
      'partyType': _$PartyTypeEnumMap[instance.partyType],
      'creditPartyId': instance.creditPartyId,
      'creditPartyType': _$PartyTypeEnumMap[instance.creditPartyType],
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
