import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

/* Project-level Imports */
// Theme
import '../theme/themes.dart';
import '../theme/colors.dart';
import '../theme/gradients.dart';

// Data Models
import '../models/gradient_color.dart';

// Controllers
import '../controllers/map_view.dart';

// Interfaces
import '../interfaces/application_page.dart';

// Providers
import '../providers/byte_care_api_notifier.dart';

// Sevices
import '../services/auth_storage.dart';

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
  MapViewController _mapViewController;
  TabController _pageTabController;
  List<BottomAppbarItem> pages;

  @override
  void initState() {
    super.initState();
    _mapViewController = MapViewController(
      mapIcon: LineAwesomeIcons.list,
      listIcon: LineAwesomeIcons.map,
    );

    pages = [
      BottomAppbarItem(
        page: ClinicPage(
          viewController: _mapViewController,
          fabIcon: _mapViewController.currentIcon,
          fabPressed: () {
            setState(() {
              _mapViewController.toggleView();
            });
          },
        ),
        onPressed: (context, page, index) {
          if (_pageTabController.index != index) {
            setState(() {
              _pageTabController.index = index;
            });
          }
        },
        icon: LineAwesomeIcons.home,
        active: true,
        // Make more modular...
        label: 'Home',
      ),
      BottomAppbarItem(
        page: TicketPage(
          fabIcon: LineAwesomeIcons.times,
          fabPressed: () {},
        ),
        onPressed: (context, page, index) {
          if (_pageTabController.index != index) {
            setState(() {
              _pageTabController.index = index;
            });
          }
        },
        icon: LineAwesomeIcons.alternate_ticket,
        active: false,
        label: 'Bookings',
      ),
      BottomAppbarItem(
        page: BlankApplicationPage(),
        onPressed: (context, page, index) {
          Provider.of<ByteCareApiNotifier>(context, listen: false).authToken =
              null;
          AuthStorage.getInstance().removeLoginToken();

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
  }

  @override
  void dispose() {
    super.dispose();
    _pageTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      theme: kByteCareThemeData,
      background: GradientColorModel(kThemeGradientPrimaryAngled),
      ignoreSafeArea: true,
      child: _build(),
    );
  }

  Widget _build() {
    var page = _getCurrentAppbarPage();

    return Scaffold(
      body: TabBarView(
        controller: _pageTabController,
        physics: NeverScrollableScrollPhysics(),
        children: pages.map((el) => el.page.asWidget()).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: page.usesFab
          ? GradientButton(
              onPressed: page.getFabPressed(),
              background: GradientColorModel(kThemeGradientPrimaryAngled),
              child: Icon(
                page.getFabIcon(),
                color: Colors.white,
              ),
              shape: BoxShape.circle,
              radius: 36.0,
            )
          : null,
      bottomNavigationBar: ArchedBottomAppbar(
        context: context,
        currentItemColor: kThemeColorPrimary,
        items: this.pages,
      ),
    );
  }

  ApplicationPage _getCurrentAppbarPage() =>
      pages[_pageTabController.index].page;

  void _updateSelectedTab(int index) {
    for (int i = 0; i < pages.length; i++) {
      pages[i].isActive = index == i ? true : false;
    }
  }
}
