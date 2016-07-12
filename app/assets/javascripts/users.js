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
  function get_phone_verification(){
    var request = new XMLHttpRequest();
    var phone = document.getElementById('user_phone').value;
    var captcha = document.getElementById('captcha').value;
    if(phone&&captcha){
      var data = new FormData();
      data.append( 'phone',phone);
      data.append("captcha",captcha);
      for(var pair of data.entries()) {
         console.log(pair[0]+ ', '+ pair[1]);
      }
    }else{
      return false;
    }
    request.open('POST', '/phone_verifications', true);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    request.setRequestHeader('X-CSRF-Token', document.getElementsByName('csrf-token')[0].content);
    request.send(data);
  }
  phone_verification.onclick='get_phone_verification();';
}
