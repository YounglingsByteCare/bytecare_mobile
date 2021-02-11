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
import '../controllers/account.dart';
import '../controllers/map_view.dart';

// Interfaces
import '../interfaces/application_page.dart';

// Sevices
import '../services/auth_storage.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/arched_bottom_appbar.dart';

// Screens
import './login_screen.dart';
import './pages/account_page.dart';
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

  T _getProvider<T>(BuildContext context, [bool listen = false]) =>
      Provider.of<T>(context, listen: listen);

  @override
  void initState() {
    super.initState();
    _getProvider<AccountController>(this.context).addListener(() {
      setState(() {});
    });

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
            setState(() => _mapViewController.toggleView());
          },
        ),
        onPressed: (context, page, index) {
          if (_pageTabController.index != index) {
            setState(() => _pageTabController.index = index);
          }
        },
        icon: LineAwesomeIcons.home,
        active: true,
        // Make more modular...
        label: 'Home',
      ),
      BottomAppbarItem(
        page: TicketPage(
          pageUpdater: _setPageOfType,
          fabIcon: LineAwesomeIcons.times,
          fabPressed: (caller) async {
            var c = caller as TicketPage;

            if (c.selectedPatient == null) {
              return;
            }

            c.processState.begin();

            var result = await _getProvider<AccountController>(this.context)
                .cancelAppointment(c.appointmentId);

            if (result.code == 200) {
              setState(() {
                c.processState.complete(
                    result.code,
                    'Successfully Canceled '
                    'Appointment');
              });

              await Future.delayed(kProcessDelayDuration);

              c.processState.reset();
            } else {
              c.processState.completeWithError(
                result.code,
                result.message,
              );

              await Future.delayed(kProcessErrorDelayDuration);

              c.processState.reset();
            }
          },
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
        page: AccountPage(
          fabIcon: LineAwesomeIcons.alternate_sign_out,
          fabPressed: () {
            _getProvider<AccountController>(this.context).logout();
            AuthStorage.getInstance().removeLoginToken();

            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginScreen.id,
              (route) => false,
            );
          },
        ),
        icon: LineAwesomeIcons.user,
        active: false,
        label: 'Account',
        onPressed: (context, page, index) {
          if (_pageTabController.index != index) {
            setState(() {
              _pageTabController.index = index;
            });
          }
        },
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
      ignoreSafeArea: false,
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

  void _setPageOfType(Type pageType) {
    for (int i = 0; i < pages.length; i++) {
      if (pages[i].page.runtimeType == pageType) {
        if (_pageTabController.index != i) {
          setState(() => _pageTabController.index = i);
        }
      }
    }
  }

  void _updateSelectedTab(int index) {
    for (int i = 0; i < pages.length; i++) {
      pages[i].isActive = index == i ? true : false;
    }
  }
}
