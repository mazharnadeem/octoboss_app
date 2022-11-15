import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:octbs_ui/screens/users/Customer/customer_bottom_navigation_bar.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issue_list_done.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issue_list_processing.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issue_list_screen_api.dart';
import 'package:octbs_ui/screens/users/Customer/customer_issues_list_screen.dart';
import 'package:octbs_ui/screens/users/Octoboss/Issues_market_screen.dart';

class CustomerIssuesTopBar extends StatefulWidget {
  CustomerIssuesTopBar({Key? key}) : super(key: key);

  @override
  State<CustomerIssuesTopBar> createState() => _CustomerIssuesTopBarState();
}

class _CustomerIssuesTopBarState extends State<CustomerIssuesTopBar>
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
    tab_controller.addListener(() {
      if(tab_controller.index==1){
      }
    });
    tab_controller.notifyListeners();
    tab_controller.removeListener(() { });
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
                    text: 'Pending'.tr.toUpperCase(),
                  ),
                  Tab(
                    text: 'Processing'.tr.toUpperCase(),
                  ),
                  Tab(
                    text: 'Done'.tr.toUpperCase(),
                  ),
                ]),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            IssueListApi(),
            IssueListProcessing(),
            IssueListDone(),
          ],
        ),
      ),
    );
  }
}
