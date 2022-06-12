import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:consuming_api/views/Login/login_view.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isHide = true;
  bool _checked = false;
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
  Future<void> _register() async {
    if (passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      var username = base64.encode(utf8.encode(usernameController.text));
      var password = base64.encode(utf8.encode(passwordController.text));
      var email = base64.encode(utf8.encode(emailController.text));

      final response =
          await http.post(Uri.parse("http://172.20.10.5:8000/register"),
              headers: headersList,
              body: jsonEncode({
                'username': username.toString(),
                'email': email.toString(),
                'password': password.toString()
              }));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.redAccent[200],
            elevation: 1,
            content: Text(
              'Cuenta creada con éxito ${response.body}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )));
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => const Login()));
        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => const Login()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.redAccent[200],
            elevation: 1,
            content: Text(
              response.body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.redAccent[200],
          elevation: 1,
          content: const Text(
            'Campos Vacios',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        toolbarHeight: 60,
        title: const Text('Regístrate'),
      ),
      body: SafeArea(
        child: Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(top: 30, left: 25, right: 25),
            width: double.infinity,
            // color: ColorsView.bgEnabled,
            child: Column(
              textDirection: TextDirection.ltr,
              children: [
                const Text(
                  'Crea una cuenta para empezar a usar la app',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Hack',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 117, 117, 117)),
                ),
                const SizedBox(
                  height: 40,
                ),
                containerText(name: 'Nombre de usuario'),
                _textField(field: 'Username'),
                const SizedBox(
                  height: 25,
                ),
                containerText(name: 'Correo Electrónico'),
                _textFieldEmail(field: 'Email Address'),
                const SizedBox(
                  height: 25,
                ),
                containerText(name: 'Contraseña'),
                _textFieldPassword(field: 'Password'),
                Container(
                  margin: const EdgeInsets.only(
                      top: 15, left: 15, right: 15, bottom: 20),
                  height: 30,
                  child: const Text(
                    'La contraseña debe tener caracteres, números y simbolos con un mínimo de 6 caracteres.',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Hack',
                        color: Color.fromARGB(239, 189, 189, 189)),
                  ),
                ),
                // containerCheckbox(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 130,
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 340,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () {
                  _register();
                },
                child: const Text(
                  'Crear cuenta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: const Text(
                      '¿Ya tienes una cuenta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  InkWell(
                    child: const Text('Iniciar sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(252, 20, 96, 1))),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()))
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _textStyle({required bool bold, required bool link}) {
    return TextStyle(
        fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
        color: link ? Colors.redAccent : Colors.black,
        fontSize: 15,
        fontFamily: 'Hack');
  }

  Container containerText({required String name}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        name,
        style: _textStyle(bold: true, link: false),
      ),
    );
  }

  SizedBox containerCheckbox() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _checked = !_checked;
                });
              },
              child: _checked
                  ? const Icon(
                      Icons.radio_button_checked,
                      color: Colors.blue,
                      size: 20,
                    )
                  : const Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey,
                      size: 20,
                    ),
            ),
          ),
          Expanded(
            flex: 5,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Al registrarme, acepto los ',
                    style: _textStyle(bold: false, link: false),
                  ),
                  TextSpan(
                    text: 'términos y condiciones',
                    style: _textStyle(bold: false, link: true),
                    // recognizer: TapGestureRecognizer()
                    //   ..onTap = () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const Home(),
                    //         ),
                    //       ),
                  ),
                  TextSpan(
                    text: ' y la',
                    style: _textStyle(bold: false, link: false),
                  ),
                  TextSpan(
                    text: ' política de privacidad.',
                    style: _textStyle(bold: false, link: true),
                    // recognizer: TapGestureRecognizer()
                    //   ..onTap = () {
                    //     // Long Pressed.
                    //   },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextField _textField({required String field}) {
    return TextField(
      style: _textStyle(bold: false, link: false),
      controller: usernameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        hintText: field,
      ),
    );
  }

  TextField _textFieldEmail({required String field}) {
    return TextField(
      style: _textStyle(bold: false, link: false),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        hintText: field,
      ),
    );
  }

  TextField _textFieldPassword({required String field}) {
    return TextField(
      obscureText: _isHide,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        suffixIcon: IconButton(
          icon: Icon(_isHide ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(
              () {
                _isHide = !_isHide;
              },
            );
          },
        ),
      ),
    );
  }
}
