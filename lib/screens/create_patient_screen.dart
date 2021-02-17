import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

/* Project-level Imports */
// Theme
import '../theme/themes.dart';
import '../theme/text.dart';
import '../theme/colors.dart';
import '../theme/gradients.dart';
import '../theme/form.dart';

// Utils
import '../utils/color.dart';

// Data Models
import '../models/address.dart';
import '../models/gradient_color.dart';
import '../models/patient.dart';
import '../models/processing_dialog_theme.dart';

// Services
import '../services/byte_care_api.dart' show ServerNotAvailableException;

// Controllers
import '../controllers/account.dart';
import '../controllers/processing_view.dart';

// Widgets
import '../widgets/gradient_background.dart';
import '../widgets/gradient_button.dart';
import '../widgets/processing_dialog.dart';

// Screens
import '../screens/errors/no_server.dart';

enum Gender {
  Male,
  Female,
  TransGender,
  TransSexual,
  IDoNotWantToSay,
}

class CreatePatientScreen extends StatefulWidget {
  static String id = 'create_patient_screen';

  final Widget returnPage;
  final String returnPageId;

  CreatePatientScreen({
    this.returnPage,
    this.returnPageId,
  }) : assert((returnPage != null) &&
            (returnPageId != null && returnPageId.isEmpty));

  @override
  _CreatePatientScreenState createState() => _CreatePatientScreenState();
}

class _CreatePatientScreenState extends State<CreatePatientScreen> {
  ProcessingViewController _processState;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  Gender _selectedGender;
  TextEditingController _idNumberController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  AddressModel _currentAddress = AddressModel();

  @override
  void initState() {
    _processState = ProcessingViewController(
      modalBuilder: (data, content, message) {
        return Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            content,
            Positioned.fill(
              child: Material(
                color: Colors.black45,
                child: Align(
                  alignment: Alignment.center,
                  child: ProcessingDialog(
                    color: data.color,
                    icon: data.icon,
                    message: message,
                    showWave: false,
                    waveColor: data.waveColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      onWillPopScope: (result) {
        return false;
      },
      successData: ProcessingDialogThemeModel(
        color: kThemeColorSuccess,
        message: 'We\'ve successfully got your data, now let\'s get to '
            'working.',
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorSuccess, 65),
          child: Icon(
            LineAwesomeIcons.check,
            color: Colors.white,
          ),
        ),
      ),
      errorData: ProcessingDialogThemeModel(
        color: kThemeColorError,
        message: 'There was an error when loading your data. Please try '
            'again.',
        icon: CircleAvatar(
          backgroundColor: darken(kThemeColorError, 65),
          child: Icon(
            LineAwesomeIcons.times,
            color: Colors.white,
          ),
        ),
      ),
      loadingData: ProcessingDialogThemeModel(
        color: kThemeColorPrimary,
        message: 'We\'re signing you in, enjoy your stay.',
        waveColor: kThemeColorSecondary,
        icon: SpinKitPulse(
          color: Colors.white,
        ),
      ),
    );

    super.initState();

    _processState.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _processState.build(
      GradientBackground(
        theme: kByteCareThemeData,
        background: GradientColorModel(kThemeGradientPrimaryAngled),
        ignoreSafeArea: true,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Container(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create a new',
                  style: kSubtitle1TextStyle.copyWith(
                    color: Colors.white.withOpacity(.9),
                  ),
                ),
                Text(
                  'Patient',
                  style: kTitle1TextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Name',
                        ),
                        validator: RequiredValidator(
                            errorText: 'This field is '
                                'required'),
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      TextFormField(
                        controller: _surnameController,
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Surname',
                        ),
                        validator: RequiredValidator(
                            errorText: 'This field is '
                                'required'),
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      DropdownButtonFormField<Gender>(
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'Gender',
                        ),
                        value: _selectedGender,
                        onChanged: (gender) {
                          if (gender != _selectedGender) {
                            setState(() {
                              _selectedGender = gender;
                            });
                          }
                        },
                        items: Gender.values.map((e) {
                          return DropdownMenuItem<Gender>(
                            value: e,
                            child: Text(
                              '${EnumToString.convertToString(e, camelCase: true)}',
                              style: kButtonBody1TextStyle,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      TextFormField(
                        controller: _idNumberController,
                        keyboardType: TextInputType.numberWithOptions(),
                        maxLength: 13,
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'ID Number',
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'This field if '
                                  'required'),
                          LengthRangeValidator(
                            min: 13,
                            max: 13,
                            errorText:
                                'Your ID number must 13 characters long.',
                          ),
                        ]),
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      IntlPhoneField(
                        controller: _phoneController,
                        showDropdownIcon: false,
                        decoration: kFormFieldInputDecoration.copyWith(
                            labelText: 'Phone Number'),
                        initialCountryCode: 'ZA',
                        validator: PatternValidator(
                          RegExp(r'\d{7}'),
                          errorText: '',
                        ),
                      ),
                      Divider(height: kFormFieldSpacing * 2),
                      Text(
                        'Address Information',
                        textAlign: TextAlign.left,
                        style: kTitle2TextStyle,
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      Row(children: [
                        SizedBox(
                          width: 96.0,
                          child: TextFormField(
                            onChanged: (value) {
                              _currentAddress.houseNumber = int.parse(value);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: kFormFieldInputDecoration.copyWith(
                              labelText: '#',
                            ),
                            validator: RequiredValidator(
                                errorText: 'This field is '
                                    'required'),
                          ),
                        ),
                        SizedBox(width: kFormFieldSpacing / 2),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              _currentAddress.street = value;
                            },
                            decoration: kFormFieldInputDecoration.copyWith(
                              labelText: 'Street Name',
                            ),
                            validator: RequiredValidator(
                                errorText: 'This field is '
                                    'required'),
                          ),
                        ),
                      ]),
                      SizedBox(height: kFormFieldSpacing / 2),
                      TextFormField(
                        onChanged: (value) {
                          _currentAddress.city = value;
                        },
                        decoration: kFormFieldInputDecoration.copyWith(
                          labelText: 'City',
                        ),
                        validator: RequiredValidator(
                            errorText: 'This field is '
                                'required'),
                      ),
                      SizedBox(height: kFormFieldSpacing),
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              _currentAddress.country = value;
                            },
                            decoration: kFormFieldInputDecoration.copyWith(
                              labelText: 'Country',
                            ),
                            validator: RequiredValidator(
                                errorText: 'This field is '
                                    'required'),
                          ),
                        ),
                        SizedBox(width: kFormFieldSpacing),
                        SizedBox(
                          width: 144.0,
                          child: TextFormField(
                            onChanged: (value) {
                              _currentAddress.postalCode = value.toString();
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: kFormFieldInputDecoration.copyWith(
                              labelText: 'Postal Code',
                            ),
                            validator: RequiredValidator(
                                errorText: 'This field is '
                                    'required'),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        color: Colors.white,
        child: IntrinsicHeight(
          child: GradientButton(
            onPressed: () {
              var res = _formKey.currentState.validate();
              if (res) {
                _createPatient();
              }
            },
            background: GradientColorModel(kButtonBackgroundLinearGradient),
            borderRadius: BorderRadius.circular(8.0),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Text(
              'Book my Appointment',
              style: kButtonBody1TextStyle,
            ),
          ),
        ),
      ),
    );
  }

  T _getProvider<T>(BuildContext context, [bool listen = false]) =>
      Provider.of<T>(context, listen: listen);

  _createPatient() async {
    _processState.begin();
    var result;

    try {
      result = await _getProvider<AccountController>(this.context)
          .createPatient(PatientModel(
        name: _nameController.text,
        surname: _surnameController.text,
        gender: EnumToString.convertToString(_selectedGender, camelCase: true),
        idNumber: _idNumberController.text,
        address: _currentAddress,
        phone: _phoneController.text,
      ));
    } on ServerNotAvailableException {
      Navigator.push(
        this.context,
        MaterialPageRoute(builder: (context) => NoServer(widget)),
      );
    }

    if (result.code == 200) {
      setState(() {
        _processState.complete(
            result.code,
            'Successfully Canceled '
            'Appointment');
      });

      await Future.delayed(kProcessDelayDuration);

      _processState.reset();

      if (widget.returnPage != null) {
        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => widget.returnPage),
        );
      } else if (widget.returnPageId != null) {
        Navigator.pushNamed(this.context, widget.returnPageId);
      } else {
        Navigator.pop(this.context);
      }
    } else {
      _processState.completeWithError(
        result.code,
        result.message,
      );

      await Future.delayed(kProcessErrorDelayDuration);

      _processState.reset();
    }
  }
}
