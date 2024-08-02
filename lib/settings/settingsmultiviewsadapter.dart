import 'package:docutain_sdk_example_flutter/settings/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'SettingsSharedPreferences.dart';
import 'data.dart';

class SettingsMultiViewsAdapter extends StatefulWidget {
  List<SettingsMultiItems> items;
  SettingsSharedPreferences settingsSharedPreferences;

  SettingsMultiViewsAdapter({
    Key? key,
    required this.items,
    required this.settingsSharedPreferences,
  }) : super(key: key);

  @override
  SettingsMultiViewsAdapterState createState() =>
      SettingsMultiViewsAdapterState();
}

class SettingsMultiViewsAdapterState extends State<SettingsMultiViewsAdapter> {
  late List<SettingsMultiItems> items;
  late SettingsSharedPreferences settingsSharedPreferences;
  late AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    settingsSharedPreferences = widget.settingsSharedPreferences;
  }

  void refresh(List<SettingsMultiItems> newData) {
    setState(() {
      items.clear();
      widget.items.clear();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        widget.items.addAll(newData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations.of(context)!;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is TitleItem) {
          return TitleViewHolder(item: item);
        } else if (item is ColorItem) {
          return ColorSettingsViewHolder(
              item: item, prefs: settingsSharedPreferences);
        } else if (item is ScanSettingsItem) {
          return ScanSettingsViewHolder(
              item: item, prefs: settingsSharedPreferences);
        } else if (item is ScanFilterItem) {
          return ScanFilterViewHolder(
              item: item, prefs: settingsSharedPreferences);
        } else if (item is EditItem) {
          return EditSettingsViewHolder(
              item: item, prefs: settingsSharedPreferences);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class TitleViewHolder extends StatelessWidget {
  final TitleItem item;

  const TitleViewHolder({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            item.title,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.3,
          color: Colors.green,
        ),
      ],
    );
  }
}

class ColorSettingsViewHolder extends StatefulWidget {
  final ColorItem item;
  final SettingsSharedPreferences prefs;

  const ColorSettingsViewHolder(
      {super.key, required this.item, required this.prefs});

  @override
  _ColorSettingsViewHolderState createState() =>
      _ColorSettingsViewHolderState();
}

class _ColorSettingsViewHolderState extends State<ColorSettingsViewHolder> {
  late ColorItem cachedItem;

  @override
  void initState() {
    super.initState();
    cachedItem = widget.prefs.getColorItem(widget.item.colorKey);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          title: Text(
            widget.item.title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.item.subtitle,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildColorCircleWithText(cachedItem.lightCircle, 'Light', () {
                _openColorPicker(context, ColorType.Light);
              }),
              const SizedBox(width: 8),
              _buildColorCircleWithText(cachedItem.darkCircle, 'Dark', () {
                _openColorPicker(context, ColorType.Dark);
              }),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildColorCircleWithText(
      String colorHex, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: hexStringToColor(colorHex),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 12.0)),
      ],
    );
  }

  void _openColorPicker(BuildContext context, ColorType colorType) {
    Color currentColor = colorType == ColorType.Light
        ? hexStringToColor(cachedItem.lightCircle)
        : hexStringToColor(cachedItem.darkCircle);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = currentColor;

        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                setState(() {
                  pickerColor = color;
                });
              },
              paletteType: PaletteType.hueWheel,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Select'),
              onPressed: () {
                setState(() {
                  String hexColor = colorToHexString(pickerColor);
                  if (colorType == ColorType.Light) {
                    cachedItem = ColorItem(
                      title: cachedItem.title,
                      subtitle: cachedItem.subtitle,
                      lightCircle: hexColor,
                      darkCircle: cachedItem.darkCircle,
                      colorKey: cachedItem.colorKey,
                    );
                    widget.prefs.saveColorItemLight(
                        widget.item.colorKey.toString(), hexColor);
                  } else {
                    cachedItem = ColorItem(
                      title: cachedItem.title,
                      subtitle: cachedItem.subtitle,
                      lightCircle: cachedItem.lightCircle,
                      darkCircle: hexColor,
                      colorKey: cachedItem.colorKey,
                    );
                    widget.prefs.saveColorItemDark(
                        widget.item.colorKey.toString(), hexColor);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ScanSettingsViewHolder extends StatefulWidget {
  final ScanSettingsItem item;
  final SettingsSharedPreferences prefs;

  const ScanSettingsViewHolder(
      {Key? key, required this.item, required this.prefs})
      : super(key: key);

  @override
  _ScanSettingsViewHolderState createState() => _ScanSettingsViewHolderState();
}

class _ScanSettingsViewHolderState extends State<ScanSettingsViewHolder> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.item.checkValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          title: Text(
            widget.item.title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.item.subtitle,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          trailing: Switch(
              value: _isChecked,
              onChanged: (isChecked) {
                setState(() {
                  _isChecked = isChecked;
                });
                widget.prefs.saveScanItem(widget.item.scanKey, isChecked);
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.5)),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class ScanFilterViewHolder extends StatelessWidget {
  final ScanFilterItem item;
  final SettingsSharedPreferences prefs;
  final TextEditingController controller = TextEditingController();

  ScanFilterViewHolder({super.key, required this.item, required this.prefs});

  @override
  Widget build(BuildContext context) {
    controller.text = item.scanValue.name;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      trailing: SizedBox(
        width: 128,
        child: TextField(
          controller: controller,
          readOnly: true,
          onTap: () {
            _scanFilterDialog(context, controller, item);
          },
        ),
      ),
    );
  }

  void _scanFilterDialog(BuildContext context, TextEditingController controller,
      ScanFilterItem item) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    final options = [
      localizations.auto_option, // Replace with localizations if needed
      localizations.gray_option,
      localizations.black_and_white_option,
      localizations.original_option,
      localizations.text_option,
      localizations.auto_2_option,
      localizations.illustration_option,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.title_scan_dialog),
          // Replace with localizations if needed
          content: SingleChildScrollView(
            child: ListBody(
              children: options.asMap().entries.map((entry) {
                int idx = entry.key;
                String option = entry.value;
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(option),
                  ),
                  onTap: () {
                    controller.text = option;
                    prefs.saveScanFilterItem(item.filterKey, idx);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text(localizations.cancel_scan_dialog),
              // Replace with localizations if needed
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EditSettingsViewHolder extends StatefulWidget {
  final EditItem item;
  final SettingsSharedPreferences prefs;

  const EditSettingsViewHolder(
      {Key? key, required this.item, required this.prefs})
      : super(key: key);

  @override
  _EditSettingsViewHolderState createState() => _EditSettingsViewHolderState();
}

class _EditSettingsViewHolderState extends State<EditSettingsViewHolder> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.item.editValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          title: Text(
            widget.item.title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.item.subtitle,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          trailing: Switch(
              value: _isChecked,
              onChanged: (isChecked) {
                setState(() {
                  _isChecked = isChecked;
                });
                widget.prefs.saveEditItem(widget.item.editKey, isChecked);
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.5)),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }
}
