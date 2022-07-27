import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';

class ScanCardResult {
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

  String get amountVND => NumberUtils.vnd(amount) ?? '-';
  String get createdDateVN =>
      DateTimeUtils.dateTimeToString(_createdDate) ?? '-';

  ScanCardResult({
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

  ScanCardResult.fromString({
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
