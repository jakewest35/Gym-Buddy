#!/bin/bash

flutter clean
flutter pub get
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
