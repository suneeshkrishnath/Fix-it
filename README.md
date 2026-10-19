# Fix-it

Fix-it is an Android-only Flutter prototype for apartment residents. It demonstrates mock resident sign-in, locally stored service requests, request tracking, and service history. It does not connect to a backend.

## Requirements

- Flutter stable with the Dart SDK version specified in `pubspec.yaml`.
- Android Studio with the Android SDK, or an Android device with USB debugging enabled.
- Windows PowerShell examples below assume Flutter is available on `PATH`.

Check the Flutter and Android toolchain from the project root:

```powershell
flutter doctor
```

## Run Locally

From the repository root:

```powershell
flutter pub get
flutter run
```

To choose a connected phone or emulator, list devices first:

```powershell
flutter devices
flutter run -d <device-id>
```

## Build Android Packages

Build a debug APK for development/testing:

```powershell
flutter build apk --debug
```

Build a release-mode APK for device testing:

```powershell
flutter build apk --release
```

Build an Android App Bundle:

```powershell
flutter build appbundle --release
```

Output files are created under `build\app\outputs\flutter-apk\` for APKs and `build\app\outputs\bundle\release\` for the App Bundle. The current Android release configuration uses the debug signing key. This is suitable for local testing, not Play Store distribution; configure a private release keystore before publishing.

## Install on an Android Phone

### Install over USB

1. Enable Developer options and USB debugging on the phone.
2. Connect it to the computer and accept the USB debugging prompt on the phone.
3. From the project root, run:

```powershell
flutter devices
flutter install -d <device-id>
```

To build, install, and launch in one step, use `flutter run -d <device-id>`.

### Install an APK manually

1. Build the APK with `flutter build apk --release`.
2. Transfer `build\app\outputs\flutter-apk\app-release.apk` to the phone.
3. Open the APK on the phone and allow installation from that source if Android asks.

## Resident App Walkthrough

1. On the sign-in screen, enter the demo phone number `+48 500000000` and apartment `A-302`.
2. Enter the mock verification code `123456`.
3. From the dashboard, choose **Create service request**. Select a category and service type, enter a description, set priority, optionally choose a preferred visit time, and submit. The confirmation screen displays the request number.
4. Open **My requests** to select a request and view its saved status timeline and details.
5. Open **Service history** to review requests and filter by category, status, or date range. Clear filters using the filter-clear action.
6. Use **Sign out** in the dashboard app bar to clear the saved mock session.

The current request categories are Plumbing, Electrical, Maintenance, Cleaning, Installation, Home Services, and Electrical Upgrade. The dashboard's Resident profile and Move-out request destinations currently show planned-feature placeholders.

## Prototype Behavior and Limits

- Authentication accepts only the demo credentials above. The resident session and service requests are stored locally with Hive.
- Request statuses are local prototype data; no administrator or technician can change them, and there is no remote synchronization.
- Photo attachments, technician and manager workflows, push notifications, online payments, and backend integrations are not implemented.
- Reinstalling or clearing app data may remove locally stored prototype information.

## Checks

Run static analysis and the test suite from the project root:

```powershell
flutter analyze
flutter test
```