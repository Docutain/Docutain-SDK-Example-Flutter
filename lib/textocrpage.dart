import 'dart:io';

import 'package:docutain_sdk/docutain_sdk.dart';
import 'package:docutain_sdk/docutain_sdk_document_datareader.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextOCRPage extends StatefulWidget {
  String filePath = "";
  TextOCRPage(this.filePath, {super.key});

  @override
  TextOCRPageState createState() => TextOCRPageState();
}

class TextOCRPageState extends State<TextOCRPage> {
  late String textResult = "";
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text OCR Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(textResult),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool isValidFilePath(String path) {
    try {
      File file = File(path);
      return file.existsSync();
    } catch (e) {
      return false; // Creating the File object failed, so it's not a valid file path
    }
  }

  void loadData() async {
    try {
      //If the user opened a file instead of scanning a document, we need to load it into the SDK first
      if (isValidFilePath(widget.filePath)) {
        if (!await DocutainSdkDocumentDataReader.loadFile(widget.filePath)) {
          // An error occurred, handle the error
          debugPrint(
              'DocumentDataReader.loadFile failed, last error: ${DocutainSdk.getLastError()}');
          return;
        }
      }

      //get the text of all currently loaded pages
      //if you want text of just one specific page, define the page number
      //see [https://docs.docutain.com/docs/Flutter/textDetection] for more details
      String text = await DocutainSdkDocumentDataReader.getText();
      if (text.isEmpty) {
        // No data detected
        setState(() {
          isLoading = false;
          textResult = "No text detected";
        });
        return;
      }

      fillEntries(text);
    } catch (ex) {
      // Handle the exception
    }
  }

  void fillEntries(String text) {
    setState(() {
      isLoading = false;
      textResult = text;
    });
  }
}

class TextField extends StatelessWidget {
  final String text;
  const TextField(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          child: Text(
            text,
            maxLines: null,
          ),
        ));
  }
}
