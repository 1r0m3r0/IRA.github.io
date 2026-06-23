var I18N = (function(){
  var lang = localStorage.getItem('lang') || 'es';
  var _data = {};
  var loaded = false;

  function t(key) {
    if (_data[key]) return _data[key];
    return key;
  }

  function load(cb) {
    fetch('assets/lang/' + lang + '.json?t=' + Date.now())
      .then(function(r){ return r.json(); })
      .then(function(d){
        _data = d;
        loaded = true;
        if (cb) cb();
      })
      .catch(function(){
        if (lang !== 'es') {
          lang = 'es';
          localStorage.setItem('lang', 'es');
          load(cb);
        }
      });
  }

  function setLanguage(newLang) {
    if (newLang === lang) return;
    lang = newLang;
    localStorage.setItem('lang', lang);
    location.reload();
  }

  function getLang() { return lang; }

  function apply() {
    document.documentElement.lang = lang;
    document.querySelectorAll('[data-i18n]').forEach(function(el){
      var key = el.getAttribute('data-i18n');
      var val = t(key);
      if (val && val !== key) {
        if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA' || el.tagName === 'SELECT') {
          el.setAttribute('placeholder', val);
        } else {
          el.innerHTML = val;
        }
      }
    });
    document.querySelectorAll('[data-i18n-title]').forEach(function(el){
      var key = el.getAttribute('data-i18n-title');
      var val = t(key);
      if (val && val !== key) el.setAttribute('title', val);
    });
    document.querySelectorAll('[data-i18n-value]').forEach(function(el){
      var key = el.getAttribute('data-i18n-value');
      var val = t(key);
      if (val && val !== key) el.setAttribute('value', val);
    });
  }

  function switcherHTML() {
    var esActive = lang === 'es' ? ' active' : '';
    var enActive = lang === 'en' ? ' active' : '';
    return '<div class="lang-switcher"><button class="lang-btn' + esActive + '" onclick="I18N.setLanguage(\'es\')" title="Español">ES</button><button class="lang-btn' + enActive + '" onclick="I18N.setLanguage(\'en\')" title="English">EN</button></div>';
  }

  return { load:load, t:t, setLanguage:setLanguage, getLang:getLang, apply:apply, switcherHTML:switcherHTML };
})();

document.addEventListener('DOMContentLoaded', function(){
  I18N.load(function(){
    I18N.apply();
  });
});
