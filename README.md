---

# 📱 Service Docket App

A **Flutter-based mobile and web application** for capturing and managing service dockets with integrated camera functionality and a Firebase backend.

---

## ✨ Features

* 📸 **Camera Integration:** Capture photos directly within the app
* 🖼️ **Image Preview:** Review captured images before saving
* ☁️ **Firebase Storage:** Automatically upload docket images to the cloud
* 🗂️ **Firestore Database:** Store docket metadata and image references
* 💻 **Cross-Platform:** Works seamlessly on Android, iOS, Web, Windows, macOS, and Linux
* 🎨 **Modern UI:** Clean and intuitive Material Design interface

---

## 🚀 Getting Started

### 🧩 Prerequisites

* Flutter SDK (>=3.0.0)
* Dart SDK
* Firebase account with a configured project
* Android Studio / Xcode (for mobile)
* Chrome (for web development)

---

### ⚙️ Installation

```bash
# Clone the repository
git clone https://github.com/umesha2001/service_docket_app.git
cd service_docket_app

# Install dependencies
flutter pub get
```

---

### 🔥 Firebase Configuration

1. Create a project in [Firebase Console](https://console.firebase.google.com)
2. Add your apps (Android/iOS/Web)
3. Download and place config files:

   * `google-services.json` → `android/app/`
   * `GoogleService-Info.plist` → `ios/Runner/`
4. Run the Firebase CLI:

   ```bash
   flutterfire configure
   ```

---

### ▶️ Run the App

```bash
# For mobile (Android/iOS emulator)
flutter run

# For web (disable CORS for development)
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

---

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point
├── docket_screen.dart     # Main docket listing screen
├── camera_screen.dart     # Camera capture interface
├── preview_screen.dart    # Image preview and save screen
└── firebase_options.dart  # Firebase configuration
```

---

## 🔧 Firebase Setup

### Firebase Storage

* Go to **Firebase Console → Storage**
* Set up a **storage bucket**
* Configure **security rules**

### Cloud Firestore

* Go to **Firebase Console → Firestore Database**
* Create a **database**
* Set up **security rules**

---

### 🌐 CORS Configuration (Web)

If deploying on web, configure CORS for Firebase Storage.
See `CORS_FIX_STEPS.md` for details.

---

## 📦 Dependencies

| Package                           | Description              |
| --------------------------------- | ------------------------ |
| `firebase_core` (^3.6.0)          | Firebase initialization  |
| `cloud_firestore` (^5.4.4)        | Cloud Firestore database |
| `firebase_storage` (^12.3.4)      | Firebase cloud storage   |
| `camera` (^0.11.0)                | Camera access            |
| `flutter_image_compress` (^2.3.0) | Image optimization       |
| `path_provider` (^2.1.4)          | Local file system access |
| `http` (^1.1.0)                   | Network requests         |

---

## 🎯 Usage

1. Launch the app → opens the **Docket Screen**
2. Tap the **camera button** → open the camera interface
3. Capture a photo of the service docket
4. Preview and confirm before saving
5. View all saved dockets in the list

---

## 💻 Platforms Supported

✅ Android
✅ iOS
✅ Web
✅ Windows
✅ macOS
✅ Linux

---

## 🔒 Security Notes

* Never commit `firebase_options.dart` with production credentials to public repos
* Use **Firebase Security Rules** to protect your data
* Configure **CORS** properly for production web deployments
* Implement **authentication** before production release

---

## 🧪 Development

### Run Tests

```bash
flutter test
```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 🐞 Known Issues

* Web version requires CORS configuration for Firebase Storage
* Camera functionality may not work in some browsers
* See `CORS_FIX_STEPS.md` for troubleshooting

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch

   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit your changes

   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. Push to the branch

   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open a **Pull Request**

---

## 📄 License

This project is open source and available under the **MIT License**.

---

## 👤 Author

**Umesha** – [@umesha2001](https://github.com/umesha2001)

---

## 🙏 Acknowledgments

* [Flutter](https://flutter.dev) team for the amazing framework
* [Firebase](https://firebase.google.com) for backend services
* [Camera plugin](https://pub.dev/packages/camera) contributors

---

