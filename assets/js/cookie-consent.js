// Cookie Consent Banner - Standalone module for all sub-pages
(function() {
  // Don't show if already on root page (it has its own banner)
  if (document.getElementById('cookieBanner')) return;

  var bannerHtml = `
    <div id="cookieBanner" class="cookie-banner" style="display: none;">
      <div class="cookie-content">
        <div class="cookie-icon">
          <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
            <circle cx="16" cy="16" r="14" stroke="currentColor" stroke-width="2" />
            <circle cx="12" cy="12" r="2" fill="currentColor" />
            <circle cx="20" cy="12" r="1.5" fill="currentColor" />
            <circle cx="12" cy="20" r="1.5" fill="currentColor" />
            <circle cx="20" cy="20" r="2" fill="currentColor" />
            <circle cx="16" cy="16" r="1" fill="currentColor" />
          </svg>
        </div>
        <div class="cookie-text">
          <h3>Uso de Cookies</h3>
          <p>Utilizamos cookies para mejorar tu experiencia, analizar el tráfico y personalizar el contenido.</p>
        </div>
        <div class="cookie-buttons">
          <button id="acceptCookies" class="btn btn-primary">Aceptar todas</button>
          <button id="rejectCookies" class="btn btn-secondary">Solo necesarias</button>
          <a href="../legal/cookies.html" id="cookieLink" class="cookie-link">Más información</a>
        </div>
      </div>
    </div>
  `;

  document.body.insertAdjacentHTML('beforeend', bannerHtml);

  var cookieBanner = document.getElementById('cookieBanner');
  var acceptBtn = document.getElementById('acceptCookies');
  var rejectBtn = document.getElementById('rejectCookies');

  // Fix cookie link depth
  var depth = window.location.pathname.split('/').length - 2;
  var link = document.getElementById('cookieLink');
  if (depth === 2) link.href = '../legal/cookies.html';
  else if (depth === 3) link.href = '../../legal/cookies.html';
  else if (depth === 1) link.href = 'legal/cookies.html';

  function checkConsent() {
    var consent = localStorage.getItem('cookieConsent');
    if (!consent) {
      setTimeout(function() {
        cookieBanner.style.display = 'block';
        cookieBanner.style.animation = 'slideUp 0.4s ease-out forwards';
      }, 1000);
    }
  }

  function hideBanner() {
    cookieBanner.style.animation = 'slideDown 0.4s ease-in forwards';
    setTimeout(function() { cookieBanner.style.display = 'none'; }, 400);
  }

  if (acceptBtn) {
    acceptBtn.addEventListener('click', function() {
      localStorage.setItem('cookieConsent', 'accepted');
      hideBanner();
    });
  }
  if (rejectBtn) {
    rejectBtn.addEventListener('click', function() {
      localStorage.setItem('cookieConsent', 'rejected');
      hideBanner();
    });
  }

  // Add animation styles if not present
  if (!document.getElementById('cookieAnimStyle')) {
    var style = document.createElement('style');
    style.id = 'cookieAnimStyle';
    style.textContent = `
      @keyframes slideUp { from { transform: translateY(100%); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
      @keyframes slideDown { from { transform: translateY(0); opacity: 1; } to { transform: translateY(100%); opacity: 0; } }
    `;
    document.head.appendChild(style);
  }

  checkConsent();
})();
