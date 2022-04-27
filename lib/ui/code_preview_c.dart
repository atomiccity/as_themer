import 'package:as_themer/automation_studio/code_themer_c.dart';
import 'package:as_themer/automation_studio/editor_theme.dart';
import 'package:as_themer/providers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String sourceCode = '''
#include <bur/plctypes.h>

int main() {
    UDINT length = 256;
    STRING message[5];
    STRING *otherMessage = "Hello, World";
    int i;

    // The braces in this for loop will be highlighted
    for (i = 0; i < sizeof(message); i++) {
        message[i] = 0x00;
    }

    /* Another memory clear */
    brsmemset((UDINT) message, 0x00, sizeof(message));

    return length;
}''';

class CodePreviewC extends ConsumerStatefulWidget {
  const CodePreviewC({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CodePreviewCState();
}

class _CodePreviewCState extends ConsumerState<CodePreviewC> {
  bool isMonitorMode = false;

  @override
  Widget build(BuildContext context) {
    var theme = ref.watch(themeProvider);
    var themer = CodeThemerC(theme: theme);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Checkbox(
            content: const Text('Monitor Mode'),
            checked: isMonitorMode,
            onChanged: (checked) {
              if (checked != null) {
                setState(() {
                  isMonitorMode = checked;
                });
              }
            }
        ),
        Container(
            color: isMonitorMode ? theme.monitorBackgroundColor : theme.backgroundColor,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Consolas', // theme.font,
                        fontSize: 14,
                      ),
                      children: themer.themeSourceCode(sourceCode, monitorMode: isMonitorMode)
                  ),
                )
            )
        ),
      ],
    );
  }
}
