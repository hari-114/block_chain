# How to Run This Flutter Project in Android Studio

Follow these steps to clone and run the **block_chain** Flutter app from GitHub using Android Studio.

---

## 1. Prerequisites

Before you start, make sure the following are installed and configured:

### Flutter SDK
- Install **Flutter** from the official site.
- Add `flutter/bin` to your system `PATH`.
- Verify installation by running:

```bash
flutter doctor
```

Fix any major issues reported (Android toolchain, licenses, devices, etc.).

### Android Studio
- Install **Android Studio** with the Android SDK.
- Create at least one **Android Virtual Device (AVD)** or plan to use a real Android device.

### Flutter & Dart Plugins
In Android Studio:
- Go to **File → Settings → Plugins**
- Search for **Flutter** (Dart will be installed automatically)
- Install and **Restart Android Studio**

---

## 2. Clone or Import the Project

You can clone the repository either via terminal or directly from Android Studio.

### Option A – Clone via Git (Terminal)

```bash
git clone https://github.com/hari-114/block_chain.git
cd block_chain
```

Use this if you are comfortable working with Git from the command line.

### Option B – Clone via Android Studio

1. Open **Android Studio**
2. Go to **File → New → Project from Version Control → Git**
3. Paste the repository URL:
   ```
   https://github.com/hari-114/block_chain.git
   ```
4. Choose a local directory
5. Click **Clone** and wait for indexing to complete

---

## 3. Open the Flutter Project Correctly

- Open Android Studio
- Go to **File → Open…**
- Select the `block_chain` folder (must contain `pubspec.yaml`, `lib/`, `android/`, etc.)

Android Studio should automatically detect it as a **Flutter project**.

If prompted, provide the **Flutter SDK path**.

---

## 4. Fetch Flutter Dependencies

1. Open `pubspec.yaml`
2. Click **Pub get** at the top of the editor

**OR** run the following from the project root:

```bash
flutter pub get
```

Wait until all dependencies are downloaded without errors.

---

## 5. Configure the Run Configuration

- Open `lib/main.dart`
- Ensure the run configuration type is **Flutter**
- Entry point should be set to `lib/main.dart`

If needed:
- Go to **Run → Edit Configurations…**
- Verify Flutter SDK path and target file

---

## 6. Run on Emulator or Real Device

### A. Using an Android Emulator

1. Go to **Tools → Device Manager**
2. Click **Create Device**
3. Choose a hardware profile
4. Select a system image (recommended: latest stable Android version)
5. Finish setup and start the emulator

### B. Using a Physical Android Device

1. Enable **Developer Options** on your phone
2. Enable **USB Debugging**
3. Connect the device via USB
4. Verify detection:

```bash
flutter devices
```

### Run the App

- Select the device/emulator from the top toolbar
- Click **Run ▶**

**OR** run from terminal:

```bash
flutter run
```

The app should build and launch on the selected device.

---

## 7. Troubleshooting

### General Diagnostics

```bash
flutter doctor -v
```

Resolve any red ❌ issues (licenses, SDK paths, missing tools).

### Common Issues

**No pubspec.yaml found**
- Ensure you are in the project root directory (`block_chain`)

**Gradle / AndroidX errors**
1. Open the `android/` folder separately in Android Studio
2. Allow Gradle and SDK updates if prompted
3. Return to the Flutter project and run:

```bash
flutter clean
flutter pub get
flutter run
```

---

## Need Help?

If you encounter errors:
- Copy the **exact error message**
- Share it in an issue or discussion

This will allow more targeted fixes to be provided.

---

Happy coding 🚀
