# Flutter Social Media App

A social media app with functionalities such as creating posts, liking, commenting,
following/unfollowing users, and searching users. Leveraged Firebase for data management
and authentication.

## To run this app
0. Go to firebase and get google-services.json add to path <android/app> folder.
1. Fill all empty string   <FirebaseOptions firebaseOptions = const FirebaseOptions(
  apiKey: "",
  authDomain: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: "",
);>
2. and add this code to <lib/config/const.dart>
3. Run this command in terminal <flutter run -d chrome --web-browser-flag "--disable-web-security">.


## New features to be added
1. One to One chat (work in progress)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
