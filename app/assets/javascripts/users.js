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
