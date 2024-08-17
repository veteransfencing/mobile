import 'package:email_validator/email_validator.dart';
import 'package:evf/api/account_check.dart';
import 'package:evf/api/account_verify.dart';
import 'package:evf/api/set_account.dart';
import 'package:evf/environment.dart';
import 'package:evf/models/account_data.dart';
import 'package:evf/styles.dart';
import 'package:evf/util/alert.dart';
import 'package:evf/util/confirmation.dart';
import 'package:evf/widgets/basic/dropdown.dart';
import 'package:evf/widgets/basic/fitted_text.dart';
import 'package:evf/widgets/basic/icon_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountEmail extends StatefulWidget {
  final AccountData data;
  const AccountEmail({super.key, required this.data});
  @override
  State<AccountEmail> createState() => _AccountEmailState();
}

class _AccountEmailState extends State<AccountEmail> {
  bool _sendResendClicked = false;
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final languages = [
      DropdownOption('en_GB', AppLocalizations.of(context)!.labelEnglish),
      DropdownOption('nl_NL', AppLocalizations.of(context)!.labelDutch),
    ];
    emailController.text = widget.data.email;
    return Form(
      key: _formKey,
      child: Column(children: [
        Text.rich(
          TextSpan(text: AppLocalizations.of(context)!.titleAccount, style: AppStyles.largeHeader),
          textAlign: TextAlign.center,
        ),
        FittedText(
          span: TextSpan(text: AppLocalizations.of(context)!.descrDevice, style: AppStyles.plainText),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(text: widget.data.id, style: AppStyles.italicText),
          textAlign: TextAlign.start,
        ),
        Text.rich(
          TextSpan(text: widget.data.device, style: AppStyles.italicText),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        FittedText(
          span: TextSpan(text: AppLocalizations.of(context)!.descrLanguage, style: AppStyles.plainText),
          textAlign: TextAlign.start,
        ),
        Row(
          children: [
            SizedBox(
                width: 100,
                child:
                    Text.rich(TextSpan(text: AppLocalizations.of(context)!.labelLanguage, style: AppStyles.boldText))),
            Dropdown(
              callback: (opt) => _onSelectLanguage(context, opt),
              options: languages,
              value: widget.data.language,
            )
          ],
        ),
        const SizedBox(height: 10),
        FittedText(
          span: TextSpan(text: AppLocalizations.of(context)!.descrEmail, style: AppStyles.plainText),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        Focus(
            onFocusChange: (hasFocus) => _storeEmail(),
            child: TextFormField(
              controller: emailController,
              readOnly: widget.data.isVerified,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.errorInvalidEmail;
                }
                if (!EmailValidator.validate(value)) {
                  return AppLocalizations.of(context)!.errorInvalidEmail;
                }
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.descrEmailInput,
              ),
            )),
        const SizedBox(height: 10),
        if (displaySent()) Text(AppLocalizations.of(context)!.descrWaitingForCode),
        if (displaySent()) const SizedBox(height: 10),
        if (displaySend())
          ElevatedButton(
            onPressed: () {
              _sendResendClicked = true;
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                _sendVerification(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.labelConfirm),
          ),
        if (displayResend())
          ElevatedButton(
            onPressed: () {
              _sendResendClicked = true;
              if (_formKey.currentState!.validate()) {
                _sendVerification(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.labelResend),
          ),
        if (displayChange())
          ElevatedButton(
            onPressed: () async {
              _sendResendClicked = true;
              if (await _confirmChange(context) == true) {
                _allowValueChange();
              }
            },
            child: Text(AppLocalizations.of(context)!.labelChange),
          ),
        if (displayCode()) const SizedBox(height: 10),
        if (displayCode())
          TextFormField(
            controller: codeController,
            validator: (value) {
              if (!_sendResendClicked) {
                if ((value == null || value.isEmpty)) {
                  return AppLocalizations.of(context)!.errorInvalidVerificationCode;
                } else if (value.length < 6) {
                  return AppLocalizations.of(context)!.errorInvalidVerificationCode;
                }
              }
              return null;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: AppLocalizations.of(context)!.descrVerificationCodeInput,
            ),
          ),
        if (displayCode()) const SizedBox(height: 10),
        if (displayCode())
          ElevatedButton(
            onPressed: () async {
              _sendResendClicked = false;
              if (_formKey.currentState!.validate()) {
                _setVerified();
              }
            },
            child: Text(AppLocalizations.of(context)!.labelVerify),
          ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: Text.rich(
            TextSpan(text: AppLocalizations.of(context)!.descrWebmaster, style: AppStyles.plainText),
            textAlign: TextAlign.start,
          )),
          const IconLink(icon: Icon(Icons.mail_outline), url: "mailto:webmaster@veteransfencing.eu"),
        ]),
      ]),
    );
  }

  // do we need to display the 'code was sent' message
  bool displaySent() => !widget.data.isVerified && _recentlyVerified();
  // display the Send button
  bool displaySend() => !widget.data.isVerified && _notVerified();
  // display the Resend button
  bool displayResend() => !widget.data.isVerified && !_notVerified() && !_recentlyVerified();
  // display the Change button
  bool displayChange() => widget.data.isVerified;
  // display the Code input field and verify button
  bool displayCode() => !widget.data.isVerified && !_notVerified();

  void _storeEmail() {
    widget.data.email = emailController.text;
    Environment.instance.accountProvider.setData(widget.data);
  }

  Future _sendVerification(BuildContext context) async {
    Environment.debug("sendVerification for ${emailController.text}");
    final txt = AppLocalizations.of(context)!.errorNotVerified;
    final txtMerged = AppLocalizations.of(context)!.errorUserMerged;
    widget.data.verificationSent = DateTime.now();
    Environment.instance.accountProvider.setData(widget.data);

    var response = await accountVerify(emailController.text);
    if (response == 'error') {
      widget.data.verificationSent = DateTime(2000, 1, 1);
      Environment.instance.accountProvider.setData(widget.data);
      await alert(txt);
    } else if (response == 'merge') {
      // reload status and account data to make sure we have our new
      // feed, followers and account information loaded
      Environment.instance.statusProvider.loadStatus();
      Environment.instance.accountProvider.loadItems();
      // display an informational message. In the meanwhile the
      // above calls run and reload the data
      await alert(txtMerged);
    }
  }

  void _allowValueChange() {
    widget.data.isVerified = false;
    Environment.instance.accountProvider.setData(widget.data);
  }

  Future _setVerified() async {
    Environment.debug("setVerified for ${codeController.text}");
    final txt = AppLocalizations.of(context)!.errorNotChecked;
    if (!await accountCheck(codeController.text)) {
      alert(txt);
    } else {
      widget.data.isVerified = true;
      widget.data.verificationSent = DateTime(2000, 1, 1);
      Environment.instance.accountProvider.setData(widget.data);
    }
  }

  bool _notVerified() {
    return DateTime(2000, 1, 2).isAfter(widget.data.verificationSent);
  }

  bool _recentlyVerified() {
    return DateTime.now().subtract(const Duration(seconds: 180)).isBefore(widget.data.verificationSent);
  }

  Future<bool?> _confirmChange(BuildContext context) async {
    return confirmation(AppLocalizations.of(context)!.descrReplaceEmail);
  }

  void _onSelectLanguage(BuildContext context, DropdownOption option) {
    widget.data.language = option.value;
    Environment.instance.accountProvider.setData(widget.data);
    Environment.debug("storing language setting ${widget.data}");
    setAccount(widget.data);
  }
}
