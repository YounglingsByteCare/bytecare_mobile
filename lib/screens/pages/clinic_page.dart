import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

/* Project-level Imports */
// Theme
import '../../theme/gradients.dart';
import '../../theme/google_maps.dart';

// Utils
import '../../utils/location.dart';

// Data Models
import '../../models/gradient_color.dart';
import '../../models/hospital.dart';

// Controllers
import '../../controllers/map_view.dart';
import '../../controllers/hospital_marker.dart';

// Providers
import '../../providers/byte_care_api_notifier.dart';

// Services
import '../../services/byte_care_api.dart';

// Interfaces
import '../../interfaces/application_page.dart';

// Widgets
import '../../widgets/gradient_button.dart';

// Screens
import '../book_appointment_screen.dart';
// import '../errors/denied_location_permission.dart';

class ClinicPage extends StatefulWidget implements ApplicationPage {
  final MapViewController viewController;

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
  BuildContext _context;

  void _updateUserLocation() async {
    if (_context == null) {
      return;
    }

    Position loc;
    try {
      loc = await getCurrentLocation();
    } catch (Exception) {
      // Navigator.pushNamed(context, DeniedLocationPermissionErrorScreen.id);
      return;
    }

    final GoogleMapController c = await _mapController.future;
    _userLocation = LatLng(loc.latitude, loc.longitude);

    setState(() {
      _getApiNotifier(_context).hospitalController.userLocation = _userLocation;
    });

    c.animateCamera(
      CameraUpdate.newLatLng(LatLng(loc.latitude, loc.longitude)),
    );
  }

  void _getHospitalInfo() async {
    if (_context == null) {
      return;
    }

    var token = _getApiNotifier(_context).authToken;
    var result = await ByteCareApi.getInstance().getHospitals(token);
    // _markerManager.clearMarkers();

    if (result.code == 200) {
      for (var hospital in result.data) {
        var pos = hospital['point'];
        setState(() {
          var m = HospitalModel(
            id: hospital['_id']['\$oid'],
            name: hospital['hospital_name'],
            location: LatLng(pos[0], pos[1]),
          );

          _getApiNotifier(_context).hospitalController.upsertHospital(m);
        });
      }
    }
  }

  Future<Uint8List> createUserMarkerBitmap(
      int radius, double borderWidth) async {
    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Paint gradientPaint = Paint();
    gradientPaint.shader = kThemeGradientPrimaryAngled.createShader(
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

  void _onLocationMarkerClick(HospitalModel marker) {
    if (_context == null) {
      return;
    }

    if (marker is HospitalModel) {
      Navigator.pushNamed(
        context,
        BookAppointmentScreen.id,
        arguments: marker,
      );
    }
  }

  ByteCareApiNotifier _getApiNotifier(BuildContext context,
      [bool listen = false]) {
    return Provider.of<ByteCareApiNotifier>(context, listen: listen);
  }

  @override
  void initState() {
    widget.viewController.addListener(() {
      setState(() {});
    });

    Future.delayed(Duration(seconds: 0)).then((value) {
      _getApiNotifier(_context).hospitalController.onTap =
          _onLocationMarkerClick;
      createUserMarkerBitmap(24, 2.0).then((imgData) {
        var bmp = BitmapDescriptor.fromBytes(imgData);

        setState(() {
          _getApiNotifier(_context)
              .hospitalController
              .updateUserMarker(icon: bmp);
        });
      });
    });
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant ClinicPage oldWidget) async {
  //   var permissionState = await getLocationPermissionState();
  //   if (permissionState == LocationPermission.deniedForever) {
  //     Navigator.pushNamed(context, DeniedLocationPermissionErrorScreen.id);
  //   } else {
  //     if (permissionState == LocationPermission.denied) {
  //       permissionState = await requestLocationPermission();
  //       if (permissionState == LocationPermission.denied ||
  //           permissionState == LocationPermission.deniedForever) {
  //         Navigator.pushNamed(context, DeniedLocationPermissionErrorScreen.id);
  //       }
  //     }
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    _context = context;

    if (_userLocation == null) {
      _updateUserLocation();
    }

    return widget.viewController.isShowing(MapView.MAP)
        ? _buildMapContent(context)
        : _buildListContent(context);
  }

  Widget _buildMapContent(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: kDefaultCameraPosition,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: true,
          markers:
              _getApiNotifier(context).hospitalController.asMarkerSet(true),
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
        ),
        Positioned(
          right: 24.0,
          bottom: 48.0,
          child: Column(
            children: <Widget>[
              GradientButton(
                onPressed: () {
                  _updateUserLocation();
                },
                background: GradientColorModel(Colors.white),
                shape: BoxShape.circle,
                radius: 24.0,
                child: Icon(
                  LineAwesomeIcons.crosshairs,
                  color: Colors.black,
                ),
              ),
              // SizedBox(height: 8.0),
              // GradientButton(
              //   onPressed: () {
              //     _getHospitalInfo();
              //   },
              //   background: GradientColorModel(kThemeGradientPrimaryAngled),
              //   shape: BoxShape.circle,
              //   radius: 24.0,
              //   child: Icon(
              //     LineAwesomeIcons.filter,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListContent(BuildContext context) {
    var data = _getApiNotifier(context).hospitalController.asHospitalSet();

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 64.0,
          ),
          children: data.map((e) {
            if (e is HospitalModel) {
              var h = e as HospitalModel;
              return InkWell(
                onTap: () {
                  _onLocationMarkerClick(h);
                },
                child: ListTile(
                  title: Text(h.name),
                  subtitle: Text('(${h.location.latitude.toStringAsFixed(2)},'
                      '${h.location.longitude.toStringAsFixed(2)})'),
                ),
              );
            }
          }).toList(),
        ),
        Positioned(
          right: 24.0,
          bottom: 48.0,
          child: GradientButton(
            onPressed: () {
              _getHospitalInfo();
            },
            background: GradientColorModel(kThemeGradientPrimaryAngled),
            shape: BoxShape.circle,
            radius: 24.0,
            child: Icon(
              LineAwesomeIcons.filter,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
