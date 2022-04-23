import 'package:fluent_ui/fluent_ui.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ColorSelector extends StatelessWidget {
  final String name;
  final Color color;
  final Function(Color) onColorChanged;

  const ColorSelector({Key? key, required this.name, required this.color, required this.onColorChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColorIndicator(
            width: 44,
            height: 44,
            borderRadius: 5,
            color: color,
            onSelectFocus: false,
            onSelect: () async {
              var newColor = await showColorPickerDialog(
                context, color,
                enableOpacity: false,
                pickersEnabled: { ColorPickerType.wheel: true, ColorPickerType.primary: false, ColorPickerType.accent: false },
                showColorCode: true,
                colorCodeReadOnly: false,
              );
              onColorChanged(newColor);
            },
          ),
        ),
      ],
    );
  }
}