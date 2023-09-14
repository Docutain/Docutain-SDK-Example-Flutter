import 'dart:io';
import 'dart:ui';
import 'package:docutain_sdk/docutain_sdk_document.dart';
import 'package:docutain_sdk/docutain_sdk_document_datareader.dart';
import 'package:docutain_sdk/docutain_sdk_logger.dart';
import 'package:docutain_sdk/docutain_sdk_ui.dart';
import 'package:docutain_sdk_example_flutter/textocrpage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dataresultpage.dart';
import 'theme_model.dart';
import 'package:docutain_sdk/docutain_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

String licenseKey =
    "YOUR_LICENSE_KEY_HERE";

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyAppState extends State<MyApp> {
  ThemeModel themeModel = ThemeModel();

  @override
  Widget build(BuildContext context) {
    initDarkMode();
    return ChangeNotifierProvider(
      create: (context) => themeModel,
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            title: 'Docutain SDK Example',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: themeModel.lightModeTheme,
            darkTheme: themeModel.darkModeTheme,
            themeMode: themeModel.currentThemeMode,
            home: MyListView(
              ctx: context,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  //the Docutain SDK needs to be initialized prior to using any functionality of it
  //a valid license key is required, visit [mailto:sdk@Docutain.com] to get a trial license)
  Future<void> initSDK() async {
    bool isDocutainPluginInitialized = await DocutainSdk.initSDK(licenseKey);
    if (!isDocutainPluginInitialized) {
      //init of Docutain SDK failed, get the last error message
      debugPrint(
          'Initialization of the Docutain SDK failed: ${await DocutainSdk.getLastError()}');
      //your logic to deactivate access to SDK functionality
      if (licenseKey == "YOUR_LICENSE_KEY_HERE") {
          showLicenseEmptyDialog();   
        return;
      }
    }
    //If you want to use text detection (OCR) and/or data extraction features, you need to set the AnalyzeConfiguration
    //in order to start all the necessary processes
    var analyzeConfig = AnalyzeConfiguration();
    analyzeConfig.readBIC = true;
    analyzeConfig.readPaymentState = true;
    if (!await DocutainSdkDocumentDataReader.setAnalyzeConfiguration(
        analyzeConfig)) {
      debugPrint(
          'Setting AnalyzeConfiguration failed: ${await DocutainSdk.getLastError()}');
    }
    //Depending on your needs, you can set the Logger's level
    DocutainSdkLogger.setLogLevel(Level.verbose);
  }

  void initDarkMode() {
    PlatformDispatcher platformDispatcher = View.of(context).platformDispatcher;

    Brightness brightness = platformDispatcher.platformBrightness;
    themeModel.setThemeMode(brightness == Brightness.dark);

    // This callback is called every time the brightness changes.
    platformDispatcher.onPlatformBrightnessChanged = () {
      Brightness brightness = platformDispatcher.platformBrightness;
      themeModel.setThemeMode(brightness == Brightness.dark);
    };
  }

  Future<void> showLicenseEmptyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("License needed"),
          content: const SingleChildScrollView(
            child: Text("You need a trial license in order to run this example. You can generate a trial license key on our website for free.")
            ),          
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Get trial license"),
              onPressed: () async {
                await launchUrl(Uri.parse(
                    'https://sdk.docutain.com/TrialLicense?Source=3932680'));
              },
            ),
          ],
        );
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

// ignore: must_be_immutable
class MyListView extends StatelessWidget {
  List<Map<String, String>> items = List.empty();

  MyListView({super.key, required this.ctx});

  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    fillListView(appLocalizations);

    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    final iconEnding = themeModel.getIconName();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Docutain SDK Example'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onItemTap(context, index),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                child: ListTile(
                  leading: Image.asset(
                    '${items[index]['icon']!}' '$iconEnding',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(items[index]['title']!),
                  subtitle: Text(items[index]['description']!),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void fillListView(AppLocalizations appLocalizations) {
    items = [
      {
        'title': appLocalizations.documentScanner,
        'description': appLocalizations.docScannerDesc,
        'icon': 'assets/icons/document_scanner',
      },
      {
        'title': appLocalizations.dataExtraction,
        'description': appLocalizations.dataExtractDesc,
        'icon': 'assets/icons/quick_reference',
      },
      {
        'title': appLocalizations.textRecognition,
        'description': appLocalizations.textRecognitionDesc,
        'icon': 'assets/icons/insert_text',
      },
      {
        'title': appLocalizations.generatePdf,
        'description': appLocalizations.generatePdfDesc,
        'icon': 'assets/icons/picture_as_pdf',
      },
    ];
  }

  Future<String> startScan() async {
    //define a DocumentScannerConfiguration to alter the scan process and define a custom theme to match your branding
    var scanConfig = DocumentScannerConfiguration();
    scanConfig.allowCaptureModeSetting = true; //defaults to false
    scanConfig.pageEditConfig.allowPageFilter = true; //defaults to true
    scanConfig.pageEditConfig.allowPageRotation = true; //defaults to true
    //for all currently supported options see [https://docs.docutain.com/docs/Flutter/docScan]
    //for theming possibilities see [https://docs.docutain.com/docs/Flutter/theming]

    //start the document scanner
    var result = await DocutainSdkUi.scanDocument(scanConfig);

    return result.toString();
  }

  void _onItemTap(BuildContext context, int index) {
    debugPrint('Item tapped: ${items[index]['title']}');

    try {
      switch (index) {
        case 0:
          startScan();
          break;
        case 1:
          startDataExtraction(context);
          break;
        case 2:
          startTextOCR(context);
          break;
        case 3:
          startGeneratePDF(context);
          break;
      }
    } catch (_) {}
  }

  Future<String> getProcessInput(BuildContext context) async {
    int selectedOption = 0;
    var localizations = AppLocalizations.of(context)!;
    String header = localizations.titleImportOption;
    String filePath = "";
    Future<String> tmp = Future.value(false.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(header),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(localizations.inputOptionScan),
                onTap: () async {
                  selectedOption = 1;
                  Navigator.pop(context);
                  tmp = startScan();
                },
              ),
              ListTile(
                title: Text(localizations.inputOptionPdf),
                onTap: () async {
                  selectedOption = 2;
                  Navigator.pop(context);
                  tmp = openPDFPicker(context);
                },
              ),
              ListTile(
                title: Text(localizations.inputOptionImage),
                onTap: () async {
                  selectedOption = 3;
                  Navigator.pop(context);
                  tmp = openImagePicker(context);
                },
              ),
            ],
          ),
        );
      },
    );

    // Do something with the selected option
    debugPrint('Selected option: $selectedOption');

    filePath = await tmp;

    return filePath;
  }

  Future<String> openPDFPicker(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      final filePath = result.files.single.path;
      // Do something with the selected file path
      debugPrint('Selected file path: $filePath');
      return filePath!;
    } else {
      // User canceled the picker
      debugPrint('No file selected');
      return false.toString();
    }
  }

  Future<String> openImagePicker(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      final filePath = result.files.single.path;
      // Do something with the selected file path
      debugPrint('Selected file path: $filePath');
      return filePath!;
    } else {
      // User canceled the picker
      debugPrint('No file selected');
      return false.toString();
    }
  }

  void startDataExtraction(BuildContext context) async {
    String filePath = await getProcessInput(context);

    if (filePath != false.toString()) {
      if (context.mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DataResultPage(filePath)));
      }
    }
  }

  void startTextOCR(BuildContext context) async {
    String filePath = await getProcessInput(context);

    if (filePath != false.toString()) {
      if (context.mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TextOCRPage(filePath)));
      }
    }
  }

  bool isValidFilePath(String path) {
    try {
      File file = File(path);
      return file.existsSync();
    } catch (e) {
      return false; // Creating the File object failed, so it's not a valid file path
    }
  }

  void startGeneratePDF(BuildContext context) async {
    String filePath = await getProcessInput(
      context,
    );

     if (filePath == false.toString()){
        //canceled file picker
        return;
     }

    if (isValidFilePath(filePath)) {
      //the user opened a file instead of scanning a document
      //so we need to load it into the SDK first
      if (!await DocutainSdkDocumentDataReader.loadFile(filePath)) {
        // An error occurred, handle the error
        debugPrint(
            'DocumentDataReader.loadFile failed, last error: ${DocutainSdk.getLastError()}');
        return;
      }
    }

    //define the output file for the PDF
    Directory dir = await getTemporaryDirectory();
    String fileName = "DocutainTempPDF";

    //generate the PDF from the currently loaded document
    //the generated PDF also contains the detected text, making the PDF searchable
    //see [https://docs.docutain.com/docs/Flutter/pdfCreation] for more details
    File? file = await DocutainSdkDocument.writePDF(dir.path, fileName);

    if (file != null) {
      //display the PDF by using the system's default viewer for demonstration purposes
      OpenFilex.open(file.path);
    }
  }
}
