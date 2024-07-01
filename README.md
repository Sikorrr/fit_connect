# FitConnect - Find Your Workout Buddy

**Note: This project is a work in progress.**

FitConnect is a mobile and web app designed to help you find your ideal workout partner in your nearby area. Whether you're into gym workouts, cycling, dancing, or any other fitness activity, FitConnect allows you to connect with like-minded individuals based on specific categories, gender preferences, and age ranges.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Future Plans](#future-plans)

## Introduction

FitConnect is built with Flutter and Firebase. It uses Bloc for state management and GoRouter for navigation. This app aims to provide a seamless experience for users to enhance their fitness journey on both mobile and web platforms.

## Features

1. **Connect with Like-minded Individuals:** Find workout partners who share similar fitness goals and interests.
2. **Workout Categories:** Choose from a variety of workout categories, such as gym workouts, cycling, dancing, yoga, or any other fitness activity you're interested in.
3. **Gender and Age Range Preferences:** Specify your preferred gender and age range for finding workout partners. This allows you to connect with people who match your preferences and feel comfortable with your chosen workout buddy.
4. **Personalized Profiles:** Create a personalized profile with your fitness interests, goals, and availability. Provide information about your fitness level, preferred workout intensity, and any specific requirements you have for a workout partner.
5. **Direct Messaging:** Communicate with potential workout buddies through a built-in messaging system. Discuss workout schedules, locations, and preferences to ensure a compatible partnership.
6. **Activity Scheduling:** Plan and schedule workout sessions with your chosen workout buddy. Coordinate timings, locations, and activity details to ensure a smooth fitness routine.

FitConnect makes it easy to find a compatible workout partner who shares your fitness interests and goals. Stay motivated, enjoy your workouts, and achieve your fitness milestones together with FitConnect!

## Installation

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sikorrr/fit_connect
   cd fit-connect
    ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Set up Firebase:**

    - Create a Firebase project in the Firebase Console.

    - Add your Android, iOS, and web apps to the project.

    - Download the google-services.json for Android and GoogleService-Info.plist for iOS, and place them in the appropriate directories.

    - Update firebase_options.dart with your Firebase project configuration.

3. **Run the app:**
    ```bash
   flutter run
   ```

### Future Plans
Here are some of the features we plan to add in the future:

- UI Enhancements: Improve the user interface for a better user experience.
- Community Challenges and Events: Create community challenges and events to engage users.
- Fitness News: Display the latest fitness news to keep users informed.
- Tests: Increase test coverage to ensure app stability.
- Offline Mode: Enable the app to function without an internet connection.
