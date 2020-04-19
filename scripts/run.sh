#!/bin/bash -xe

cd game
flutter run -d chrome --dart-define=FLUTTER_WEB_USE_SKIA=true
