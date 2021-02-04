(function() {
  window.config = {
    'linkid-versinon': '1.0.0',
    'self-versinon': '1.0.0',
    'public-versinon': '1.0.0',
    crypto: true,
    cryptoLog: false,
    'page-config': {
      style: 'center',
      common: {
        ico: '/public/deploy/images/favicon.png',
        bg: {
          not_logged_in_bg: '/public/deploy/images/bg/not_logged_in_bg.jpg',
          logged_in_bg: '/public/deploy/images/bg/logged_in_bg.jpg',
          second_auth_bg: '/public/deploy/images/bg/second_auth_bg.jpg'
        },
        notice: '',
        browser: {
          msie: 10,
          firefox: null,
          chrome: null,
          opera: null,
          safari: null
        },
        copyright: {
          text: [],
          class: 'color:#ffffff;'
        },
        ssoOauth: {},
        addr: {
          cas_server: '',
          link_server: '/linkid/protected',
          frontend_server: '/',
          download_browser: '/public/cas-password-page/web/browser',
          visitor_register: '/public/cas-password-page/visitor',
          download_browser_low: '/public/polyfills-page/lower-browser-ie6.html',
          forget_password: '/public/cas-password-page/web/name',
          forget_password_phone: '/public/cas-password-page/phone/name',
          self_service: '/cas-success'
        },
        noticeDefaultShow: true
      },
      styles: {
        center: {
          logo: {
            not_logged_in_logo: '/public/deploy/images/logo/center/not_logged_in_logo.png',
            logged_in_logo: '/public/deploy/images/logo/center/logged_in_logo.png',
            admin_logo: '/public/deploy/images/logo/center/admin_logo.png'
          }
        },
        right: {
          logo: {
            not_logged_in_logo: '/public/deploy/images/logo/right/not_logged_in_logo.png',
            logged_in_logo: '/public/deploy/images/logo/right/logged_in_logo.png',
            admin_logo: '/public/deploy/images/logo/right/admin_logo.png'
          }
        },
        birth: {
          logo: {
            not_logged_in_logo: '/public/deploy/images/logo/birth/not_logged_in_logo.png',
            logged_in_logo: '/public/deploy/images/logo/birth/logged_in_logo.png',
            admin_logo: '/public/deploy/images/logo/birth/admin_logo.png',
            not_logged_in_birth_text: '/public/deploy/images/logo/birth/birth_text.png'
          }
        }
      },
      phone: {
        logo: '/public/deploy/images/phone/logo.png',
        bg: '/public/deploy/images/phone/bg.jpg'
      }
    }
  };

  if (document.querySelectorAll('[rel=\'icon\']').length > 0) {
    // document.querySelectorAll("[rel='icon']")[0].href = window.config["page-config"]["common"]["ico"];
  }

  function getBrowserInfo() {
    var Sys = {};
    var ua = navigator.userAgent.toLowerCase();
    var re = /(msie|firefox|chrome|opera|version).*?([\d.]+)/;
    var m = ua.match(re);
    if (!!m) {
      Sys.browser = m[1].replace(/version/, '\'safari');
      Sys.ver = m[2];
    }
    return Sys;
  }

  if (!!document.getElementById('login-page-flowkey')) {
    // login page
    var bwInfo = getBrowserInfo();
    if (
      bwInfo.browser &&
      window.config['page-config']['common']['browser'] &&
      window.config['page-config']['common']['browser'][bwInfo.browser]
    ) {
      try {
        var requiredVer = window.config['page-config']['common']['browser'][bwInfo.browser];
        var curVer = parseInt(bwInfo.ver);
        if (curVer < requiredVer) {
          // location.href = window.config["page-config"]["common"]["addr"]["download_browser_low"];
        }
      } catch (error) {
      }
    }
  }

  window.casPageInit = function(pageName) {
    var url = document.getElementById('frontend-addr').innerText;
    // if (location && location.search && location.search.indexOf('debug') > -1) {
    //   var script = document.createElement('script');
    //   script.type = 'text/javascript';
    //   script.src = url + '/public/utils/eruda.js';
    //   script.onload = function() {
    //     eruda.init();
    //   };
    //   script.onerror = function(e) {
    //     console.error(e);
    //   };
    //   document.body.appendChild(script);
    // }
    var loadJsCss = function(jsCssConfig) {
      function createScript(index) {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = url + jsCssConfig.js[index];
        script.onload = function() {
          if (index < jsCssConfig.js.length - 1) {
            createScript(index + 1);
          }
        };
        script.onerror = function(e) {
          console.log(e);
          // alert('加载js资源失败，请重试...');
        };
        document.body.appendChild(script);
      }

      createScript(0);

      for (var i = 0; i < jsCssConfig.css.length; i++) {
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = url + jsCssConfig.css[i];
        link.onload = function() {
        };
        link.onerror = function(e) {
          console.log(e);
        };
        var head = document.getElementsByTagName('head')[0];
        head.appendChild(link);
      }
    };
    var loadJsCssForLogin = function(jsCssConfig) {
      // function createScript(index) {
      for (var i = 0; i < jsCssConfig.js.length; i++) {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = url + jsCssConfig.js[i];
        script.onload = function() {
          // if (index < jsCssConfig.js.length - 1) {
          //   createScript(index + 1);
          // }
        };
        script.onerror = function(e) {
          console.log(e);
          // alert('加载js资源失败，请重试...');
        };
        document.body.appendChild(script);
      }
      // }
      // createScript(0);

      for (var i = 0; i < jsCssConfig.css.length; i++) {
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = url + jsCssConfig.css[i];
        link.onload = function() {
        };
        link.onerror = function(e) {
          console.log(e);
        };
        var head = document.getElementsByTagName('head')[0];
        head.appendChild(link);
      }
    };
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = url + '/public/caspagehash.js?' + new Date().getTime();
    script.onload = function() {
      if (
        pageName === 'logout' ||
        pageName === 'propagatelogout' ||
        pageName === 'serviceerror' ||
        pageName === 'error'
      ) {
        if (document.getElementById('logout-header-logo')) {
          document.getElementById('logout-header-logo').src =
            window.config['page-config']['styles'][window.config['page-config']['style']]['logo']['logged_in_logo'];
        }
        if (document.getElementById('logout-body-bg')) {
          document.getElementById('logout-body-bg').style.backgroundImage =
            'url(\'' + window.config['page-config']['common']['bg']['logged_in_bg'] + '\')';
        }
        if (document.querySelectorAll('[rel=\'icon\']').length > 0) {
          document.querySelectorAll('[rel=\'icon\']')[0].href = window.config['page-config']['common']['ico'];
        } else {
          var head = document.head || document.getElementsByTagName('head')[0];
          var icon = document.createElement('link');
          icon.rel = 'icon';
          icon.type = 'image/x-icon';
          icon.href = window.config['page-config']['common']['ico'];
          head.appendChild(icon);
        }
      } else if (pageName === 'weixin') {
        if (
          document.getElementById('login-rule-type') &&
          document.getElementById('login-rule-type').innerText === 'second'
        ) {
          pageName = 'gatewayweixin';
        }
        var pageJsCssConfig = window.config['page-config']['styles'][window.config['page-config']['style']][pageName];
        loadJsCss(pageJsCssConfig);
      } else if (pageName === 'login') {
        var pageJsCssConfig = window.config['page-config']['styles'][window.config['page-config']['style']][pageName];
        loadJsCssForLogin(pageJsCssConfig);
      } else {
        var pageJsCssConfig = window.config['page-config']['styles'][window.config['page-config']['style']][pageName];
        loadJsCss(pageJsCssConfig);
      }
    };
    script.onerror = function(e) {
      console.log(e);
    };
    document.body.appendChild(script);
  };
})();
