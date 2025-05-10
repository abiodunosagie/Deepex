# 💳 Deepex – Digital Utilities & Gift Card App

Deepex is a modern Flutter-based mobile app designed to allow users to:

- Redeem Gift Cards (locally and internationally)
- Buy Airtime
- Purchase Data Bundles
- Pay for Electricity Bills (e.g. PHED, IKEDC, etc.)
- Enjoy a responsive, elegant experience in both Light and Dark mode

> Built with 💙 by Smith using **Flutter + MVVM + Riverpod + Lottie**

---

## 📲 Features

- 💳 Gift Card Redemption (image upload, rate fetch, real-time status)
- 📞 Airtime & 📡 Data Purchase (MTN, GLO, Airtel, 9mobile)
- 💡 Electricity Payments (Prepaid and Postpaid meters)
- 🎨 Dark and Light Mode Toggle
- 🔁 Reusable Utility Methods (formatters, validators, snackbars, etc.)
- 📱 Fully Responsive Design
- 🧠 Clean MVVM Architecture
- 🔄 Safe API Calls with graceful error handling
- 🔐 Local Persistence using SharedPreferences
- 🎬 Lottie Animations for feedback and states

---

## 🧱 Tech Stack

| Layer             | Tech Used                     |
|------------------|-------------------------------|
| State Management | Riverpod                      |
| Architecture     | MVVM (Model-View-ViewModel)   |
| UI               | Flutter SDK + Lottie          |
| Animations       | Lottie                        |
| Theming          | ThemeData + Riverpod toggle   |
| Networking       | `http` package                |
| Routing          | `go_router`                   |
| Environment      | `flutter_dotenv`              |
| Storage          | `shared_preferences`          |

---

## 📂 Folder Structure

```bash
lib/
├── app.dart                      # Entry point config (theme, routing)
├── main.dart                     # Initializes Riverpod, runs app
├── core/
│   ├── constants/                # Texts, colors, images
│   ├── themes/                   # Dark/Light theme logic
│   ├── utils/                    # Formatters, validators, etc.
│   └── router/                   # GoRouter setup
├── features/
│   ├── giftcard/                 # MVVM setup per feature
│   ├── airtime/
│   ├── data/
│   ├── electricity/
│   └── dashboard/                # Home, Bottom Nav
├── global/
│   ├── lottie/                   # JSON animation files
│   ├── providers.dart            # Global Riverpod providers
│   └── widgets/                  # Custom buttons, loaders, etc.
└── models/                       # Shared data models

##Updated Folder Structure with Routing
```bash 
lib/
├── assets/                    # Store assets like Lottie animations, images, etc.
│   └── animations/            # For storing Lottie animations
├── constants/                 # For colors, text, etc.
│   ├── app_colors.dart
│   ├── app_text.dart
├── models/                    # For defining data models
│   ├── gift_card_model.dart
│   ├── airtime_model.dart
│   ├── data_model.dart
│   └── electricity_bill_model.dart
├── providers/                 # For managing app state using Riverpod
│   ├── gift_card_provider.dart
│   ├── airtime_provider.dart
│   ├── data_provider.dart
│   └── electricity_provider.dart
├── routing/                   # For managing navigation and route setup
│   └── app_router.dart
├── screens/                   # For UI screens (Views)
│   ├── home_screen.dart
│   ├── gift_card_screen.dart
│   ├── airtime_screen.dart
│   ├── data_screen.dart
│   └── electricity_screen.dart
├── services/                  # For API calls and data fetching
│   ├── api_service.dart
│   └── payment_service.dart
├── utilities/                 # Utility methods (e.g., for dark mode handling, form validation)
│   ├── dark_mode_utils.dart
│   └── form_utils.dart
├── widgets/                   # Custom widgets for reusability
│   ├── custom_button.dart
│   ├── input_field.dart
│   └── animated_card.dart
├── main.dart                  # Entry point
└── app.dart                   # To set up providers and app-wide settings (e.g., theme)

`

## Setup

1. Clone the repository.

```bash
git clone https://github.com/yourusername/deepex.git
cd deepex

```bash
flutter pub get

```bash
flutter run

## Packages Used

- **Riverpod**: State management solution for the app.
- **Lottie**: For adding Lottie animations to the app.
- **Shared Preferences**: For saving dark mode preferences.
- **Http**: For making API requests.
- **Provider**: State management dependency (for general use).
- **GoRouter**: For routing and navigation management.
- **Connectivity Plus**: For handling network connectivity.

## Features

- **Gift Card Redemption**: Redeem various gift cards within the app.
- **Airtime and Data Purchase**: Buy airtime and data from different service providers.
- **Electricity Bill Payment**: Pay bills like PHED, etc.
- **Dark Mode**: App-wide support for dark mode.
- **Responsive Design**: Optimized for various screen sizes.
- **Navigation**: Seamless routing between screens using GoRouter.

## Dark Mode

Dark mode is automatically applied based on user preferences. You can toggle it using the `DarkModeUtils` class.

## Contribution

Feel free to fork and contribute to this repository. Pull requests are welcome.


```bash

This should give you the necessary foundation for routing in your **Deepex** app! Let me know if you need any more details on this setup.
