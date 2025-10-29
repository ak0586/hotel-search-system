Flutter Hotel Search App
A modern Flutter application that allows users to sign in with Google and search for hotels using the MyTravaly API.
Features
📱 Page 1: Google Sign-In/Sign-Up

Clean, gradient-based UI design
Google Authentication integration
Automatic silent sign-in on app restart
Stream-based authentication events
Error handling and loading states

🏠 Page 2: Home Page

Personalized welcome screen with user profile
Search bar for hotel queries (name, city, state, country)
Sample popular destination cards
Quick search shortcuts
Sign-out functionality

🔍 Page 3: Search Results

Real-time API integration with MyTravaly
Hotel listings with details (name, location, rating, address)
Infinite scroll pagination
Loading indicators
Empty state handling
Pull-to-refresh capability

Prerequisites
Before you begin, ensure you have the following installed:

Flutter SDK (3.0.0 or higher)
Dart SDK (3.0.0 or higher)
Android Studio / Xcode (for mobile development)
A Google Cloud Platform account (for OAuth configuration)

Installation
1. Clone the Repository
bashgit clone https://github.com/yourusername/flutter_hotel_app.git
cd flutter_hotel_app
2. Install Dependencies
bashflutter pub get
3. Configure Google Sign-In
For Android:

Go to Google Cloud Console
Create a new project or select an existing one
Enable the Google Sign-In API
Create OAuth 2.0 credentials (Android type)
Add your SHA-1 certificate fingerprint:

bash   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

Download the google-services.json file and place it in android/app/
Update android/build.gradle:

gradle   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }

Update android/app/build.gradle:

gradle   apply plugin: 'com.google.gms.google-services'

Add to android/app/src/main/AndroidManifest.xml:

xml   <application>
       <!-- ... -->
       <meta-data
           android:name="com.google.android.gms.version"
           android:value="@integer/google_play_services_version" />
   </application>
For iOS:

Go to Google Cloud Console
Create OAuth 2.0 credentials (iOS type)
Add your iOS Bundle ID
Download the GoogleService-Info.plist file and add it to ios/Runner/
Update ios/Runner/Info.plist:

xml   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLSchemes</key>
           <array>
               <!-- Replace with your REVERSED_CLIENT_ID from GoogleService-Info.plist -->
               <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
           </array>
       </dict>
   </array>
   
   <key>GIDClientID</key>
   <string>YOUR-CLIENT-ID.apps.googleusercontent.com</string>

Run pod install in the ios/ directory:

bash   cd ios
   pod install
   cd ..
For Web:

Create OAuth 2.0 credentials (Web application type)
Add authorized JavaScript origins
Update web/index.html:

html   <head>
       <!-- ... -->
       <meta name="google-signin-client_id" content="YOUR-CLIENT-ID.apps.googleusercontent.com">
   </head>
4. Update Client IDs (Optional)
If you want to specify client IDs directly in code, update the initialize() call in GoogleSignInPage:
dartawait GoogleSignIn.instance.initialize(
  clientId: 'YOUR-WEB-CLIENT-ID.apps.googleusercontent.com',
  serverClientId: 'YOUR-SERVER-CLIENT-ID.apps.googleusercontent.com',
);
API Configuration
The app uses the MyTravaly API for hotel search functionality.
API Details:

Base URL: https://api.mytravaly.com/public/v1/
Auth Token: 71523fdd8d26f585315b4233e39d9263
Documentation: View on Postman

The API token is already configured in the code. No additional setup required.
Running the App
Debug Mode
bashflutter run
Release Mode (Android)
bashflutter build apk --release
Release Mode (iOS)
bashflutter build ios --release
Web
bashflutter run -d chrome
Project Structure
lib/
├── main.dart                 # Main entry point
├── pages/
│   ├── google_sign_in_page.dart   # Page 1: Authentication
│   ├── home_page.dart              # Page 2: Home/Search
│   └── search_results_page.dart    # Page 3: Results
Dependencies
yamldependencies:
  flutter:
    sdk: flutter
  google_sign_in: ^6.1.5    # Google Authentication
  http: ^1.1.0              # HTTP requests for API calls
Key Features Implementation
Google Sign-In Flow

User clicks "Sign in with Google"
Google authentication dialog appears
User selects account and grants permissions
App receives user profile and authentication tokens
User is navigated to Home Page

Search Flow

User enters search query (hotel name, city, state, or country)
App makes API request to MyTravaly
Results are displayed with pagination
Infinite scroll loads more results automatically

Pagination

Loads 10 results per page
Automatically fetches next page when scrolling near bottom (90% threshold)
Shows loading indicator while fetching
Stops when no more results available

Troubleshooting
Google Sign-In Issues
Problem: "Sign in failed: PlatformException"

Solution: Ensure SHA-1 certificate is correctly added to Google Cloud Console
Verify google-services.json (Android) or GoogleService-Info.plist (iOS) is properly configured

Problem: "API not enabled"

Solution: Enable Google Sign-In API in Google Cloud Console

API Issues
Problem: "Failed to load hotels: 401"

Solution: Verify the auth token is correct in the code

Problem: "Failed to load hotels: Network error"

Solution: Check internet connection and API endpoint availability

Build Issues
Problem: "Execution failed for task ':app:processDebugGoogleServices'"

Solution: Ensure google-services.json is in the correct location (android/app/)

Problem: iOS build fails

Solution: Run pod install in the ios/ directory and clean build folder

Testing
Manual Testing Checklist

 Google Sign-In works on all platforms
 User profile displays correctly on Home Page
 Search functionality works with different queries
 Pagination loads additional results
 Empty state shows when no results found
 Sign-out functionality works
 App handles network errors gracefully

Future Enhancements

 Add hotel details page
 Implement favorites/bookmarks
 Add filters (price, rating, amenities)
 Implement map view for search results
 Add booking functionality
 Dark mode support
 Offline caching
 Multi-language support

Screenshots
Add screenshots of your app here
Contributing

Fork the repository
Create your feature branch (git checkout -b feature/AmazingFeature)
Commit your changes (git commit -m 'Add some AmazingFeature')
Push to the branch (git push origin feature/AmazingFeature)
Open a Pull Request

License
This project is licensed under the MIT License - see the LICENSE file for details.
Support
For issues and questions:

Create an issue on GitHub
Email: support@example.com

Acknowledgments

Flutter - UI Framework
Google Sign-In - Authentication
MyTravaly API - Hotel Data Provider

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
