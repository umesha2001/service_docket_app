# Service Docket App

A Flutter-based mobile application for capturing and managing service dockets with camera integration and Firebase backend.

## 📱 Features

- **Camera Integration**: Capture photos directly from the app
- **Image Preview**: Review captured images before saving
- **Firebase Storage**: Automatic cloud storage for all docket images
- **Firestore Database**: Store docket metadata and image references
- **Cross-Platform**: Works on Android, iOS, and Web
- **Modern UI**: Clean, intuitive Material Design interface

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Firebase account with a project set up
- Android Studio / Xcode (for mobile development)
- Chrome (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/umesha2001/service_docket_app.git
   cd service_docket_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add your app (Android/iOS/Web) to the Firebase project
   - Download and place the configuration files:
     - `google-services.json` in `android/app/`
     - `GoogleService-Info.plist` in `ios/Runner/`
   - Run Firebase CLI to generate options:
     ```bash
     flutterfire configure
     ```

4. **Run the app**
   ```bash
   # For mobile devices/emulator
   flutter run
   
   # For web with CORS disabled (development)
   flutter run -d chrome --web-browser-flag "--disable-web-security"
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point
├── docket_screen.dart     # Main docket listing screen
├── camera_screen.dart     # Camera capture interface
├── preview_screen.dart    # Image preview and save
└── firebase_options.dart  # Firebase configuration
```

## 🔧 Configuration

### Firebase Setup

1. **Enable Firebase Storage**
   - Go to Firebase Console → Storage
   - Set up storage bucket
   - Configure security rules

2. **Enable Cloud Firestore**
   - Go to Firebase Console → Firestore Database
   - Create database
   - Set up security rules

### CORS Configuration (Web)

For web deployment, you may need to configure CORS for Firebase Storage. See `CORS_FIX_STEPS.md` for detailed instructions.

## 📦 Dependencies

- **firebase_core** (^3.6.0): Firebase initialization
- **cloud_firestore** (^5.4.4): Cloud database
- **firebase_storage** (^12.3.4): Cloud storage
- **camera** (^0.11.0): Camera access
- **flutter_image_compress** (^2.3.0): Image optimization
- **path_provider** (^2.1.4): File system access
- **http** (^1.1.0): Network requests

## 🎯 Usage

1. **Launch the app** - Opens to the docket screen
2. **Tap the camera button** - Opens camera interface
3. **Capture photo** - Take a picture of the service docket
4. **Preview & confirm** - Review the image and save
5. **View saved dockets** - Browse all captured dockets in the list

## 🌐 Platforms Supported

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔒 Security Notes

- Never commit `firebase_options.dart` with production credentials to public repositories
- Use Firebase Security Rules to protect your data
- For production web deployment, properly configure CORS
- Implement authentication before deploying to production

## 🛠️ Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

**Web**
```bash
flutter build web --release
```

## 📝 Known Issues

- Web version requires CORS configuration for Firebase Storage
- Camera may not work in some web browsers
- See `CORS_FIX_STEPS.md` for troubleshooting

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

Umesha - [@umesha2001](https://github.com/umesha2001)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Camera plugin contributors
