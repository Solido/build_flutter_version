## This is a proof of concept and WIP

Access your pubspec application version and git commit status from auto-generated widgets.
Configure your widget to display last commit numbers or message and choose to display it in 
debug only or help your users debug your application by providing build informations on AboutDialog.

## Installation

Add this builder

    build_flutter_version:
        https://github.com/Solido/build_flutter_version

Then

    flutter packages pub run build_runner watch
    
Will generate Widgets available in 'utils/version.dart'


## Configuration

```dart
DisplayVersion(
  // Version contains all the info about the pubspec and last git commit
  builder: (context, version) { 
     return Text("${version.name} ${version.version} / ${version.gitInfo.message} : ${version.gitInfo.sha}");
     // Will render MyAppName 1.2 / adding help section : c78d654678iozka8790
  },
)
```


## Requirements

- Git command available in current path

Check

- Inherited Title
- AboutDialog
- AboutListTile
