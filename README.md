This is a proof of concept and WIP

Access your pubspec application version and git commit status from auto-generated and configurable widgets.


Add this builder

    build_flutter_version:
        https://github.com/Solido/build_flutter_version

Then

    flutter packages pub run build_runner watch
    
Will generated Widgets will be generated to 'utils/version.dart'

 

Requirements

- Git command available in current path

Check

- Inherited Title
- AboutDialog
- AboutListTile
