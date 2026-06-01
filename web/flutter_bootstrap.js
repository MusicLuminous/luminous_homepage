(function() {
  "use strict";

  const SERVICE_WORKER_URL = "flutter_service_worker.js";
  const SERVICE_WORKER_SCOPE = "./";

  function registerServiceWorker() {
    if ("serviceWorker" in navigator) {
      window.addEventListener("load", function() {
        navigator.serviceWorker.register(SERVICE_WORKER_URL, {
          scope: SERVICE_WORKER_SCOPE
        }).then(function(registration) {
          console.log("Service Worker registered with scope: ", registration.scope);
          
          registration.addEventListener("updatefound", function() {
            const newWorker = registration.installing;
            newWorker.addEventListener("statechange", function() {
              if (newWorker.state === "installed") {
                if (navigator.serviceWorker.controller) {
                  console.log("New content is available; please refresh.");
                } else {
                  console.log("Content is cached for offline use.");
                }
              }
            });
          });
        }).catch(function(err) {
          console.error("Service Worker registration failed: ", err);
        });
      });
    }
  }

  function loadMainDartJs() {
    return new Promise(function(resolve, reject) {
      var scriptTag = document.createElement("script");
      scriptTag.src = "main.dart.js";
      scriptTag.type = "application/javascript";
      scriptTag.defer = true;
      scriptTag.onload = resolve;
      scriptTag.onerror = reject;
      document.body.appendChild(scriptTag);
    });
  }

  function bootstrap() {
    registerServiceWorker();
    
    loadMainDartJs().then(function() {
      console.log("main.dart.js loaded successfully");
    }).catch(function(error) {
      console.error("Failed to load main.dart.js: ", error);
    });
  }

  if (document.readyState === "complete") {
    bootstrap();
  } else {
    document.addEventListener("DOMContentLoaded", bootstrap);
  }
})();