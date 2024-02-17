import 'dart:typed_data';  // Add this import

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';  // Add this import
import 'package:pdf/widgets.dart' as pdfLib;  // Add this import

class CertificatePage extends StatelessWidget {
  final String recipientName;
  final String eventName;

  CertificatePage({required this.recipientName, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate'),
      ),
      body: Center(
        child: ElevatedButton(  // Change RaisedButton to ElevatedButton
          onPressed: () {
            generatePDF(context);
          },
          child: Text('Generate Certificate'),
        ),
      ),
    );
  }

  void generatePDF(BuildContext context) {
    final pdf = pdfLib.Document();

    pdf.addPage(
      pdfLib.Page(
        build: (pdfLib.Context context) {
          return pdfLib.Center(
            child: pdfLib.Column(
              mainAxisAlignment: pdfLib.MainAxisAlignment.center,
              crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
              children: <pdfLib.Widget>[
                pdfLib.Text(
                  'Certificate of Participation',
                  style: pdfLib.TextStyle(
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                pdfLib.SizedBox(height: 20),
                pdfLib.Text(
                  'This is to certify that',
                  style: pdfLib.TextStyle(fontSize: 16),
                ),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text(
                  recipientName,
                  style: pdfLib.TextStyle(
                    fontSize: 18,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text(
                  'has successfully participated in',
                  style: pdfLib.TextStyle(fontSize: 16),
                ),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text(
                  eventName,
                  style: pdfLib.TextStyle(
                    fontSize: 18,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                pdfLib.SizedBox(height: 50),
                pdfLib.Text(
                  'Date: ${DateTime.now().toIso8601String()}',
                  style: pdfLib.TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );

    savePDF(context, pdf);
  }

  void savePDF(BuildContext context, pdfLib.Document pdf) async {
    final bytes = await pdf.save();
    final blob = pdfLib.Document();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          bytes: Uint8List.fromList(bytes),  // Wrap bytes with Uint8List
        ),
      ),
    );
  }
}

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List bytes;  // Change List<int> to Uint8List

  const PdfPreviewScreen({Key? key, required this.bytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Preview'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Save the PDF or share it here
          },
          child: Text('Save PDF'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CertificatePage(
      recipientName: 'John Doe',
      eventName: 'Event X',
    ),
  ));
}
