class Constant {
  static const String DEFAULT_URL = "https://www.google.com/search?q=";
  static const String DEFAULT_FAVICON =
      "https://149362025.v2.pressablecdn.com/wp-content/uploads/2015/10/default-favicon.png";
  static const String enableDesktopModeJs =
      "document.querySelector('meta[name=\"viewport\"]').setAttribute('content', 'width=1024px, initial-scale=' + (document.documentElement.clientWidth / 1024));";
  static const String desableDesktopModeJs =
      "document.querySelector('meta[name=\"viewport\"]').setAttribute('content', 'width=document.documentElement.clientWidth, initial-scale=' + (1.0));";

  static const String APP_THEME = "Theme";
  static const String DARK = "Dark";
  static const String LIGHT = "Light";
  static const String SYSTEM_DEFAULT = "System default";
}
