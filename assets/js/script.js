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
// FORM VALIDATION & SUBMISSION
// ============================================
const contactForm = document.getElementById('contactForm');

if (contactForm) {
    contactForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        // Get form data
        const formData = {
            name: document.getElementById('name').value,
            email: document.getElementById('email').value,
            subject: document.getElementById('subject').value,
            message: document.getElementById('message').value
        };

        // Basic validation
        if (!formData.name || !formData.email || !formData.subject || !formData.message) {
            showNotification('Por favor completa todos los campos', 'error');
            return;
        }

        // Email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(formData.email)) {
            showNotification('Por favor ingresa un email válido', 'error');
            return;
        }

        // Simulate form submission
        const submitButton = contactForm.querySelector('button[type="submit"]');
        const originalText = submitButton.innerHTML;
        submitButton.innerHTML = '<span>Enviando...</span>';
        submitButton.disabled = true;

        // Simulate API call
        setTimeout(() => {
            showNotification('¡Mensaje enviado exitosamente!', 'success');
            contactForm.reset();
            submitButton.innerHTML = originalText;
            submitButton.disabled = false;
        }, 1500);
    });
}

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
// SCROLL ANIMATIONS
// ============================================
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('fade-in');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe elements for scroll animations
const animateOnScroll = document.querySelectorAll('.project-card, .course-card, .blog-card, .contact-item');
animateOnScroll.forEach(el => observer.observe(el));

// ============================================
// TICKER ANIMATION WITH LIVE PRICES
// ============================================
const tickerContent = document.getElementById('tickerContent');

// Function to fetch live crypto prices (Multiple coins)
async function fetchCryptoPrices() {
    try {
        // Using CoinGecko API (free, no API key required)
        const response = await fetch('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,binancecoin,solana,cardano,polkadot&vs_currencies=usd&include_24hr_change=true');
        const data = await response.json();

        return {
            btc: {
                price: data.bitcoin.usd,
                change: data.bitcoin.usd_24h_change
            },
            eth: {
                price: data.ethereum.usd,
                change: data.ethereum.usd_24h_change
            },
            bnb: {
                price: data.binancecoin.usd,
                change: data.binancecoin.usd_24h_change
            },
            sol: {
                price: data.solana.usd,
                change: data.solana.usd_24h_change
            },
            ada: {
                price: data.cardano.usd,
                change: data.cardano.usd_24h_change
            },
            dot: {
                price: data.polkadot.usd,
                change: data.polkadot.usd_24h_change
            }
        };
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
        maximumFractionDigits: 2
    }).format(price);
}

// Function to format percentage
function formatPercentage(change) {
    const sign = change >= 0 ? '+' : '';
    return `${sign}${change.toFixed(2)}%`;
}

// Function to update ticker with live prices
async function updateTicker() {
    if (!tickerContent) return;

    const prices = await fetchCryptoPrices();

    if (prices) {
        // Create ticker items for all cryptocurrencies
        const tickerHTML = `
            <span class="ticker-item ${prices.btc.change >= 0 ? 'up' : 'down'}">
                BTC/USD: ${formatPrice(prices.btc.price)} ${prices.btc.change >= 0 ? '▲' : '▼'} ${formatPercentage(prices.btc.change)}
            </span>
            <span class="ticker-item ${prices.eth.change >= 0 ? 'up' : 'down'}">
                ETH/USD: ${formatPrice(prices.eth.price)} ${prices.eth.change >= 0 ? '▲' : '▼'} ${formatPercentage(prices.eth.change)}
            </span>
            <span class="ticker-item ${prices.bnb.change >= 0 ? 'up' : 'down'}">
                BNB/USD: ${formatPrice(prices.bnb.price)} ${prices.bnb.change >= 0 ? '▲' : '▼'} ${formatPercentage(prices.bnb.change)}
            </span>
            <span class="ticker-item ${prices.sol.change >= 0 ? 'up' : 'down'}">
                SOL/USD: ${formatPrice(prices.sol.price)} ${prices.sol.change >= 0 ? '▲' : '▼'} ${formatPercentage(prices.sol.change)}
            </span>
            <span class="ticker-item ${prices.ada.change >= 0 ? 'up' : 'down'}">
                ADA/USD: ${formatPrice(prices.ada.price)} ${prices.ada.change >= 0 ? '▲' : '▼'} ${formatPercentage(prices.ada.change)}
            </span>
            <span class="ticker-item ${prices.dot.change >= 0 ? 'up' : 'down'}">
                DOT/USD: ${formatPrice(prices.dot.price)} ${prices.dot.change >= 0 ? '▲' : '▼'} ${formatPercentage(prices.dot.change)}
            </span>
        `.repeat(2); // Repeat twice for seamless loop

        // Update ticker content
        tickerContent.innerHTML = tickerHTML;

        // Clone for seamless loop
        const existingClone = tickerContent.parentElement.querySelector('.ticker-content:nth-child(2)');
        if (existingClone) {
            existingClone.remove();
        }
        const tickerClone = tickerContent.cloneNode(true);
        tickerContent.parentElement.appendChild(tickerClone);
    }
}

// Initialize ticker with live prices
if (tickerContent) {
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
