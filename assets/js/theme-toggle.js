(function () {
  var root = document.documentElement;
  var buttons = document.querySelectorAll('[data-theme-choice]');

  function setTheme(theme) {
    root.setAttribute('data-theme', theme);
    try {
      localStorage.setItem('theme', theme);
    } catch (e) {}
    Array.prototype.forEach.call(buttons, function (button) {
      button.classList.toggle('is-active', button.getAttribute('data-theme-choice') === theme);
    });
  }

  Array.prototype.forEach.call(buttons, function (button) {
    button.addEventListener('click', function () {
      setTheme(button.getAttribute('data-theme-choice'));
    });
  });

  setTheme(root.getAttribute('data-theme') || 'light');
})();
