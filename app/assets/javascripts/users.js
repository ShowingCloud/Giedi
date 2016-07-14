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
  var phone_verification = document.getElementById('phone_verification');
  var phone_reset = document.getElementById('phone_reset');
  function get_phone_verification(){
    var request = new XMLHttpRequest();
    var phone = document.getElementById('user_phone').value;
    var captcha = document.getElementById('captcha').value;
    if(phone&&captcha){
      var data = {phone:phone,_rucaptcha:captcha};
      var url = '/phone_verifications?' + Object.keys(data).map(function(k) {
          return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
      }).join('&');

    }else{
      return false;
    }
    request.open('POST', url, true);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    request.setRequestHeader('X-CSRF-Token', document.getElementsByName('csrf-token')[0].content);
    request.send();
  }

  function reset_phone_verification(){
    var request = new XMLHttpRequest();
    var phone = document.getElementById('user_phone').value;
    var captcha = document.getElementById('captcha').value;
    if(phone&&captcha){
      var data = {phone:phone,_rucaptcha:captcha};
      var url = '/phone_verifications/reset?' + Object.keys(data).map(function(k) {
          return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
      }).join('&');

    }else{
      return false;
    }
    request.open('POST', url, true);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    request.setRequestHeader('X-CSRF-Token', document.getElementsByName('csrf-token')[0].content);
    request.send();
  }

  phone_reset.addEventListener('click', reset_phone_verification, false);
  phone_verification.addEventListener('click', get_phone_verification, false);
}
