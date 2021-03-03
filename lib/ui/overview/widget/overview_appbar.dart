import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'overview_range_form.dart';

class OverviewAppBar extends StatelessWidget {
  static const overviewRangeIconKey = Key('home_overview_range_icon');
  static const title = 'Geldstroom';

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      title: Text(OverviewAppBar.title),
      actions: [
        IconButton(
          key: OverviewAppBar.overviewRangeIconKey,
          icon: Icon(Icons.filter_list_sharp),
          onPressed: () => showOverviewRangeFilter(context),
        )
      ],
    );
  }

  void showOverviewRangeFilter(BuildContext context) {
    showMaterialModalBottomSheet(
      builder: (_) => OverviewRangeForm(),
      useRootNavigator: true,
      context: context,
    );
  }
}