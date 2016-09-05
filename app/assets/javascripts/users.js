// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// window.onload = function () {
//   addEventListenerByClass('captcha', 'click', refreshCapture);
//   var phone_verification = document.getElementById('phone_verification');
//   var phone_reset = document.getElementById('phone_reset');
//   function get_phone_verification(){
//     var request = new XMLHttpRequest();
//     var phone = document.getElementById('user_phone').value;
//     var captcha = document.getElementById('captcha').value;
//     if(phone&&captcha){
//       var data = {phone:phone,_rucaptcha:captcha};
//       var url = '/phone_verifications?' + Object.keys(data).map(function(k) {
//           return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
//       }).join('&');

//     }else{
//       alert("something is missing");
//     }
//     request.open('POST', url, true);
//     request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
//     request.setRequestHeader('X-CSRF-Token', document.getElementsByName('csrf-token')[0].content);
//     request.send();
//   }

//   function reset_phone_verification(){
//     var request = new XMLHttpRequest();
//     var phone = document.getElementById('user_phone').value;
//     var captcha = document.getElementById('captcha').value;
//     if(phone&&captcha){
//       var data = {phone:phone,_rucaptcha:captcha};
//       var url = '/password_resets_by_phone?' + Object.keys(data).map(function(k) {
//           return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
//       }).join('&');

//     }else{
//       alert("something is missing");
//     }
//     request.open('POST', url, true);
//     request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
//     request.setRequestHeader('X-CSRF-Token', document.getElementsByName('csrf-token')[0].content);
//     request.send();
//   }

//   phone_reset.addEventListener('click', reset_phone_verification, false);
//   phone_verification.addEventListener('click', get_phone_verification, false);
// }

function refreshCapture(e) {
    e.target.src = e.target.src.split('?')[0] + '?' + (new Date()).getTime();
}

function suspend(ele, seconds) {
    if (!ele) return;
    var target = $(ele);
    target.prop('disabled', true);
    var timeleft = seconds;
    var waite = setInterval(function () {
        console.log(timeleft);
        if (timeleft <= 0) {
            clearInterval(waite);
            target.text("再次获取").prop('disabled', false);
        } else {
            target.text(timeleft + "秒");
            timeleft--;
        }

    }, 1000);
}

function get_phone_verification() {
    var _this = this;
    var phone = document.getElementById('user_phone').value;
    var captcha = document.getElementById('captcha').value;
    if (phone && captcha) {
        var data = {
            phone: phone,
            _rucaptcha: captcha
        };
    } else {
        alert("手机号或图形验证码未填写");
    }

    $.ajax({
        type: "POST",
        url: "/phone_verifications",
        data: data,
        dataType: "JSON",
        success: function () {
            alert("短信验证码已发送");
            suspend(_this, 30);
        }
    });

}

function reset_phone_verification(e) {
    var _this = this;
    var phone = document.getElementById('user_phone').value;
    var captcha = document.getElementById('captcha').value;
    if (phone && captcha) {
        var data = {
            phone: phone,
            _rucaptcha: captcha
        };

    } else {
        alert("something is missing");
    }

    $.ajax({
        type: "POST",
        url: "/password_resets_by_phone",
        data: data,
        dataType: "JSON",
        success: function () {
            alert("短信验证码已发送");
            suspend(_this, 30);
        }
    });

}

$(document).ready(function () {
    $('.captcha').on('click', refreshCapture);
    $('#phone_verification').on('click', get_phone_verification);
    $('#phone_reset').on('click', reset_phone_verification);
});

$(document).ajaxError(function (event, jqxhr) {
    if (jqxhr.responseText) {
        var errorMsg = {
            "E000": "图形验证码无效",
            "E001": "无效的手机号",
            "E002": "该手机号已存在",
            "E003": "该手机号未注册",
            "E004": "短信发送失败，请联系网站管理员",
            "E005": "短信获取太频繁，请稍等再试"
        };
        var code = JSON.parse(jqxhr.responseText).code;
        var msg = errorMsg[code];
        if (msg) {
            alert(msg);
        }
        $('.captcha').trigger('click');
    }
});
