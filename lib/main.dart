import 'dart:io';

import 'package:as_themer/automation_studio/as_config.dart';
import 'package:as_themer/automation_studio/code_themer_c.dart';
import 'package:as_themer/automation_studio/editor_theme.dart';
import 'package:as_themer/providers.dart';
import 'package:as_themer/ui/code_preview_c.dart';
import 'package:as_themer/ui/color_selector.dart';
import 'package:as_themer/ui/version_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async{
    // Hide window title bar
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  });

  var configs = await AutomationStudioConfig.findAutomationStudioVersions();
  runApp(ProviderScope(child: MyApp(configs: configs)));
}

class MyApp extends StatelessWidget {
  final List<AutomationStudioConfig> configs;
  const MyApp({Key? key, required this.configs}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Automation Studio Themer',
      theme: ThemeData(
        accentColor: Colors.blue,
      ),
      home: MyHomePage(title: 'Automation Studio Themer', configs: configs),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  final List<AutomationStudioConfig> configs;
  const MyHomePage({Key? key, required this.title, required this.configs}) : super(key: key);

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with WindowListener {
  String? predefinedTheme;

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = ref.watch(themeProvider);
    var themer = CodeThemerC(theme: theme);
    return NavigationView(
      appBar: NavigationAppBar(
          title: DragToMoveArea(
              child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  )
              )
          ),
          automaticallyImplyLeading: false,
          actions: DragToMoveArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [Spacer(), WindowButtons()],
            ),
          )
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CommandBar(
            primaryItems: [
              CommandBarButton(
                  icon: const Icon(FluentIcons.open_file),
                  label: const Text('Load'),
                  onPressed: () async {
                    var config = await showDialog<AutomationStudioConfig?>(
                        context: context,
                        builder: (context) {
                          return SelectVersionDialog(configs: widget.configs);
                        }
                    );
                    if (config != null) {
                      setState(() {
                        var theme = EditorThemeUtils.fromEditorSet(File(config.editorSetPath));
                        ref.read(themeProvider.notifier).setTheme(theme);
                        //themer = CodeThemerC(theme: theme);
                      });
                    }
                  }
              ),
              CommandBarButton(
                  icon: const Icon(FluentIcons.save),
                  label: const Text('Save'),
                  onPressed: () {

                  }
              ),
            ],
          ),
          Row(
            children: [
              const CodePreviewC(),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Combobox<String>(
                      placeholder: const Text('Presets         '),
                      isExpanded: false,
                      items: PredefinedTheme.themes.keys.map((e) => ComboboxItem<String>(value: e, child: Text(e))).toList(),
                      value: predefinedTheme,
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(themeProvider.notifier).setTheme(PredefinedTheme.themes[value]!);
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ColorSelector(
                              name: 'Background',
                              color: theme.backgroundColor,
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setBackground(color);
                              }
                          ),
                          ColorSelector(
                              name: 'Monitor\nBackground',
                              color: theme.monitorBackgroundColor,
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setMonitorBackground(color);
                              }
                          ),
                          ColorSelector(
                              name: 'Keyword',
                              color: theme.getColor(EditorComponent.keyword),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.keyword, color);
                              }
                          ),
                          ColorSelector(
                              name: 'String',
                              color: theme.getColor(EditorComponent.string),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.string, color);
                              }
                          ),
                          ColorSelector(
                              name: 'Number',
                              color: theme.getColor(EditorComponent.number),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.number, color);
                              }
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ColorSelector(
                              name: 'Data Types',
                              color: theme.getColor(EditorComponent.dataType),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.dataType, color);
                              }
                          ),
                          ColorSelector(
                              name: 'Names',
                              color: theme.getColor(EditorComponent.name),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.name, color);
                              }
                          ),
                          ColorSelector(
                              name: 'Comments',
                              color: theme.getColor(EditorComponent.remark),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.remark, color);
                              }
                          ),
                          ColorSelector(
                              name: 'Operator',
                              color: theme.getColor(EditorComponent.operator),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.operator, color);
                              }
                          ),
                          ColorSelector(
                              name: 'Header File',
                              color: theme.getColor(EditorComponent.includeFiles),
                              onColorChanged: (color) {
                                ref.read(themeProvider.notifier).setColor(EditorComponent.includeFiles, color);
                              }
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 30,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
