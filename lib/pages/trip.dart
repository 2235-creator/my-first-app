import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/response/trip_idx_get_res.dart';
import '../config/config.dart';

class TripPage extends StatefulWidget {
  final int idx;
  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late Future<List<TripIdxGetResponse>> tripFuture;

  @override
  void initState() {
    super.initState();
    tripFuture = fetchTrips();
  }

  Future<List<TripIdxGetResponse>> fetchTrips() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    final response = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(response.body);
    return tripIdxGetResponseFromJson(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip List')),
      body: FutureBuilder<List<TripIdxGetResponse>>(
        future: tripFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final trips = snapshot.data!;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(trip.coverimage, width: 80, fit: BoxFit.cover),
                  title: Text(trip.name),
                  subtitle: Text('${trip.country} • ${trip.duration} days • \$${trip.price}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
