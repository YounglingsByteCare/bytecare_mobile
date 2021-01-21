import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bytecare_mobile/screens/errors/denied_location_permission.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/* Project-level Imports */
// Constants
import '../../constants/theme.dart';

// Utils
import '../../utils/location.dart';

// Data Models
import '../../models/gradient_color.dart';
import '../../models/map_list_controller.dart';
import '../../models/map_marker_manager.dart';
import '../../models/hospital_marker.dart';

// Services
import '../../services/bytecare_api.dart';

// Interfaces
import '../../interfaces/application_page.dart';

// Widgets
import '../../widgets/gradient_button.dart';

// Screens
import '../book_appointment_screen.dart';

class ClinicPage extends StatefulWidget implements ApplicationPage {
  final MapListController viewController;

  final IconData _fabIcon;
  final void Function() _fabPressed;

  ClinicPage(
      {@required this.viewController,
      IconData fabIcon,
      void Function() fabPressed})
      : this._fabIcon = fabIcon,
        this._fabPressed = fabPressed;

  @override
  _ClinicPageState createState() => _ClinicPageState();

  @override
  get usesFab => _fabIcon != null && _fabPressed != null;

  @override
  IconData getFabIcon() => _fabIcon;

  @override
  getFabPressed() => _fabPressed;

  @override
  Widget asWidget() => this;
}

class _ClinicPageState extends State<ClinicPage> {
  Completer<GoogleMapController> _mapController = Completer();
  LatLng _userLocation;
  MapMarkerManager _markerManager;

  void _updateUserLocation(BuildContext context) async {
    Position loc;
    try {
      loc = await getCurrentLocation();
    } catch (Exception) {
      Navigator.pushNamed(context, DeniedLocationPermissionErrorScreen.id);
      return;
    }

    final GoogleMapController c = await _mapController.future;

    _userLocation = LatLng(loc.latitude, loc.longitude);

    setState(() {
      _markerManager.setUserLocation(LatLng(loc.latitude, loc.longitude));
    });

    c.animateCamera(
      CameraUpdate.newLatLng(LatLng(loc.latitude, loc.longitude)),
    );
  }

  void _getClinicData() async {
    var result = await ByteCareAPI().getClinics();

    if (result.code == 200) {
      for (var hospital in result.data) {
        var pos = hospital['point'];
        setState(() {
          _markerManager.addMarker(
            hospitalId: hospital['_id']['\$oid'],
            hospitalName: hospital['hospital_name'],
            position: LatLng(pos[0], pos[1]),
            onTap: _onLocationMarkerClick,
          );
        });
      }
    }
  }

  Future<Uint8List> createUserMarkerBitmap(
      int radius, double borderWidth) async {
    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Paint gradientPaint = Paint();
    gradientPaint.shader = kThemePrimaryAngledLinearGradient.createShader(
      Rect.fromLTWH(0, 0, radius * 2.0, radius * 2.0),
    );

    canvas.drawCircle(
      Offset(radius.toDouble(), radius.toDouble()),
      radius * 1.0,
      gradientPaint,
    );
    canvas.drawCircle(
      Offset(radius.toDouble(), radius.toDouble()),
      radius * 1.0 - borderWidth,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(radius.toDouble(), radius.toDouble()),
      radius * 1.0 - borderWidth * 2,
      gradientPaint,
    );

    var icon = LineAwesomeIcons.user;

    TextPainter tPainter = TextPainter(textDirection: TextDirection.ltr);
    tPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: Colors.white,
        fontSize: radius.toDouble(),
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );

    tPainter.layout();
    tPainter.paint(
      canvas,
      Offset(
        radius - tPainter.width * .5,
        radius - tPainter.height * .5,
      ),
    );

    final img = await recorder.endRecording().toImage(radius * 2, radius * 2);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  void _onLocationMarkerClick(HospitalMarker marker) {
    if (marker is HospitalMarker) {
      Navigator.pushNamed(
        context,
        BookAppointmentScreen.id,
        arguments: marker,
      );
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _updateUserLocation(context);
    });

    _markerManager = MapMarkerManager.withUser(
      defaultMarker: HospitalMarker(
        onTap: _onLocationMarkerClick,
        markerId: MarkerId(''),
        hospitalId: '',
        hospitalName: '',
        position: LatLng(0.0, 0.0),
      ),
      userMarker: Marker(
        markerId: MarkerId(''),
        infoWindow: InfoWindow(
          title: 'You',
          snippet: 'Your location',
        ),
      ),
    );

    createUserMarkerBitmap(24, 2.0).then((imgData) {
      var bmp = BitmapDescriptor.fromBytes(imgData);
      setState(() {
        _markerManager.updateUserMarker(icon: bmp);
      });
    });

    _getClinicData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ClinicPage oldWidget) async {
    // TODO: implement didUpdateWidget
    var permissionState = await getLocationPermissionState();
    if (permissionState == LocationPermission.deniedForever) {
      Navigator.pushNamed(context, DeniedLocationPermissionErrorScreen.id);
    } else {
      if (permissionState == LocationPermission.denied) {
        permissionState = await requestLocationPermission();
        if (permissionState == LocationPermission.denied ||
            permissionState == LocationPermission.deniedForever) {
          Navigator.pushNamed(context, DeniedLocationPermissionErrorScreen.id);
        }
      }
    }
    super.didUpdateWidget(oldWidget);
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
                  _updateUserLocation(context);
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
                onPressed: () {
                  _getClinicData();
                },
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
      initialCameraPosition: kDefaultCameraPosition,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
      markers: _markerManager.asSet(true),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Widget _buildListContent() {
    var data = _markerManager.asSet(false);

    return ListView(
      children: data.map((e) {
        if (e is HospitalMarker) {
          return InkWell(
            onTap: () {
              _onLocationMarkerClick(e);
            },
            child: ListTile(
              title: Text(e.hospitalName),
              subtitle: Text('(${e.coords.latitude.toStringAsFixed(2)},'
                  '${e.coords.longitude.toStringAsFixed(2)})'),
            ),
          );
        }
      }).toList(),
    );

    //   return ListView.separated(
    //     itemBuilder: (context, index) {
    //       var dataItem = data[index];
    //       if (dataItem is HospitalMarker) {
    //         return InkWell(
    //           onTap: () {
    //             _onLocationMarkerClick(dataItem);
    //           },
    //           child: ListTile(
    //             title: Text(dataItem.hospitalName),
    //             subtitle: Text(
    //               '(${dataItem.coords.latitude.toStringAsFixed(2)}, '
    //               '${dataItem.coords.longitude.toStringAsFixed(2)}',
    //             ),
    //           ),
    //         );
    //       } else {
    //         return Container();
    //       }
    //     },
    //     separatorBuilder: (context, index) {
    //       return Divider(
    //         height: 1.0,
    //         thickness: 1.0,
    //       );
    //     },
    //     itemCount: data.length,
    //   );
  }
}
