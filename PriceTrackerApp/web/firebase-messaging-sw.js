importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCRaznwzMqcjRCPqA-psScyBIaNwRbPi0Y",
    authDomain: "price-drop-tracker-73c57.firebaseapp.com",
    projectId: "price-drop-tracker-73c57",
    storageBucket: "price-drop-tracker-73c57.appspot.com",
    messagingSenderId: "930473203875",
    appId: "1:930473203875:web:7fcd61f019fe20e6b50716",
    measurementId: "G-M9SK1FRV7B"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});