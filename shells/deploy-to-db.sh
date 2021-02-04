#!/bin/bash

# var=$(awk '/Image 0/{print $2}' <<< 'Image 0 asfds'); echo $var
deploy=$1
echo "input deploy.js $deploy"

while IFS= read -r line; do
    # echo "Text read from file: $line"
    temp=$(awk '/style:/{print $2}' <<< $line);
    if [ -n "$temp" ];then style=$temp;
    fi
    temp=$(awk '/ico:/{print $2}' <<< $line);
    if [ -n "$temp" ];then ico=$temp;
    fi
    temp=$(awk '/not_logged_in_bg:/{print $2}' <<< $line);
    if [ -n "$temp" ];then not_logged_in_bg=$temp;
    fi
    temp=$(awk '/^text:/{print $2,$3,$4}' <<< $line);
    if [ -n "$temp" ];then copyright=$temp;
    fi
    temp=$(awk '/^not_logged_in_logo:/{print $2}' <<< $line);
    if [ -n "$temp" ];then logo=$temp;
    fi
    temp=$(awk '/^noticeDefaultShow:/{print $2}' <<< $line);
    if [ -n "$temp" ];then noticeDefaultShow=$temp;
    fi

    # not_logged_in_bg=$(awk '/not_logged_in_bg:/{print $2}' <<< $line);
    # copyright=$(awk '/text:/{print $2}' <<< $line);
    # logo=$(awk '/not_logged_in_logo:/{print $2}' <<< $line);
done < "$deploy"



echo "catch $style,$ico,$not_logged_in_bg,$copyright,$logo,$noticeDefaultShow"
cutLen=`expr ${#copyright} - 4`
# echo $cutLen;
# echo "format ${copyright:1:$cutLen}"
if [ "$style" == "'center'," ]
then
   isCenter=true
    isRight=false
    isBirth=false
fi
if [ "$style" == "'right'," ]
then
   isCenter=false
    isRight=true
    isBirth=false
fi
if [ "$style" == "'birth'," ]
then
   isCenter=false
    isRight=false
    isBirth=true
fi



echo "var linkidDb = db.getSiblingDB('linkid-dev');

linkidDb.DICT_CONFIG.remove({'name' : 'pc.login.page.config'});
linkidDb.DICT_CONFIG.insert(
    {
    'desc' : '登录页面自定义',
    'isDeleted' : false,
    'name' : 'pc.login.page.config',
    'scene' : 'pc.login.page',
    'type' : 'list',
    'value' :  {
      'layout' : {
        'right' : $isRight,
        'middle' : $isCenter,
        'right-anniversary' : $isBirth
      },
      'portetFold' : $noticeDefaultShow,
      'background' : $not_logged_in_bg
      'logo' : $logo
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
      'copyright' : ${copyright:1:$cutLen},
      'pagename' : '统一身份认证平台',
      'icp' : '',
      'linkurl' : ''
    }
});" > db.js

# icon=

