import 'dart:convert';
import 'dart:io';
import 'package:docutain_sdk/docutain_sdk.dart';
import 'package:docutain_sdk/docutain_sdk_document_datareader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class DataResultPage extends StatefulWidget {
  String filePath = "";
  DataResultPage(this.filePath, {super.key});

  @override
  DataResultPageState createState() => DataResultPageState();
}

class DataResultPageState extends State<DataResultPage> {
  late String jsonResult;
  bool isLoading = true;

  TextEditingController name1Controller = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  TextEditingController name3Controller = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController bicController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController invoiceIdController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController paymentStateController = TextEditingController();

  @override
  void dispose() {
    name1Controller.dispose();
    name2Controller.dispose();
    name3Controller.dispose();
    zipCodeController.dispose();
    cityController.dispose();
    streetController.dispose();
    phoneController.dispose();
    customerIdController.dispose();
    ibanController.dispose();
    bicController.dispose();
    dateController.dispose();
    amountController.dispose();
    invoiceIdController.dispose();
    referenceController.dispose();
    paymentStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<EntryField> entryFields = [
      EntryField(AppLocalizations.of(context)!.name1Hint, 'Name1Entry',
          name1Controller),
      EntryField(AppLocalizations.of(context)!.name2Hint, 'Name2Entry',
          name2Controller),
      EntryField(AppLocalizations.of(context)!.name3Hint, 'Name3Entry',
          name3Controller),
      EntryField(AppLocalizations.of(context)!.zipcodeHint, 'ZipCodeEntry',
          zipCodeController),
      EntryField(
          AppLocalizations.of(context)!.cityHint, 'CityEntry', cityController),
      EntryField(AppLocalizations.of(context)!.streetHint, 'StreetEntry',
          streetController),
      EntryField(AppLocalizations.of(context)!.phoneHint, 'PhoneEntry',
          phoneController),
      EntryField(AppLocalizations.of(context)!.customerIdHint,
          'CustomerIdEntry', customerIdController),
      EntryField(
          AppLocalizations.of(context)!.ibanHint, 'IbanEntry', ibanController),
      EntryField(
          AppLocalizations.of(context)!.bicHint, 'BicEntry', bicController),
      EntryField(
          AppLocalizations.of(context)!.dateHint, 'DateEntry', dateController),
      EntryField(AppLocalizations.of(context)!.amountHint, 'AmountEntry',
          amountController),
      EntryField(AppLocalizations.of(context)!.invoiceIdHint, 'InvoiceIdEntry',
          invoiceIdController),
      EntryField(AppLocalizations.of(context)!.referenceHint, 'ReferenceEntry',
          referenceController),
      EntryField(AppLocalizations.of(context)!.paymentStateHint,
          'PaymentStateEntry', paymentStateController),
    ];

    List<Widget> visibleEntryFields = entryFields
        .map((entryField) {
          return Visibility(
            visible: entryField.controller.text.isNotEmpty &&
                entryField.controller.text != "null",
            child: entryField,
          );
        })
        .toList()
        .cast<Widget>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Result Page'),
        leading: Semantics(
            identifier: "back",
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: visibleEntryFields +
                [
                  const SizedBox(height: 20),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //analyze the document and load the detected data
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

      //analyze the currently loaded document and get the detected data
      String json = await DocutainSdkDocumentDataReader.analyze();
      if (json.isEmpty) {
        // No data detected
        setState(() {
          name1Controller.text = "No data detected";
          isLoading = false;
        });
        return;
      }

      setState(() {
        jsonResult = json;
        isLoading = false;
      });

      fillEntries(json);
    } catch (ex) {
      // Handle the exception
    }
  }

  void fillEntries(String json) {
    //detected data is returned as JSON, so serializing the data in order to extract the key value pairs
    //see [https://docs.docutain.com/docs/Flutter/dataExtraction] for more information
    try {
      Map<String, dynamic> result = jsonDecode(json);
      //load the text into the textfields if value is detected
      dateController.text = result['Date'].toString();
      amountController.text = result['Amount'].toString();
      invoiceIdController.text = result['InvoiceId'].toString();
      referenceController.text = result['Reference'].toString();
      paymentStateController.text = result['PaymentState'].toString();
      Map<String, dynamic> address = result['Address'];
      name1Controller.text = address['Name1'].toString();
      name2Controller.text = address['Name2'].toString();
      name3Controller.text = address['Name3'].toString();
      zipCodeController.text = address['Zipcode'].toString();
      cityController.text = address['City'].toString();
      streetController.text = address['Street'].toString();
      phoneController.text = address['Phone'].toString();
      customerIdController.text = address['CustomerId'].toString();
      var bank = address['Bank'];
      //TODO: handle multiple bank accounts
      if (bank.length > 0) {
        RegExp ibanSplitter = RegExp(".{4}");
        ibanController.text =
            bank[0]['IBAN'].toString().replaceAllMapped(ibanSplitter, (match) {
          return '${match.group(0)} ';
        });
        bicController.text = bank[0]['BIC'].toString();
      }
    } catch (_) {}

    setState(() {
      isLoading = false;
    });
  }
}

class EntryField extends StatelessWidget {
  final String placeholder;
  final String entryName;
  final TextEditingController controller;

  const EntryField(this.placeholder, this.entryName, this.controller,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Semantics(
          identifier: entryName.replaceAll("Entry", ""),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: placeholder,
            ),
            controller: controller,
            readOnly: true,
            key: Key(entryName),
          )),
    );
  }
}
