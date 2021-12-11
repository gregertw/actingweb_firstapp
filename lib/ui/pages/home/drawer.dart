import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first_app/ui/widgets/custom_dialog.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  Future<bool> _userInfo(BuildContext context) async {
    var appState = Provider.of<AppStateModel>(context, listen: false);
    try {
      appState.setUserInfo();
      return true;
    } catch (e) {
      return false;
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
              appState.authorize();
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
              var msger = ScaffoldMessenger.of(context);
              var drawerGetUserInfoResultMsg = Text(
                  AppLocalizations.of(context)!.drawerGetUserInfoResultMsg);
              var drawerGetUserInfoFailedMsg = Text(
                  AppLocalizations.of(context)!.drawerGetUserInfoFailedMsg);
              _userInfo(context).then((value) => {
                    if (value)
                      {
                        msger.showSnackBar(SnackBar(
                          content: drawerGetUserInfoResultMsg,
                          duration: const Duration(seconds: 3),
                        ))
                      }
                    else
                      {
                        msger.showSnackBar(SnackBar(
                          content: drawerGetUserInfoFailedMsg,
                          duration: const Duration(seconds: 3),
                        ))
                      }
                  });
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
    accountName: Text(appState.name == ''
        ? AppLocalizations.of(context)!.drawerHeaderInitialName
        : appState.name),
    accountEmail: Text(appState.email == ''
        ? AppLocalizations.of(context)!.drawerHeaderInitialEmail
        : appState.email),
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
                title: Text(appState.name == ''
                    ? AppLocalizations.of(context)!.drawerEmptyName
                    : appState.name),
                subtitle: Text(appState.email == ''
                    ? AppLocalizations.of(context)!.drawerEmptyEmail
                    : appState.email),
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
                      description: appState.fcmToken ?? 'N/A',
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
