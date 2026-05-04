# Bot Flow Builder

Flutter (Android) port of the Bot Flow Builder web prototype.

## Build
GitHub Actions workflow `.github/workflows/build-apk.yml` builds a release APK
on every push and uploads it as the `app-release-apk` artifact.

## Local
```
flutter create --platforms=android --org com.botflow .
flutter pub get
flutter build apk --release
```
