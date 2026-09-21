import 'package:fintrack/data/models/category_model.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.occurredOn,
    this.note,
    this.paymentMethod,
    this.attachmentUrl,
    this.category,
  });

  final int id;
  final String type;
  final double amount;
  final String currency;
  final DateTime occurredOn;
  final String? note;
  final String? paymentMethod;
  final String? attachmentUrl;
  final CategoryModel? category;

  bool get isIncome => type == 'income';

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'DZD',
      occurredOn: DateTime.parse(json['occurred_on'] as String),
      note: json['note'] as String?,
      paymentMethod: json['payment_method'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}
