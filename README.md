# Fitness Kolkata - Flutter Fitness Plans App

A modern, responsive Flutter application for managing fitness plans with timer functionality, beautiful UI, and enhanced user experience.

## 🚀 Features

- **📅 Plan Management**: Create, view, and manage fitness plans
- **⏰ Timer Integration**: Real-time countdown timers for upcoming sessions
- **🎯 Fitness Levels**: Three difficulty levels (Beginner, Intermediate, Advanced) with visual indicators
- **🖼️ Dynamic Images**: Fitness images from Picsum with beautiful loading states
- **📱 Responsive Design**: Works seamlessly on mobile, tablet, and desktop
- **🎨 Modern UI**: Material 3 design with warm earth-tone color scheme and smooth animations
- **✨ Beautiful Splash Screen**: Stunning animated splash screen with particle effects and warm gradient
- **✅ Comprehensive Testing**: Full widget test coverage

## 📋 Prerequisites

Before running this project, make sure you have:

- **Flutter SDK** (3.8.1 or higher)
- **Dart SDK** (3.8.1 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android Emulator** or **iOS Simulator** (for mobile testing)
- **Chrome** (for web testing)

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd fitness_kolkata
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the Application

#### For Mobile (Android/iOS)

```bash
flutter run
```

#### For Web

```bash
flutter run -d chrome
```

#### For Desktop

```bash
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

### 4. Run Tests

```bash
flutter test
```

### 5. Generate App Icons (Optional)

```bash
flutter pub run flutter_launcher_icons:main
```

## 🔧 Troubleshooting

### Common Issues

#### Flutter Doctor Issues

```bash
flutter doctor
```

Run this command to check for any setup issues and follow the suggested fixes.

#### Dependency Issues

```bash
flutter clean
flutter pub get
```

#### Build Issues

```bash
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons:main
flutter run
```

#### Web CORS Issues

If you encounter CORS issues when running on web, use:

```bash
flutter run -d chrome --web-renderer html
```

## 📦 Dependencies

### Core Dependencies

- **flutter**: SDK for building the app
- **provider**: ^6.1.5+1 - State management solution
- **dio**: ^5.9.0 - HTTP client for API calls
- **intl**: ^0.20.2 - Internationalization and date formatting
- **cupertino_icons**: ^1.0.8 - iOS-style icons

### Development Dependencies

- **flutter_test**: Testing framework
- **flutter_lints**: ^5.0.0 - Linting rules for code quality
- **flutter_launcher_icons**: ^0.13.1 - App icon generation

### Key Features Implemented

- **Responsive Design System**: Custom breakpoints and utilities
- **Enhanced UI Components**: Animated cards, buttons, and form fields
- **Timer Functionality**: Countdown timers with visual feedback
- **Image Loading**: Progressive loading with beautiful placeholders
- **API Integration**: RESTful API calls with error handling
- **Animated Splash Screen**: Beautiful particle-based splash screen with warm earth-tone gradient
- **Modern Color Scheme**: Warm sand and clay color palette for a premium fitness experience

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── api/                    # API service and error handling
│   ├── repository/             # Data repository layer
│   └── utils/                  # Utility classes (responsive, date utils)
├── data/
│   └── models/                 # Data models (Plan, DayPlans)
├── ui/
│   ├── screens/                # App screens
│   │   ├── splash_screen.dart
│   │   ├── plans_list_screen.dart
│   │   ├── plan_editor_screen.dart
│   │   ├── plan_detail_screen.dart
│   │   ├── workouts_screen.dart
│   │   ├── progress_screen.dart
│   │   └── profile_screen.dart
│   ├── navigation/             # Navigation components
│   │   ├── main_navigation.dart
│   │   └── bottom_nav_item.dart
│   └── widgets/                # Reusable UI components
│       ├── plan_card.dart
│       ├── animated_card.dart
│       ├── enhanced_button.dart
│       ├── time_picker_field.dart
│       └── ...
├── viewmodels/                 # Business logic and state management
└── main.dart                   # App entry point
```

## 🎯 Approach & Thought Process

### 1. **Architecture Decision**

- **MVVM Pattern**: Separated business logic from UI using Provider for state management
- **Repository Pattern**: Abstracted data access layer for better testability
- **Component-Based UI**: Created reusable widgets for consistency

### 2. **Responsive Design Strategy**

- **Mobile-First Approach**: Designed for mobile, then adapted for larger screens
- **Breakpoint System**: Implemented custom breakpoints (mobile: <600px, tablet: 600-1024px, desktop: >1024px)
- **Flexible Layouts**: Used responsive utilities for padding, margins, and grid systems

### 3. **User Experience Focus**

- **Progressive Loading**: Implemented beautiful loading states for images
- **Visual Feedback**: Added animations and micro-interactions
- **Accessibility**: Ensured proper contrast ratios and semantic widgets

### 4. **Code Quality & Testing**

- **Clean Code**: Followed Flutter best practices and naming conventions
- **Comprehensive Testing**: Wrote widget tests for critical user flows
- **Error Handling**: Implemented robust error handling with user-friendly messages

## 📱 App Screens & Navigation

The app features a modern bottom navigation system with the following main screens:

### 🏠 Home Screen (Plans List)

- **Daily Challenge Banner**: Motivational fitness challenges
- **Week Calendar**: Interactive calendar for date selection
- **Plan Management**: View, create, and manage fitness plans
- **Real-time Timers**: Countdown timers for upcoming sessions

### 🏋️ Workouts Screen

- Dedicated workout tracking interface
- Exercise routines and progress monitoring

### 📊 Progress Screen

- Fitness progress visualization
- Achievement tracking and statistics

### 👤 Profile Screen

- User profile management
- Settings and preferences

### ✨ Splash Screen

- Beautiful animated introduction with particle effects
- Warm earth-tone gradient background
- Smooth transition to main app

## 🔧 Technical Implementation Details

### Fitness Level Dropdown

- **Three Levels**: Beginner (Green), Intermediate (Orange), Advanced (Red)
- **Visual Indicators**: Color-coded icons for each difficulty level
- **Form Validation**: Ensures level selection before form submission

### Image Loading Enhancement

- **Progressive Loading**: Gradient backgrounds with progress indicators
- **Fitness-Specific Images**: Uses Picsum with fitness-related seeds
- **Error Handling**: Graceful fallbacks with fitness icons

### Timer Functionality

- **Real-Time Countdown**: Live timers for upcoming fitness sessions
- **Visual Feedback**: Pulsing animations and progress indicators
- **Session Management**: Automatic notifications when sessions start

### API Integration

- **RESTful Design**: Clean API calls with proper error handling
- **Retry Logic**: Automatic retry for failed requests
- **Debug Logging**: Comprehensive logging for development

### Splash Screen Experience

- **Warm Color Palette**: Beautiful gradient using warm sand (#D1913C), light beige (#FFD194), and brownish clay (#A86832)
- **Extended Animation**: 4.5-second animation sequence for smooth user experience
- **Particle Effects**: Floating particles with continuous movement animation
- **Professional Branding**: "FITNESS KOLKATA" with motivational tagline
- **Smooth Transitions**: Elastic animations with proper timing intervals

## ⏱️ Time Investment

**Total Time: Approximately 5-8 hours**

### Breakdown:

- **Initial Setup & Analysis**: 0.5-1 hour

  - Project structure analysis
  - Requirements understanding
  - Architecture planning

- **Core Implementation**: 2-3 hours

  - Responsive design system
  - Enhanced UI components
  - API service improvements
  - Timer functionality

- **UI/UX Enhancements**: 2-3 hours

  - Fitness level dropdown
  - Image loading improvements
  - Animations and transitions
  - Plan detail screen
  - Beautiful splash screen with particle effects
  - Warm earth-tone color scheme implementation

- **Testing & Bug Fixes**: 0.5-1 hour
  - Widget test fixes
  - Layout issue resolution
  - Cross-platform testing

## 🚦 Getting Started Guide

### For Developers

1. **Fork the repository** and clone it locally
2. **Install Flutter** if not already installed
3. **Run `flutter doctor`** to ensure setup is correct
4. **Install dependencies** with `flutter pub get`
5. **Run tests** with `flutter test` to ensure everything works
6. **Start development** with `flutter run`

### For Users

1. **Download the app** from the releases section
2. **Install on your device** (Android APK or iOS IPA)
3. **Enjoy the beautiful splash screen** with warm earth-tone animations
4. **Create fitness plans** with three difficulty levels
5. **Use interactive timers** to track your workout sessions
6. **Experience responsive design** across all your devices

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Picsum Photos** for providing beautiful placeholder images
- **Material Design** for the design system guidelines
