/// Configuration for using `package:build`-compatible build systems.
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline.
///
/// See [package:build_runner](https://pub.dartlang.org/packages/build_runner)
/// for more information.
library builder;

import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:git/git.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Builder buildFlutterVersion([BuilderOptions options]) =>
    _FlutterVersionBuilder();

class _FlutterVersionBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    var assetId = AssetId(buildStep.inputId.package, 'pubspec.yaml');
    var content = await buildStep.readAsString(assetId);
    var pubspec = Pubspec.parse(content, sourceUrl: assetId.uri);

    if (pubspec.version == null) {
      throw StateError('pubspec.yaml does not have a version defined.');
    }

    var gitDir = await GitDir.fromExisting(Directory.current.path);
    var commits = await gitDir.getCommits();
    var lastCommit = commits.values.last;
    var branch = await gitDir.getCurrentBranch();

    await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, 'lib/utils/version.dart'), '''
// Generated code. Do not modify.
import 'package:flutter/material.dart';

class GitInfo {
  final String message = '${lastCommit.message}';
  final String sha = '${lastCommit.treeSha}';
  final String branch = '${branch.branchName}';

  const GitInfo();
}

class Version {
  final String name = '${pubspec.name}';
  final String description = '${pubspec.description ?? ''}';
  final String version = '${pubspec.version}';
  final String homepage = '${pubspec.homepage ?? ''}';
  final String authors = '${pubspec.authors ?? ''}';
  final gitInfo = const GitInfo();
}

typedef Widget VersionBuilder(BuildContext context, Version version);

class VersionDialog extends AboutDialog {
  VersionDialog({
    Key key,
    Widget applicationIcon,
    String applicationLegalese,
    List<Widget> children,
  }) : super(key:key, 
    applicationName:'${pubspec.name}', 
    applicationVersion:'${pubspec.version}',
    applicationIcon: applicationIcon,
    applicationLegalese: applicationLegalese,
    children: children);
}

/// Setup the Title widget
class VersionApp extends StatelessWidget {
  final Widget child;
  final Color color;

  VersionApp({@required this.child, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: Version().name,
      color: color,
      child: child,
    );
  }
}

/// A configurable Widget that display conditionally
class DisplayVersion extends StatelessWidget {
  
  final VersionBuilder builder;
  final production = const bool.fromEnvironment("dart.vm.product");
  final bool onDebugOnly;

  DisplayVersion({this.builder, this.onDebugOnly = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !onDebugOnly || !production,
      child: builder(context, Version()),
      replacement: Container(),
    );
  }
}


''');
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['utils/version.dart']
  };
}
