import 'package:universal_html/html.dart' as html;

class CookieManager {

  static addToCookie(String key, String value) {
    const String cookieExpireTimeInSeconds='1800';//30 min
    html.document.cookie = "$key=$value;max-age=$cookieExpireTimeInSeconds; path=/;";
  }

  static addCookieForAYear(String key, String value) {
    const String cookieExpireTimeInSeconds='31536000';//1 year
    html.document.cookie = "$key=$value;max-age=$cookieExpireTimeInSeconds; path=/;";
  }

  static deleteMultiplayerGameCookies(){
    String? cookies = html.document.cookie;
    if(cookies!=null){
      List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : [];
      for (int i = 0; i < listValues.length; i++) {
        List<String> map = listValues[i].split("=");
        String name = map[0].trim();
        if(name!='currentUserName'){
          cookies = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
        }
      }
    }
  }

  static String getCookie(String key) {
    String? cookies = html.document.cookie;
    String matchVal = "";
    if(cookies!=null){
      List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : [];
      for (int i = 0; i < listValues.length; i++) {
        List<String> map = listValues[i].split("=");
        String _key = map[0].trim();
        String _val = map[1].trim();
        if (key == _key) {
          matchVal = _val;
          break;
        }
      }
    }
    return matchVal;
  }

}