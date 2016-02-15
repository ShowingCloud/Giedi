$(function () {
        var action = function () {
            var all = $('.sliders').find('[data-src]');
            var listLength = all.length;
            $.each(all, function (k, v) {
                var _self = $(v);
                _self.css({"background-image": "url(" + _self.attr('data-src') + ")"});
            });
            $(all[0]).show();
            $(all[1]).hide();
            $(all[2]).hide();
            var s = $('.switch');
            var a = s.find('.article');
            if (window.innerWidth > 1200) {
                s.css({'left': (window.innerWidth - 150) / 2});
            } else {
                s.css({'left': '525px'})
            }
            a.css({'width': 1 / (listLength) * 100 + '%'});

            s.on('click', function (event) {
                event.preventDefault();
                console.log(0);
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
            //slider.init();
            $('.list').find('.item').on('click', function () {
                var index = $(this).index();
                $(this).find('.item-title').addClass('active');
                $(this).siblings().find('.item-title').removeClass('active');
                $('.content').find('.item.active').removeClass('active');
                $('.content').find('.item').eq(index).addClass('active');
            });
        };

        var slider = {
            init: function () {
                var items = $('.sliders').find('[data-src]');
                $.each(items, function (k, v) {
                    var _self = $(v);
                    _self.css({"background-image": "url(" + _self.attr('data-src') + ")"});
                    if (k === 0) {
                        _self.show();
                    } else {
                        _self.hide();
                    }
                });
                slider.option.length = items.length;
                slider.option.currentIndex = 0;

                var s = $('.switch');
                var a = s.find('.article');
                a.css({'width': 1 / (slider.option.length) * 100 + '%'});
                s.on('click', function (event) {
                    event.preventDefault();
                    var x = event.pageX;
                    var y = $(this).offset().left;
                    var z = x - y;

                    for (var i = 0; i < slider.option.length; i++) {
                        if (z <= i * (1 / slider.option.length)) {
                            slider.changeByIndex(i);
                        }
                    }
                })
            },
            option: {},
            changeByIndex: function (index) {

            }
        };

        action();
    }
)
;