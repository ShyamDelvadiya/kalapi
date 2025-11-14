// Replace with your actual Firebase config
importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js');

firebase.initializeApp({
   apiKey: 'AIzaSyAaiCd5z0Vxe1fjejC6-RqVG7M8ARezBZ4',
      appId: '1:45722123246:web:0fa4e10a0fda6c4d09ecff',
      messagingSenderId: '45722123246',
      projectId: 'mypg-f7b17',
      authDomain: 'mypg-f7b17.firebaseapp.com',
      storageBucket: 'mypg-f7b17.firebasestorage.app',
      measurementId: 'G-7TD75RV6SQ',
});

const messaging = firebase.messaging();
