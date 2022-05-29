/// Environment config variables to be passed in as part of CI/CD
class Environment {
  static const String firebaseVapidKey = String.fromEnvironment(
      "FIREBASE_VAPID_KEY",
      defaultValue:
          "BCKRpKeIZ7-0iWQGbOe6rcTGW1kvAGbyDNPH4Waw-Yzs2cRPJ5xsKUvoybBp2l7KIBx7W2SYh1T9kKh3dlG2KHw");
  // Default values here are client ids for the test version of first_app
  // in app stores and on the web.
  static const String customUriScheme = String.fromEnvironment(
      "CUSTOM_URI_SCHEME",
      defaultValue: "io.actingweb.firstapp");

  static const String redirectUrlGithubApp = String.fromEnvironment(
      "REDIRECTURL_GITHUB_APP",
      defaultValue: "io.actingweb.firstapp://oauthredirect");
  static const String clientIdGithubApp = String.fromEnvironment(
      "CLIENTID_GITHUB_APP",
      defaultValue: "b304cfeaaf2710cf250a");
  static const String secretGithubApp =
      String.fromEnvironment("SECRET_GITHUB_APP", defaultValue: "");

  static const String redirctUrlGoogleApp = String.fromEnvironment(
      "REDIRECTURL_GOOGLE_APP",
      // This value needs to be changed when you change the CUSTOM_URI_SCHEME and app scheme in
      defaultValue: "io.actingweb.firstapp:/oauthredirect");
  static const String clientIdGoogleApp = String.fromEnvironment(
      "CLIENTID_GOOGLE_APP",
      defaultValue:
          "748007732162-nnqg752ptfoejjmfg8bfo244j1bs2v71.apps.googleusercontent.com");

  static const String redirctUrlGoogleWeb =
      // If value is empty, the current URL path will be used, which normally works ok so this
      // value doesn't have to be explicitly set.
      String.fromEnvironment("REDIRECTURL_GOOGLE_WEB", defaultValue: '');
  static const String clientIdGoogleWeb = String.fromEnvironment(
      "CLIENTID_GOOGLE_WEB",
      // The default value here is for illustration purposes only.
      defaultValue:
          "748007732162-5h639jbt5m5tnjf675c7b0h13r8ajomg.apps.googleusercontent.com");
  static const String secretGoogleWeb = String.fromEnvironment(
      "SECRET_GOOGLE_WEB",
      defaultValue: "MUST_BE_SET_FROM_GOOGLE_OAUTH_CLIENT");
}
