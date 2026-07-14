// ============================================
// FINTECH PORTFOLIO - INTERACTIVE JAVASCRIPT
// ============================================

// ============================================
// MOUSE POSITION TRACKING (for hexagon trails)
// ============================================
let mouseX = 0;
let mouseY = 0;

// Track mouse position
document.addEventListener('mousemove', (e) => {
    mouseX = e.clientX;
    mouseY = e.clientY;
});


// ============================================
// HEXAGON TRAIL EFFECT (BLOCKCHAIN THEME)
// ============================================
let lastTrailTime = 0;
const trailDelay = 50; // milliseconds between trails
const trailPositions = []; // Store trail positions for chain effect

document.addEventListener('mousemove', (e) => {
    if (window.innerWidth <= 768) return; // Skip on mobile

    const currentTime = Date.now();
    if (currentTime - lastTrailTime < trailDelay) return;

    lastTrailTime = currentTime;

    // Create hexagon trail
    const trail = document.createElement('div');
    trail.className = 'cursor-trail';
    trail.style.left = e.clientX + 'px';
    trail.style.top = e.clientY + 'px';

    // Store position for chain lines
    trailPositions.push({ x: e.clientX, y: e.clientY, element: trail });

    // Limit stored positions
    if (trailPositions.length > 5) {
        trailPositions.shift();
    }

    // Create chain connection lines
    if (trailPositions.length > 1) {
        const prevPos = trailPositions[trailPositions.length - 2];
        const line = document.createElement('div');
        line.className = 'chain-line';

        const deltaX = e.clientX - prevPos.x;
        const deltaY = e.clientY - prevPos.y;
        const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
        const angle = Math.atan2(deltaY, deltaX) * 180 / Math.PI;

        line.style.left = prevPos.x + 'px';
        line.style.top = prevPos.y + 'px';
        line.style.width = distance + 'px';
        line.style.transform = `rotate(${angle}deg)`;

        document.body.appendChild(line);

        // Remove line after animation
        setTimeout(() => line.remove(), 600);
    }

    document.body.appendChild(trail);

    // Remove trail after animation completes
    setTimeout(() => {
        trail.remove();
        const index = trailPositions.findIndex(p => p.element === trail);
        if (index > -1) trailPositions.splice(index, 1);
    }, 800);
});

// ============================================
// HEADER SCROLL EFFECT
// ============================================
const header = document.getElementById('header');
let lastScroll = 0;

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;

    if (currentScroll > 100) {
        header.classList.add('scrolled');
    } else {
        header.classList.remove('scrolled');
    }

    lastScroll = currentScroll;
});

// ============================================
// MOBILE MENU TOGGLE
// ============================================
const mobileMenuToggle = document.getElementById('mobileMenuToggle');
const navMenu = document.getElementById('navMenu');

if (mobileMenuToggle) {
    mobileMenuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        mobileMenuToggle.classList.toggle('active');
    });
}

// Close mobile menu when clicking on a link
const navLinks = document.querySelectorAll('.nav-link');
navLinks.forEach(link => {
    link.addEventListener('click', () => {
        if (window.innerWidth <= 768) {
            navMenu.classList.remove('active');
            mobileMenuToggle.classList.remove('active');
        }
    });
});

// ============================================
// SMOOTH SCROLL
// ============================================
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));

        if (target) {
            const headerOffset = 80;
            const elementPosition = target.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

            window.scrollTo({
                top: offsetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// ============================================
// TYPEWRITER EFFECT
// ============================================
const typewriterElement = document.getElementById('typewriter');
const texts = [
    'Economista',
    'Administrador de Empresas',
    'Master en Gestion Financiera',
    'Master en Población y Desarrollo',
    'Doctorante en Ciencias de la Ingenieria',
    'Desarrollador FinTech',
    'Experto en Trading Algorítmico',
    'Desarrollador Blockchain',
    'Especialista en DeFi',
    'Ingeniero de IA Financiera'
];

let textIndex = 0;
let charIndex = 0;
let isDeleting = false;
let typeSpeed = 100;

function typeWriter() {
    if (!typewriterElement) return;

    const currentText = texts[textIndex];

    if (isDeleting) {
        typewriterElement.textContent = currentText.substring(0, charIndex - 1);
        charIndex--;
        typeSpeed = 50;
    } else {
        typewriterElement.textContent = currentText.substring(0, charIndex + 1);
        charIndex++;
        typeSpeed = 100;
    }

    if (!isDeleting && charIndex === currentText.length) {
        // Pause at end
        typeSpeed = 2000;
        isDeleting = true;
    } else if (isDeleting && charIndex === 0) {
        isDeleting = false;
        textIndex = (textIndex + 1) % texts.length;
        typeSpeed = 500;
    }

    setTimeout(typeWriter, typeSpeed);
}

// Start typewriter effect
if (typewriterElement) {
    setTimeout(typeWriter, 1000);
}

// ============================================
// PROJECT FILTERING
// ============================================
const filterButtons = document.querySelectorAll('.filter-btn');
const projectCards = document.querySelectorAll('.project-card');

filterButtons.forEach(button => {
    button.addEventListener('click', () => {
        // Remove active class from all buttons
        filterButtons.forEach(btn => btn.classList.remove('active'));
        // Add active class to clicked button
        button.classList.add('active');

        const filter = button.getAttribute('data-filter');

        projectCards.forEach(card => {
            const category = card.getAttribute('data-category');

            if (filter === 'all' || category.includes(filter)) {
                card.style.display = 'block';
                card.classList.add('fade-in');
            } else {
                card.style.display = 'none';
            }
        });
    });
});

// ============================================
// NOTIFICATION SYSTEM
// ============================================
function showNotification(message, type = 'info') {
    // Remove existing notification
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }

    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;

    // Add styles
    Object.assign(notification.style, {
        position: 'fixed',
        top: '100px',
        right: '20px',
        padding: '1rem 1.5rem',
        background: type === 'success' ? 'rgba(0, 255, 65, 0.2)' : 'rgba(255, 0, 64, 0.2)',
        border: `1px solid ${type === 'success' ? '#00ff41' : '#ff0040'}`,
        borderRadius: '0.5rem',
        color: type === 'success' ? '#00ff41' : '#ff0040',
        fontFamily: 'var(--font-mono)',
        fontSize: '0.875rem',
        zIndex: '10000',
        animation: 'slideIn 0.3s ease',
        boxShadow: type === 'success' ? '0 0 20px rgba(0, 255, 65, 0.3)' : '0 0 20px rgba(255, 0, 64, 0.3)'
    });

    // Add to DOM
    document.body.appendChild(notification);

    // Remove after 3 seconds
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Add notification animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// ============================================
// SCROLL ANIMATIONS (ENHANCED: REVEAL + STAGGER)
// ============================================
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            if (entry.target.classList.contains('reveal-section')) {
                entry.target.classList.add('visible');
            } else {
                entry.target.classList.add('fade-in');
            }
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe elements for scroll animations
const animateOnScroll = document.querySelectorAll('.project-card, .course-card, .blog-card, .contact-item');
animateOnScroll.forEach(el => observer.observe(el));

// FEATURE 2: Observe section-level reveals
const revealSections = document.querySelectorAll('.reveal-section');
revealSections.forEach(el => observer.observe(el));

// FEATURE 2: Observe staggered children with delay
const staggerContainers = document.querySelectorAll('.reveal-stagger');
staggerContainers.forEach(container => {
    const children = container.children;
    Array.from(children).forEach((child, i) => {
        child.style.transitionDelay = (i * 0.08) + 's';
        observer.observe(child);
    });
});

// ============================================
// TICKER ANIMATION WITH LIVE PRICES
// ============================================
const tickerTrackTop = document.getElementById('tickerTrackTop');
const tickerTrackBottom = document.getElementById('tickerTrackBottom');

// CoinGecko id for each ticker symbol shown on the page
const TICKER_COINS = {
    btc: 'bitcoin',
    eth: 'ethereum',
    bnb: 'binancecoin',
    sol: 'solana',
    ada: 'cardano',
    dot: 'polkadot',
    xrp: 'ripple',
    doge: 'dogecoin',
    avax: 'avalanche-2',
    matic: 'matic-network',
    link: 'chainlink',
    ltc: 'litecoin'
};

// Function to fetch live crypto prices (all coins shown in the ticker)
async function fetchCryptoPrices() {
    try {
        // Using CoinGecko API (free, no API key required)
        const ids = Object.values(TICKER_COINS).join(',');
        const response = await fetch(`https://api.coingecko.com/api/v3/simple/price?ids=${ids}&vs_currencies=usd&include_24hr_change=true`);
        const data = await response.json();

        const prices = {};
        for (const [symbol, id] of Object.entries(TICKER_COINS)) {
            if (data[id] && typeof data[id].usd === 'number') {
                prices[symbol] = {
                    price: data[id].usd,
                    change: typeof data[id].usd_24h_change === 'number' ? data[id].usd_24h_change : 0
                };
            }
        }
        return prices;
    } catch (error) {
        console.error('Error fetching crypto prices:', error);
        return null;
    }
}

// Function to format price
function formatPrice(price) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2,
        maximumFractionDigits: price < 1 ? 4 : 2
    }).format(price);
}

// Function to format percentage
function formatPercentage(change) {
    const sign = change >= 0 ? '+' : '';
    return `${sign}${change.toFixed(2)}%`;
}

// Update the price/change text of every ticker item for a given coin,
// without touching the surrounding DOM so the scroll animation never restarts
function updateTickerItem(symbol, data) {
    const isUp = data.change >= 0;
    document.querySelectorAll(`.ticker-item[data-coin="${symbol}"]`).forEach((item) => {
        item.querySelector('.ticker-price').textContent = formatPrice(data.price);
        const changeEl = item.querySelector('.ticker-change');
        changeEl.textContent = `${isUp ? '▲' : '▼'} ${formatPercentage(data.change)}`;
        changeEl.classList.toggle('up', isUp);
        changeEl.classList.toggle('down', !isUp);
    });
}

// Function to update ticker with live prices
async function updateTicker() {
    if (!tickerTrackTop && !tickerTrackBottom) return;

    const prices = await fetchCryptoPrices();
    if (!prices) return;

    for (const [symbol, data] of Object.entries(prices)) {
        updateTickerItem(symbol, data);
    }
}

// Initialize ticker with live prices
if (tickerTrackTop || tickerTrackBottom) {
    updateTicker(); // Initial load
    setInterval(updateTicker, 60000); // Update every 60 seconds
}

// ============================================
// DIGITAL PARTICLES
// ============================================
function createParticle() {
    if (window.innerWidth <= 768) return; // Don't create particles on mobile

    const particle = document.createElement('div');
    particle.className = 'digital-particle';

    const startX = Math.random() * window.innerWidth;
    const duration = 3 + Math.random() * 4;
    const size = 1 + Math.random() * 2;

    Object.assign(particle.style, {
        left: `${startX}px`,
        top: '-10px',
        width: `${size}px`,
        height: `${size}px`,
        animationDuration: `${duration}s`
    });

    document.body.appendChild(particle);

    setTimeout(() => particle.remove(), duration * 1000);
}

// Create particles periodically
if (window.innerWidth > 768) {
    setInterval(createParticle, 300);
}

// Add particle styles
const particleStyle = document.createElement('style');
particleStyle.textContent = `
    .digital-particle {
        position: fixed;
        background: var(--color-accent-cyan);
        border-radius: 50%;
        pointer-events: none;
        z-index: 1;
        animation: particleFall linear forwards;
        opacity: 0.6;
    }
    
    @keyframes particleFall {
        0% {
            transform: translateY(0) translateX(0);
            opacity: 0.6;
        }
        100% {
            transform: translateY(100vh) translateX(50px);
            opacity: 0;
        }
    }
`;
document.head.appendChild(particleStyle);

// ============================================
// PERFORMANCE OPTIMIZATIONS
// ============================================

// Debounce function for scroll events
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Lazy load images
const images = document.querySelectorAll('img[data-src]');
const imageObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const img = entry.target;
            img.src = img.dataset.src;
            img.removeAttribute('data-src');
            imageObserver.unobserve(img);
        }
    });
});

images.forEach(img => imageObserver.observe(img));

// ============================================
// ACTIVE NAV LINK HIGHLIGHTING
// ============================================
const sections = document.querySelectorAll('section[id]');

function highlightNavLink() {
    const scrollPosition = window.pageYOffset + 100;

    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.offsetHeight;
        const sectionId = section.getAttribute('id');

        if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${sectionId}`) {
                    link.classList.add('active');
                }
            });
        }
    });
}

window.addEventListener('scroll', debounce(highlightNavLink, 100));

// ============================================
// INITIALIZE ON PAGE LOAD
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    console.log('🚀 FinTech Portfolio Loaded');

    // Add fade-in animation to hero
    const hero = document.querySelector('.hero-content');
    if (hero) {
        setTimeout(() => hero.classList.add('fade-in'), 100);
    }

    // Highlight current nav link
    highlightNavLink();
});

// ============================================
// PREVENT CONTEXT MENU ON PRODUCTION (OPTIONAL)
// ============================================
// Uncomment to disable right-click
// document.addEventListener('contextmenu', (e) => e.preventDefault());

// ============================================
// CONSOLE MESSAGE
// ============================================
console.log('%c🚀 FinTech Portfolio', 'color: #00d4ff; font-size: 20px; font-weight: bold;');
console.log('%cDeveloped with ❤️ using modern web technologies', 'color: #00ff41; font-size: 12px;');
console.log('%cInterested in the code? Check out the GitHub repo!', 'color: #a855f7; font-size: 12px;');

// ============================================
// COOKIE CONSENT BANNER
// ============================================
(function () {
    const cookieBanner = document.getElementById('cookieBanner');
    const acceptBtn = document.getElementById('acceptCookies');
    const rejectBtn = document.getElementById('rejectCookies');

    // Check if user has already made a choice
    function checkCookieConsent() {
        const consent = localStorage.getItem('cookieConsent');
        if (!consent && cookieBanner) {
            // Show banner after 1 second
            setTimeout(() => {
                cookieBanner.style.display = 'block';
                cookieBanner.style.animation = 'slideUp 0.4s ease-out forwards';
            }, 1000);
        }
    }

    // Accept all cookies
    if (acceptBtn) {
        acceptBtn.addEventListener('click', () => {
            localStorage.setItem('cookieConsent', 'accepted');
            hideBanner();
            enableAnalytics();
            showNotification('Preferencias de cookies guardadas', 'success');
        });
    }

    // Reject optional cookies
    if (rejectBtn) {
        rejectBtn.addEventListener('click', () => {
            localStorage.setItem('cookieConsent', 'rejected');
            hideBanner();
            showNotification('Solo cookies esenciales activas', 'success');
        });
    }

    // Hide banner with animation
    function hideBanner() {
        if (cookieBanner) {
            cookieBanner.style.animation = 'slideDown 0.4s ease-in forwards';
            setTimeout(() => {
                cookieBanner.style.display = 'none';
            }, 400);
        }
    }

    // Enable Google Analytics if cookies accepted
    function enableAnalytics() {
        if (typeof gtag !== 'undefined') {
            gtag('consent', 'update', {
                'analytics_storage': 'granted'
            });
            gtag('config', 'G-XXXXXXXXXX');
        }
    }

    // Initialize on page load
    checkCookieConsent();

    // Add animations CSS
    const cookieStyle = document.createElement('style');
    cookieStyle.textContent = `
        @keyframes slideUp {
            from {
                transform: translateY(100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        @keyframes slideDown {
            from {
                transform: translateY(0);
                opacity: 1;
            }
            to {
                transform: translateY(100%);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(cookieStyle);
})();

// ============================================
// LANGUAGE SWITCHER INIT
// ============================================
(function(){
  var container = document.getElementById('langSwitcher');
  if (!container) return;
  var lang = localStorage.getItem('lang') || 'es';
  var esActive = lang === 'es' ? ' active' : '';
  var enActive = lang === 'en' ? ' active' : '';
  container.innerHTML = '<div class="lang-switcher"><button class="lang-btn' + esActive + '" onclick="I18N.setLanguage(\'es\')" title="Español" aria-label="Cambiar idioma a español">ES</button><button class="lang-btn' + enActive + '" onclick="I18N.setLanguage(\'en\')" title="English" aria-label="Switch language to English">EN</button></div>';
})();

// ============================================
// DYNAMIC COPYRIGHT YEAR
// ============================================
(function(){
  var y = document.getElementById('currentYear');
  if (y) { y.textContent = new Date().getFullYear(); }
})();

// ============================================
// FEATURE 1: TERMINAL INTERACTIVA
// ============================================
(function(){
  var termBody = document.getElementById('terminalBody');
  var termInput = document.getElementById('termInput');
  var termInputLine = document.getElementById('termInputLine');
  if (!termBody || !termInput) return;

  var commands = {
    help: function(){
      return '<span class="term-success">Comandos disponibles:</span><br>' +
        '  <span class="term-highlight">help</span>      — Muestra esta ayuda<br>' +
        '  <span class="term-highlight">whoami</span>    — ¿Quién soy?<br>' +
        '  <span class="term-highlight">skills</span>    — Habilidades técnicas<br>' +
        '  <span class="term-highlight">projects</span>  — Proyectos destacados<br>' +
        '  <span class="term-highlight">courses</span>   — Catálogo de cursos<br>' +
        '  <span class="term-highlight">contact</span>   — Información de contacto<br>' +
        '  <span class="term-highlight">clear</span>     — Limpiar terminal<br>' +
        '  <span class="term-highlight">date</span>      — Fecha actual<br>' +
        '  <span class="term-highlight">neofetch</span>  — Información del sistema<br>' +
        '  <span class="term-highlight">matrix</span>    — Wake up, Neo...<br>' +
        '  <span class="term-highlight">sudo</span>      — Modo superusuario';
    },
    whoami: function(){
      return 'Israel Romero Apo — FinTech Developer. 5+ años en trading algorítmico, blockchain y DeFi.';
    },
    skills: function(){
      return '<span class="term-highlight">Lenguajes:</span> Python (95%), JavaScript/TS (85%), Solidity (80%), MQL5 (85%), C++ (70%), SQL (90%)<br>' +
        '<span class="term-highlight">Frameworks:</span> React/Next.js (75%), Node.js (80%)<br>' +
        '<span class="term-highlight">Especialidades:</span> Trading Algorítmico, Blockchain, DeFi, IA Financiera';
    },
    projects: function(){
      return 'Proyectos destacados:<br>' +
        '  • <a href="proyectos/demo-trading-bot.html" style="color:#00d4ff;">Trading Bot AI</a> — Sistema de trading con ML<br>' +
        '  • <a href="proyectos/demo-defi-dashboard.html" style="color:#00d4ff;">DeFi Dashboard</a> — Análisis multi-chain<br>' +
        '  • <a href="proyectos/demo-risk-analytics.html" style="color:#00d4ff;">Risk Analytics Engine</a> — Motor de riesgo financiero<br>' +
        '  • <a href="proyectos/demo-crypto-screener.html" style="color:#00d4ff;">Crypto Screener Pro</a> — Scanner de criptomonedas';
    },
    courses: function(){
      return 'Catálogo de cursos: <a href="cursos/index.html" style="color:#00d4ff;">Ver catálogo completo →</a>';
    },
    contact: function(){
      return '<span class="term-highlight">WhatsApp:</span> +591 7485 6380<br>' +
        '<span class="term-highlight">Email:</span> israelromeroapo@gmail.com';
    },
    date: function(){
      return new Date().toString();
    },
    neofetch: function(){
      return '<pre style="color:#00ff41;font-size:.75rem;line-height:1.3;margin:0;">' +
        '      ████████████      <span style="color:#00d4ff;">israel</span><span style="color:#fff;">@</span><span style="color:#00d4ff;">portfolio</span>\n' +
        '    ██            ██    <span style="color:#00d4ff;">-------------------</span>\n' +
        '  ██    ██    ██    ██  <span style="color:#fff;">OS:</span> FinTech OS v5.0\n' +
        '  ██  ██  ██  ██  ██  <span style="color:#fff;">Host:</span> Blockchain Node\n' +
        '  ██            ██  <span style="color:#fff;">Kernel:</span> 15.0.0-finance\n' +
        '    ██  ██████  ██    <span style="color:#fff;">Uptime:</span> 5+ years\n' +
        '      ██      ██      <span style="color:#fff;">Shell:</span> zsh 5.9\n' +
        '        ████████        <span style="color:#fff;">CPU:</span> Brain v1.0 @ 3.2GHz\n' +
        '                        <span style="color:#fff;">RAM:</span> 16GB / 32GB\n' +
        '</pre>';
    },
    matrix: function(){
      triggerMatrixEffect();
      return '<span class="term-success">Wake up, Neo... The Matrix has you.</span>';
    },
    sudo: function(){
      return '<span class="term-error">⛔ Acceso root concedido... es broma 😄</span>';
    }
  };

  function addOutput(html, cls){
    var div = document.createElement('div');
    div.className = 'term-output' + (cls ? ' ' + cls : '');
    div.innerHTML = html;
    termBody.insertBefore(div, termInputLine);
  }

  function addHistory(cmd){
    var div = document.createElement('div');
    div.className = 'term-line';
    div.innerHTML = '<span class="term-prompt">guest@portfolio:~$</span> <span class="term-cmd">' + cmd + '</span>';
    termBody.insertBefore(div, termInputLine);
  }

  function clearTerminal(){
    var lines = termBody.querySelectorAll('.term-line,.term-output');
    var inputs = termBody.querySelectorAll('.term-line');
    for(var i = 0; i < lines.length; i++){
      if(lines[i] !== termInputLine) lines[i].remove();
    }
  }

  function handleCommand(cmd){
    cmd = cmd.trim().toLowerCase();
    if(!cmd) return;
    addHistory(cmd);
    if(cmd === 'clear'){
      clearTerminal();
    } else if(commands[cmd]){
      addOutput(commands[cmd]());
    } else {
      addOutput('<span class="term-error">Comando no encontrado: ' + cmd + '</span>. Escribe <span class="term-highlight">help</span> para ver los comandos disponibles.');
    }
    termBody.scrollTop = termBody.scrollHeight;
  }

  termInput.addEventListener('keydown', function(e){
    if(e.key === 'Enter'){
      e.preventDefault();
      var cmd = termInput.value;
      termInput.value = '';
      handleCommand(cmd);
    }
  });

  // Keep focus on terminal input
  termBody.addEventListener('click', function(){
    termInput.focus();
  });

  // Focus input on load
  termInput.focus();
})();

// ============================================
// FEATURE 2: RADAR CHART DE SKILLS
// ============================================
(function(){
  function createRadarChart(){
    var canvas = document.getElementById('skillsRadar');
    if(!canvas || typeof Chart === 'undefined') return;
    var ctx = canvas.getContext('2d');
    new Chart(ctx, {
      type: 'radar',
      data: {
        labels: ['Python', 'JavaScript/TS', 'Solidity', 'MQL5', 'C++', 'SQL', 'React/Next.js', 'Node.js'],
        datasets: [{
          label: 'Nivel de Habilidad',
          data: [95, 85, 80, 85, 70, 90, 75, 80],
          backgroundColor: 'rgba(0,212,255,0.15)',
          borderColor: 'rgba(0,212,255,0.8)',
          borderWidth: 2,
          pointBackgroundColor: 'rgba(0,255,65,0.9)',
          pointBorderColor: '#00ff41',
          pointHoverBackgroundColor: '#a855f7',
          pointHoverBorderColor: '#a855f7',
          pointRadius: 4,
          pointHoverRadius: 6
        }]
      },
      options: {
        animation: { duration: 1500, easing: 'easeOutQuart' },
        responsive: true,
        maintainAspectRatio: true,
        plugins: { legend: { display: false } },
        scales: {
          r: {
            beginAtZero: true,
            max: 100,
            ticks: { display: false, stepSize: 20 },
            pointLabels: { color: '#aaa', font: { size: 11, family: "'JetBrains Mono', monospace" } },
            grid: { color: 'rgba(255,255,255,0.08)' },
            angleLines: { color: 'rgba(255,255,255,0.08)' }
          }
        }
      }
    });
  }

  if(document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', createRadarChart);
  } else {
    createRadarChart();
  }
})();

// ============================================
// FEATURE 3: EASTER EGGS — KONAMI CODE + SUDO
// ============================================
(function(){
  if(sessionStorage.getItem('konamiActivated') === 'true') return;

  var konamiCode = [38,38,40,40,37,39,37,39,66,65]; // ↑↑↓↓←→←→BA
  var konamiIndex = 0;
  var konamiTimer = null;

  document.addEventListener('keydown', function(e){
    if(e.keyCode === konamiCode[konamiIndex]){
      konamiIndex++;
      if(konamiTimer) clearTimeout(konamiTimer);
      konamiTimer = setTimeout(function(){ konamiIndex = 0; }, 2000);
      if(konamiIndex === konamiCode.length){
        sessionStorage.setItem('konamiActivated', 'true');
        showKonamiOverlay();
        konamiIndex = 0;
      }
    } else {
      konamiIndex = 0;
    }
  });

  function showKonamiOverlay(){
    var overlay = document.createElement('div');
    overlay.className = 'konami-overlay';
    overlay.innerHTML = '<h2>🏆 MODO HACKER ACTIVADO 🏆</h2><p>Código Konami detectado. Bienvenido al modo secreto.</p><button id="konamiClose">CERRAR</button>';
    document.body.appendChild(overlay);
    document.getElementById('konamiClose').addEventListener('click', function(){
      overlay.style.animation = 'konamiFadeIn .3s ease reverse';
      setTimeout(function(){ overlay.remove(); }, 300);
    });
  }
})();

// ============================================
// FEATURE 4: EFECTO PARALLAX EN ORBES DEL HERO
// ============================================
(function(){
  document.addEventListener('mousemove', function(e){
    var orb1 = document.querySelector('.orb-1');
    var orb2 = document.querySelector('.orb-2');
    var orb3 = document.querySelector('.orb-3');
    if(orb1){
      var x1 = (e.clientX / window.innerWidth - 0.5) * 20;
      var y1 = (e.clientY / window.innerHeight - 0.5) * 20;
      orb1.style.transform = 'translate(' + x1 + 'px, ' + y1 + 'px)';
    }
    if(orb2){
      var x2 = (e.clientX / window.innerWidth - 0.5) * -30;
      var y2 = (e.clientY / window.innerHeight - 0.5) * -30;
      orb2.style.transform = 'translate(' + x2 + 'px, ' + y2 + 'px)';
    }
    if(orb3){
      var x3 = (e.clientX / window.innerWidth - 0.5) * 15;
      var y3 = (e.clientY / window.innerHeight - 0.5) * -20;
      orb3.style.transform = 'translate(' + x3 + 'px, ' + y3 + 'px)';
    }
  });
})();

// ============================================
// FEATURE 5: CONTADOR DE VISITAS SIMULADO
// ============================================
(function(){
  var el = document.getElementById('learnerCount');
  if(!el) return;
  function updateCount(){
    var base = 1200;
    var variation = Math.floor(Math.random() * 200);
    var count = base + variation;
    el.textContent = count.toLocaleString();
  }
  updateCount();
  setInterval(updateCount, 30000);
})();

// ============================================
// MATRIX RAIN EFFECT (for terminal matrix cmd)
// ============================================
function triggerMatrixEffect(){
  var canvas = document.createElement('canvas');
  canvas.style.position = 'fixed';
  canvas.style.top = '0';
  canvas.style.left = '0';
  canvas.style.width = '100%';
  canvas.style.height = '100%';
  canvas.style.zIndex = '99998';
  canvas.style.pointerEvents = 'none';
  document.body.appendChild(canvas);

  var ctx = canvas.getContext('2d');
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  var chars = 'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789';
  var drops = [];
  var fontSize = 14;
  var columns = Math.floor(canvas.width / fontSize);
  for(var i = 0; i < columns; i++) drops[i] = Math.random() * -100;

  function draw(){
    ctx.fillStyle = 'rgba(0,0,0,0.05)';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = '#0F0';
    ctx.font = fontSize + 'px monospace';
    for(var i = 0; i < drops.length; i++){
      var char = chars[Math.floor(Math.random() * chars.length)];
      ctx.fillText(char, i * fontSize, drops[i] * fontSize);
      if(drops[i] * fontSize > canvas.height && Math.random() > 0.975) drops[i] = 0;
      drops[i]++;
    }
  }

  var interval = setInterval(draw, 35);
  setTimeout(function(){
    clearInterval(interval);
    canvas.style.transition = 'opacity 0.5s';
    canvas.style.opacity = '0';
    setTimeout(function(){ canvas.remove(); }, 500);
  }, 4000);
}

// ============================================
// NUEVA FEATURE 1: THREE.JS PARTICLE NETWORK (CANVAS HERO)
// ============================================
(function(){
  if (typeof THREE === 'undefined') return;

  var canvas = document.getElementById('heroCanvas');
  if (!canvas) return;

  var scene, camera, renderer, particleSystem, linesMesh;
  var mouseTargetX = 0, mouseTargetY = 0;
  var currentMouseX = 0, currentMouseY = 0;
  var PARTICLE_COUNT = 100;
  var CONNECT_DISTANCE = 80;
  var particles = [];

  function createGlowTexture(colorHex) {
    var texCanvas = document.createElement('canvas');
    texCanvas.width = 32;
    texCanvas.height = 32;
    var ctx = texCanvas.getContext('2d');
    var gradient = ctx.createRadialGradient(16, 16, 0, 16, 16, 16);
    gradient.addColorStop(0, colorHex);
    gradient.addColorStop(0.2, colorHex);
    gradient.addColorStop(0.5, 'rgba(0,0,0,0)');
    gradient.addColorStop(1, 'rgba(0,0,0,0)');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, 32, 32);
    return new THREE.CanvasTexture(texCanvas);
  }

  function init() {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 200);
    camera.position.z = 50;

    renderer = new THREE.WebGLRenderer({ canvas: canvas, alpha: true, antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setClearColor(0x000000, 0);

    var accentColors = ['#00d4ff', '#00ff41', '#a855f7'];
    var threeColors = [
      new THREE.Color('#00d4ff'),
      new THREE.Color('#00ff41'),
      new THREE.Color('#a855f7')
    ];

    var positions = new Float32Array(PARTICLE_COUNT * 3);
    var colorsAttr = new Float32Array(PARTICLE_COUNT * 3);

    for (var i = 0; i < PARTICLE_COUNT; i++) {
      var x = (Math.random() - 0.5) * 80;
      var y = (Math.random() - 0.5) * 50;
      var z = (Math.random() - 0.5) * 40;

      positions[i * 3] = x;
      positions[i * 3 + 1] = y;
      positions[i * 3 + 2] = z;

      var col = threeColors[Math.floor(Math.random() * threeColors.length)];
      colorsAttr[i * 3] = col.r;
      colorsAttr[i * 3 + 1] = col.g;
      colorsAttr[i * 3 + 2] = col.b;

      particles.push({
        x: x, y: y, z: z,
        vx: (Math.random() - 0.5) * 0.03,
        vy: (Math.random() - 0.5) * 0.03,
        vz: (Math.random() - 0.5) * 0.03
      });
    }

    var geometry = new THREE.BufferGeometry();
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    geometry.setAttribute('color', new THREE.BufferAttribute(colorsAttr, 3));

    var texture = createGlowTexture('rgba(0,212,255,1)');

    var material = new THREE.PointsMaterial({
      size: 1.2,
      map: texture,
      blending: THREE.AdditiveBlending,
      depthWrite: false,
      vertexColors: true,
      transparent: true,
      opacity: 0.85
    });

    particleSystem = new THREE.Points(geometry, material);
    scene.add(particleSystem);

    // Lines geometry (pre-allocate)
    var maxLines = PARTICLE_COUNT * PARTICLE_COUNT;
    var lineGeometry = new THREE.BufferGeometry();
    var linePositionsArr = new Float32Array(maxLines * 6);
    lineGeometry.setAttribute('position', new THREE.BufferAttribute(linePositionsArr, 3));
    lineGeometry.setDrawRange(0, 0);

    var lineMaterial = new THREE.LineBasicMaterial({
      color: 0x00d4ff,
      transparent: true,
      opacity: 0.12,
      blending: THREE.AdditiveBlending,
      depthWrite: false
    });

    linesMesh = new THREE.LineSegments(lineGeometry, lineMaterial);
    scene.add(linesMesh);

    document.addEventListener('mousemove', function(e) {
      mouseTargetX = (e.clientX / window.innerWidth) * 2 - 1;
      mouseTargetY = -(e.clientY / window.innerHeight) * 2 + 1;
    });

    window.addEventListener('resize', onResize);

    animate();
  }

  function onResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
  }

  function animate() {
    requestAnimationFrame(animate);

    currentMouseX += (mouseTargetX - currentMouseX) * 0.05;
    currentMouseY += (mouseTargetY - currentMouseY) * 0.05;

    var posArr = particleSystem.geometry.attributes.position.array;
    var screenPositions = [];

    for (var i = 0; i < PARTICLE_COUNT; i++) {
      var p = particles[i];
      var idx = i * 3;

      p.x += p.vx;
      p.y += p.vy;
      p.z += p.vz;

      if (Math.abs(p.x) > 40) p.vx *= -1;
      if (Math.abs(p.y) > 25) p.vy *= -1;
      if (Math.abs(p.z) > 20) p.vz *= -1;

      p.x += currentMouseX * 0.015;
      p.y += currentMouseY * 0.015;

      posArr[idx] = p.x;
      posArr[idx + 1] = p.y;
      posArr[idx + 2] = p.z;

      var vector = new THREE.Vector3(p.x, p.y, p.z);
      vector.project(camera);
      var sx = (vector.x * window.innerWidth) / 2 + window.innerWidth / 2;
      var sy = -(vector.y * window.innerHeight) / 2 + window.innerHeight / 2;
      screenPositions.push({ x: sx, y: sy });
    }

    particleSystem.geometry.attributes.position.needsUpdate = true;

    var lineArr = linesMesh.geometry.attributes.position.array;
    var lineIdx = 0;
    var lineCount = 0;
    var maxLineElements = Math.floor(lineArr.length / 6);

    for (var i = 0; i < PARTICLE_COUNT; i++) {
      for (var j = i + 1; j < PARTICLE_COUNT; j++) {
        var dx = screenPositions[i].x - screenPositions[j].x;
        var dy = screenPositions[i].y - screenPositions[j].y;
        var dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < CONNECT_DISTANCE && lineCount < maxLineElements) {
          var pi = particles[i];
          var pj = particles[j];
          lineArr[lineIdx] = pi.x;
          lineArr[lineIdx + 1] = pi.y;
          lineArr[lineIdx + 2] = pi.z;
          lineArr[lineIdx + 3] = pj.x;
          lineArr[lineIdx + 4] = pj.y;
          lineArr[lineIdx + 5] = pj.z;
          lineIdx += 6;
          lineCount++;
        }
      }
    }

    for (var k = lineIdx; k < lineArr.length; k++) {
      lineArr[k] = 0;
    }

    linesMesh.geometry.setDrawRange(0, lineCount * 2);
    linesMesh.geometry.attributes.position.needsUpdate = true;

    scene.rotation.y += 0.0003;
    scene.rotation.x += 0.0001;

    renderer.render(scene, camera);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();

// ============================================
// FEATURE: AI TUTOR — KNOWLEDGE BASE
// ============================================
var AI_KNOWLEDGE = {
  'mco':'Mínimos Cuadrados Ordinarios: método para estimar la recta que mejor se ajusta a los datos minimizando la suma de errores al cuadrado. Fórmula: β̂ = (X\'X)⁻¹X\'Y. Se estudia en Econometría → Curso 1.',
  'regresion':'La regresión lineal modela la relación entre una variable dependiente Y y variables independientes X. Y = β₀ + β₁X + ε. Curso: Econometría Fundamentos.',
  'r2':'R² (Coeficiente de Determinación): mide qué proporción de la variabilidad de Y es explicada por el modelo. R²=1 significa ajuste perfecto.',
  'hipotesis':'Una prueba de hipótesis evalúa si hay suficiente evidencia para rechazar una afirmación sobre un parámetro. Se usa el p-value: si p<0.05 se rechaza H₀.',
  'bitcoin':'Bitcoin: primera criptomoneda descentralizada creada en 2009 por Satoshi Nakamoto. Usa Proof-of-Work. Suministro máximo: 21 millones. Curso: Blockchain → Fundamentos.',
  'ethereum':'Ethereum: plataforma blockchain con smart contracts. Segunda criptomoneda por capitalización. Usa Proof-of-Stake desde The Merge (2022). Curso: Blockchain → Curso 2.',
  'blockchain':'Blockchain: cadena de bloques descentralizada e inmutable. Base de criptomonedas, DeFi, NFTs y tokenización. Programa completo de 6 cursos disponible.',
  'defi':'DeFi (Finanzas Descentralizadas): ecosistema de apps financieras sin intermediarios. Préstamos, exchanges descentralizados, yield farming. Curso: Blockchain → Curso 2.',
  'python':'Python: lenguaje de programación interpretado de alto nivel. Ideal para data science, finanzas y automatización. Programas: Python Básico → Medio → Avanzado.',
  'pandas':'Pandas: librería Python para análisis de datos. DataFrames, Series, groupby, merge. Curso: Python Básico → Datos y Data Science I.',
  'sql':'SQL: Structured Query Language para gestionar bases de datos relacionales. SELECT, INSERT, UPDATE, DELETE. Programas: SQL Básico → Medio → Avanzado.',
  'solidity':'Solidity: lenguaje de programación para smart contracts en Ethereum. Similar a JavaScript/C++. Se usa con Hardhat o Foundry. Curso: Blockchain y Smart Contracts.',
  'garch':'GARCH: modelo para volatilidad en series financieras. Captura el "volatility clustering" donde alta volatilidad tiende a persistir. Curso: Econometría Financiera.',
  'var':'VaR (Value at Risk): medida que estima la pérdida máxima de una inversión en un horizonte dado con cierto nivel de confianza (ej: 95%, 99%). Curso: Finanzas.',
  'sharpe':'Ratio de Sharpe: mide retorno ajustado por riesgo = (Retorno - Tasa libre de riesgo) / Volatilidad. Sharpe > 1 es bueno, > 2 excelente. Curso: Trading y Finanzas.',
  'markowitz':'Teoría de Markowitz: optimización de portafolios maximizando retorno para un nivel de riesgo. La frontera eficiente muestra combinaciones óptimas. Curso: Finanzas.',
  'machine learning':'Machine Learning: rama de IA donde algoritmos aprenden patrones de datos. Árboles, Random Forest, XGBoost, redes neuronales. Cursos: Data Science II y Trading Algorítmico.',
  'deep learning':'Deep Learning: subcampo de ML con redes neuronales profundas. LSTM para series, CNN para imágenes, Transformers para NLP. Curso: Data Science II.',
  'api':'API: Interfaz de Programación de Aplicaciones. REST, GraphQL, WebSockets. FastAPI en Python. Curso: Python Medio → APIs Web.',
  'docker':'Docker: plataforma de contenedores para empaquetar apps. Imágenes, Dockerfiles, docker-compose. Curso: Python Avanzado → DevOps Cloud.',
  'backtesting':'Backtesting: simular estrategia de trading con datos históricos. Métricas: Sharpe ratio, max drawdown, win rate. Curso: Trading Algorítmico.',
  'estadistica':'Estadística: ciencia de recopilar, analizar e interpretar datos. Descriptiva e inferencial. Programa completo de 6 cursos: Probabilidad → Descriptiva → Inferencia → Predictivos → ML → Aplicada.',
  'econometria':'Econometría: aplicación de métodos estadísticos a datos económicos. Programa de 8 cursos: MCO, Avanzada, Causalidad, ML, Series de Tiempo, Micro, Macro y Financiera. Basado en currícula de LSE y Chicago.',
  'metodologia':'Metodología de la Investigación: estudio sistemático de métodos para generar conocimiento. Enfoques cualitativo, cuantitativo y mixto. Programa de 6 cursos con IMRyD y ciencia abierta.',
  'ia':'Inteligencia Artificial: simulación de inteligencia humana por máquinas. Incluye machine learning, deep learning, NLP, agentes autónomos. Cursos: IA para Investigación y Data Science.',
  'tokenizacion':'Tokenización RWA: representación de activos reales en blockchain. Mercado de $31B en 2025. Permite fraccionar propiedades, bonos y arte. Curso: Blockchain → RWA.',
  'solana':'Solana: blockchain de alta velocidad (65K TPS). Usa Proof-of-History. Popular para DeFi y NFTs. Competidor principal de Ethereum.',
  'react':'React: biblioteca JavaScript para interfaces de usuario. Componentes, hooks, estado. Usado con Next.js para SSR. Parte del stack de desarrollo moderno.'
};

// Hook into terminal to support AI queries
(function(){
  var origHandler = window.handleTerminalCommand;
  window.handleTerminalCommand = function(cmd) {
    if (origHandler && typeof origHandler === 'function') {
      var result = origHandler(cmd);
      if (result !== undefined && result !== false) return result;
    }
    // AI knowledge matching
    var input = cmd.toLowerCase().trim();
    for (var key in AI_KNOWLEDGE) {
      if (input.indexOf(key) !== -1 || key.indexOf(input) !== -1) {
        return { type: 'ai', text: AI_KNOWLEDGE[key] };
      }
    }
    return { type: 'unknown', text: 'No tengo información sobre eso. Prueba con: MCO, R², regresión, Bitcoin, Python, SQL, GARCH, DeFi, IA, estadística, econometría...' };
  };
})();

// ============================================
// FEATURE: DAILY STREAK TRACKER
// ============================================
window.updateDailyStreak = function(){
  var key = 'portfolio_streak';
  var data = JSON.parse(localStorage.getItem(key) || '{"lastDate":"","streak":0,"bestStreak":0}');
  var today = new Date().toISOString().split('T')[0];
  var yesterday = new Date(Date.now()-86400000).toISOString().split('T')[0];
  if (data.lastDate === today) return data;
  data.streak = (data.lastDate === yesterday) ? data.streak + 1 : 1;
  data.lastDate = today;
  if (data.streak > data.bestStreak) data.bestStreak = data.streak;
  localStorage.setItem(key, JSON.stringify(data));
  var streakEl = document.getElementById('streakDisplay');
  if (streakEl) streakEl.innerHTML = ' | <span style="color:#ffd700;">🔥 Racha: ' + data.streak + ' día(s)</span>';
  return data;
};

(function(){
  var data = JSON.parse(localStorage.getItem('portfolio_streak') || '{"streak":0}');
  var el = document.getElementById('streakDisplay');
  if (el && data.streak > 0) {
    el.innerHTML = ' | <span style="color:#ffd700;">🔥 Racha: ' + data.streak + ' día(s)</span>';
  }
})();

// ============================================
// FEATURE: LEADERBOARD SIMULATION
// ============================================
(function(){
  var list = document.getElementById('leaderboardList');
  var you = document.getElementById('leaderboardYou');
  if (!list) return;
  var names = ['CryptoTrader99','QuantMaster','DataWizard','BlockchainDev','PyAlgo','ML_Fenix','FinTechPro','StatGenius','TradingBotX','Sol_Sage'];
  var userPoints = 0;
  for (var i=0; i<localStorage.length; i++) {
    var k = localStorage.key(i);
    if (k.indexOf('_progress')>0) { try{ userPoints += JSON.parse(localStorage.getItem(k)).length*10; }catch(e){} }
  }
  userPoints = Math.max(userPoints, 30);
  var entries = names.map(function(n){ return {name:n,pts:Math.floor(Math.random()*2000)+200}; });
  entries.push({name:'TÚ',pts:userPoints,isYou:true});
  entries.sort(function(a,b){return b.pts-a.pts;});
  entries.slice(0,5).forEach(function(e,i){
    var row = document.createElement('div');
    row.className = 'leaderboard-row';
    if (e.isYou){ row.style.color='#00d4ff'; row.style.fontWeight='700'; }
    row.innerHTML = '<span class="rank">#'+(i+1)+'</span><span class="name">'+(e.isYou?'👉 ':'')+e.name+'</span><span class="pts">'+e.pts+' pts</span>';
    list.appendChild(row);
  });
  var rank = entries.findIndex(function(e){return e.isYou;})+1;
  if (you) you.textContent = 'Tu posición: #'+rank+' — ¡Sigue aprendiendo para subir!';
})();

// ============================================
// FEATURE: QUICK PRACTICE MODE
// ============================================
var QUICK_QUESTIONS = [
  {q:'¿Qué mide el coeficiente R²?', opts:['La varianza del error','La proporción de varianza explicada','El tamaño de la muestra','El valor p'], ans:1, course:'Econometría'},
  {q:'¿Qué es un smart contract?', opts:['Un contrato físico digitalizado','Código auto-ejecutable en blockchain','Un acuerdo legal en PDF','Una wallet digital'], ans:1, course:'Blockchain'},
  {q:'¿Cuál es el comando SQL para obtener datos?', opts:['GET','SELECT','FETCH','QUERY'], ans:1, course:'SQL Básico'},
  {q:'En Python, ¿qué hace pandas?', opts:['Análisis de datos con DataFrames','Crear gráficos 3D','Minar criptomonedas','Enviar emails'], ans:0, course:'Python Básico'},
  {q:'¿Qué es el Sharpe Ratio?', opts:['Medida de liquidez','Retorno ajustado por riesgo','Indicador de volumen','Tasa de interés'], ans:1, course:'Finanzas'},
  {q:'¿Qué significa GARCH?', opts:['General Algorithm for Risk Control','Heterocedasticidad Condicional Autorregresiva Generalizada','Global Asset Risk Control Hub','Geometric Average Return'], ans:1, course:'Econometría Financiera'},
  {q:'¿Quién creó Bitcoin?', opts:['Vitalik Buterin','Satoshi Nakamoto','Elon Musk','Hal Finney'], ans:1, course:'Blockchain'},
  {q:'¿Qué optimiza Markowitz?', opts:['Velocidad de ejecución','Retorno vs Riesgo del portafolio','Consumo de memoria','Número de transacciones'], ans:1, course:'Finanzas'},
  {q:'¿Cuál NO es un lenguaje de programación?', opts:['Python','Solidity','HTML','MQL5'], ans:2, course:'Desarrollo'},
  {q:'¿Qué mide el p-value?', opts:['Probabilidad del resultado si H₀ es cierta','Tamaño del efecto','Correlación','Error estándar'], ans:0, course:'Estadística'}
];

window.startQuickPractice = function(){
  var qs = QUICK_QUESTIONS.sort(function(){return Math.random()-0.5}).slice(0,3);
  var idx=0, score=0, time=30, timer;
  var modal = document.createElement('div');
  modal.className = 'quick-practice-modal';
  modal.innerHTML = '<div class="quick-practice-card"><h3>🎲 Práctica Rápida</h3><div class="quick-timer" id="qtimer">30s</div><div id="qcontent"></div></div>';
  document.body.appendChild(modal);
  function showQ(){
    if (idx>=qs.length){ showResult(); return; }
    var q=qs[idx];
    var h='<div class="quick-question">Pregunta '+(idx+1)+'/3: '+q.q+'</div><div class="quick-options">';
    q.opts.forEach(function(o,i){ h+='<div class="quick-opt" onclick="window.quickAnswer('+i+')">'+o+'</div>'; });
    document.getElementById('qcontent').innerHTML=h+'</div>';
  }
  window.quickAnswer = function(i){
    var q=qs[idx]; var opts=document.querySelectorAll('.quick-opt');
    opts.forEach(function(o,j){ if(j===q.ans) o.classList.add('correct'); else if(j===i) o.classList.add('wrong'); o.style.pointerEvents='none'; });
    if(i===q.ans) score++; idx++; setTimeout(showQ,800);
  };
  function showResult(){
    clearInterval(timer); var pct=score/3;
    var cls=pct>=0.66?'good':(pct>=0.33?'ok':'bad');
    var msg=pct>=0.66?'¡Excelente! 🎉':(pct>=0.33?'¡Bien! 👍':'Sigue practicando 💪');
    document.getElementById('qtimer').textContent='';
    document.getElementById('qcontent').innerHTML='<div class="quick-result '+cls+'"><h3>'+msg+'</h3><p>Acertaste '+score+' de 3</p><p>📚 Curso: <strong>'+qs[0].course+'</strong></p></div><button class="btn btn-primary" onclick="this.closest(\'.quick-practice-modal\').remove()" style="margin-top:1rem;">Cerrar</button>';
    if(window.updateDailyStreak) window.updateDailyStreak();
  }
  timer=setInterval(function(){time--;document.getElementById('qtimer').textContent=time+'s';if(time<=0){clearInterval(timer);showResult();}},1000);
  showQ();
  modal.addEventListener('click',function(e){if(e.target===modal){clearInterval(timer);modal.remove();}});
};

// ============================================
// FEATURE: SOCIAL SHARE FOR CERTIFICATES
// ============================================
window.shareCertificate = function(title, score){
  var text = '🎓 ¡Completé el curso "' + title + '" con ' + score + '! en israelromero.xyz';
  var url = encodeURIComponent(window.location.href);
  var h = '<div class="quick-practice-modal" onclick="this.remove()"><div class="quick-practice-card"><h3>Compartir Certificado</h3><div style="display:flex;gap:0.8rem;justify-content:center;margin:1.5rem 0;flex-wrap:wrap;">';
  h += '<a href="https://www.linkedin.com/sharing/share-offsite/?url='+url+'" target="_blank" class="btn btn-primary" style="background:#0077b5;">LinkedIn</a>';
  h += '<a href="https://twitter.com/intent/tweet?text='+encodeURIComponent(text)+'&url='+url+'" target="_blank" class="btn btn-primary" style="background:#1da1f2;">Twitter</a>';
  h += '<a href="https://wa.me/?text='+encodeURIComponent(text+' '+url)+'" target="_blank" class="btn btn-primary" style="background:#25d366;">WhatsApp</a>';
  h += '</div><button class="btn btn-secondary" onclick="this.closest(\'.quick-practice-modal\').remove()">Cerrar</button></div></div>';
  document.body.insertAdjacentHTML('beforeend', h);
};

// ============================================
// FEATURE: QR CODE GENERATOR
// ============================================
(function(){
  var el = document.getElementById('contactQR');
  if (!el) return;
  if (typeof QRCode !== 'undefined') {
    new QRCode(el, {
      text: 'https://wa.me/59174856380?text=Hola%20Israel%2C%20vi%20tu%20portfolio',
      width: 130,
      height: 130,
      colorDark: '#000000',
      colorLight: '#ffffff'
    });
  } else {
    el.innerHTML = '<img src="https://api.qrserver.com/v1/create-qr-code/?size=130x130&data=https://wa.me/59174856380" alt="QR WhatsApp" style="display:block;">';
  }
})();

(function(){
  var el = document.getElementById('lastUpdated');
  if (!el) return;
  var months = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
  var d = new Date();
  el.textContent = months[d.getMonth()] + ' ' + d.getFullYear();
})();
