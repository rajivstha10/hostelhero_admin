import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFeePage extends StatefulWidget {
  @override
  _AddFeePageState createState() => _AddFeePageState();
}

class _AddFeePageState extends State<AddFeePage> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<void> addFee(String studentId, double amount) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final collection =
          firestore.collection('fees'); // Replace with your collection name

      await collection.add({
        'studentId': studentId,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Fee added to Firestore successfully.');
    } catch (error) {
      print('Error adding fee to Firestore: $error');
      // Handle the error, e.g., show an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Fee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Student email:'),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(labelText: 'Enter Student email'),
            ),
            Text('Amount:'),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Amount'),
            ),
            ElevatedButton(
              onPressed: () {
                final studentId = _studentIdController.text;
                final amount = double.tryParse(_amountController.text) ?? 0.0;

                if (studentId.isNotEmpty && amount > 0) {
                  addFee(studentId, amount);
                } else {
                  // Handle invalid input, e.g., show an error message.
                }
              },
              child: Text('Add Fee'),
            ),
          ],
        ),
      ),
    );
  }
}
