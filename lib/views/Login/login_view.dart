import 'dart:convert';
import 'package:consuming_api/views/Home/home.dart';
import 'package:consuming_api/views/Register/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isHide = true;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> _sendPostToken(String token) async {
    final accessToken = 'Bearer ' +
        token.replaceAll(
            RegExp(r"[!$%^&*()+|~=`{}\[\]:;'<>?,\/"
                '"'
                "]"),
            '');
    final res = await http.get(Uri.parse('http://192.168.1.76:8000/home'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': accessToken,
        });
    if (res.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            jsonDecode(res.body).toString(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent[200],
          elevation: 1,
          content: const Text(
            'Invalid credentials',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Future<void> _login() async {
    if (passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      var password = base64.encode(utf8.encode(passwordController.text));
      final response = await http
          .post(Uri.parse("http://192.168.1.76:8000/auth/login"), body: {
        'username': usernameController.text,
        'password': password.toString(),
      });
      if (response.statusCode == 200) {
        await _sendPostToken(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.redAccent[200],
            elevation: 1,
            content: const Text(
              'Usuario o Contraseña inválidos',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.redAccent[200],
          elevation: 1,
          content: const Text(
            'Campos Vacios',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4f1581),
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text('Iniciar sesión'),
      ),
      body: SafeArea(
        child: Expanded(
          flex: 3,
          child: Container(
            margin:
                const EdgeInsets.only(top: 35, left: 25, right: 25, bottom: 50),
            width: double.infinity,
            child: Column(
              textDirection: TextDirection.ltr,
              children: [
                const Text(
                  'Inicia sesión con tu cuenta para continuar',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Hack',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 50,
                ),
                containerText(name: 'Nombre de usuario'),
                _textField(field: 'Username'),
                const SizedBox(
                  height: 30,
                ),
                containerText(name: 'Contraseña'),
                _textFieldPassword(field: 'Password'),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 10),
                  child: const InkWell(
                    child: Text(
                      '¿Has olvidado tu contraseña?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                  ),
                )
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
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () {
                  _login();
                },
                child: const Text(
                  'Ingresar',
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
                      '¿Todavía no tienes una cuenta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  InkWell(
                    child: const Text(
                      'Regístrate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(252, 20, 96, 1),
                      ),
                    ),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      )
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

  TextField _textField({required String field}) {
    return TextField(
      style: _textStyle(bold: false),
      controller: usernameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
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
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
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

  TextStyle _textStyle({required bool bold}) {
    return TextStyle(
      fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
      fontSize: 15,
      fontFamily: 'Hack',
    );
  }

  Container containerText({required String name}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        name,
        style: _textStyle(bold: true),
      ),
    );
  }
}
