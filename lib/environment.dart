/// Environment config variables to be passed in as part of CI/CD
class Environment {
  static const String firebaseVapidKey = String.fromEnvironment(
      "FIREBASE_VAPID_KEY",
      defaultValue:
          "BCKRpKeIZ7-0iWQGbOe6rcTGW1kvAGbyDNPH4Waw-Yzs2cRPJ5xsKUvoybBp2l7KIBx7W2SYh1T9kKh3dlG2KHw");
  // Default values here are client ids for the test version of first_app
  // in app stores and on the web.
  static const String clientIdGithubApp = String.fromEnvironment(
      "CLIENTID_GITHUB_APP",
      defaultValue: "b304cfeaaf2710cf250a");
  static const String secretGithubApp =
      String.fromEnvironment("SECRET_GITHUB_APP", defaultValue: "");

  static const String clientIdGoogleApp = String.fromEnvironment(
      "CLIENTID_GOOGLE_APP",
      defaultValue:
          "748007732162-nnqg752ptfoejjmfg8bfo244j1bs2v71.apps.googleusercontent.com");

  static const String clientIdGoogleWeb = String.fromEnvironment(
      "CLIENTID_GOOGLE_WEB",
      defaultValue:
          "748007732162-5h639jbt5m5tnjf675c7b0h13r8ajomg.apps.googleusercontent.com");
  static const String secretGoogleWeb =
      String.fromEnvironment("SECRET_GOOGLE_WEB", defaultValue: "");
}
