# Fix-it

Fix-it is an Android-only Flutter prototype with resident and technician roles in one phone app. It demonstrates mock sign-in, locally stored requests, technician assignments, request tracking, and service history. It does not connect to a backend.

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

### Resident / Tenant Phone App

Run from the repository root:

```powershell
flutter pub get
flutter build apk --debug
```

For a release APK or App Bundle:

```powershell
flutter build apk --release
flutter build appbundle --release
```

Outputs are created under `build\app\outputs\flutter-apk\` for APKs and `build\app\outputs\bundle\release\` for the App Bundle.

### Administrator Tablet App

The administrator app is a separate Flutter package with application ID `com.iks.mobile.admin_tablet`. From the repository root, build a debug APK with:

```powershell
Push-Location apps/admin_tablet
flutter pub get
flutter build apk --debug
Pop-Location
```

For a release APK or App Bundle:

```powershell
Push-Location apps/admin_tablet
flutter build apk --release
flutter build appbundle --release
Pop-Location
```

Admin outputs are under `apps\admin_tablet\build\app\outputs\flutter-apk\` for APKs and `apps\admin_tablet\build\app\outputs\bundle\release\` for the App Bundle. Both apps currently use the debug signing key for local builds. Configure a private release keystore before Play Store distribution.

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

1. Choose English or Arabic on the sign-in screen. The language preference is saved on the device; Arabic uses right-to-left layout.
2. Enter the demo phone number `+48 500000000` and apartment `A-302`.
3. Enter the mock verification code `123456`.
4. From the dashboard, choose **Create service request**. Select a category and service type, enter a description, set priority, optionally choose a preferred visit time, and submit. The confirmation screen displays the request number.
5. Open **My requests** to select a request and view its saved status timeline and details.
6. Open **Service history** to review requests and filter by category, status, or date range. Clear filters using the filter-clear action.
7. **Resident profile** displays mock tenant, apartment, tenancy, and contract details. **Move-out request** accepts a local request and shows its saved workflow status.
8. Use **Sign out** in the dashboard app bar to clear the saved mock session.

The dashboard notification icon opens a sample tenant notification inbox. It can also preview technician and administrator messages. These are local examples, not delivered push notifications.

The current request categories are Plumbing, Electrical, Maintenance, Cleaning, Installation, Home Services, and Electrical Upgrade.

## Technician App Walkthrough

1. From the resident sign-in screen, choose **Technician sign in**.
2. Enter the demo technician ID `TECH-001`. This prototype accepts the ID without a password; it is not secure authentication.
3. Use the **Assigned** and **Work history** tabs to review sample jobs. Open an assignment to see its request details, apartment location, and scheduled time.
4. For an active job, accept the assignment, start work, and mark it complete with comments. Completion moves it to **Awaiting tenant confirmation**; it does not close the request.
5. Use **Propose new time** to submit an appointment change. Sign in as the resident and open that request to approve or reject the proposal.
6. The tenant can confirm and close technician-completed work, then reopen it within 24 hours after closure.
7. Use the notification icon to view sample technician notices.

Sample technician assignments are stored alongside resident requests on the device. They are demonstrations, not real jobs.

The **Workflow examples** tab shows dummy examples for accepted, rejected, travelling, started, blocked, completed, closed, and reopened work, with sample timestamps, reasons, elapsed time, and tenant/admin notification previews. These are illustrative records, not live status actions or delivered notifications.

## Prototype Behavior and Limits

- Resident authentication accepts only the demo credentials above. Technician prototype sign-in accepts `TECH-001` by ID only. Both sessions and requests are stored locally with Hive.
- Technician status updates, tenant appointment decisions, request closure, and reopening are local prototype behavior. The separate administrator tablet app also uses in-memory sample data and does not synchronize with the phone app. Appointment proposals require tenant and administrator approval in the prototype, but those decisions are not shared across apps.
- Photo uploads, production authentication, push delivery, online payments, and backend integrations are not implemented. Administrator notification and report screens are previews based on local sample data. Profile and move-out data are mock/local; move-out status is not updated by an administrator.
- Reinstalling or clearing app data may remove locally stored prototype information.

## Checks

Run static analysis and the test suite from the project root:

```powershell
flutter analyze
flutter test
```