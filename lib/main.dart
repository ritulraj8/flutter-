import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FetchDataScreen(),
    );
  }
}

class FetchDataScreen extends StatelessWidget {
  const FetchDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keys'),
      backgroundColor: Colors.amber[300],),
      body: FutureBuilder(
        future: fetchData(),  // Using a future function with try-catch
        builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Loading state
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data: ${snapshot.error}'));  // Error handling
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));  // Empty collection case
          }

          // Display fetched data
          return ListView(
            children: snapshot.data!.map((document) {
              return ListTile(
                title: Text(document['Name'] ?? 'No Name'),  // Null safety check
                subtitle: Text('Roll No: ${document['RollNo']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('keys').get();
      return querySnapshot.docs;  // Return the fetched documents
    } catch (error) {
      throw Exception('Failed to fetch data: $error');  // Catch any errors
    }
  }
}


