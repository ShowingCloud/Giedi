$(function () {
        var action = function () {
            slider.init('.slider-item', 5000);//start
            $('.list').find('.item').on('click', function () {
                var index = $(this).index();
                $(this).find('.item-title').addClass('active');
                $(this).siblings().find('.item-title').removeClass('active');
                $('.content').find('.item.active').removeClass('active');
                $('.content').find('.item').eq(index).addClass('active');
            });
        };

        var slider = {
            init: function (selector, interval) {
                var items = $(selector);
                $.each(items, function (k, v) {
                    var _self = $(v);
                    _self.css({"background-image": "url(" + _self.attr('data-src') + ")"});//lazy load
                    if (k === 0) {
                        _self.show();
                    } else {
                        _self.hide();
                    }
                });
                var s = $('.switch');
                var a = s.find('.article');
                a.css({'width': 1 / (items.length) * 100 + '%'});
                var step = (1 / items.length) * 150;

                slider.option.selector = selector;
                slider.option.length = items.length;
                slider.option.currentIndex = 0;
                slider.option.article = a;
                slider.option.step = step;

                s.on('click', function (event) {
                    event.preventDefault();
                    var x = event.pageX;
                    var y = $(this).offset().left;
                    var z = x - y;

                    for (var i = 0; i < slider.option.length; i++) {
                        if (z <= (i + 1) * slider.option.step) {
                            slider.changeByIndex(i);
                            break;
                        }
                    }

                });

                if (arguments.length >= 2 && typeof arguments[1]) {
                    console.log('auto');
                    window.setInterval(function () {
                        var cI = slider.option.currentIndex;
                        var l = slider.option.length;
                        var nI = cI + 1;
                        if (nI === l) {
                            nI = 0;
                        }
                        slider.changeByIndex(nI);
                    }, interval)
                }
            },
            option: {},
            changeByIndex: function (index) {
                if (slider.option.currentIndex === index) {
                    return index;
                } else {
                    slider.option.currentIndex = index;
                    slider.option.article.css({
                        'margin-left': index * slider.option.step,
                        'background': slider.randomColor()
                    });
                    var items = $(slider.option.selector);
                    items.eq(index).fadeIn();
                    items.eq(index).siblings().fadeOut();
                }
            },
            randomColor: function () {
                console.log(Math.random() * 0x1000000);
                return '#' + ('00000' + (Math.random() * 0x1000000 << 0).toString(16)).slice(-6);
            }
        };

        action();
    }
);