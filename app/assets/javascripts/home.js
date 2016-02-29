$(function () {
        var action = function () {
            //slider.init('.slider-item', 5000);//start
            navFixed.init();
            activityTabs.init();
            lazyload.init();
        };

        var slider = {
            init: function (selector, interval) {
                var items = $(selector);
                $.each(items, function (k, v) {
                    var _self = $(v);

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

                if (arguments.length >= 2 && typeof arguments[1] === 'number') {
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


        var navFixed = {
            init: function () {
                $(window).on('scroll', function (event) {
                    var y = window.scrollY;
                    var nav = $('.navbar');
                    nav.css({top: 0 - y + 'px'});
                    if (y > 500) {
                        nav.css({top: 0});
                    }
                })
            }
        };

        var activityTabs = {
            init: function () {
                $('.tabs-top').find('.item').on('click', function () {
                    var index = $(this).index();
                    $(this).addClass('active');
                    $(this).siblings().removeClass('active');
                    var target = $($('.tabs-top').attr('data-tabs'));
                    target.find('.tabs-item.active').removeClass('active');
                    target.find('.tabs-item').eq(index).addClass('active');
                });
            }
        };

        var lazyload = {
            init: function () {
                var tag = $('[data-src]');
                var default_src = '';
                $.each(tag, function (k, v) {
                    var $self = $(v);
                    if ($self[0].tagName === 'IMG') {
                        $self.attr({src: default_src});
                    } else {
                        $self.css({"background-image": "url(" + default_src + ")"});//default image
                    }
                    lazyload.loading($self,$self.attr('data-src'));
                });
            },
            loading: function (jqObj,src) {
                var img = new Image();
                img.src = src;
                $(img).on('load', function () {
                    if (jqObj[0].tagName === 'IMG') {
                        jqObj.attr({src: src});
                    } else {
                        jqObj.css({"background-image": "url(" + src + ")"});//lazy load
                    }
                });
            }
        };
        action();
    }
);