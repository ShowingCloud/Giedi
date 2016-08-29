/**
 * Created by yaolin on 16/8/25.
 */
$(function () {

    sliderInit();
    historyWarp();

    $('#about').fullpage({
        //Navigation
        navigation: true,
        navigationPosition: 'right',
        navigationTooltips: ['1', '2', '3', '4', '5'],

        //Scrolling
        css3: true,
        loopBottom: true,

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

                }
                if (index == 2) {
                    $('.slider-section').removeClass('ready');

                    var a1 = window.setTimeout(function () {
                        $('.text-animate').removeClass('ready');
                    }, 700);
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
        console.log(n_index);
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