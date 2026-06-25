// Cookie Consent Banner - Standalone module for all sub-pages
(function() {
  if (document.getElementById('cookieBanner')) return;

  var depth = window.location.pathname.split('/').length - 1;
  var prefix = '';
  for (var i = 0; i < depth; i++) prefix += '../';

  // Inject all CSS inline so it works without styles.css
  if (!document.getElementById('cookieConsentCss')) {
    var css = document.createElement('style');
    css.id = 'cookieConsentCss';
    css.textContent =
      '.cookie-banner{position:fixed;bottom:0;left:0;right:0;z-index:10000;background:rgba(10,15,25,0.97);backdrop-filter:blur(20px);border-top:1px solid rgba(0,212,255,0.2);box-shadow:0 -10px 40px rgba(0,0,0,0.5);padding:1.5rem}' +
      '.cookie-content{max-width:1200px;margin:0 auto;display:flex;align-items:center;gap:2rem;flex-wrap:wrap}' +
      '.cookie-icon{flex-shrink:0}' +
      '.cookie-icon svg{color:#00d4ff;filter:drop-shadow(0 0 10px rgba(0,212,255,0.3))}' +
      '.cookie-text{flex:1;min-width:300px}' +
      '.cookie-text h3{color:#eef5ff;font-size:1.25rem;font-weight:600;margin-bottom:0.5rem;font-family:Inter,sans-serif}' +
      '.cookie-text p{color:#8899bb;font-size:0.9rem;line-height:1.6;margin:0;font-family:Inter,sans-serif}' +
      '.cookie-buttons{display:flex;align-items:center;gap:1rem;flex-wrap:wrap}' +
      '.cookie-buttons .btn{font-family:Inter,sans-serif;padding:0.7rem 1.5rem;border-radius:8px;border:none;font-weight:600;font-size:0.9rem;cursor:pointer;transition:all 0.2s}' +
      '.cookie-buttons .btn-primary{background:linear-gradient(135deg,#00d4ff,#00e5ff);color:#0a0f1e}' +
      '.cookie-buttons .btn-primary:hover{transform:translateY(-2px);box-shadow:0 5px 20px rgba(0,212,255,0.3)}' +
      '.cookie-buttons .btn-secondary{background:rgba(255,255,255,0.08);color:#8899bb;border:1px solid rgba(255,255,255,0.1)}' +
      '.cookie-buttons .btn-secondary:hover{background:rgba(255,255,255,0.12);color:#eef5ff}' +
      '.cookie-link{color:#00d4ff;text-decoration:none;font-size:0.9rem;transition:color 0.3s;font-family:Inter,sans-serif}' +
      '.cookie-link:hover{color:#00ff88}' +
      '@media screen and (max-width:768px){.cookie-content{flex-direction:column;text-align:center;gap:1.5rem}.cookie-buttons{justify-content:center;width:100%}.cookie-buttons .btn{flex:1;min-width:120px}}' +
      '@keyframes slideUp{from{transform:translateY(100%);opacity:0}to{transform:translateY(0);opacity:1}}' +
      '@keyframes slideDown{from{transform:translateY(0);opacity:1}to{transform:translateY(100%);opacity:0}}';
    document.head.appendChild(css);
  }

  var bannerHtml =
    '<div id="cookieBanner" class="cookie-banner" style="display:none">' +
      '<div class="cookie-content">' +
        '<div class="cookie-icon"><svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="14" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2" fill="currentColor"/><circle cx="20" cy="12" r="1.5" fill="currentColor"/><circle cx="12" cy="20" r="1.5" fill="currentColor"/><circle cx="20" cy="20" r="2" fill="currentColor"/><circle cx="16" cy="16" r="1" fill="currentColor"/></svg></div>' +
        '<div class="cookie-text"><h3>Uso de Cookies</h3><p>Utilizamos cookies para mejorar tu experiencia, analizar el tráfico y personalizar el contenido.</p></div>' +
        '<div class="cookie-buttons">' +
          '<button id="acceptCookies" class="btn btn-primary">Aceptar todas</button>' +
          '<button id="rejectCookies" class="btn btn-secondary">Solo necesarias</button>' +
          '<a href="' + prefix + 'legal/cookies.html" class="cookie-link">Más información</a>' +
        '</div>' +
      '</div>' +
    '</div>';

  document.body.insertAdjacentHTML('beforeend', bannerHtml);

  var cookieBanner = document.getElementById('cookieBanner');
  var acceptBtn = document.getElementById('acceptCookies');
  var rejectBtn = document.getElementById('rejectCookies');

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

  checkConsent();
})();
