# Scripts

This folder contains bash scripts used in your project. These scripts are used to automate some of the processes in your project.

[![tr](https://img.shields.io/badge/lang-tr-red.svg)](https://github.com/yunusemrealpak/flutter_boilerplate/blob/master/scripts/ReadMe-tr.md)

## 1. Localization

This bash script runs the generate command of a package called easy_localization. This command file creates a class for each language in the lib/core/localization/ folder that defines all the variables in the assets/i10n/ folder. These classes are written to a file called locale_keys.g.dart and are used for the localization support of your project.

In short, this script automates the code generation process of the easy_localization package, which is used to simplify the localization process of your project. This way, the creation of the keys required for the localization of your project can be done faster and error-free.

```{r, engine='bash', count_lines}
sh scripts/localization.sh
```

## 2. Build Runner

This bash script runs the command of a package called build_runner. This command runs all the generators in your project. This way, all the code generation processes in your project are performed.

```{r, engine='bash', count_lines}
sh scripts/build_runner.sh
```

## 3. Build

This script builds your project in debug and release modes. It is integrated with flavors in your project. If you are not using flavors, you can run it without adding <flavor_name>.

```{r, engine='bash', count_lines}
sh scripts/build.sh -apk <flavor_name>
```
```{r, engine='bash', count_lines}
sh scripts/build.sh -bundle <flavor_name>
```

> Note: You can add these scripts to the "preLaunchTask" field in the .vscode/launch.json file in the root directory of your project. This way, the build processes in your project will be automatically performed when you run it in debug or release mode.

> If you want to add a nice script you use to this area, I will be happy to evaluate it.


