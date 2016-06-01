function getMap() {
    var a = new Object();
    return a.put = function(b, c) {
        a[b + "_"] = c;
    }, a.get = function(b) {
        return a[b + "_"];
    }, a.remove = function(b) {
        delete a[b + "_"];
    }, a.keyset = function() {
        var c, b = "";
        for (c in a) "string" == typeof c && "_" == c.substring(c.length - 1) && (b += ",",
            b += c.substring(0, c.length - 1));
        return "" == b ? b.split(",") : b.substring(1).split(",");
    }, a;
}

function search(a) {
    var b = $(a).find("input").val();
    return null == b || "" == b ? !1 : ($(a).attr("action", "http://m.111.com.cn/search/search.action?keyWord=" + encodeURI(encodeURI(b))),
        void 0);
}

function gotoCatalogPage() {
    window.location.href = "http://m.111.com.cn/mblock/17/b_wap_index_catalog.html";
}

function gotoProvincePage() {
    window.location.href = "http://m.111.com.cn/mblock/18/b_wap_index_province.html";
}

function getLocation() {
    if (null == jQuery.cookie("provinceId") || null == jQuery.cookie("provinceName")) {
        var a = new BMap.Geolocation();
        a.getCurrentPosition(function(a) {
            this.getStatus() == BMAP_STATUS_SUCCESS ? jQuery.ajax({
                type: "POST",
                dataType: "json",
                async: !1,
                cache: !1,
                url: "/location/getCurrLocation.action",
                data: "lng=" + a.point.lng + "&lat=" + a.point.lat,
                success: function(a) {
                    a.result ? (null == jQuery.cookie("provinceId") && ($("#provinceName").text(a.city),
                        $("#myModalLabel").text("1ҩ��Ҫʹ������ǰ��λ�ã�" + a.city), $("#myModal").show()), baiduProvince = a.city) : ($("#myModalLabel1").text(a.message + "���ֶ���������λ��!"),
                        $("#myModal1").show());
                }
            }) : alert("failed" + this.getStatus());
        }, {
            enableHighAccuracy: !0
        });
    }
}

function autoWriteCookie() {
    var a = map.get(baiduProvince.trim());
    return "" == a || null == a ? ($("#myModalLabel1").text(res.message + "���ֶ���������λ��!"),
        $("#myModal1").show(), void 0) : (jQuery.cookie("provinceId", a, {
        path: "/",
        domain: ".111.com.cn",
        expires: 15
    }), jQuery.cookie("provinceName", baiduProvince, {
        path: "/",
        domain: ".111.com.cn",
        expires: 15
    }), $("#provinceName").text(baiduProvince), $("#myModal").hide(), void 0);
}

var map, bullets, slider, baiduProvince = "",
    browser = {
        versions: function() {
            var a = navigator.userAgent;
            return navigator.appVersion, {
                trident: a.indexOf("Trident") > -1,
                presto: a.indexOf("Presto") > -1,
                webKit: a.indexOf("AppleWebKit") > -1,
                gecko: a.indexOf("Gecko") > -1 && -1 == a.indexOf("KHTML"),
                mobile: !!a.match(/AppleWebKit.*Mobile.*/) || !!a.match(/AppleWebKit/),
                ios: !!a.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/),
                android: a.indexOf("Android") > -1 || a.indexOf("Linux") > -1,
                iPhone: a.indexOf("iPhone") > -1 || a.indexOf("Mac") > -1,
                iPad: a.indexOf("iPad") > -1,
                webApp: -1 == a.indexOf("Safari")
            };
        }()
    };

$(document).ready(function() {
    var a, b, c;
    null == jQuery.cookie("provinceId") || null == jQuery.cookie("provinceName") || $("#provinceName").text(jQuery.cookie("provinceName")),
    getLocation(), $(".i_close").click(function() {
        $(".app_box").hide();
    }), a = jQuery.cookie("UserInfo"), a && (b = a.match(/NickName=(.*?)&/)[1] || a.match(/UserName=(.*?)&/)[1],
        "" != b && null != b && "null" != b ? b.length > 7 ? $("#loginUserName").find("small").text(b.substring(0, 7) + "...  ") : $("#loginUserName").find("small").text(b + "  ") : (c = a.match(/UserName=(.*?)&/)[1] || a.match(/UserName=(.*?)&/)[1],
            c.length > 7 ? $("#loginUserName").find("small").text(c.substring(0, 7) + "...   ") : $("#loginUserName").find("small").text(c + "  ")),
        $("#loginUserName").removeClass("hide"), $("#loginA").addClass("hide"), $("#registA").addClass("hide")),
    jQuery.cookie("sourceUrl", window.location.href, {
        path: "/",
        domain: ".111.com.cn",
        expires: 30
    });
}), map = getMap(), map.put("����", 2), map.put("�Ϻ�", 1), map.put("�㶫", 20), map.put("�㽭", 6),
map.put("����", 5), map.put("����", 13), map.put("����", 2), map.put("����", 7), map.put("����", 14),
map.put("����", 27), map.put("�㶫", 20), map.put("����", 21), map.put("����", 23), map.put("����", 22),
map.put("�ӱ�", 4), map.put("����", 17), map.put("������", 11), map.put("����", 18), map.put("����", 19),
map.put("����", 10), map.put("����", 5), map.put("����", 15), map.put("����", 9), map.put("���ɹ�", 8),
map.put("����", 30), map.put("�ຣ", 28), map.put("ɽ��", 16), map.put("����", 26), map.put("ɽ��", 32),
map.put("�Ϻ�", 1), map.put("�Ĵ�", 12), map.put("���", 3), map.put("�½�", 29), map.put("����", 25),
map.put("����", 24), map.put("�㽭", 6), bullets = document.getElementById("position").getElementsByTagName("li"),
slider = Swipe(document.getElementById("slider"), {
    auto: 3e3,
    continuous: !0,
    callback: function(a) {
        for (var b = bullets.length; b--;) bullets[b].className = " ";
        bullets[a].className = "on";
    }
});

/*
$(function() {
    if ($.cookie("appClosedType") == null) { //ͷ��App����ҳ���ر��ж�
        //$(".app_download").show();
        $(".index_mask").show();
    } else {
        var appcloesdtype = $.cookie("appClosedType");
        if (appcloesdtype == 1) {
            //$(".app_download").hide();
            $(".index_mask").hide();
        }
    }
    var expiresDate = new Date();
    expiresDate.setTime(expiresDate.getTime() + (24 * 60 * 60 * 1000));
    $(".cont_visit").click(function() {
        $.cookie('appClosedType', 1, {
            path: '/',
            expires: expiresDate,
            domain: '.111.com.cn'
        })
        //$(".app_download").hide();
        $(".index_mask").hide();
    });
    $("#app_down").click(function() {
        do_app_download();
    });
});
*/
function openApp() {

    if (browser.versions.ios == true || browser.versions.iPhone == true || browser.versions.iPad == true) {
        $('#openApp').attr("href", "");
        var ifr = document.createElement('iframe');
        ifr.src = 'yaowang://main';
        ifr.style.display = 'none';
        document.body.appendChild(ifr);
        window.setTimeout(function() {
            document.body.removeChild(ifr);
        }, 3000)

    } else if (browser.versions.android == true) {
        $('#openApp').attr("href", "");
        var ifr = document.createElement('iframe');
        ifr.src = 'yaowang://main';
        ifr.style.display = 'none';
        document.body.appendChild(ifr);
        window.setTimeout(function() {
            location.href = '';
        }, 100)
    }
}
//˽�˶����첽����
var personnalNav = {
    pageSize: 10,
    pageIndex: {},
    offSet: {},
    tagId: 0,
    sex: "",
    loaded: true,
    init: function() {
        var me = this;
        me.getTags();
    },
    //��ȡ��ǩ����
    getTags: function() {
        var me = this;
        jQuery.ajax({
            url: '/privateTailor/getUserTags.action?sex=m',
            type: 'POST',
            dataType: 'text'
        }).done(function(tagsData) {
            var data = jQuery.parseJSON(tagsData);
            if (data.status == 1) {
                //��Ⱦ��ǩ
                me._renderTags(data.tagList);
            }
            //��Ⱦδ��¼��ǩ
            else {
                me._renderDefultTags();
            }
            //��ȡ��һ����ǩ��Ʒ�б�
            me.getProducts($("#perTagNav li:first a"));
            me._bindEvents();
        });
    },
    //��ȾĬ�����ű�ǩ
    _renderDefultTags: function() {
        var me = this,
            insertStr = '';
        insertStr = '<li><a href="javascript:void(0);" data-sex="b" data-tagid="-1">����</a></li>';
        me.pageIndex["tag-1"] = 0;
        $("#perTagNav").html(insertStr);
        $(".pro-list").append('<div class="proItems" id="proItems-1"></div>');
    },
    //��Ⱦ��ǩ
    _renderTags: function(tagsData) {
        var me = this,
            insertStr = '';
        for (var i = 0; i < tagsData.length; i++) {
            insertStr += '<li><a href="javascript:void(0);" data-sex="' + tagsData[i].sex + '" data-tagid="' + tagsData[i].tagId + '">' + tagsData[i].tagName + '</a></li>';
            me.pageIndex["tag" + tagsData[i].tagId] = 0;
            me.offSet["tag" + tagsData[i].tagId] = 0;
            //��ӱ�ǩ��Ʒ�б�
            $(".pro-list").append('<div class="proItems" id="proItems' + tagsData[i].tagId + '"></div>');
        }
        $("#perTagNav").html(insertStr);
    },
    //��ȡ��һҳ��Ʒ�б�
    getProducts: function(tagLink) {
        var me = this,
            sendData = {
                'tagId': $(tagLink).data('tagid'),
                'sex': $(tagLink).data('sex'),
                'offSet': me.offSet["tag" + $(tagLink).data('tagid')],
                'pageIndex': me.pageIndex["tag" + $(tagLink).data('tagid')],
                'pageSize': me.pageSize
            },
            activeList = "proItems" + $(tagLink).data('tagid');
        if ($("#" + activeList).children().length > 0) {
            me.tagId = $(tagLink).data('tagid');
            me.sex = $(tagLink).data('sex');
            $("#perTagNav li a.active").removeClass('active');
            $(tagLink).addClass('active');
            $(".proItems.active").removeClass('active');
            $("#" + activeList).addClass('active');
            return;
        } else {
            jQuery.ajax({
                url: '/privateTailor/queryGoodsByTag.action',
                type: 'POST',
                dataType: 'text',
                data: sendData
            }).done(function(proData) {
                me.tagId = $(tagLink).data('tagid');
                me.sex = $(tagLink).data('sex');
                me.pageIndex["tag" + $(tagLink).data('tagid')] = 2;
                $("#perTagNav li a.active").removeClass('active');
                $(tagLink).addClass('active');
                $(".proItems.active").removeClass('active');
                $("#" + activeList).addClass('active');
                var data = jQuery.parseJSON(proData);
                me.offSet["tag" + $(tagLink).data('tagid')] = data.offset;
                if (data.status == 1) {
                    me._renderProlist(data.goodsList);
                }
            });
        }
    },
    //��ȡ��һҳ��Ʒ
    getNextProlist: function() {
        var me = this,
            sendData = {
                'tagId': me.tagId,
                'sex': me.sex,
                'offSet': me.offSet["tag" + me.tagId],
                'pageIndex': me.pageIndex["tag" + me.tagId],
                'pageSize': me.pageSize
            };
        jQuery.ajax({
            url: '/privateTailor/queryGoodsByTag.action',
            type: 'POST',
            dataType: 'text',
            data: sendData
        }).done(function(proData) {
            me.loaded = true;
            me.pageIndex["tag" + me.tagId] = me.pageIndex["tag" + me.tagId] + 1;
            var data = jQuery.parseJSON(proData);
            me.offSet["tag" + me.tagId] = data.offset;
            if (data.status == 1) {
                me._renderProlist(data.goodsList);

            }
        });
    },
    //��Ⱦ��Ʒ�б�
    _renderProlist: function(prosData) {
        var me = this;

        if (prosData.length < 1) {
            if ($(".pro-item.no-items").length > 0) {
                $(".pro-item.no-items").show();
                return;
            } else {
                var insertStr = '<div class="pro-item col-xs-12 no-items">û�и�����Ʒ�ˣ�</div>';
                $(".pro-list").append(insertStr);
            }
            return;
        }
        $(".pro-item.no-items").hide();
        for (var i = 0; i < prosData.length; i++) {
            var insertStr = '<div class="pro-item col-xs-6">' +
                '<a href="http://m.111.com.cn/product/' + prosData[i].itemId + '.html">' +
                '<div class="mian_img">' +
                '<img src="' + prosData[i].img + '">' +
                '</div>' +
                '<div class="p_info">' +
                '<p>' + prosData[i].name + '</p>' +
                '<span class="prolist_product_price">��' + parseFloat(prosData[i].price).toFixed(2) + '</span>' +
                '<del class="marketPrice">��' + parseFloat(prosData[i].marketPrice).toFixed(2) + '</del>' +
                '</div>' +
                '</a>' +
                '</div>';
            $("#proItems" + me.tagId).append(insertStr);
        }
    },
    //���¼�
    _bindEvents: function() {
        var me = this;
        //��������
        $(window).unbind('scroll').bind('scroll', function(event) {
            var scrollTop = $(window).scrollTop(),
                lastItemTop = 0,
                lastItemHeight = 0;
            if ($(".active .pro-item:last").length > 0) {
                lastItemTop = $(".active .pro-item:last").offset().top;
                lastItemHeight = $(".active .pro-item:last").height();
            } else {
                return;
            }
            if (lastItemTop && scrollTop > (lastItemTop - (lastItemHeight * 2))) {
                if (personnalNav.loaded) {
                    personnalNav.loaded = false;
                    personnalNav.getNextProlist();
                }
            }
        });
        //�����ǩ��ȡ��Ʒ�б�
        $("#perTagNav li a").on('click', function(event) {
            var link = this;
            if ($(link).hasClass('active')) {
                return;
            }
            personnalNav.getProducts(this);
        });
        //���չ����ǩ
        $(".mui-scrollspy-btn").on('click', function(event) {
            if ($("#J_nav").hasClass('open')) {
                $("#J_nav").removeClass('open');
            } else {
                $("#J_nav").addClass('open');
            }
        });
    },
    lazyLoadDom: function() {
        personnalNav._checkScroll();
        $(window).unbind('scroll').bind('scroll', function(event) {
            personnalNav._checkScroll();
        });
    },
    _checkScroll: function() {
        var scrollTop = $(window).scrollTop() + $(window).height(),
            personTop = $("footer").offset().top,
            personnalDom = $(".personnal-made");
        if (personnalDom.length <= 0 && scrollTop > personTop - 80) {
            window.setTimeout(function(){
                $("#personnal-poll").replaceWith($("#personnal-poll").val());
                personnalNav.init();
            }, 1500);
        }
    }
};
$(document).ready(function() {
    personnalNav.lazyLoadDom();
});
