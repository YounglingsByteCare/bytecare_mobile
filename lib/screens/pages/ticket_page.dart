import 'package:bytecare_mobile/models/api_result.dart';
import 'package:flutter/material.dart';

/* Project-level Imports */
// Constants
import '../../constants/theme.dart';

// Data Models
import '../../models/gradient_color.dart';

// Interfaces
import '../../interfaces/application_page.dart';

// Services
import '../../services/bytecare_api.dart';

// Widgets
import '../../widgets/gradient_background.dart';
import '../../widgets/gradient_button.dart';

class TicketPage extends StatefulWidget implements ApplicationPage {
  final IconData _fabIcon;
  final void Function() _fabPressed;

  var _selectedPatient;

  TicketPage({
    IconData fabIcon,
    void Function() fabPressed,
  })  : _fabIcon = fabIcon,
        _fabPressed = fabPressed;

  @override
  _TicketPageState createState() => _TicketPageState();

  @override
  Widget asWidget() => this;

  @override
  IconData getFabIcon() => _fabIcon;

  @override
  void Function() getFabPressed() => _fabPressed;

  @override
  // TODO: implement usesFab
  get usesFab => _fabIcon != null && _fabPressed != null;
}

class _TicketPageState extends State<TicketPage> {
  List<ApiResult> _ticketData;
  bool ticketRequestSent = false;

  @override
  void initState() {
    _getTicketData();
    super.initState();
  }

  void _getTicketData() async {
    ticketRequestSent = false;
    if (!ticketRequestSent) {
      ticketRequestSent = true;

      var result = await ByteCareAPI().getAppointments();

      if (result.code == 200) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (this.mounted) {
            setState(() {
              _ticketData = result.data;
            });
          }
        });
      } else {
        print(result.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getTicketData();
    return GradientBackground(
      themeData: kByteCareThemeData,
      backgroundFill: GradientColor(kThemePrimaryAngledLinearGradient),
      ignoreSafeArea: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Showing appointment for',
                  style: kSubtitle1TextStyle.copyWith(
                    color: Colors.white.withOpacity(.9),
                  ),
                ),
                Text(
                  'Jesse Boise',
                  style: kTitle1TextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1.0),
                    blurRadius: 16.0,
                  ),
                ],
              ),
              child: _buildTicketData(
                'Groote Schuur Hospital',
                '2020-01-29 '
                    '12:18:36',
                'Not yet completed',
                'Stomach Bug',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTicketData(String hospitalName, String datetime,
      String completionStatus, String reason) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              hospitalName,
              style: kBody1TextStyle,
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Text(
          datetime,
          style: kBody1TextStyle,
        ),
        SizedBox(height: 16.0),
        Text(
          completionStatus,
          style: kBody1TextStyle,
        ),
        SizedBox(height: 16.0),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Reason for Visit',
                  textAlign: TextAlign.start,
                  style: kSubtitle1TextStyle,
                ),
                SizedBox(height: 8.0),
                RichText(
                  text: TextSpan(
                    text: reason,
                    style: kBody1TextStyle,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 80.0),
      ],
    );
  }

//  children: _ticketData.map((el) {
//             return Container();
//           }).toList(),
}
