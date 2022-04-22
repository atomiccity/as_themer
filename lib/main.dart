import 'package:as_themer/automation_studio/as_config.dart';
import 'package:as_themer/ui/version_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() async {
  var configs = await AutomationStudioConfig.findAutomationStudioVersions();
  runApp(MyApp(configs: configs));
}

class MyApp extends StatelessWidget {
  final List<AutomationStudioConfig> configs;
  const MyApp({Key? key, required this.configs}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        accentColor: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', configs: configs),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<AutomationStudioConfig> configs;
  const MyHomePage({Key? key, required this.title, required this.configs}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Button(
      child: const Text('Press Me'),
      onPressed: () async {
        var theme = await showDialog<AutomationStudioConfig>(
            context: context,
            builder: (context) {
              return SelectVersionDialog(configs: widget.configs);
            }
        );
      },
    );
  }
}
