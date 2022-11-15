import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issue_list_processing.dart';
import 'package:octbs_ui/screens/users/Octoboss/Issues_market_screen.dart';

class OctobossTopBar extends StatefulWidget {
  OctobossTopBar({Key? key}) : super(key: key);

  @override
  State<OctobossTopBar> createState() => _OctobossTopBarState();
}


class _OctobossTopBarState extends State<OctobossTopBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3, color: Colors.orange)),
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.black45,
                labelColor: Colors.orange,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    text: 'pending'.toUpperCase(),
                  ),
                  Tab(
                    text: 'processing'.toUpperCase(),
                  ),
                  Tab(
                    text: 'done'.toUpperCase(),
                  ),
                ]),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            IssuesMarket(),
            IssuesMarket(),
            IssuesMarket(),
          ],
        ),
      ),
    );
  }
}
