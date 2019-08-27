import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geldstroom/provider/auth.dart';
import 'package:geldstroom/utils/validate_input.dart';
import 'package:geldstroom/widgets/shared/button_gradient.dart';
import 'package:geldstroom/widgets/shared/quotes.dart';
import 'package:geldstroom/widgets/shared/snackbar_notification.dart';
import 'package:geldstroom/widgets/shared/text_input.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _scaffold = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordComfirmationController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _passwordComfirmationFocusNode = FocusNode();
  var _isLoading = false;
  String _errorEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordComfirmationController.dispose();
    _passwordFocusNode.dispose();
    _passwordComfirmationFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    try {
      if (_emailController.text.isEmpty &&
          _passwordController.text.isEmpty &&
          _passwordComfirmationController.text.isEmpty &&
          _isLoading) {
        return;
      }
      _resetError();
      _setLoading(true);
      final isValid = _form.currentState.validate();
      if (!isValid) {
        _setLoading(false);
        return;
      }
      await Provider.of<Auth>(context)
          .register(_emailController.text, _passwordController.text);
      _showSnackbar('Successfully register, now you can sign in.',
          SnackBarNotificationType.SUCCESS);
      _clearFormValue();
      _setLoading(false);
    } catch (error) {
      if (error.toString() == 'Email is already exist') {
        _setEmailError(error.toString());
      }
      _showSnackbar('$error', SnackBarNotificationType.ERROR);
      _setLoading(false);
    }
  }

  void _resetError() {
    _setEmailError(null);
  }

  void _setEmailError(String value) {
    setState(() {
      _errorEmail = value;
    });
  }

  void _clearFormValue() {
    _emailController.text = '';
    _passwordController.text = '';
    _passwordComfirmationController.text = '';
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quote =
        'It is not enough to do your best: you must know what to do, and then do your best. - W. Edwards Deming';
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;
    final horizontalPadding = EdgeInsets.symmetric(horizontal: 8);
    return Scaffold(
      key: _scaffold,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      Quotes(quote: quote),
                      SizedBox(height: 50),
                      TextInput(
                        labelText: 'Email Address',
                        textEditingController: _emailController,
                        errorText: _errorEmail,
                        icon: Icon(Icons.mail_outline),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: validateEmail,
                        onFieldSubmitted: _passwordFocusNode.requestFocus,
                      ),
                      TextInput(
                        labelText: 'Password',
                        focusNode: _passwordFocusNode,
                        textEditingController: _passwordController,
                        obscureText: true,
                        icon: Icon(Icons.lock_outline),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        validator: validatePassword,
                        onFieldSubmitted:
                            _passwordComfirmationFocusNode.requestFocus,
                      ),
                      TextInput(
                        labelText: 'Password Comfirmation',
                        focusNode: _passwordComfirmationFocusNode,
                        textEditingController: _passwordComfirmationController,
                        obscureText: true,
                        icon: Icon(Icons.lock_outline),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        validator: (value) => validatePasswordComfirmation(
                            value, _passwordController.text),
                        onFieldSubmitted: _onSubmit,
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  child: Text('Already have an account? Sign in.'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(
                  padding: horizontalPadding,
                  margin: EdgeInsets.only(bottom: 15),
                  child: ButtonGradient(
                    child: _buttonChild(),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        accentColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onPressed: () {
                      _onSubmit();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonChild() {
    return _isLoading
        ? SpinKitDualRing(color: Colors.white, size: 32)
        : Text(
            'SIGN UP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          );
  }

  void _showSnackbar(String text, SnackBarNotificationType type) {
    _scaffold.currentState.removeCurrentSnackBar();
    _scaffold.currentState.showSnackBar(
      snackBarNotification(
        text: text,
        type: type,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
