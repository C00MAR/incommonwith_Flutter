let deferredPrompt;

window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredPrompt = e;
  window.dispatchEvent(new Event('pwa-installable'));
});

function triggerPWAInstall() {
  if (deferredPrompt) {
    deferredPrompt.prompt();
    deferredPrompt.userChoice.then((choiceResult) => {
      deferredPrompt = null;
      window.dispatchEvent(new Event('pwa-installed'));
    });
  }
}
