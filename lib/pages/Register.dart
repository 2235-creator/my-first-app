import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/customers_register_post_req.dart';
import 'package:my_first_app/pages/login.dart';

import '../model/request/response/custopmer_register_post_res.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController checkpasswordCtl = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ชื่อ - นามสกุล', style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: fullnameCtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: phoneCtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('อีเมล์', style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: emailCtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('รหัสผ่าน', style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: passwordCtl,
                      obscureText: true, // 👈 ซ่อนข้อความ
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ยืนยันรหัสผ่าน', style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: checkpasswordCtl,
                      obscureText: true, // 👈 ซ่อนข้อความ
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        register();
                      },
                      child: Text('สมัครสมาชิก'),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'หากมีบัญชีอยู่แล้ว',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('เข้าสูระบบ', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void back() {
    Navigator.pop(context);
  }

  void register() {
    CustomerRegisterPostResquest req = CustomerRegisterPostResquest(
      fullname: fullnameCtl.text,
      phone: phoneCtl.text,
      email: emailCtl.text,
      image: "",
      password: passwordCtl.text,
    );

    if (passwordCtl.text != checkpasswordCtl.text) {
      log('wrong Password');
      return;
    }

    http
        .post(
          Uri.parse("http://192.168.21.174:3000/customers/"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostResquestToJson(req),
        )
        .then((value) {
          log(value.body);
          CustomerRegisterPostRespone customerRegisterPostRespone =
              customerRegisterPostResponeFromJson(value.body);
          log(customerRegisterPostRespone.message);
          // log(customerRegisterPostRespone.id);
          // log(customerRegisterPostRespone.phone);
          // log(customerRegisterPostRespone.email);
          // log(customerRegisterPostRespone.password);
        })
        .catchError((error) {
          log(error);
        });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
