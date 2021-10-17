import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/ui/widgets/custom_dialog.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  void _userInfo(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context, listen: false);
    var auth0 = AuthClient(
        authClient: Provider.of<AppStateModel>(context, listen: false)
            .mocks
            .getAppAuth());
    try {
      var res = auth0.getUserInfo(appState.userToken);
      if (res is List || res is Map) {
        // Do something
      }
      // The demo.identityserver.io/api/test API doesn't return anything
      // interesting, so we fake the setting of user info
      Provider.of<AppStateModel>(context, listen: false).setUserInfo(Map.from({
        'email': AppLocalizations.of(context)!.drawerEmail,
        'name': AppLocalizations.of(context)!.drawerUser
      }));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.drawerGetUserInfoResultMsg),
        duration: const Duration(seconds: 3),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.drawerGetUserInfoFailedMsg),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          buildDrawerHeader(context),
          ListTile(
            key: const Key("DrawerMenuTile_RefreshTokens"),
            title: Text(AppLocalizations.of(context)!.drawerRefreshTokens),
            onTap: () {
              appState.refresh();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.drawerRefreshTokensResultMsg),
                duration: const Duration(seconds: 3),
              ));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            key: const Key("DrawerMenuTile_GetUserInfo"),
            title: Text(AppLocalizations.of(context)!.drawerGetUserInfo),
            onTap: () {
              _userInfo(context);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            key: const Key("DrawerMenuTile_Localisation"),
            title: Text(AppLocalizations.of(context)!.drawerLocalisation),
            subtitle: Text(appState.localeAbbrev!),
            onTap: () {
              // Here you should have a widget to select among
              // supported locales. This is just a quick and dirty
              // switch
              appState.switchLocale();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.drawerLocalisationResultMsg +
                        appState.localeAbbrev!),
                duration: const Duration(seconds: 3),
              ));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            key: const Key('DrawerMenuTile_LogOut'),
            leading: const Icon(
              Icons.exit_to_app,
              color: Color(0xe81751ff),
            ),
            trailing: Text(AppLocalizations.of(context)!.logoutButton),
            onTap: () {
              Navigator.of(context).pop();
              appState.logOut();
            },
          ),
        ],
      ),
    );
  }
}

Widget buildDrawerHeader(BuildContext context) {
  var appState = Provider.of<AppStateModel>(context);
  return UserAccountsDrawerHeader(
    key: const Key("DrawerMenu_Header"),
    accountName: Text(appState.name == null
        ? AppLocalizations.of(context)!.drawerHeaderInitialName
        : appState.name!),
    accountEmail: Text(appState.email == null
        ? AppLocalizations.of(context)!.drawerHeaderInitialEmail
        : appState.email!),
    onDetailsPressed: () => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var container = Container(
          key: const Key("DrawerMenu_BottomSheet"),
          alignment: Alignment.center,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(appState.name == null
                    ? AppLocalizations.of(context)!.drawerEmptyName
                    : appState.name!),
                subtitle: Text(appState.email == null
                    ? AppLocalizations.of(context)!.drawerEmptyEmail
                    : appState.email!),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.drawerButtomSheetFCMToken),
                subtitle: Text(AppLocalizations.of(context)!.clickToView),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: AppLocalizations.of(context)!
                          .drawerButtomSheetFCMToken,
                      description: appState.fcmToken,
                      buttonText: AppLocalizations.of(context)!.okButton,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.drawerButtomSheetUserToken),
                subtitle: Text(AppLocalizations.of(context)!.clickToView),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: AppLocalizations.of(context)!
                          .drawerButtomSheetUserToken,
                      description: appState.userToken,
                      buttonText: AppLocalizations.of(context)!.okButton,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.drawerButtomSheetIdToken),
                subtitle: Text(AppLocalizations.of(context)!.clickToView),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: AppLocalizations.of(context)!
                          .drawerButtomSheetIdToken,
                      description: appState.idToken,
                      buttonText: AppLocalizations.of(context)!.okButton,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.drawerButtomSheetExpires),
                subtitle: Text(appState.expires == null
                    ? ''
                    : appState.expires!.toIso8601String()),
              ),
            ],
          ),
        );
        return container;
      },
    ),
    currentAccountPicture: CircleAvatar(
      child: Image.asset('assets/actingweb-header-small.png'),
      backgroundColor: Colors.white,
    ),
  );
}
