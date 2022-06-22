import { initializeApp } from "https://www.gstatic.com/firebasejs/9.8.3/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.8.3/firebase-analytics.js";
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyCs1wO5Ma-izv13NOzegpDIBMKW767dE3E",
    authDomain: "flluter-push-notifications.firebaseapp.com",
    projectId: "flluter-push-notifications",
    storageBucket: "flluter-push-notifications.appspot.com",
    messagingSenderId: "101948232468",
    appId: "1:101948232468:web:d4474cc1f08a15c126e801",
    measurementId: "G-K4HKYRE8V1"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);