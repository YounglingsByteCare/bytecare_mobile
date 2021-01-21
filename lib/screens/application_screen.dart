import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* Project-level Imports */
// Constants
import '../constants/theme.dart';

// Data Models
import '../models/gradient_color.dart';
import '../models/map_list_controller.dart';

// Interfaces
import '../interfaces/application_page.dart';

// Sevices
import '../services/bytecare_api.dart';
import '../services/storage_manager.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/arched_bottom_appbar.dart';

// Screens
import './login_screen.dart';
import './pages/blank_application_page.dart';
import './pages/clinic_page.dart';
import './pages/ticket_page.dart';

class ApplicationScreen extends StatefulWidget {
  static final id = 'application_screen';

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen>
    with SingleTickerProviderStateMixin {
  MapListController _mapListController;
  TabController _pageTabController;
  List<BottomAppbarItem> pages;

  @override
  void initState() {
    super.initState();
    _mapListController = MapListController(
      mapIcon: LineAwesomeIcons.list,
      listIcon: LineAwesomeIcons.map,
    );

    pages = [
      BottomAppbarItem(
        page: ClinicPage(
          viewController: _mapListController,
          fabIcon: _mapListController.getAppropriateIconData(),
          fabPressed: () {
            setState(() {
              _mapListController.toggleView();
            });
          },
        ),
        onPressed: (page, index) {
          if (_pageTabController.index != index) {
            setState(() {
              _pageTabController.index = index;
            });
          }
        },
        icon: LineAwesomeIcons.home,
        isCurrent: true,
        // Make more modular...
        label: 'Home',
      ),
      BottomAppbarItem(
        page: TicketPage(
          fabIcon: LineAwesomeIcons.times,
          fabPressed: () {},
        ),
        onPressed: (page, index) {
          if (_pageTabController.index != index) {
            setState(() {
              _pageTabController.index = index;
            });
          }
        },
        icon: LineAwesomeIcons.alternate_ticket,
        isCurrent: false,
        label: 'Bookings',
      ),
      BottomAppbarItem(
        page: BlankApplicationPage(),
        onPressed: (page, index) {
          ByteCareAPI().logout();
          StorageManager().removeLoginToken();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.id,
            (route) => false,
          );
        },
        icon: LineAwesomeIcons.alternate_sign_out,
      ),
    ];

    _pageTabController = TabController(
      initialIndex: 0,
      length: pages.length,
      vsync: this,
    );

    _pageTabController.addListener(() {
      _updateSelectedTab(_pageTabController.index);
    });

    // TODO: Check to see if current profile has any linked appointments.
    // TODO: if so, open `TicketPage`, instead of the `ClinicPage`.
  }

  @override
  void dispose() {
    super.dispose();
    _pageTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      themeData: kByteCareThemeData,
      backgroundFill: GradientColor(kThemePrimaryLightLinearGradient),
      ignoreSafeArea: true,
      child: _build(),
    );
  }

  Widget _build() {
    return Scaffold(
      body: TabBarView(
        controller: _pageTabController,
        physics: NeverScrollableScrollPhysics(),
        children: pages.map((el) => el.page.asWidget()).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _getCurrentAppbarPage().usesFab
          ? GradientButton(
              onPressed: _getCurrentAppbarPage().getFabPressed(),
              backgroundFill: GradientColor(kThemePrimaryAngledLinearGradient),
              child: Icon(
                _getCurrentAppbarPage().getFabIcon(),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(8.0),
              shape: BoxShape.circle,
              radius: 36.0,
            )
          : null,
      bottomNavigationBar: ArchedBottomAppbar(
        currentItemColor: kThemePrimaryBlue,
        items: this.pages,
      ),
    );
  }

  ApplicationPage _getCurrentAppbarPage() =>
      pages[_pageTabController.index].page;

  void _updateSelectedTab(int index) {
    for (int i = 0; i < pages.length; i++) {
      pages[i].isCurrent = index == i ? true : false;
    }
  }
}
