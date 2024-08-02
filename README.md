# Docutain SDK

## Docutain SDK example app for Flutter

This example app shows how to integrate the [Docutain SDK for Flutter](https://sdk.Docutain.com).


## What is Docutain SDK?

The Docutain SDK brings functionalities for automatic document scanning, text recognition (OCR), intelligent data extraction and PDF creation to your apps.

It works 100% offline which ensures maximum data safety.

It contains modules which are individually licensable.

For more details visit our website https://sdk.Docutain.com

Check out our blog articles on [How to create a Flutter Document Scanner](https://sdk.docutain.com/blogartikel/how-to-create-a-flutter-document-scanner) and [How to create a Flutter Plugin from scratch](https://sdk.docutain.com/blogartikel/how-to-create-a-flutter-plugin-from-scratch).

## Getting started

Clone the repo:

```
git clone https://github.com/Docutain/docutain-sdk-example-flutter
cd docutain-sdk-example-flutter
```

Install the project dependencies:

```
flutter pub get
```

**Run on Android**

Connect a device via USB and run the following to get the device ID: 

```
flutter devices
```

Run the app on the selected device:

```
flutter run -d <DEVICE_ID>
```

**Run on iOS**

Install dependencies:

```
cd ios
pod update
```

Open the `Runner.xcworkspace` file from the iOS folder with Xcode.

Set your provisioning and signing settings.

Build and run the app in Xcode.


## Documentation of the Docutain SDK

- [Developer Guide](https://docs.docutain.com/docs/Flutter/intro)


## License and Support

The Docutain SDK is a commercial product and requires a paid license for production use. In order to get a trial license, please visit our website via [https://sdk.docutain.com/TrialLicense](https://sdk.docutain.com/TrialLicense?Source=3932424) to generate a trial license key. 

If you need technical support of any kind, please contact us via [support.sdk@Docutain.com](mailto:support.sdk@Docutain.com).
