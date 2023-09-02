# Price Tracker App

## Introduction

The Price Tracker app is designed to help users track product prices and receive notifications when prices drop to their desired levels. This documentation provides a comprehensive overview of the app's features, architecture, and user flows.

## Features

- User authentication and registration using Google Sign-In.
- Search and selection of products for price tracking.
- Input and submission of expected prices for tracking.
- Display of saved items and notifications based on price drops.

## Frontend Components

### LoginPage

The LoginPage enables users to log in or register using their Google accounts. It integrates Google Sign-In functionality for a secure and seamless authentication process.

### ListBuilder

The ListBuilder component displays search results to users and allows them to select products for tracking. It provides an interactive interface for product selection.

### PriceInput

Users can input their expected prices for tracked products using the PriceInput component. The input data is then submitted to Firebase Firestore for further processing.

### SavedList

The SavedList component showcases users' saved items and displays notifications when prices drop to the expected levels. It retrieves and displays data from Firebase Firestore.

### FinalPage

The FinalPage provides users with feedback based on tracking results. It offers different messages and options based on whether the price is already lower than expected or if notifications will be sent.

## Backend Integration

### Firebase Authentication

Firebase Authentication is used for secure user login and registration. It employs Firebase's authentication services to ensure user privacy and data security.

### Firebase Firestore

Firestore serves as the app's database, storing user data, expected prices, and tracking results. It offers real-time synchronization and seamless data management.

### Firebase Cloud Messaging (FCM)

FCM is employed to send push notifications to users. Notifications are triggered based on price drops and are delivered to users' devices through FCM.

## Data Flow

The flow of data within the app starts with user inputs such as login details, expected prices, and product selections. These inputs interact with frontend components and are stored in Firestore. When tracked prices drop, notifications are sent using FCM, completing the data flow cycle.

## User Flows

### User Login and Registration

1. User accesses the app and lands on the LoginPage.
2. User selects the Google Sign-In option to log in or register.
3. Firebase Authentication verifies user credentials.
4. Upon successful authentication, the user gains access to the app's main functionalities.

### Product Tracking and Notifications

1. User searches for products using the ListBuilder component.
2. User selects products to track, which triggers interactions with Firestore.
3. User inputs expected prices using PriceInput.
4. PriceInput data is stored in Firestore for further processing.
5. When tracked prices drop, FCM sends notifications to users.
6. Users receive notifications on their devices via FCM.

(Continue with user flows for other scenarios)

## External Services

The app integrates the following external services:

- Flask Server: A lightweight web server built using Flask.
- Firebase Cloud Messaging (FCM): Provides push notification services.

## Third-Party Libraries

The Price Tracker app utilizes the following third-party libraries:

### Dart (Frontend) Libraries:

- `firebase_auth`
- `cloud_firestore`
- `firebase_messaging`
- `google_sign_in`
- `provider`

### Python (Backend) Libraries:

- Flask
- firebase-admin
- requests

## Architecture Diagram

![Architecture Diagram](architecture_diagram.png)

## Author

The Price Tracker app was developed by [Vishnukanth S](https://github.com/qunata-guy) & [Subash D](https://github.com/Subashh46) 


For any inquiries or feedback, feel free to contact me at [vkanthishnu@gmail.com](mailto:vkanthishnu@gmail.com).

---

License: [MIT License](LICENSE)