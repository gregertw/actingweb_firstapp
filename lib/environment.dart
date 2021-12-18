/// Environment config variables to be passed in as part of CI/CD
class Environment {
  // Default values here are client ids for the test version of first_app
  // in app stores and on the web.
  static const String clientIdGithubApp = String.fromEnvironment(
      "CLIENTID_GITHUB_APP",
      defaultValue: "b304cfeaaf2710cf250a");
  static const String secretGithubApp =
      String.fromEnvironment("SECRET_GITHUB_APP", defaultValue: "");

  static const String clientIdGithubWeb = String.fromEnvironment(
      "CLIENTID_GITHUB_WEB",
      defaultValue: "d143d790c7324c1c74ef");
  static const String secretGithubWeb =
      String.fromEnvironment("SECRET_GITHUB_WEB", defaultValue: "");

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
