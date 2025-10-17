// Casino Assistant - Service Worker
// Version 2.1 - Fixed 404 errors

const CACHE_NAME = 'casino-assistant-v2.1';
const urlsToCache = [
  '/',
  '/index.html',
  '/manifest.json',
  '/404.html',
  '/test.html',
  '/auth/login.html',
  '/auth/settings.html',
  '/games/poker_odds.html',
  '/games/roulette_odds.html',
  '/games/slots_odds.html',
  '/games/craps_odds.html',
  '/games/baccarat_odds.html',
  '/games/keno_odds.html',
  '/games/paigow_odds.html',
  '/games/video_poker.html',
  '/games/blackjack_dashboard.html',
  '/games/blackjack_client.html',
  '/games/blackjack_live_advisor.html',
  '/games/casino_academy.html',
  '/games/premium.html',
  '/docs/sounds.js',
  '/docs/help.html',
  '/legal/terms.html',
  '/legal/privacy.html'
];

// Install event - cache resources
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(urlsToCache);
      })
      .then(() => self.skipWaiting())
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch event - serve from cache, fallback to network, handle 404
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Cache hit - return response
        if (response) {
          return response;
        }

        // Clone the request
        const fetchRequest = event.request.clone();

        return fetch(fetchRequest).then(response => {
          // If 404, serve custom 404 page
          if (response.status === 404) {
            return caches.match('/404.html').then(cached404 => {
              return cached404 || response;
            });
          }

          // Check if valid response
          if (!response || response.status !== 200 || response.type !== 'basic') {
            return response;
          }

          // Clone the response
          const responseToCache = response.clone();

          caches.open(CACHE_NAME)
            .then(cache => {
              cache.put(event.request, responseToCache);
            });

          return response;
        }).catch(error => {
          // Network error - serve 404 page
          return caches.match('/404.html').then(cached404 => {
            return cached404 || new Response('Page not found', {
              status: 404,
              statusText: 'Not Found'
            });
          });
        });
      })
  );
});

// Background sync for offline actions
self.addEventListener('sync', event => {
  if (event.tag === 'sync-stats') {
    event.waitUntil(syncStats());
  }
});

async function syncStats() {
  // Sync user statistics when back online
  // Implementation would go here
}

// Push notifications (for future use)
self.addEventListener('push', event => {
  const options = {
    body: event.data ? event.data.text() : 'New update available!',
    icon: '/icons/icon-192x192.png',
    badge: '/icons/badge-72x72.png',
    vibrate: [100, 50, 100],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: 1
    },
    actions: [
      {
        action: 'explore',
        title: 'Open App',
        icon: '/icons/checkmark.png'
      },
      {
        action: 'close',
        title: 'Close',
        icon: '/icons/xmark.png'
      }
    ]
  };

  event.waitUntil(
    self.registration.showNotification('Casino Assistant', options)
  );
});

// Notification click handler
self.addEventListener('notificationclick', event => {
  event.notification.close();

  if (event.action === 'explore') {
    event.waitUntil(
      clients.openWindow('/')
    );
  }
});
