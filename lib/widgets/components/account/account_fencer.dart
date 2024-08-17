import 'package:evf/api/account_link.dart';
import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';
import 'package:evf/styles.dart';
import 'package:evf/util/alert.dart';
import 'package:evf/util/confirmation.dart';
import 'package:evf/widgets/basic/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AccountFencer extends StatefulWidget {
  final AccountData data;
  const AccountFencer({super.key, required this.data});
  @override
  State<AccountFencer> createState() => _AccountFencerState();
}

class _AccountFencerState extends State<AccountFencer> {
  final firstDate = DateTime.now().subtract(const Duration(days: 120 * 365));
  final lastDate = DateTime.now().subtract(const Duration(days: 4 * 365));
  final surnameController = TextEditingController();
  final givenNameController = TextEditingController();
  final datePickerController = TextEditingController();
  var isLinking = false;
  var isDatePicking = false;
  var canEdit = false;

  @override
  void initState() {
    super.initState();
    canEdit = widget.data.fencer.id == '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    surnameController.dispose();
    givenNameController.dispose();
    datePickerController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final genders = [
      DropdownOption('M', AppLocalizations.of(context)!.labelMale),
      DropdownOption('F', AppLocalizations.of(context)!.labelFemale),
    ];
    final countries = [
      DropdownOption('', AppLocalizations.of(context)!.labelNoCountryPicked),
      const DropdownOption('ALB', 'ALB'),
      const DropdownOption('AND', 'AND'),
      const DropdownOption('ARM', 'ARM'),
      const DropdownOption('AUT', 'AUT'),
      const DropdownOption('AZE', 'AZE'),
      const DropdownOption('BEL', 'BEL'),
      const DropdownOption('BIH', 'BIH'),
      const DropdownOption('BLR', 'BLR'),
      const DropdownOption('BUL', 'BUL'),
      const DropdownOption('CRO', 'CRO'),
      const DropdownOption('CZE', 'CZE'),
      const DropdownOption('DEN', 'DEN'),
      const DropdownOption('ESP', 'ESP'),
      const DropdownOption('EST', 'EST'),
      const DropdownOption('FIN', 'FIN'),
      const DropdownOption('FRA', 'FRA'),
      const DropdownOption('GBR', 'GBR'),
      const DropdownOption('GEO', 'GEO'),
      const DropdownOption('GER', 'GER'),
      const DropdownOption('GRE', 'GRE'),
      const DropdownOption('HUN', 'HUN'),
      const DropdownOption('IRL', 'IRL'),
      const DropdownOption('ISL', 'ISL'),
      const DropdownOption('ISR', 'ISR'),
      const DropdownOption('ITA', 'ITA'),
      const DropdownOption('LAT', 'LAT'),
      const DropdownOption('LTU', 'LTU'),
      const DropdownOption('LUX', 'LUX'),
      const DropdownOption('MAL', 'MAL'),
      const DropdownOption('MDA', 'MDA'),
      const DropdownOption('MKD', 'MKD'),
      const DropdownOption('MON', 'MON'),
      const DropdownOption('NED', 'NED'),
      const DropdownOption('NOR', 'NOR'),
      const DropdownOption('POL', 'POL'),
      const DropdownOption('POR', 'POR'),
      const DropdownOption('ROU', 'ROU'),
      const DropdownOption('RSM', 'RSM'),
      const DropdownOption('RUS', 'RUS'),
      const DropdownOption('SLO', 'SLO'),
      const DropdownOption('SRB', 'SRB'),
      const DropdownOption('SUI', 'SUI'),
      const DropdownOption('SVK', 'SVK'),
      const DropdownOption('SWE', 'SWE'),
      const DropdownOption('TUR', 'TUR'),
      const DropdownOption('UKR', 'UKR'),
      DropdownOption('OTH', AppLocalizations.of(context)!.labelOtherCountry),
    ];
    surnameController.text = widget.data.fencer.lastName;
    givenNameController.text = widget.data.fencer.firstName;
    Environment.debug("checking ${widget.data.fencer.dateOfBirth}");
    if (DateTime(1000, 1, 2).isBefore(widget.data.fencer.dateOfBirth)) {
      Environment.debug("setting datePickerController text");
      datePickerController.text = _formattedDate(widget.data.fencer.dateOfBirth);
    }
    return Form(
        key: _formKey,
        child: Column(children: [
          Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.titleFencer, style: AppStyles.largeHeader),
            textAlign: TextAlign.center,
          ),
          Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.descrFencer, style: AppStyles.plainText),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) _storeSurname();
              },
              child: TextFormField(
                controller: surnameController,
                readOnly: !canEdit,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2) {
                    return AppLocalizations.of(context)!.errorEmptySurname;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.descrSurnameInput,
                ),
              )),
          const SizedBox(height: 10),
          Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) _storeGivenName();
              },
              child: TextFormField(
                controller: givenNameController,
                readOnly: !canEdit,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2) {
                    return AppLocalizations.of(context)!.errorEmptyGivenName;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.descrGivenNameInput,
                ),
              )),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
                child: Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) _storeDatePicker();
                    },
                    child: TextFormField(
                      controller: datePickerController,
                      readOnly: !canEdit,
                      validator: (value) {
                        Environment.debug("datePicker testing $value");
                        if (value == null || value.isEmpty) {
                          Environment.debug("date conversion fails");
                          return AppLocalizations.of(context)!.errorInvalidDate;
                        } else {
                          var date = widget.data.fencer.dateOfBirth;
                          var txt = _formattedDate(date);
                          Environment.debug("widget date is $txt");
                          if (value == txt) {
                            if (firstDate.isAfter(date) || lastDate.isBefore(date)) {
                              return AppLocalizations.of(context)!.errorInvalidDate;
                            }
                          } else {
                            return AppLocalizations.of(context)!.errorInvalidDate;
                          }
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.descrEnterDate,
                      ),
                    ))),
            if (canEdit) const SizedBox(width: 10),
            if (canEdit)
              IconButton(onPressed: () => _showDatePicker(context), icon: const Icon(Icons.calendar_today_outlined))
          ]),
          Row(
            children: [
              SizedBox(
                  width: 100,
                  child:
                      Text.rich(TextSpan(text: AppLocalizations.of(context)!.labelGender, style: AppStyles.boldText))),
              Dropdown(
                callback: (opt) => _onSelectGender(context, opt),
                disabled: !canEdit,
                options: genders,
                value: widget.data.fencer.gender,
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: 100,
                  child:
                      Text.rich(TextSpan(text: AppLocalizations.of(context)!.labelCountry, style: AppStyles.boldText))),
              Dropdown(
                callback: (opt) => _onSelectCountry(context, opt),
                disabled: !canEdit,
                options: countries,
                value: widget.data.fencer.country,
              )
            ],
          ),
          const SizedBox(height: 20),
          if (_displayLink())
            ElevatedButton(
              onPressed: () async {
                if (!isLinking && _formKey.currentState!.validate()) {
                  _linkFencer(context);
                }
              },
              child: Text(widget.data.fencer.id == ''
                  ? AppLocalizations.of(context)!.labelLink
                  : AppLocalizations.of(context)!.labelUpdate),
            ),
          if (!_displayLink())
            ElevatedButton(
              onPressed: () async {
                await _allowChange(context);
              },
              child: Text(AppLocalizations.of(context)!.labelChange),
            ),
        ]));
  }

  Future _linkFencer(BuildContext context) async {
    var msg = AppLocalizations.of(context)!.errorFencerNotFound;
    var error = AppLocalizations.of(context)!.errorLinkError;
    setState(() => isLinking = true);
    var response = await accountLink(Environment.instance.accountProvider.data.fencer, false);
    if (response == 'create') {
      final confirmed = await confirmation(msg);
      if (confirmed == true) {
        response = await accountLink(Environment.instance.accountProvider.data.fencer, true);
      }
    }
    if (response == "error") {
      alert(error);
    } else {
      // reload the data to get the proper information now
      Environment.instance.accountProvider.loadItems();
    }
    Environment.debug("setting state to not isLinking and not canEdit");
    setState(() {
      isLinking = false;
      canEdit = false;
    });
  }

  void _storeSurname() {
    widget.data.fencer.lastName = surnameController.text.toUpperCase();
    Environment.instance.accountProvider.setData(widget.data);
  }

  void _storeDatePicker() {
    var date = DateTime.tryParse(datePickerController.text);
    if (date != null) {
      widget.data.fencer.dateOfBirth = date;
    }
    Environment.instance.accountProvider.setData(widget.data);
  }

  void _storeGivenName() {
    widget.data.fencer.firstName = givenNameController.text;
    Environment.instance.accountProvider.setData(widget.data);
  }

  void _showDatePicker(BuildContext context) async {
    setState(() => isDatePicking = true);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    Environment.debug("datepicker says $pickedDate");
    if (pickedDate != null) {
      widget.data.fencer.dateOfBirth = pickedDate;
      datePickerController.text = _formattedDate(pickedDate);
    }
    Environment.instance.accountProvider.setData(widget.data);
    setState(() => isDatePicking = false);
  }

  void _onSelectGender(BuildContext context, DropdownOption option) {
    widget.data.fencer.gender = option.value;
    Environment.instance.accountProvider.setData(widget.data);
  }

  void _onSelectCountry(BuildContext context, DropdownOption option) {
    widget.data.fencer.country = option.value;
    Environment.instance.accountProvider.setData(widget.data);
  }

  Future _allowChange(BuildContext context) async {
    if (await confirmation(AppLocalizations.of(context)!.descrReplaceFencer) == true) {
      setState(() => canEdit = true);
    }
  }

  bool _displayLink() => canEdit == true;

  DateTime _initialDate() {
    if (widget.data.fencer.dateOfBirth.isBefore(DateTime.now().subtract(const Duration(days: 120 * 365)))) {
      return DateTime.now().subtract(const Duration(days: 50 * 365));
    }
    return widget.data.fencer.dateOfBirth;
  }

  String _formattedDate(DateTime dt) {
    return DateFormat(DateFormat.YEAR_MONTH_DAY).format(dt);
  }
}
