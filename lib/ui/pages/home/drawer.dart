import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/generated/l10n.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/ui/widgets/custom_dialog.dart';

class HomePageDrawer extends StatelessWidget {
  void _userInfo(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context, listen: false);
    var auth0 = AuthClient(
        authClient: Provider.of<AppStateModel>(context, listen: false)
            .mocks
            .getMock('authClient'));
    auth0.getUserInfo(appState.userToken).then((res) {
      if (res != null) {
        // The demo.identityserver.io/api/test API doesn't return anything
        // interesting, so we fake the setting of user info
        Provider.of<AppStateModel>(context, listen: false).setUserInfo(
            Map.from({
          'email': S.of(context).drawerEmail,
          'name': S.of(context).drawerUser
        }));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).drawerGetUserInfoResultMsg),
          duration: const Duration(seconds: 3),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).drawerGetUserInfoFailedMsg),
          duration: const Duration(seconds: 3),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          buildDrawerHeader(context),
          ListTile(
            key: Key("DrawerMenuTile_RefreshTokens"),
            title: Text(S.of(context).drawerRefreshTokens),
            onTap: () {
              appState.refresh();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.of(context).drawerRefreshTokensResultMsg),
                duration: const Duration(seconds: 3),
              ));
            },
          ),
          ListTile(
            key: Key("DrawerMenuTile_GetUserInfo"),
            title: Text(S.of(context).drawerGetUserInfo),
            onTap: () {
              Navigator.of(context).pop();
              _userInfo(context);
            },
          ),
          ListTile(
            key: Key("DrawerMenuTile_Localisation"),
            title: Text(S.of(context).drawerLocalisation),
            subtitle: Text(appState.locale),
            onTap: () {
              // Here you should have a widget to select among
              // supported locales. This is just a quick and dirty
              // switch
              appState.switchLocale();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.of(context).drawerLocalisationResultMsg +
                    appState.locale),
                duration: const Duration(seconds: 3),
              ));
            },
          ),
          ListTile(
            key: Key('DrawerMenuTile_LogOut'),
            leading: new Icon(
              Icons.exit_to_app,
              color: Color(0xe81751ff),
            ),
            trailing: Text(S.of(context).logoutButton),
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
    key: Key("DrawerMenu_Header"),
    accountName: Text(appState.name == null
        ? S.of(context).drawerHeaderInitialName
        : appState.name),
    accountEmail: Text(appState.email == null
        ? S.of(context).drawerHeaderInitialEmail
        : appState.email),
    onDetailsPressed: () => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var container = Container(
          key: Key("DrawerMenu_BottomSheet"),
          alignment: Alignment.center,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(appState.name == null
                    ? S.of(context).drawerEmptyName
                    : appState.name),
                subtitle: Text(appState.email == null
                    ? S.of(context).drawerEmptyEmail
                    : appState.email),
              ),
              ListTile(
                title: Text(S.of(context).drawerButtomSheetFCMToken),
                subtitle: Text(S.of(context).clickToView),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: S.of(context).drawerButtomSheetFCMToken,
                      description: appState.fcmToken,
                      buttonText: S.of(context).okButton,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(S.of(context).drawerButtomSheetUserToken),
                subtitle: Text(S.of(context).clickToView),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: S.of(context).drawerButtomSheetUserToken,
                      description: appState.userToken,
                      buttonText: S.of(context).okButton,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(S.of(context).drawerButtomSheetIdToken),
                subtitle: Text(S.of(context).clickToView),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: S.of(context).drawerButtomSheetIdToken,
                      description: appState.idToken,
                      buttonText: S.of(context).okButton,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(S.of(context).drawerButtomSheetExpires),
                subtitle: Text(appState.expires == null
                    ? ''
                    : appState.expires.toIso8601String()),
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
