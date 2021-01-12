import 'package:meta/meta.dart';

import '../../../shared/common/utils/utils.dart';
import 'dto.dart';

class GetTransactionDto implements BaseDto {
  static const _defaultType = 'ALL';
  static const _defaultCategoryId = 'ALL';
  static const _defaultLimit = 15;
  static const _defaultOffset = 0;

  const GetTransactionDto({
    @required this.start,
    @required this.end,
    this.categoryId = _defaultCategoryId,
    this.type = _defaultType,
    this.limit = _defaultLimit,
    this.offset = _defaultOffset,
  });

  final String categoryId;
  final String type;
  final int limit;
  final int offset;
  final DateTime start;
  final DateTime end;

  @override
  Map<String, dynamic> get toMap {
    final map = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'start': start.microsecondsSinceEpoch,
      'end': end.microsecondsSinceEpoch,
    };

    if (type != _defaultType) map['type'] = type;
    if (categoryId != _defaultCategoryId) map['category'] = categoryId;

    return map;
  }

  factory GetTransactionDto.weekly({
    String categoryId,
    String type,
    int limit = _defaultLimit,
    int offset = _defaultOffset,
  }) {
    final dateRange = DateRange.weekly();

    return GetTransactionDto(
      categoryId: categoryId,
      type: type,
      start: dateRange.start,
      end: dateRange.end,
    );
  }

  factory GetTransactionDto.monthly({
    String categoryId,
    String type,
    int limit = _defaultLimit,
    int offset = _defaultOffset,
  }) {
    final dateRange = DateRange.monthly();

    return GetTransactionDto(
      categoryId: categoryId,
      type: type,
      start: dateRange.start,
      end: dateRange.end,
    );
  }
}
