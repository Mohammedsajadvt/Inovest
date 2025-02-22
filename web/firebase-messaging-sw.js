importScripts(
  "https://www.gstatic.com/firebasejs/11.3.1/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/11.3.1/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyC7JYWHl93JqaI6JtrO-RwVldhni5DpL_0",
  authDomain: "inovest-ea78c.firebaseapp.com",
  projectId: "inovest-ea78c",
  storageBucket: "inovest-ea78c.firebasestorage.app",
  messagingSenderId: "565236548413",
  appId: "1:565236548413:web:ebdf2040065655cf763b54",
  measurementId: "G-8SB707KX2Z",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
