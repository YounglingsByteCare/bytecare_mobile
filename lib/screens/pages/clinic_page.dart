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
import '../../controllers/hospital_marker.dart';
import '../../controllers/map_view.dart';

// Interfaces
import '../../interfaces/application_page.dart';

// Widgets
import '../../widgets/gradient_button.dart';

// Screens
import '../book_appointment_screen.dart';

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

  void _updateUserLocation() async {
    if (this.context == null) {
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

    if (c == null) {
      return;
    }

    _userLocation = LatLng(loc.latitude, loc.longitude);

    setState(() {
      _getProvider<HospitalMarkerController>(this.context).userLocation =
          _userLocation;
    });

    c.animateCamera(
      CameraUpdate.newLatLng(LatLng(loc.latitude, loc.longitude)),
    );
  }

  void _getHospitalInfo() async {
    if (this.context == null) {
      return;
    }

    _getProvider<HospitalMarkerController>(this.context).loadHospitals();
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
    if (this.context == null) {
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

  T _getProvider<T>(BuildContext context, [bool listen = false]) {
    return Provider.of<T>(context, listen: listen);
  }

  @override
  void initState() {
    widget.viewController.addListener(() {
      setState(() {});
    });

    Future.delayed(Duration(seconds: 0)).then((value) {
      _getProvider<HospitalMarkerController>(this.context).onTap =
          _onLocationMarkerClick;
      createUserMarkerBitmap(32, 2.0).then((imgData) {
        var bmp = BitmapDescriptor.fromBytes(imgData);

        setState(() {
          _getProvider<HospitalMarkerController>(this.context)
              .updateUserMarker(icon: bmp);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        Consumer<HospitalMarkerController>(
          builder: (context, controller, child) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: kDefaultCameraPosition,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
              markers: controller.asMarkerSet(true),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            );
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
              //   heroTag: 'map_filter',
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
    return Stack(
      children: [
        Consumer<HospitalMarkerController>(
          builder: (context, controller, child) {
            return ListView(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: 64.0,
              ),
              children: controller.asHospitalSet().map((e) {
                if (e is HospitalModel) {
                  return InkWell(
                    onTap: () {
                      _onLocationMarkerClick(e);
                    },
                    child: ListTile(
                      title: Text(e.name),
                      subtitle: Text(
                        '(${e.location.latitude.toStringAsFixed(2)},'
                        '${e.location.longitude.toStringAsFixed(2)})',
                      ),
                    ),
                  );
                }
              }).toList(),
            );
          },
        ),
        Positioned(
          right: 24.0,
          bottom: 48.0,
          child: GradientButton(
            heroTag: 'map_filter',
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
