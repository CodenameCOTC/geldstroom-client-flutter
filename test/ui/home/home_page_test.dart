import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/ui/home/home_page.dart';
import 'package:geldstroom/ui/home/widget/overview_balance.dart';
import 'package:geldstroom/ui/home/widget/overview_range_form.dart';
import 'package:geldstroom/ui/home/widget/overview_transaction.dart';
import 'package:mockito/mockito.dart';

import '../../helper_tests/tranasction_json.dart';
import '../../test_helper.dart';

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

class MockOverviewTransactionBloc extends MockBloc<OverviewTransactionState>
    implements OverviewTransactionBloc {}

void main() {
  group('HomePage', () {
    Widget subject;
    OverviewRangeCubit overviewRangeCubit;
    OverviewBalanceCubit overviewBalanceCubit;
    OverviewTransactionBloc overviewTransactionBloc;

    setUp(() {
      overviewRangeCubit = MockOverviewRangeCubit();
      overviewBalanceCubit = MockOverviewBalanceCubit();
      overviewTransactionBloc = MockOverviewTransactionBloc();
      when(overviewTransactionBloc.state).thenReturn(
        OverviewTransactionState(
          status: FetchStatus.loadSuccess(),
          isReachEnd: true,
        ),
      );
      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: overviewRangeCubit),
          BlocProvider.value(value: overviewBalanceCubit),
          BlocProvider.value(value: overviewTransactionBloc),
        ],
        child: buildTestableBlocWidget(
          initialRoutes: HomePage.routeName,
          routes: {
            HomePage.routeName: (_) => HomePage(),
          },
        ),
      );
    });

    tearDown(() {
      overviewRangeCubit.close();
    });

    testWidgets('renders correctly', (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
      when(overviewBalanceCubit.state)
          .thenReturn(OverviewBalanceState.initial());
      when(overviewTransactionBloc.state).thenReturn(
        OverviewTransactionState(
          status: FetchStatus.loadInProgress(),
          isReachEnd: true,
        ),
      );
      await tester.pumpWidget(subject);

      expect(find.text(HomePage.appBarTitle), findsOneWidget);
      expect(find.byType(OverviewBalance), findsOneWidget);
      expect(find.byType(OverviewTransaction), findsOneWidget);
      expect(
        find.byKey(HomePage.overviewRangeIconKey).hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets(
        'should able to show OverviewRangeForm by tapping overview range icon',
        (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
      when(overviewBalanceCubit.state)
          .thenReturn(OverviewBalanceState.initial());
      await tester.pumpWidget(subject);

      final icon = find.byKey(HomePage.overviewRangeIconKey).hitTestable();
      await tester.tap(icon);
      await tester.pumpAndSettle();
      expect(find.byType(OverviewRangeForm), findsOneWidget);
    });

    group('calls', () {
      testWidgets(
          'add OverviewTransactionEvent.fetchMore when scroll reach end',
          (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(
            status: FetchStatus.loadSuccess(),
            data: List<Transaction>.generate(
              15,
              (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
            ),
            isReachEnd: false,
          ),
        );
        await tester.pumpWidget(subject);
        await tester.drag(
          find.byKey(HomePage.customScrollViewKey),
          Offset(0, -1000),
        );
        verify(
          overviewTransactionBloc.add(OverviewTransactionEvent.fetchMore()),
        ).called(1);
      });
    });
  });
}
