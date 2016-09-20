/**
 * Created by yaolin on 16/8/25.
 */
$(function () {
    sliderInit();
    historyWarp();
    serviceUpper();
    serviceLower();
    caseSlide();

    bannerMobile();

    var hisSwiper = new Swiper('.his-swiper', {
        speed: 400,
        spaceBetween: 100,
        paginationHide: false,
        pagination: '.his-pag',
        paginationClickable: true
    });

    var serviceSwiper = new Swiper('.service-swiper',{
        speed: 400,
        spaceBetween: 100,
        paginationHide: false,
        pagination: '.service-pag',
        paginationClickable: true
    });

    var moreServiceSwiper = new Swiper('.more-service-swiper',{
        speed: 400,
        spaceBetween: 100,
        paginationHide: false,
        pagination: '.more-service-pag',
        paginationClickable: true
    });

    var caseSwiper = new Swiper('.case-swiper',{
        speed: 400,
        spaceBetween: 100,
        paginationHide: false,
        pagination: '.case-pag',
        paginationClickable: true
    });

    $('#about').fullpage({
        //Navigation
        navigation: true,
        navigationPosition: 'right',

        //Scrolling
        css3: true,
        loopBottom: true,
        touchSensitivity: 15,
        normalScrollElementTouchThreshold: 5,
        bigSectionsDestination: 'top',

        //Accessibility
        keyboardScrolling: true,

        afterLoad: function (anchorLink, index) {
            var loadedSection = $(this);
            if (!loadedSection.hasClass('loaded')) {
                loadedSection.addClass('loaded');
                if (index == 1) {

                    $('.gps-icon').removeClass('ready');
                    var a1 = window.setTimeout(function () {
                        $('.mail-icon').removeClass('ready');
                    }, 600);

                    var a2 = window.setTimeout(function () {
                        $('.phone-icon').removeClass('ready');
                    }, 1200);

                    var a3 = window.setTimeout(function () {
                        $('.weixin-icon').removeClass('ready');
                    }, 1800);
                    fixHeight();
                }
                if (index == 2) {
                    $('.slider-section').removeClass('ready');

                    var a1 = window.setTimeout(function () {
                        $('.text-animate').removeClass('ready');
                    }, 500);
                }
                if (index == 3) {
                    $('.list').removeClass('ready');
                    var a1 = window.setTimeout(function () {
                        $('.center').removeClass('ready');
                    }, 500);
                    var a2 = window.setTimeout(function () {
                        $('.warp').removeClass('ready');
                    }, 1000);
                }
                if (index == 4) {
                    $('.service-upper').removeClass('ready');
                    var a1 = window.setTimeout(function () {
                        $('.service-lower').removeClass('ready');
                    }, 500);
                }
            }
        }
    });
});

function sliderInit() {
    var space = $('.slider-section');
    var length = space.find('.slider-item').length;
    space.find('.slider-list').css('width', length * 200);
    var btn = space.find('.slider-btn');
    btn.on('click', {space: space}, function (event) {
        event.preventDefault();
        var data = event.data;
        var space = data.space;
        var a = space.find('.slider-item');
        var old = space.find('.slider-item.active');
        var l = space.find('.slider-list');
        var index = old.index();
        var n_index = 0;
        if ($(this).hasClass('prev')) {
            n_index = index - 1;
        } else {
            n_index = index + 1;
        }
        if (n_index >= a.length) {
            n_index = a.length - 1;
        }
        if (n_index < 0) {
            n_index = 0
        }
        l.css('left', (2 - n_index) * 200 + 'px');
        old.removeClass('active');
        a.eq(n_index).addClass('active');
    })
}

function historyWarp() {
    var space = $('#history');
    var length = space.find('.list-item').length;
    space.find('.warp-list').css('width', length * 300);

    var btn = space.find('.list-item');

    btn.on('click', {space: space}, function (event) {
        event.preventDefault();
        var data = event.data;
        var space = data.space;
        var _self = $(this);
        _self.siblings('.active').removeClass('active');
        _self.addClass('active');
        var index = _self.index();
        var l = space.find('.warp-list');
        l.css('left', (0 - index) * 300 + 'px');
        var box = space.find('.box').eq(index);
        box.siblings('.active').removeClass('active');
        box.addClass('active');
    })
}

function serviceUpper() {
    var space = $('#service');
    var btn = space.find('.upper-item');
    btn.on('mouseenter', {space: space}, function (event) {
        event.preventDefault();
        var data = event.data;
        var space = data.space;
        var _self = $(this);
        _self.siblings('.active').removeClass('active');
        _self.addClass('active');
        var index = _self.index();
        var l = space.find('.right>.upper-list');
        l.css('top', ((0 - index) * 280) + 'px');
    })
}

function serviceLower() {
    var space = $('#service');
    var btn = space.find('.tab-title>.item');
    btn.on('mouseenter', {space: space}, function (event) {
        event.preventDefault();
        var data = event.data;
        var space = data.space;
        var _self = $(this);
        _self.siblings('.active').removeClass('active');
        _self.addClass('active');
        var index = _self.index();
        var l = space.find('.tab-content>.tab-list');
        l.css('left', ((0 - index) * 600) + 'px');
    })
}

function caseSlide() {
    var space = $('#case');
    var btn = space.find('.case-item');

    btn.on('mouseenter', {space: space}, function (event) {
        event.preventDefault();
        var data = event.data;
        var space = data.space;
        var _self = $(this);
        _self.siblings('.active').removeClass('active');
        _self.addClass('active');
        var index = _self.index();
        var l = space.find('.case-list');
        l.css('left', ((0 - index) * 150) + 'px');

        var a = space.find('.shade');

        a.removeClass('active');
        a.eq(index).addClass('active');
    })
}

function fixHeight() {
    var h = $('.fp-tableCell').height();
    $('.banner-contact').css({'padding-top': (h - 400) / 2 + 'px'});
}

function bannerMobile() {
    var space = $('#banner-m');
    var btn = space.find('.contact-us');
    var p = space.find('.banner-contact');
    var _is_hide = false;
    btn.on('click', function () {
        $('.banner-contact').addClass('active');
    });
    p.on('touchstart', function (event) {
        event.preventDefault();
        var s_d = event.originalEvent.targetTouches[0].clientX;
        $(this).on('touchmove', {s_d: s_d}, function (event) {
            event.preventDefault();
            var data = event.data;
            var s_d = data.s_d;
            var n_d = event.originalEvent.targetTouches[0].clientX;
            if (n_d - s_d > 100) {
                _is_hide = true;
            }
        });
    });
    p.on('touchend', function (event) {
        event.preventDefault();
        $(this).off('touchmove');

        if (_is_hide) {
            $(this).removeClass('active');
            _is_hide = false;
        }
    })
}