import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_first_app/model/request/response/customers_idx_get_res.dart';
import '../config/config.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final int idx;
  const ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> loadData;
  late CustomerIdxGetResponse customerIdxGetResponse;
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    log('Customer id: ${widget.idx}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'delete') {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                children: [
                  const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'ยืนยันการยกเลิกสมาชิก?',
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('ปิด')),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      delete();
                      }, child: const Text('ยืนยัน'))
                  ],
                  ),
                ],
                ),
              );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // รูปภาพลูกค้า
                  if (customerIdxGetResponse.image.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Image.network(
                        customerIdxGetResponse.image,
                        width: 150,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 150,
                          );
                        },
                      ),
                    ),
                  // ข้อมูลลูกค้า
                  _buildTextField('ชื่อ-นามสกุล', nameCtl),
                  _buildTextField('เบอร์โทรศัพท์', phoneCtl),
                  _buildTextField('อีเมล', emailCtl),
                  _buildTextField('รูปภาพ', imageCtl),
                  const SizedBox(height: 16),
                  Center(
                    child: FilledButton(
                      onPressed: update,
                      child: const Text('บันทึกข้อมูล'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    try {
      var res =
          await http.get(Uri.parse('http://192.168.21.174:3000/customers/${widget.idx}'));
      log(res.body);

      final data = json.decode(res.body) as Map<String, dynamic>;
      customerIdxGetResponse = CustomerIdxGetResponse.fromJson(data);

      nameCtl.text = customerIdxGetResponse.fullname;
      phoneCtl.text = customerIdxGetResponse.phone;
      emailCtl.text = customerIdxGetResponse.email;
      imageCtl.text = customerIdxGetResponse.image;
    } catch (e) {
      log('Error loading data: $e');
      rethrow;
    }
  }

  Widget _buildTextField(String label, TextEditingController ctl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(controller: ctl),
        ],
      ),
    );
  }

  void update() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var jsonData = {
      "fullname": nameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text
    };

    try {
      var res = await http.put(
        Uri.parse('http://192.168.21.174:3000/customers/${widget.idx}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(jsonData),
      );
      log(res.body);
      var result = jsonDecode(res.body);
      log(result['message'] ?? 'No message');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            )
          ],
        ),
      );
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ: ${err.toString()}'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            )
          ],
        ),
      );
    }
  }
  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    
    var res = await http.delete(Uri.parse('http://192.168.21.174:3000/customers/${widget.idx}'));
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text('ปิด'))
          ],
        ),
      ).then((s) {
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      });
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }    
}
