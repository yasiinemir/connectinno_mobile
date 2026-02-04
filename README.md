Connectinno'nun beklediği tüm kriterleri (BLoC kullanımı, Offline-first yaklaşımı, AI bonusu ve UX detayları) kapsayan, profesyonel bir Flutter README.md dosyası hazırladım.

Bu dosya, sadece kodu değil, senin bir geliştirici olarak vizyonunu ve mimari kararlarını da sunacaktır.

# 📱 VibeNotes - Flutter Mobile Application
VibeNotes is a high-performance, offline-first note-taking application built with Flutter. It features a modern UI, robust state management, and an innovative AI-driven music recommendation engine to enhance the user experience. 

This project was developed as a comprehensive technical case study for Connectinno. 

# 🌟 Key Features

Offline-First Behavior: Full local persistence ensures notes are available even without an internet connection. 


Background Sync: Automatic data synchronization with the backend when the network becomes available. 


AI Mood Matcher (Bonus): Leverages Google Gemini AI to analyze the sentiment of your notes and matches them with a YouTube soundtrack. 


Advanced CRUD: Complete management of notes including Pinning/Favoriting and a search bar for efficient filtering. 


UX Awareness: Includes "Undo Delete" functionality via snackbars and clear loading/error states for a smooth flow. 

# 🏗️ Architecture & State Management
The app follows a Clean Architecture pattern to separate concerns and ensure maintainability: 

UI Layer: Modular widgets and screens built with Flutter.


Business Logic (BLoC): State management is handled using the Bloc/Cubit pattern for predictable state transitions (Authentication, Note CRUD, Sync). 


Data Layer: Repositories managing the flow between the Local Database (Hive) and the Remote Backend. 

# 🛠️ Tech Stack

State Management: Bloc / Cubit 


Local Database: Hive (Lightweight & Fast for mobile) 


Remote Database: Firebase (Authentication & Cloud Firestore) 

Networking: Dio (with Interceptors for centralized error handling)


Animations: Native Splash Screen & Smooth Transitions 

# 🚀 Getting Started
# 1. Prerequisites
Flutter SDK (v3.0.0 or higher)

Dart SDK (v3.0.0 or higher)

A Firebase project set up with Google Sign-In or Email/Password Auth enabled. 

# 2. Configuration
Create a .env file in the root directory (or use a config file) and provide your backend URL:
BACKEND_URL=http://127.0.0.1:8000
# 3. Running the App
# Install dependencies
flutter pub get

# Generate local database adapters (if using Hive)
dart run build_runner build

# Run the application
flutter run

# 🧠 AI Product Vision
The VibeNotes AI feature represents a shift from static tools to interactive experiences. By analyzing the "Vibe" of a note, the app creates a personalized environment. 

How it works:

User writes a note (e.g., "Hard work pays off!").

The backend (Gemini AI) identifies the mood as "Energetic/Motivational".

A matching YouTube video (e.g., Eminem - Lose Yourself) is suggested and can be played within the app.
