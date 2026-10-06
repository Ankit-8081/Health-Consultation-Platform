(function () {
    'use strict';

    // After the first submit the button is disabled and shows "Saving...", so a double click cannot submit twice.
    document.querySelectorAll('form').forEach(function (form) {
        if (form.classList.contains('inline-form')) { return; }
        form.addEventListener('submit', function () {
            var btn = form.querySelector('button[type="submit"]');
            if (!btn) { return; }
            btn.dataset.originalText = btn.textContent;
            btn.disabled = true;
            btn.textContent = 'Saving...';
        });
    });

    // Back button restores the page from cache: put the buttons back.
    window.addEventListener('pageshow', function (event) {
        if (!event.persisted) { return; }
        document.querySelectorAll('button[data-original-text]').forEach(function (btn) {
            btn.disabled = false;
            btn.textContent = btn.dataset.originalText;
        });
    });

    // Show / hide password.
    document.querySelectorAll('.toggle-password').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var input = document.getElementById(btn.dataset.target);
            if (!input) { return; }
            var show = input.type === 'password';
            input.type = show ? 'text' : 'password';
            btn.textContent = show ? 'Hide' : 'Show';
            btn.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
        });
    });
}());
