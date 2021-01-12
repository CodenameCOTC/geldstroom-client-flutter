import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../shared/common/utils/utils.dart';
import 'dto.dart';

class GetBalanceDto extends Equatable implements BaseDto {
  const GetBalanceDto({
    @required this.categoryId,
    @required this.start,
    @required this.end,
  });

  final String categoryId;
  final DateTime start; // timestamp
  final DateTime end; // timestamp

  factory GetBalanceDto.weekly() {
    final dateRange = DateRange.weekly();

    return GetBalanceDto(
      categoryId: 'ALL',
      start: dateRange.start,
      end: dateRange.end,
    );
  }

  factory GetBalanceDto.monthly() {
    final dateRange = DateRange.monthly();

    return GetBalanceDto(
      categoryId: 'ALL',
      start: dateRange.start,
      end: dateRange.end,
    );
  }

  @override
  List<Object> get props => [categoryId, start, end];

  @override
  Map<String, dynamic> get toMap => {
        'category': categoryId,
        'start': start.millisecondsSinceEpoch ~/ 1000,
        'end': end.millisecondsSinceEpoch ~/ 1000,
      };
}
