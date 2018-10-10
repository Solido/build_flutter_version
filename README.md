## This is a proof of concept and WIP

#### Feedback and ideas welcome !!

Access your pubspec and git commit informations like versions and commit status from **auto-generated** widgets.

Configure your widgets to display pertinent and always up to date informations to your users like the last build version,
expose advanced info in production or dev only to help debug specific builds.

We also preconfigure AboutDialog and AboutListTile.

More to come !

_NB: I wrote this specific Flutter and Git version based on the work of https://github.com/kevmoo/build_version
and will try to follow this package evolution on top of our own requirements._

## Installation

Add this builder

    build_flutter_version:
        https://github.com/Solido/build_flutter_version

Then

    flutter packages pub run build_runner watch
    
Will generate a dart file at `utils/version.dart`
Just import this file to access Widgets that fits your needs.


## Configuration

```dart
DisplayVersion(
  // Version contains infos about the pubspec and last git commit
  builder: (context, version) { 
     return Text("${version.name} ${version.version} / ${version.gitInfo.message} : ${version.gitInfo.sha}");
     // => MyAppName 1.2 / adding help section : c78d654678iozka8790
  },
)
```


## Requirements

- Git command available in current path

Check

- Inherited Title
- AboutDialog
- AboutListTile

## Todo

- [ ] Acces n last commits
