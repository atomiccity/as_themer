import 'package:fluent_ui/fluent_ui.dart';
import 'package:as_themer/automation_studio/as_config.dart';

class SelectVersionDialog extends StatefulWidget {
  final List<AutomationStudioConfig> configs;

  const SelectVersionDialog({Key? key, required this.configs}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectVersionDialogState();
}

class _SelectVersionDialogState extends State<SelectVersionDialog> {
  AutomationStudioConfig? selectedConfig;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Select Version...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'These are the versions of Automation Studio that were detected.  '),
                TextSpan(
                  text: 'Please make sure to have all instances of Automation Studio closed when loading or saving.',
                  style: TextStyle(fontWeight: FontWeight.bold)
                )
              ]
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Combobox<AutomationStudioConfig>(
              placeholder: const Text('Detected versions'),
              isExpanded: false,
              items: widget.configs.map((e) => ComboboxItem<AutomationStudioConfig>(value: e, child: Text(e.version))).toList(),
              value: selectedConfig,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedConfig = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        Button(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        FilledButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context, selectedConfig);
          },
        )
      ],
    );
  }
}
