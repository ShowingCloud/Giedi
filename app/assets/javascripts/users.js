function register_check() {
    $("#user_name,#user_email").keydown(function() {
        $(this).closest(".row").find('.msg').text("");
    });
    $("#user_name").blur(function() {
        var _this = $(this);
        var value = _this.val();

        if (!value) {
            return;
        }
        $.ajax({
            url: '/check/username',
            type: "GET",
            data: {
                username: value
            },
            complete: function() {},
            success: function(data) {
                if (data.available === false) {
                    _this.closest(".row").find('.msg').text("用户名已被占用");
                }
            },
            error: function() {
                console.log("register_check ajax error!");
            }
        });
    });

    $("#user_email").blur(function() {
        var _this = $(this);
        var value = _this.val();
        if (!value) {
            return;
        }
        $.ajax({
            url: '/check/email',
            type: "GET",
            data: {
                email: value
            },
            complete: function() {},
            success: function(data) {
                if (data.available === false) {
                    _this.closest(".row").find('.msg').text("邮箱已被占用");
                }
            },
            error: function() {
                console.log("register_check ajax error!");
            }
        });
    });
}

function refreshCapture(e) {
    e.target.src = e.target.src.split('?')[0] + '?' + (new Date()).getTime();
}

function suspend(ele, seconds) {
    if (!ele) return;
    var target = $(ele);
    target.prop('disabled', true);
    var timeleft = seconds;
    var waite = setInterval(function() {
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
        success: function() {
            alert("短信验证码已发送");
            suspend(_this, 30);
        }
    });

}

function reset_phone_verification(e) {
    var _this = this;
    var phone = document.getElementById('password_reset_phone').value;
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
        success: function() {
            alert("短信验证码已发送");
            suspend(_this, 30);
        }
    });

}

$(document).ready(function() {
    $('.captcha').on('click', refreshCapture);
    $('#phone_verification').on('click', get_phone_verification);
    $('#phone_reset').on('click', reset_phone_verification);
    register_check();
});

$(document).ajaxError(function(event, jqxhr) {
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
