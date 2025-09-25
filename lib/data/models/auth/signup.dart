import 'package:flutter/material.dart';
import '../../db/db_helper.dart';
import 'login.dart';
import '../../../screens/widgets/bezierContainer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final db = DBHelper();

  void _signup() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء إدخال اسم المستخدم وكلمة المرور")),
      );
      return;
    }

    try {
      await db.insertUser(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إنشاء الحساب بنجاح")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      const   SnackBar(content: Text("اسم المستخدم موجود بالفعل")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          padding:const  EdgeInsets.symmetric(vertical: 20),
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
              Positioned(
                top: 40,
                left: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:const  Row(
                    children: <Widget>[
                       Icon(Icons.keyboard_arrow_left, color: Colors.black),
                       SizedBox(width: 4),
                       Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
          const SizedBox(height:150),
          _title(), const Text("A new ACCOUNT",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w900),),
                Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'new UserName',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'أدخل ';
                    final parsed = double.tryParse(v);
                    if (parsed == null) return '  Enter Strong password ';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
            GestureDetector(
              onTap: _signup,
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
                  "حفظ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
]
    )
        ]
    )
        ));
  }
}
Widget _title() {
  return RichText(
    textAlign: TextAlign.center,
    text: const TextSpan(
        text: 'C',
        style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10)
        ),
        children: [
          TextSpan(
            text: 're',
            style: TextStyle(color: Colors.black, fontSize: 48),
          ),
          TextSpan(
            text: 'at',
            style: TextStyle(color: Color(0xffe46b10), fontSize: 48),
          ),
          TextSpan(
            text: 'e',
            style: TextStyle(fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.blue),
          ),
        ]),
  );
}
