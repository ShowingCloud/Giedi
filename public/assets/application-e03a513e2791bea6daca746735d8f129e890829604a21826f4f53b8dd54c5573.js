// Place all the behaviors and hooks related to the matching controller here.
(function(win) {
  if(!win.CASino) {
    win.CASino = { baseUrl: '/' };
  }

  win.CASino.url = function(path) {
    return win.CASino.baseUrl + path;
  }
})(this);
(function(win, doc) {
  var url = win.CASino.url('login'),
      cookie_regex = /(^|;)\s*tgt=/,
      ready_bound = false;

  function checkCookieExists() {
    var serviceEl = doc.getElementById('service'),
        service = serviceEl ? serviceEl.getAttribute('value') : null;

    if(cookie_regex.test(doc.cookie)) {
      if(service) {
        url += '?service=' + encodeURIComponent(service);
      }
      win.location = url;
    } else {
      setTimeout(checkCookieExists, 1000);
    }
  }

  // Auto-login when logged-in in other browser window (9887c4e)
  doc.addEventListener('DOMContentLoaded', function() {
    if(ready_bound) {
      return;
    }
    ready_bound = true;
    if(doc.getElementById('login-form')) {
      checkCookieExists();
    }
  });

})(this, document);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

;
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function addEventListenerByClass(className, event, fn) {
    var list = document.getElementsByClassName(className);
    for (var i = 0, len = list.length; i < len; i++) {
        list[i].addEventListener(event, fn, false);
    }
}
function refreshCapture(e){
  e.target.src=e.target.src.split('?')[0] + '?' + (new Date()).getTime();
}
window.onload = function () {
  addEventListenerByClass('captcha', 'click', refreshCapture);
}
;
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//


;
