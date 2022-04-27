import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AsThemeInstall {
  String path;
  String name;

  AsThemeInstall({
    required this.name,
    required this.path,
  });
}

Future<List<AsThemeInstall>> getAsThemeConfigs() async {
  // Get AS config dir
  var roamingDir = (await getApplicationSupportDirectory()).parent.parent;
  var asDir = Directory(join(roamingDir.path, 'BR'));

  if (!asDir.existsSync()) {
    return List<AsThemeInstall>.empty();
  }

  var themes = List<AsThemeInstall>.empty(growable: true);

  asDir.list().forEach((element) {
    if (basename(element.path).startsWith('AS')) {
      var editorSet = File(join(element.path, 'Editor.set'));
      if (editorSet.existsSync()) {
        themes.add(AsThemeInstall(name: basename(element.path), path: editorSet.path));
      }
    }
  });

  return themes;
}