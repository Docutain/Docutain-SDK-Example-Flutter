import 'package:docutain_sdk_example_flutter/settings/settingsmultiviewsadapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settingssharedpreferences.dart';
import 'data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsSharedPreferences settingsSharedPreferences;
  SettingsMultiViewsAdapter? settingsAdapter;
  late List<SettingsMultiItems> settingsItems;
  late AppLocalizations localizations;
  final GlobalKey<SettingsMultiViewsAdapterState> adapterKey =
      GlobalKey<SettingsMultiViewsAdapterState>();

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        leading: Semantics(
            identifier: "back",
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: settingsAdapter ?? const SizedBox(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _resetSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: Text(
                  localizations.rest_settings,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initializePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    settingsSharedPreferences = SettingsSharedPreferences(prefs);
    if (settingsSharedPreferences.isEmpty()) {
      settingsSharedPreferences.defaultSettings();
    }
    settingsItems = _prepareData();
    setState(() {
      settingsAdapter = SettingsMultiViewsAdapter(
        key: adapterKey,
        items: settingsItems,
        settingsSharedPreferences: settingsSharedPreferences,
      );
    });
  }

  List<SettingsMultiItems> _prepareData() {
    final colorPrimaryItem =
        settingsSharedPreferences.getColorItem(ColorSetting.ColorPrimary);
    final colorSecondaryItem =
        settingsSharedPreferences.getColorItem(ColorSetting.ColorSecondary);
    final colorOnSecondaryItem =
        settingsSharedPreferences.getColorItem(ColorSetting.ColorOnSecondary);
    final colorScanButtonsLayoutBackground = settingsSharedPreferences
        .getColorItem(ColorSetting.ColorScanButtonsLayoutBackground);
    final colorScanButtonsForeground = settingsSharedPreferences
        .getColorItem(ColorSetting.ColorScanButtonsForeground);
    final colorScanPolygon =
        settingsSharedPreferences.getColorItem(ColorSetting.ColorScanPolygon);
    final colorBottomBarBackground = settingsSharedPreferences
        .getColorItem(ColorSetting.ColorBottomBarBackground);
    final colorBottomBarForeground = settingsSharedPreferences
        .getColorItem(ColorSetting.ColorBottomBarForeground);
    final colorTopBarBackground = settingsSharedPreferences
        .getColorItem(ColorSetting.ColorTopBarBackground);
    final colorTopBarForeground = settingsSharedPreferences
        .getColorItem(ColorSetting.ColorTopBarForeground);

    final allowCaptureModeSetting = settingsSharedPreferences
        .getScanItem(ScanSetting.AllowCaptureModeSetting)
        .checkValue;
    final autoCapture = settingsSharedPreferences
        .getScanItem(ScanSetting.AutoCapture)
        .checkValue;
    final autoCrop =
        settingsSharedPreferences.getScanItem(ScanSetting.AutoCrop).checkValue;
    final multiPage =
        settingsSharedPreferences.getScanItem(ScanSetting.MultiPage).checkValue;
    final preCaptureFocus = settingsSharedPreferences
        .getScanItem(ScanSetting.PreCaptureFocus)
        .checkValue;
    final defaultScanFilter = settingsSharedPreferences
        .getScanFilterItem(ScanSetting.DefaultScanFilter)
        .scanValue;

    final allowPageFilter = settingsSharedPreferences
        .getEditItem(EditSetting.AllowPageFilter)
        .editValue;
    final allowPageRotation = settingsSharedPreferences
        .getEditItem(EditSetting.AllowPageRotation)
        .editValue;
    final allowPageArrangement = settingsSharedPreferences
        .getEditItem(EditSetting.AllowPageArrangement)
        .editValue;
    final allowPageCropping = settingsSharedPreferences
        .getEditItem(EditSetting.AllowPageCropping)
        .editValue;
    final pageArrangementShowDeleteButton = settingsSharedPreferences
        .getEditItem(EditSetting.PageArrangementShowDeleteButton)
        .editValue;
    final pageArrangementShowPageNumber = settingsSharedPreferences
        .getEditItem(EditSetting.PageArrangementShowPageNumber)
        .editValue;

    return [
      TitleItem(title: localizations.color_settings),
      ColorItem(
        title: localizations.color_primary_title,
        subtitle: localizations.color_primary_subtitle,
        lightCircle: colorPrimaryItem.lightCircle,
        darkCircle: colorPrimaryItem.darkCircle,
        colorKey: ColorSetting.ColorPrimary,
      ),
      ColorItem(
        title: localizations.color_secondary_title,
        subtitle: localizations.color_secondary_subtitle,
        lightCircle: colorSecondaryItem.lightCircle,
        darkCircle: colorSecondaryItem.darkCircle,
        colorKey: ColorSetting.ColorSecondary,
      ),
      ColorItem(
        title: localizations.color_on_secondary_title,
        subtitle: localizations.color_on_secondary_subtitle,
        lightCircle: colorOnSecondaryItem.lightCircle,
        darkCircle: colorOnSecondaryItem.darkCircle,
        colorKey: ColorSetting.ColorOnSecondary,
      ),
      ColorItem(
        title: localizations.color_scan_layout_title,
        subtitle: localizations.color_scan_layout_subtitle,
        lightCircle: colorScanButtonsLayoutBackground.lightCircle,
        darkCircle: colorScanButtonsLayoutBackground.darkCircle,
        colorKey: ColorSetting.ColorScanButtonsLayoutBackground,
      ),
      ColorItem(
        title: localizations.color_scan_foreground_title,
        subtitle: localizations.color_scan_foreground_subtitle,
        lightCircle: colorScanButtonsForeground.lightCircle,
        darkCircle: colorScanButtonsForeground.darkCircle,
        colorKey: ColorSetting.ColorScanButtonsForeground,
      ),
      ColorItem(
        title: localizations.color_scan_polygon_title,
        subtitle: localizations.color_scan_polygon_subtitle,
        lightCircle: colorScanPolygon.lightCircle,
        darkCircle: colorScanPolygon.darkCircle,
        colorKey: ColorSetting.ColorScanPolygon,
      ),
      ColorItem(
        title: localizations.color_bottom_bar_background_title,
        subtitle: localizations.color_bottom_bar_background_subtitle,
        lightCircle: colorBottomBarBackground.lightCircle,
        darkCircle: colorBottomBarBackground.darkCircle,
        colorKey: ColorSetting.ColorBottomBarBackground,
      ),
      ColorItem(
        title: localizations.color_bottom_bar_forground_title,
        subtitle: localizations.color_bottom_bar_forground_subtitle,
        lightCircle: colorBottomBarForeground.lightCircle,
        darkCircle: colorBottomBarForeground.darkCircle,
        colorKey: ColorSetting.ColorBottomBarForeground,
      ),
      ColorItem(
        title: localizations.color_top_bar_background_title,
        subtitle: localizations.color_top_bar_background_subtitle,
        lightCircle: colorTopBarBackground.lightCircle,
        darkCircle: colorTopBarBackground.darkCircle,
        colorKey: ColorSetting.ColorTopBarBackground,
      ),
      ColorItem(
        title: localizations.color_top_bar_forground_title,
        subtitle: localizations.color_top_bar_forground_subtitle,
        lightCircle: colorTopBarForeground.lightCircle,
        darkCircle: colorTopBarForeground.darkCircle,
        colorKey: ColorSetting.ColorTopBarForeground,
      ),
      TitleItem(title: localizations.scan_settings),
      ScanSettingsItem(
        title: localizations.capture_mode_setting_title,
        subtitle: localizations.capture_mode_setting_subtitle,
        checkValue: allowCaptureModeSetting,
        scanKey: ScanSetting.AllowCaptureModeSetting,
      ),
      ScanSettingsItem(
        title: localizations.auto_capture_setting_title,
        subtitle: localizations.auto_capture_setting_subtitle,
        checkValue: autoCapture,
        scanKey: ScanSetting.AutoCapture,
      ),
      ScanSettingsItem(
        title: localizations.auto_crop_setting_title,
        subtitle: localizations.auto_crop_setting_subtitle,
        checkValue: autoCrop,
        scanKey: ScanSetting.AutoCrop,
      ),
      ScanSettingsItem(
        title: localizations.multi_page_setting_title,
        subtitle: localizations.multi_page_setting_subtitle,
        checkValue: multiPage,
        scanKey: ScanSetting.MultiPage,
      ),
      ScanSettingsItem(
        title: localizations.pre_capture_setting_title,
        subtitle: localizations.pre_capture_setting_subtitle,
        checkValue: preCaptureFocus,
        scanKey: ScanSetting.PreCaptureFocus,
      ),
      ScanFilterItem(
        title: localizations.default_scan_setting_title,
        subtitle: localizations.default_scan_setting_subtitle,
        scanValue: defaultScanFilter,
        filterKey: ScanSetting.DefaultScanFilter,
      ),
      TitleItem(title: localizations.edit_settings),
      EditItem(
        title: localizations.allow_page_filter_setting_title,
        subtitle: localizations.allow_page_filter_setting_subtitle,
        editValue: allowPageFilter,
        editKey: EditSetting.AllowPageFilter,
      ),
      EditItem(
        title: localizations.allow_page_rotation_setting_title,
        subtitle: localizations.allow_page_rotation_setting_subtitle,
        editValue: allowPageRotation,
        editKey: EditSetting.AllowPageRotation,
      ),
      EditItem(
        title: localizations.allow_page_arrangement_setting_title,
        subtitle: localizations.allow_page_arrangement_setting_subtitle,
        editValue: allowPageArrangement,
        editKey: EditSetting.AllowPageArrangement,
      ),
      EditItem(
        title: localizations.allow_page_cropping_setting_title,
        subtitle: localizations.allow_page_cropping_setting_subtitle,
        editValue: allowPageCropping,
        editKey: EditSetting.AllowPageCropping,
      ),
      EditItem(
        title: localizations.page_arrangement_delete_setting_title,
        subtitle: localizations.page_arrangement_delete_setting_subtitle,
        editValue: pageArrangementShowDeleteButton,
        editKey: EditSetting.PageArrangementShowDeleteButton,
      ),
      EditItem(
        title: localizations.page_arrangement_number_setting_title,
        subtitle: localizations.page_arrangement_number_setting_subtitle,
        editValue: pageArrangementShowPageNumber,
        editKey: EditSetting.PageArrangementShowPageNumber,
      ),
    ];
  }

  void _resetSettings() {
    settingsSharedPreferences.defaultSettings();
    settingsItems = _prepareData();
    adapterKey.currentState?.refresh(settingsItems);
  }
}
