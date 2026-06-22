// Anesthesie Calculator Service Worker
const CACHE = 'anesthesiecalc-v5';
const URLS = [
  '.',
  'index.html',
  'manifest.json',
  'icon.svg',
  'favicon a.png',
  'favicon.ico',
  'anestbanner.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE).then(cache => cache.addAll(URLS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE).map(k => caches.delete(k))
    )).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(res => res || fetch(event.request))
  );
});
