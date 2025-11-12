Service Docket App
A Flutter-based mobile application for capturing and managing service dockets with camera integration and Firebase backend.

📱 Features
Camera Integration: Capture photos directly from the app
Image Preview: Review captured images before saving
Firebase Storage: Automatic cloud storage for all docket images
Firestore Database: Store docket metadata and image references
Cross-Platform: Works on Android, iOS, and Web
Modern UI: Clean, intuitive Material Design interface
🚀 Getting Started
Prerequisites
Flutter SDK (>=3.0.0)
Dart SDK
Firebase account with a project set up
Android Studio / Xcode (for mobile development)
Chrome (for web development)
Installation
Clone the repository

git clone https://github.com/umesha2001/service_docket_app.git
cd service_docket_app
Install dependencies

flutter pub get
Configure Firebase

Create a Firebase project at Firebase Console
Add your app (Android/iOS/Web) to the Firebase project
Download and place the configuration files:
google-services.json in android/app/
GoogleService-Info.plist in ios/Runner/
Run Firebase CLI to generate options:
flutterfire configure
Run the app

# For mobile devices/emulator
flutter run

# For web with CORS disabled (development)
flutter run -d chrome --web-browser-flag "--disable-web-security"
🏗️ Project Structure
lib/
├── main.dart              # App entry point
├── docket_screen.dart     # Main docket listing screen
├── camera_screen.dart     # Camera capture interface
├── preview_screen.dart    # Image preview and save
└── firebase_options.dart  # Firebase configuration
🔧 Configuration
Firebase Setup
Enable Firebase Storage

Go to Firebase Console → Storage
Set up storage bucket
Configure security rules
Enable Cloud Firestore

Go to Firebase Console → Firestore Database
Create database
Set up security rules
CORS Configuration (Web)
For web deployment, you may need to configure CORS for Firebase Storage. See CORS_FIX_STEPS.md for detailed instructions.

📦 Dependencies
firebase_core (^3.6.0): Firebase initialization
cloud_firestore (^5.4.4): Cloud database
firebase_storage (^12.3.4): Cloud storage
camera (^0.11.0): Camera access
flutter_image_compress (^2.3.0): Image optimization
path_provider (^2.1.4): File system access
http (^1.1.0): Network requests
🎯 Usage
Launch the app - Opens to the docket screen
Tap the camera button - Opens camera interface
Capture photo - Take a picture of the service docket
Preview & confirm - Review the image and save
View saved dockets - Browse all captured dockets in the list
🌐 Platforms Supported
✅ Android
✅ iOS
✅ Web
✅ Windows
✅ macOS
✅ Linux
🔒 Security Notes
Never commit firebase_options.dart with production credentials to public repositories
Use Firebase Security Rules to protect your data
For production web deployment, properly configure CORS
Implement authentication before deploying to production
🛠️ Development
Running Tests
flutter test
Building for Production
Android

flutter build apk --release
iOS

flutter build ios --release
Web

flutter build web --release
📝 Known Issues
Web version requires CORS configuration for Firebase Storage
Camera may not work in some web browsers
See CORS_FIX_STEPS.md for troubleshooting
🤝 Contributing
Fork the repository
Create your feature branch (git checkout -b feature/AmazingFeature)
Commit your changes (git commit -m 'Add some AmazingFeature')
Push to the branch (git push origin feature/AmazingFeature)
Open a Pull Request
📄 License
This project is open source and available under the MIT License.

👤 Author
Umesha - @umesha2001

🙏 Acknowledgments
Flutter team for the amazing framework
Firebase for backend services
Camera plugin contributors
