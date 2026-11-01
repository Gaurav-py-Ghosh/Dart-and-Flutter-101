// The lab app. Run it with:  flutter run -d chrome   (or -d windows)
// Each row opens one lab. The matching note in the notes folder explains it.
// Press r in the terminal for hot reload, and R for hot restart.

import 'package:flutter/material.dart';

import 'labs/app_labs.dart';
import 'labs/state_labs.dart';
import 'labs/ui_labs.dart';

void main() => runApp(const LabApp());

class Lab {
  const Lab(this.title, this.page, {this.fullScreen = false});
  final String title;
  final Widget page;
  final bool fullScreen;
}

const labs = <Lab>[
  Lab('Layout', LayoutLab()),
  Lab('Lifecycle', LifecycleLab()),
  Lab('Keys', KeysLab()),
  Lab('Forms', FormLab()),
  Lab('Navigator', NavigatorLab()),
  Lab('go_router', GoRouterLab(), fullScreen: true),
  Lab('State management', StateLab()),
  Lab('FutureBuilder and StreamBuilder', AsyncLab()),
  Lab('Architecture: MVVM todo', ArchitectureLab()),
  Lab('Saving data', StorageLab()),
  Lab('Animation', AnimationLab()),
  Lab('Performance', PerformanceLab()),
  Lab('Native calls', ChannelLab()),
  Lab('Search and paging', SearchLab()),
];

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Interview Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const LabMenu(),
    );
  }
}

class LabMenu extends StatelessWidget {
  const LabMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Interview Lab')),
      body: ListView.separated(
        itemCount: labs.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final lab = labs[index];
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(lab.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => lab.fullScreen
                    ? lab.page
                    : Scaffold(
                        appBar: AppBar(title: Text(lab.title)),
                        body: lab.page,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
