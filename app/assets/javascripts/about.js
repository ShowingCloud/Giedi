/**
 * Created by yaolin on 16/8/25.
 */
$(function () {
    $('#about').fullpage({
        //Navigation
        navigation: true,
        navigationPosition: 'right',
        navigationTooltips: ['1', '2', '3', '4', '5'],


        //Scrolling
        css3: true,
        loopBottom: true,


        //Accessibility
        keyboardScrolling: true
    });

    $('.gps-icon').removeClass('ready');
    var a1 = window.setTimeout(function () {
        $('.mail-icon').removeClass('ready');
    }, 999);

    var a2 = window.setTimeout(function () {
        $('.phone-icon').delay(1999).removeClass('ready');
    }, 1999);

    var a3 = window.setTimeout(function () {
        $('.weixin-icon').delay(2999).removeClass('ready');
    }, 2999);


});