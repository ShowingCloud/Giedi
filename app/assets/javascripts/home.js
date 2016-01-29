$(function () {
    var action = function () {
        var all = $('[data-src]');
        $.each(all, function (k, v) {
            var _self = $(v);
            console.log(_self.attr('data-src'));
            _self.css({"background-image": "url(" + _self.attr('data-src') + ")"});
        });

        var s = $('.switch');
        var a = s.find('.article');
        if (window.innerWidth > 1200) {
            s.css({'left': (window.innerWidth - 150) / 2});
        } else {
            s.css({'left': '525px'})
        }
        a.css({'width': 1 / (all.length) * 100 + '%'});
        $(all[0]).fadeIn();
        $(all[1]).fadeOut();
        $(all[2]).fadeOut();
        s.on('click', function (event) {
            event.preventDefault();
            var x = event.pageX;
            var y = $(this).offset().left;
            var z = x - y;
            if (z <= 50) {
                a.css({"margin-left": "0"});
                $(all[0]).fadeIn();
                $(all[1]).fadeOut();
                $(all[2]).fadeOut();
            } else if (z <= 100) {
                a.css({"margin-left": "50px"});
                $(all[1]).fadeIn();
                $(all[0]).fadeOut();
                $(all[2]).fadeOut();
            } else {
                a.css({"margin-left": "100px"});
                $(all[2]).fadeIn();
                $(all[1]).fadeOut();
                $(all[0]).fadeOut();
            }
        });

        $('.list').find('.item').on('click', function () {
            var index = $(this).index();
            $(this).find('.item-title').addClass('active');
            $(this).siblings().find('.item-title').removeClass('active');
            $('.content').find('.item.active').removeClass('active');
            $('.content').find('.item').eq(index).addClass('active');
        });
    };
    action();
});