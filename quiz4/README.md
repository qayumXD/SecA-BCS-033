# Quiz 4: Supabase Authentication System

This project is a Flutter application that implements a Registration and Login system using Supabase Authentication.

## Features
- **Registration**: Users can create an account with an email and password.
- **Login**: Secure login for existing users.
- **Validation**: Full input validation for all fields.
- **Home Screen**: Displays the logged-in user's email and unique User ID.
- **Auth Flow**: Uses `supabase_flutter` for seamless authentication management.

## Setup Instructions
1.  **Supabase Project**: Create a new project on [Supabase](https://supabase.com/).
2.  **Authentication Settings**: Enable Email Auth in your Supabase dashboard.
3.  **Credentials**: 
    - Go to `Settings > API`.
    - Copy your `Project URL` and `anon public key`.
4.  **Configuration**:
    - Open `lib/main.dart`.
    - Replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` with your actual credentials.
5.  **Run the App**:
    ```bash
    flutter pub get
    flutter run
    ```

## Folder Structure
- `lib/services/auth_service.dart`: Contains logic for Supabase Auth calls.
- `lib/screens/login_screen.dart`: UI and logic for user login.
- `lib/screens/registration_screen.dart`: UI and logic for user registration.
- `lib/screens/home_screen.dart`: UI for the authenticated user's profile.
- `Screenshots/`: Folder for required application screenshots.

## Screenshots Requirement
Please include the following screenshots in the `Screenshots/` folder:
1. Registration Screen
2. Login Screen
3. Home Screen
4. Email Confirmation Screen
5. Supabase Auth Table Screenshot
