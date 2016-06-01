/* 
 * 日期插件
 * 滑动选取日期（年，月，日）
 * V1.1
 */
// (function ($) {
//
// })(jQuery);
function rewrite()
{
    document.write("This text was written by an external script!")
}

function setImageClickFunction(){
    var imgs = document.getElementsByTagName("img");
    for (var i=0;i<imgs.length;i++){
        var src = imgs[i].src;
        imgs[i].setAttribute("onClick","click(src)");
    }
    document.location = imageurls;
}

function click(imagesrc){
    var url="ClickImage:"+imagesrc;
    document.location = url;
}
