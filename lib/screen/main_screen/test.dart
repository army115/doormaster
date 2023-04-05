import 'package:flutter/material.dart';

void main() => runApp(const DropdownMenuExample());

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  // final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  ColorLabel? selectedColor;
  IconLabel? selectedIcon;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<ColorLabel>> colorEntries =
        <DropdownMenuEntry<ColorLabel>>[];
    for (final ColorLabel color in ColorLabel.values) {
      colorEntries.add(DropdownMenuEntry<ColorLabel>(
          value: color, label: color.label, enabled: color.label != 'Grey'));
    }

    final List<DropdownMenuEntry<IconLabel>> iconEntries =
        <DropdownMenuEntry<IconLabel>>[];
    for (final IconLabel icon in IconLabel.values) {
      iconEntries
          .add(DropdownMenuEntry<IconLabel>(value: icon, label: icon.label));
    }

    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: Scaffold(
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // DropdownMenu<ColorLabel>(
                  //   initialSelection: ColorLabel.green,
                  //   controller: colorController,
                  //   label: const Text('Color'),
                  //   dropdownMenuEntries: colorEntries,
                  //   onSelected: (ColorLabel? color) {
                  //     setState(() {
                  //       selectedColor = color;
                  //     });
                  //   },
                  // ),
                  const SizedBox(width: 20),
                  DropdownMenu(
                    controller: iconController,
                    enableFilter: true,
                    leadingIcon: const Icon(Icons.search),
                    label: const Text('Icon'),
                    dropdownMenuEntries: iconEntries,
                    inputDecorationTheme:
                        const InputDecorationTheme(filled: true),
                    onSelected: (IconLabel? icon) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                  )
                ],
              ),
            ),
            if (selectedColor != null && selectedIcon != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'You selected a ${selectedColor?.label} ${selectedIcon?.label}'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        selectedIcon?.icon,
                        color: selectedColor?.color,
                      ))
                ],
              )
            else
              const Text('Please select a color and an icon.')
          ],
        )),
      ),
    );
  }
}

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

enum IconLabel {
  smile('Smile', Icons.sentiment_satisfied_outlined),
  cloud(
    'Cloud',
    Icons.cloud_outlined,
  ),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}
