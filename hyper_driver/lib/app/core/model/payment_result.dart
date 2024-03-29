import 'package:hyper_driver/app/core/utils/date_time_utils.dart';
import 'package:hyper_driver/app/core/utils/number_utils.dart';

class PaymentResult {
  bool _status = false;
  String? _uid;
  double? _amount;
  DateTime? _createdDate;
  int _source = 2;

  get status => _status;
  get uid => _uid ?? '-';
  get amount => _amount ?? '-';
  get createdDate => _createdDate ?? '-';
  get source => _source;

  String get amountVND => NumberUtils.vnd(amount);
  String get createdDateVN => DateTimeUtils.dateTimeToString(_createdDate);

  PaymentResult({
    status = false,
    uid,
    amount,
    createdDate,
    source = 2,
  }) {
    _status = status;
    _uid = uid;
    _amount = amount;
    _createdDate = createdDate;
    _source = source;
  }

  PaymentResult.fromString({
    String? status,
    String? uid,
    String? amount,
    String? createdDate,
    String? source,
  }) {
    _status = status == '0';
    _uid = uid;
    _amount = double.tryParse(amount ?? '');
    _createdDate = DateTimeUtils.parseDateTime(int.tryParse(createdDate ?? ''));
    _source = source == 'momo'
        ? 1
        : source == 'paypal'
            ? 0
            : 2;
  }
}
