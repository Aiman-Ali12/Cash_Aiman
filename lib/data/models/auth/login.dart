import 'package:aiman_cash/data/models/auth/signup.dart';
import 'package:flutter/material.dart';
import '../../../screens/home_screen.dart';
import '../../../screens/widgets/bezierContainer.dart';
import '../../db/db_helper.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ← أضف هذا
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final db = DBHelper();

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    bool success = await db.loginUser(username, password);
    if (success) {
      Navigator.pushReplacement(context,
       MaterialPageRoute(builder: (_) =>  HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
       const  SnackBar(content: Text("اسم المستخدم أو كلمة المرور غير صحيحة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
          Positioned(
          top: -height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child:const  BezierContainer(),
          ),
      Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height:150),
              _title(),
              const Text("TO LOGIN",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w900),),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 70),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.account_circle_outlined),
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (v) =>
                          v == null || v.trim().isEmpty ? 'أدخل username' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController, // يجب إضافة controller
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) =>
                          v == null || v.trim().isEmpty ? 'أدخل كلمة المرور' : null,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _login,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xfffbb448), Color(0xfff7892b)],
                              ),
                            ),
                            child: const Text(
                              "دخول",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "ليس لديك حساب؟ سجل الآن",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]
    )
    ));
  }
}
Widget _title() {
  return RichText(
    textAlign: TextAlign.center,
    text: const TextSpan(
        text: 'W',
        style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10)
        ),
        children: [
          TextSpan(
            text: 'el',
            style: TextStyle(color: Colors.black, fontSize: 48),
          ),
          TextSpan(
            text: 'co',
            style: TextStyle(color: Color(0xffe46b10), fontSize: 48),
          ),
          TextSpan(
            text: 'm',
            style: TextStyle(fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.blue),
          ),TextSpan(
            text: 'e',
            style: TextStyle(fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.blue),
          ),
        ]),
  );
}

    // );
  // }
// }
