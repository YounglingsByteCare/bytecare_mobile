import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* Project-level Imports */
// Constants
import '../../constants/theme.dart';

// Utils
import '../../utils/location.dart';

// Data Models
import '../../models/map_list_controller.dart';
import '../../models/gradient_color.dart';

// Widgets
import '../../widgets/gradient_button.dart';

class ClinicPage extends StatefulWidget {
  final MapListController viewController;

  ClinicPage({@required this.viewController});

  @override
  _ClinicPageState createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  CameraPosition _userCurrentLocation = kDefaultCameraPosition;

  void _updateUserLocation() {
    getCurrentLocation().then((value) {
      setState(() => _userCurrentLocation = CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: kDefaultMapZoom,
          ));
    });
  }

  @override
  void initState() {
    _updateUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedCrossFade(
          duration: Duration(milliseconds: 350),
          firstChild: _buildMapContent(),
          secondChild: _buildListContent(),
          crossFadeState: widget.viewController.isShowingMap
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
        Positioned(
          right: 24.0,
          bottom: 40.0,
          child: Column(
            children: <Widget>[
              GradientButton(
                onPressed: () {
                  _updateUserLocation();
                },
                backgroundFill: GradientColor(Colors.white),
                shape: BoxShape.circle,
                radius: 24.0,
                child: Icon(
                  LineAwesomeIcons.crosshairs,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              GradientButton(
                onPressed: () {},
                backgroundFill:
                    GradientColor(kThemePrimaryAngledLinearGradient),
                shape: BoxShape.circle,
                radius: 24.0,
                child: Icon(
                  LineAwesomeIcons.filter,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapContent() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _userCurrentLocation ?? kDefaultCameraPosition,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
    );
  }

  Widget _buildListContent() {
    return ListView(
      shrinkWrap: true,
      children: [
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
        Text('This is a Text widget'),
      ],
    );
  }
}
