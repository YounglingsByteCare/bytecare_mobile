import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* Project-level Imports */
// Constants
import '../constants/theme.dart';

// Data Models
import '../models/gradient_color.dart';
import '../models/map_list_controller.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/arched_bottom_appbar.dart';

// Screens
import './pages/clinic_page.dart';
import './pages/ticket_page.dart';

class ApplicationScreen extends StatefulWidget {
  static final id = 'application_screen';

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  Widget visiblePage;
  MapListController _mapListController;
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _mapListController = MapListController(
      mapIcon: LineAwesomeIcons.list,
      listIcon: LineAwesomeIcons.map,
    );

    visiblePage = ClinicPage(viewController: _mapListController);
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
      body: visiblePage,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GradientButton(
        onPressed: () {},
        backgroundFill: GradientColor(kThemePrimaryAngledLinearGradient),
        child: Icon(
          LineAwesomeIcons.bars,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(8.0),
        shape: BoxShape.circle,
        radius: 36.0,
      ),
      bottomNavigationBar: ArchedBottomAppbar(
        currentItemColor: kThemePrimaryBlue,
        items: [
          BottomAppbarItem(
            page: ClinicPage(viewController: _mapListController),
            onPressed: (page) {
              if (!(visiblePage is ClinicPage)) {
                setState(() {
                  visiblePage = page;
                });
              }
            },
            icon: LineAwesomeIcons.home,
            isCurrent: visiblePage is ClinicPage,
            label: 'Home',
          ),
          BottomAppbarItem(
            page: TicketPage(),
            onPressed: (page) {
              if (!(visiblePage is TicketPage)) {
                setState(() {
                  visiblePage = page;
                });
              }
            },
            icon: LineAwesomeIcons.alternate_ticket,
            isCurrent: visiblePage is TicketPage,
            label: 'Ticket',
          ),
          BottomAppbarItem(
            onPressed: (page) {},
            icon: LineAwesomeIcons.sms,
            isCurrent: false,
            label: 'Chat',
          ),
          BottomAppbarItem(
            onPressed: (page) {},
            icon: LineAwesomeIcons.alternate_identification_card,
            isCurrent: false,
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
