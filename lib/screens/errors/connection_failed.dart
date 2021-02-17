import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/* Project-level Imports */
// Theme
import '../../theme/text.dart';
import '../../theme/colors.dart';

// Services
import '../../services/byte_care_api.dart';

class ConnectionFailed extends StatefulWidget {
  Widget returnPage;

  ConnectionFailed([this.returnPage]);

  @override
  _ConnectionFailedState createState() => _ConnectionFailedState();
}

class _ConnectionFailedState extends State<ConnectionFailed> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kThemeColorPrimary,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 10 / 9,
              child: UnDraw(
                illustration: UnDrawIllustration.server_down,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              'Connection Failed',
              style: kTitle1TextStyle.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Text(
              'We failed to connect to our server.\n'
              'Please excuse this problem, we are trying our best to fix it.',
              style: kBody1TextStyle.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            IntrinsicWidth(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _retryConnection,
                style: ElevatedButton.styleFrom(
                  textStyle: kButtonBody1TextStyle,
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.shade300;
                    }
                    return Colors.white;
                  }),
                ),
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 250),
                  alignment: Alignment.center,
                  crossFadeState: _isLoading
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Text(
                    'Retry Connection',
                    style: kButtonBody1TextStyle.copyWith(color: Colors.black),
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IntrinsicWidth(
                      child: SpinKitDualRing(
                        color: kThemeColorPrimary,
                        size: kButtonBody1TextStyle.fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retryConnection() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    var result = await ByteCareApi.getInstance().testConnection();
    if (result) {
      Navigator.pop(this.context);
      if (widget.returnPage != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.returnPage),
        );
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(_buildSnackBar());
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSnackBar() {
    return SnackBar(
      content: Text('Server is still down...'),
      behavior: SnackBarBehavior.floating,
    );
  }
}
