import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:migo/layout/navigation_panel.dart';
import 'package:migo/layout/top_app_bar.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/models/authManager.dart';

class AppLayout extends StatelessWidget {
  final Widget content;
  final String pageName;
  final int activeTab;
  const AppLayout(
      {Key? key,
      required this.content,
      required this.pageName,
      required this.activeTab})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Responsive.isMobile(context)
         ? AppBar(
             title: Text(pageName,
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
             ),
             elevation: 10,
             backgroundColor: Theme.of(context).primaryColor,
             iconTheme: IconThemeData(color: Colors.white),
             actions: [
               PopupMenuButton<String>(
                 icon: CircleAvatar(
                   backgroundImage: AssetImage('assets/avatar.png'),
                 ),
                 onSelected: (value) {
                  if (value == 'Logout') {
                     Get.find<AuthenticationManager>().logOut();
                   }
                 },
                 itemBuilder: (_) =>  [
                   PopupMenuItem(
                     value: 'Logout',
                     child: ListTile(
                       leading: Icon(
                        Icons.logout,
                        color: Color(0xFF7717E8),
                      ),
                       title: Text('Déconnexion'),
                     ),
                   ),
                 ],
               ),
             ],
           )
         :  null,
      bottomNavigationBar: Visibility(
        visible: Responsive.isMobile(context),
        child: NavigationPanel(
          axis: Axis.horizontal,
          activeTab: activeTab,
        ),
      ),
      body: SafeArea(
        child: Responsive(
          mobile: content,
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigationPanel(
                axis: Axis.vertical,
                activeTab: activeTab,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TopAppBar(
                    pageName: pageName,
                  ),
                  Flexible(child: content),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
