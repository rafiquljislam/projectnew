import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/ui/Authentication/Splash_screen/Splash_screenmodel.dart';
import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_view.dart';

import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_viewmodel.dart';
import 'package:projectnew/utils/Style.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/ColorTheme.dart';
import 'package:projectnew/utils/models/userModel.dart';

import 'package:provider/provider.dart';

class ProfileEditView extends StatefulWidget {
  final String userId;
  final UseR currentUser;
  ProfileEditView(this.currentUser, this.userId);
  @override
  _ProfileEditViewState createState() => _ProfileEditViewState(currentUser);
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final UseR currentUser;
  _ProfileEditViewState(this.currentUser);

  @override
  Widget build(BuildContext context) {
    var themeP = Provider.of<ThemeModelProvider>(context, listen: false);
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          SpecialButton(
            isCurrentuser: false,
            left: 0,
            color: Colors.white,
            clickFunction: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blueGrey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSectionProfileEdit(
                  currentUser: currentUser,
                ),
                SizedBox(
                  height: 20,
                ),
                BodySectionProfileEdit(currentUser: currentUser),
                SizedBox(
                  height: 10,
                ),
                CardContainer(
                  color: Theme.of(context).cardColor,
                  color2: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "DarkMode",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Switch(
                              onChanged: (value) {
                                themeP.themeSwitchFunction(value);
                              },
                              value: themeP.isDark,
                            )
                          ],
                        ),
                        Container(
                          height: 100,
                          child: Row(
                            children: [
                              Expanded(
                                  child: CardContainer(
                                color: Colors.red,
                                color2: Colors.red,
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: CardContainer(
                                color: Colors.purple,
                                color2: Colors.purple,
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: CardContainer(
                                color2: Colors.amber,
                                color: Colors.amber,
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class BodySectionProfileEdit extends StatelessWidget {
  final UseR currentUser;
  final userId;

  const BodySectionProfileEdit({Key key, this.currentUser, this.userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var splashProvider = Provider.of<SplashScreenModel>(context, listen: false);
    return CardContainer(
      color: Theme.of(context).cardColor,
      color2: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Consumer<ProfileViewModel>(builder: (context, _value, __) {
              return EditingTextField(
                  keyboardtype: TextInputType.name,
                  icon: Icon(Icons.account_circle_sharp),
                  hinttext: currentUser.displayName,
                  controllerText: _value.userNameEditCotroller);
            }),
            SizedBox(
              height: 10,
            ),
            Consumer<ProfileViewModel>(builder: (context, _fourthprovider, __) {
              return EditingTextField(
                  keyboardtype: TextInputType.multiline,
                  icon: Icon(Icons.description),
                  hinttext: currentUser.userDescription,
                  controllerText: _fourthprovider.userDescriptionEditCotroller);
            }),
            SizedBox(
              height: 10,
            ),
            Consumer<ProfileViewModel>(builder: (context, _value, __) {
              return InkWell(
                onTap: () async {
                  splashProvider.eventLoadingStatus = LoadingStatus.Loading;
                  _value.isUpdating = true;

                  _value.updateDataTofirebase(currentUser).then((value) {
                    splashProvider.getDataFromFirebase(
                        _value.firebaseUser.uid, true);
                  }).then((value) {
                    _value.isUpdating = false;
                    Navigator.pop(context);
                  });
                },
                child: CardContainer(
                  color: Colors.red.shade500,
                  color2: Colors.purple.shade500,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: _value.isUpdatingData
                          ? CircularProgressIndicator()
                          : Text(
                              "Save",
                              style: Style().buttonTxtXl,
                            ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class HeaderSectionProfileEdit extends StatelessWidget {
  final UseR currentUser;

  const HeaderSectionProfileEdit({Key key, @required this.currentUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Consumer<ProfileViewModel>(builder: (context, _fourthprovider, __) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: Stack(
                    children: [
                      _fourthprovider.fileImage != null
                          ? ProfileImage(
                              isCurrentUser: false,
                              imageWidget: Image.file(
                                _fourthprovider.fileImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ProfileImage(
                              isCurrentUser: false,
                              imageWidget: CachedNetworkImage(
                                imageUrl: currentUser.photoUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                      InkWell(
                        onTap: () {
                          _fourthprovider.pickImageFromGallery();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.width * 0.35,
                          child: Center(
                            child: Icon(Icons.camera_alt,
                                size: 100, color: Colors.black45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ],
    );
  }
}

class EditingTextField extends StatelessWidget {
  final controllerText;
  final hinttext;
  final icon;
  final keyboardtype;
  EditingTextField(
      {@required this.hinttext,
      @required this.controllerText,
      @required this.icon,
      @required this.keyboardtype});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 0,
      color: Colors.grey[50],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: TextField(
            style: TextStyle(fontSize: 22),
            keyboardType: keyboardtype,
            maxLines: keyboardtype == TextInputType.multiline ? null : 1,
            controller: controllerText,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabled: true,
              enabledBorder: InputBorder.none,
              hintText: hinttext,
              alignLabelWithHint: true,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
