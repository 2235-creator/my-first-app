import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/pages/trip.dart';
import '../model/request/response/trip_get_response.dart';
import 'package:my_first_app/pages/profile.dart';

class ShowTripPage extends StatefulWidget {
  final int cid;
  const ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];
  List<TripGetResponse> tripGetall = [];

  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else {
            return buildTripList();
          }
        },
      ),
    );
  }

  Future<void> getTrips() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('http://192.168.21.174:3000/trips'));
    tripGetResponses = tripGetResponseFromJson(res.body);
    tripGetall = tripGetResponseFromJson(res.body);

    log("โหลดทริปทั้งหมด: ${tripGetResponses.length}");
  }

  void filterTrips(String zone) {
    List<TripGetResponse> filtered =
        tripGetall.where((trip) => trip.destinationZone == zone).toList();
    setState(() {
      tripGetResponses = filtered;
    });
  }

  Widget buildTripList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('ปลายทาง', style: TextStyle(fontSize: 18)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      tripGetResponses = List.from(tripGetall);
                    });
                  },
                  child: const Text('ทั้งหมด'),
                ),
              ),
              FilledButton(
                onPressed: () => filterTrips('เอเชีย'),
                child: const Text('เอเชีย'),
              ),
              FilledButton(
                onPressed: () => filterTrips('ยุโรป'),
                child: const Text('ยุโรป'),
              ),
              FilledButton(
                onPressed: () => filterTrips('อาเซียน'),
                child: const Text('อาเซียน'),
              ),
              FilledButton(
                onPressed: () => filterTrips('ประเทศไทย'),
                child: const Text('ประเทศไทย'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tripGetResponses.length,
            itemBuilder: (context, index) {
              final trip = tripGetResponses[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.name, style: TextStyle(fontSize: 20)),
                        Row(
                          children: [
                            Image.network(
                              trip.coverimage,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ประเทศ ${trip.country}'),
                                  Text('ระยะเวลา ${trip.duration} วัน'),
                                  Text('ราคา ${trip.price.toString()} บาท'),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TripPage(idx: trip.idx),
                                        ),
                                      );
                                    },
                                    child: const Text('รายละเอียดเพิ่มเติม'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
