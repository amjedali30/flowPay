// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  String get id =>
      throw _privateConstructorUsedError; // @JsonKey(fromJson: _typeFromJson) required TransactionType type,
// @JsonKey(fromJson: _categoryFromJson) required TransactionCategory category,
  @TransactionTypeConverter()
  TransactionType get type => throw _privateConstructorUsedError;
  @TransactionCategoryConverter()
  TransactionCategory get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  PaymentType get paymentType => throw _privateConstructorUsedError;
  String? get partyId => throw _privateConstructorUsedError;
  PartyType? get partyType => throw _privateConstructorUsedError;
  String? get creditPartyId => throw _privateConstructorUsedError;
  PartyType? get creditPartyType => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  double get balanceAmount => throw _privateConstructorUsedError;
  bool get isCredit => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) then) =
      _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call(
      {String id,
      @TransactionTypeConverter() TransactionType type,
      @TransactionCategoryConverter() TransactionCategory category,
      double amount,
      PaymentType paymentType,
      String? partyId,
      PartyType? partyType,
      String? creditPartyId,
      PartyType? creditPartyType,
      double totalAmount,
      double paidAmount,
      double balanceAmount,
      bool isCredit,
      DateTime date,
      String? note,
      DateTime createdAt});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? paymentType = null,
    Object? partyId = freezed,
    Object? partyType = freezed,
    Object? creditPartyId = freezed,
    Object? creditPartyType = freezed,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? balanceAmount = null,
    Object? isCredit = null,
    Object? date = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TransactionCategory,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      partyId: freezed == partyId
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      partyType: freezed == partyType
          ? _value.partyType
          : partyType // ignore: cast_nullable_to_non_nullable
              as PartyType?,
      creditPartyId: freezed == creditPartyId
          ? _value.creditPartyId
          : creditPartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      creditPartyType: freezed == creditPartyType
          ? _value.creditPartyType
          : creditPartyType // ignore: cast_nullable_to_non_nullable
              as PartyType?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAmount: null == balanceAmount
          ? _value.balanceAmount
          : balanceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      isCredit: null == isCredit
          ? _value.isCredit
          : isCredit // ignore: cast_nullable_to_non_nullable
              as bool,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(_$TransactionModelImpl value,
          $Res Function(_$TransactionModelImpl) then) =
      __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @TransactionTypeConverter() TransactionType type,
      @TransactionCategoryConverter() TransactionCategory category,
      double amount,
      PaymentType paymentType,
      String? partyId,
      PartyType? partyType,
      String? creditPartyId,
      PartyType? creditPartyType,
      double totalAmount,
      double paidAmount,
      double balanceAmount,
      bool isCredit,
      DateTime date,
      String? note,
      DateTime createdAt});
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(_$TransactionModelImpl _value,
      $Res Function(_$TransactionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? paymentType = null,
    Object? partyId = freezed,
    Object? partyType = freezed,
    Object? creditPartyId = freezed,
    Object? creditPartyType = freezed,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? balanceAmount = null,
    Object? isCredit = null,
    Object? date = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TransactionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TransactionCategory,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      partyId: freezed == partyId
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String?,
      partyType: freezed == partyType
          ? _value.partyType
          : partyType // ignore: cast_nullable_to_non_nullable
              as PartyType?,
      creditPartyId: freezed == creditPartyId
          ? _value.creditPartyId
          : creditPartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      creditPartyType: freezed == creditPartyType
          ? _value.creditPartyType
          : creditPartyType // ignore: cast_nullable_to_non_nullable
              as PartyType?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAmount: null == balanceAmount
          ? _value.balanceAmount
          : balanceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      isCredit: null == isCredit
          ? _value.isCredit
          : isCredit // ignore: cast_nullable_to_non_nullable
              as bool,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl(
      {required this.id,
      @TransactionTypeConverter() required this.type,
      @TransactionCategoryConverter() required this.category,
      required this.amount,
      required this.paymentType,
      this.partyId,
      this.partyType,
      this.creditPartyId,
      this.creditPartyType,
      this.totalAmount = 0.0,
      this.paidAmount = 0.0,
      this.balanceAmount = 0.0,
      this.isCredit = false,
      required this.date,
      this.note,
      required this.createdAt});

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  @override
  final String id;
// @JsonKey(fromJson: _typeFromJson) required TransactionType type,
// @JsonKey(fromJson: _categoryFromJson) required TransactionCategory category,
  @override
  @TransactionTypeConverter()
  final TransactionType type;
  @override
  @TransactionCategoryConverter()
  final TransactionCategory category;
  @override
  final double amount;
  @override
  final PaymentType paymentType;
  @override
  final String? partyId;
  @override
  final PartyType? partyType;
  @override
  final String? creditPartyId;
  @override
  final PartyType? creditPartyType;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final double paidAmount;
  @override
  @JsonKey()
  final double balanceAmount;
  @override
  @JsonKey()
  final bool isCredit;
  @override
  final DateTime date;
  @override
  final String? note;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TransactionModel(id: $id, type: $type, category: $category, amount: $amount, paymentType: $paymentType, partyId: $partyId, partyType: $partyType, creditPartyId: $creditPartyId, creditPartyType: $creditPartyType, totalAmount: $totalAmount, paidAmount: $paidAmount, balanceAmount: $balanceAmount, isCredit: $isCredit, date: $date, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.partyId, partyId) || other.partyId == partyId) &&
            (identical(other.partyType, partyType) ||
                other.partyType == partyType) &&
            (identical(other.creditPartyId, creditPartyId) ||
                other.creditPartyId == creditPartyId) &&
            (identical(other.creditPartyType, creditPartyType) ||
                other.creditPartyType == creditPartyType) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.balanceAmount, balanceAmount) ||
                other.balanceAmount == balanceAmount) &&
            (identical(other.isCredit, isCredit) ||
                other.isCredit == isCredit) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      category,
      amount,
      paymentType,
      partyId,
      partyType,
      creditPartyId,
      creditPartyType,
      totalAmount,
      paidAmount,
      balanceAmount,
      isCredit,
      date,
      note,
      createdAt);

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel(
      {required final String id,
      @TransactionTypeConverter() required final TransactionType type,
      @TransactionCategoryConverter()
      required final TransactionCategory category,
      required final double amount,
      required final PaymentType paymentType,
      final String? partyId,
      final PartyType? partyType,
      final String? creditPartyId,
      final PartyType? creditPartyType,
      final double totalAmount,
      final double paidAmount,
      final double balanceAmount,
      final bool isCredit,
      required final DateTime date,
      final String? note,
      required final DateTime createdAt}) = _$TransactionModelImpl;

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override
  String
      get id; // @JsonKey(fromJson: _typeFromJson) required TransactionType type,
// @JsonKey(fromJson: _categoryFromJson) required TransactionCategory category,
  @override
  @TransactionTypeConverter()
  TransactionType get type;
  @override
  @TransactionCategoryConverter()
  TransactionCategory get category;
  @override
  double get amount;
  @override
  PaymentType get paymentType;
  @override
  String? get partyId;
  @override
  PartyType? get partyType;
  @override
  String? get creditPartyId;
  @override
  PartyType? get creditPartyType;
  @override
  double get totalAmount;
  @override
  double get paidAmount;
  @override
  double get balanceAmount;
  @override
  bool get isCredit;
  @override
  DateTime get date;
  @override
  String? get note;
  @override
  DateTime get createdAt;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
