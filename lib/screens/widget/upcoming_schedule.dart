import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpcomingSchedule extends StatelessWidget {
  const UpcomingSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Meetings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AppointmentCard(),
            ),
          ),
        ],
      ),
    );
  }
}
class AppointmentData {
  final String serviceType;
  final DateTime serviceDate;
  final String problemDescription;
  final String address;
  final String status; // You can add a status field if applicable

  AppointmentData({
    required this.serviceType,
    required this.serviceDate,
    required this.problemDescription,
    required this.address,
    this.status = "Pending", // Default status if not available
  });

  // Factory method to create an instance from Firestore data
  factory AppointmentData.fromFirestore(Map<String, dynamic> data) {
    return AppointmentData(
      serviceType: data['serviceType'] ?? '',
      serviceDate: (data['serviceDate'] as Timestamp).toDate(),
      problemDescription: data['problemDescription'] ?? '',
      address: data['address'] ?? '',
      status: data['status'] ?? 'Pending',
    );
  }

}

  class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<AppointmentData>> fetchServiceRequests() async {
      List<AppointmentData> serviceRequests = [];

      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('serviceRequests')
            .orderBy('timestamp', descending: true)
            .get();

        for (var doc in querySnapshot.docs) {
          // Convert each document into a ServiceRequest object
          serviceRequests.add(AppointmentData.fromFirestore(doc.data()));
        }
      } catch (e) {
        print("Error fetching service requests: $e");
      }

      return serviceRequests;
    }

    DateFormatter(String DateFormat){
      DateTime now= DateTime.parse(DateFormat);
      return "${now.day}/${now.month}/${now.year}";
    }

    return FutureBuilder<List<AppointmentData>>(
      future: fetchServiceRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("No data available"));
        }

        final appointment = snapshot.data!;
        return Column(
          children: List.generate(
            appointment.length,
             (index) => Column(
              children: [
                ListTile(
                  title: Text(
                    appointment[index].serviceType,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("Room: ${appointment[index].address}"),
                  trailing: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/member.jpg"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                    height: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          DateFormatter( appointment[index].serviceDate.toString()),
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time_filled, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                         "10:00 AM",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          appointment[index].status,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F6FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF7165D6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Reschedule",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
