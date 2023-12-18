import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String roomNo;
  final String phoneNumber;

  User({
    required this.name,
    required this.email,
    required this.roomNo,
    required this.phoneNumber,
  });
}

class Adduser extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Function to add a user
  void _addUser() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String roomNo = _roomNoController.text;
    final String phoneNumber = _phoneNumberController.text;

    final user = User(
      name: name,
      email: email,
      roomNo: roomNo,
      phoneNumber: phoneNumber,
    );

    try {
      final firestore = FirebaseFirestore.instance;
      final collection =
          firestore.collection('users'); // Replace with your collection name

      await collection.add({
        'name': user.name,
        'email': user.email,
        'roomNo': user.roomNo,
        'phoneNumber': user.phoneNumber,
      });

      setState(() {
        // Clear the input fields
        _nameController.clear();
        _emailController.clear();
        _roomNoController.clear();
        _phoneNumberController.clear();
      });
    } catch (error) {
      print('Error adding user to Firestore: $error');
      // Handle the error, e.g., show an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add User:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _roomNoController,
              decoration: InputDecoration(labelText: 'Room No.'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: _addUser,
                child: Text('Add User'),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Users:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No users available.'),
                    );
                  }

                  // Display the list of users from Firestore
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['email']),
                        trailing: Text(data['roomNo']),
                        // Add any additional fields you want to display
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
