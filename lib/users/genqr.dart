import 'package:flutter/material.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String _qrData = ''; // Store the QR code data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _qrData.isNotEmpty
                ? Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?data=$_qrData&size=200x200',
                    width: 200,
                    height: 200,
                  )
                : Text('No QR Code generated yet.'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _generateQRCode,
              child: Text('Generate QR Code'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateQRCode() async {
    // Get the current date and time
    DateTime now = DateTime.now();
    String formattedDateTime = now.toLocal().toString();

    setState(() {
      _qrData = formattedDateTime;
    });
  }
}
