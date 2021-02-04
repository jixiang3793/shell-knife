#!/bin/bash

# var=$(awk '/Image 0/{print $2}' <<< 'Image 0 asfds'); echo $var
deploy=$1
dir=$2
echo "input deploy.js $deploy"

while IFS= read -r line; do
    # echo "Text read from file: $line"
    temp=$(awk '/style":/{print $2}' <<< $line);
    if [ -n "$temp" ];then style=$temp;
    fi
    temp=$(awk '/ico":/{print $2}' <<< $line);
    if [ -n "$temp" ];then ico=$temp;
    fi
    temp=$(awk '/not_logged_in_bg":/{print $2}' <<< $line);
    if [ -n "$temp" ];then not_logged_in_bg=$temp;
    fi
    temp=$(awk '/^"text":/{print $2,$3,$4,$5,$6}' <<< $line);
    if [ -n "$temp" ];then copyright=$temp;
    fi
    temp=$(awk '/not_logged_in_logo":/{print $2}' <<< $line);
    if [ -n "$temp" ];then logo=$temp;
    fi
    temp=$(awk '/noticeDefaultShow":/{print $2}' <<< $line);
    if [ -n "$temp" ];then noticeDefaultShow=$temp;
    fi

    # not_logged_in_bg=$(awk '/not_logged_in_bg:/{print $2}' <<< $line);
    # copyright=$(awk '/text:/{print $2}' <<< $line);
    # logo=$(awk '/not_logged_in_logo:/{print $2}' <<< $line);
done < "$deploy"



echo "catch $style,$ico,$not_logged_in_bg,$copyright,$logo,$noticeDefaultShow"
cutLen=`expr ${#copyright} - 4`
cutStyleLen=`expr ${#style} - 3`
# echo $cutLen;
# echo "format ${copyright:1:$cutLen}"
if [ "${style:1:$cutStyleLen}" == "center" ]
then
   isCenter=true
    isRight=false
    isBirth=false
fi
if [ "${style:1:$cutStyleLen}" == "right" ]
then
   isCenter=false
    isRight=true
    isBirth=false
fi
if [ "${style:1:$cutStyleLen}" == "birth" ]
then
   isCenter=false
    isRight=false
    isBirth=true
fi


echo "var linkidDb = db.getSiblingDB('linkid-dev');

var count = linkidDb.DICT_CONFIG.count({'name' : 'pc.login.page.config'});
if (count === 0) {
  linkidDb.DICT_CONFIG.insert(
      {
      'desc' : '登录页面自定义',
      'isDeleted' : false,
      'name' : 'pc.login.page.config',
      'scene' : 'pc.login.page',
      'type' : 'list',
      'value' :  {
        // 布局风格
        'layout' : {
          'right' : $isRight,
          'middle' : $isCenter,
          'right-anniversary' : $isBirth
        },
        // 公告是否默认展开
        'portetFold' : $noticeDefaultShow,
        // 登录页面背景图片
        'background' : $not_logged_in_bg
        // 登录页面logo
        'logo' : $logo
        // 浏览器页卡小图标
        'ico' : $ico
        'browsers' : [ {
          'browserName' : 'chrome',
          'logo' : '/public/sso/browser-icon/chrome.png',
          'name' : '谷歌浏览器',
          'downloadurl' : '/public/polyfills-page/install-package/chrome_87.0.4280.66.exe'
        }, {
          'browserName' : 'ie',
          'logo' : '/public/sso/browser-icon/ie.png',
          'name' : 'IE11浏览器',
          'downloadurl' : '/public/polyfills-page/install-package/ie11_zh-cn_wol_win7.exe'
        } ],
        // 版权信息
        'copyright' : ${copyright:1:$cutLen},
        'pagename' : '统一身份认证平台',
        'icp' : '',
        'linkurl' : ''
      }
  });
}
" > $2db.js

# icon=

