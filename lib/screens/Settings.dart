import '../providers/AppStateManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.g.dart';
import '../utils/app_themes.dart';
import '../utils/langs.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";
  SettingsScreen();

  @override
  SettingsRouteState createState() => new SettingsRouteState();
}

class SettingsRouteState extends State<SettingsScreen> {
  AppStateManager appManager;
  @override
  Widget build(BuildContext context) {
    appManager = Provider.of<AppStateManager>(context);
    bool themeSwitch = appManager.themeData == appThemeData[AppTheme.Dark];
    String language =
        appLanguageData[AppLanguage.values[appManager.preferredLanguage]]
            ['name'];

    bool isSwitched2 = true;
    bool isSwitched3 = true, isSwitched4 = true;
    bool isSwitched5 = false, isSwitched6 = false;

    return Scaffold(
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                title: Text("Settings",
                    style: TextStyles.headline(context).copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            ),
            Divider(height: 1),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text(t.chooseapplanguage),
                        content: Container(
                          height: 250.0,
                          width: 400.0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: appLanguageData.length,
                            itemBuilder: (BuildContext context, int index) {
                              var selected =
                                  appLanguageData[AppLanguage.values[index]]
                                          ['name'] ==
                                      language;
                              return ListTile(
                                trailing: selected
                                    ? Icon(Icons.check)
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                title: Text(
                                    appLanguageData[AppLanguage.values[index]]
                                        ['name']),
                                onTap: () {
                                  appManager.setAppLanguage(index);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  children: <Widget>[
                    Text(t.selectlanguage,
                        style: TextStyles.subhead(context).copyWith(
                            color: MyColors.grey_90,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text(language,
                        style: TextStyles.subhead(context)
                            .copyWith(color: MyColors.primary)),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(t.nightmode,
                            style: TextStyles.subhead(context).copyWith(
                                color: MyColors.grey_90,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                        Switch(
                          value: themeSwitch,
                          onChanged: (value) {
                            appManager.setTheme(
                                value ? AppTheme.Dark : AppTheme.White);
                          },
                          activeColor: MyColors.primary,
                          inactiveThumbColor: Colors.grey,
                        )
                      ],
                    ),
                    Container(height: 15)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Game Sound",
                            style: TextStyles.subhead(context).copyWith(
                                color: MyColors.grey_90,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                        Switch(
                          value: isSwitched2,
                          onChanged: (value) {
                            setState(() {
                              isSwitched2 = value;
                            });
                          },
                          activeColor: MyColors.primary,
                          inactiveThumbColor: Colors.grey,
                        )
                      ],
                    ),
                    Text("Sound during gameplay",
                        style: TextStyles.body1(context)
                            .copyWith(color: Colors.grey[400])),
                    Container(height: 15)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            Container(height: 25),
            Container(
              child: Text("Push Notification",
                  style: TextStyles.subhead(context).copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Text("Recommended tournaments",
                        style: TextStyles.body1(context)
                            .copyWith(color: Colors.grey[400])),
                    Spacer(),
                    Switch(
                      value: isSwitched3,
                      onChanged: (value) {
                        setState(() {
                          isSwitched3 = value;
                        });
                      },
                      activeColor: MyColors.primary,
                      inactiveThumbColor: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Text("New Deals & Rewards",
                        style: TextStyles.body1(context)
                            .copyWith(color: Colors.grey[400])),
                    Spacer(),
                    Switch(
                      value: isSwitched4,
                      onChanged: (value) {
                        setState(() {
                          isSwitched4 = value;
                        });
                      },
                      activeColor: MyColors.primary,
                      inactiveThumbColor: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Text("Occasional promo",
                        style: TextStyles.body1(context)
                            .copyWith(color: Colors.grey[400])),
                    Spacer(),
                    Switch(
                      value: isSwitched5,
                      onChanged: (value) {
                        setState(() {
                          isSwitched5 = value;
                        });
                      },
                      activeColor: MyColors.primary,
                      inactiveThumbColor: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Text("Event & Match",
                        style: TextStyles.body1(context)
                            .copyWith(color: Colors.grey[400])),
                    Spacer(),
                    Switch(
                      value: isSwitched6,
                      onChanged: (value) {
                        setState(() {
                          isSwitched6 = value;
                        });
                      },
                      activeColor: MyColors.primary,
                      inactiveThumbColor: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            Container(height: 25),
            Container(
              child: Text("More",
                  style: TextStyles.subhead(context).copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text("Ask a Question",
                    style: TextStyles.body1(context)
                        .copyWith(color: Colors.grey[400])),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text("F A Q",
                    style: TextStyles.body1(context)
                        .copyWith(color: Colors.grey[400])),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text("Privacy Policy",
                    style: TextStyles.body1(context)
                        .copyWith(color: Colors.grey[400])),
              ),
            ),
            Divider(height: 0),
            Container(height: 15),
          ],
        ),
      ),
    );
  }
}
