import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tiksi_weather/api.dart';
import 'package:tiksi_weather/components/button.dart';
import 'package:tiksi_weather/components/date_widget.dart';
import 'package:tiksi_weather/components/weather_icon.dart';
import 'components/background.dart';
import 'dart:math' as math;

import 'components/input.dart';

class WeatherPage extends StatefulWidget {
  final Api firebase;
  WeatherPage({required this.firebase});
  @override
  _WeatherPageState createState() => _WeatherPageState(firebase: firebase);
}

class _WeatherPageState extends State<WeatherPage> {
  Api firebase;
  _WeatherPageState({required this.firebase});

  bool errorEmail = false;
  bool errorPass = false;

  bool authPage = false;
  bool loading = true;

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  DateTime currentDate = DateTime.now();

  Map weather = {
    "iconName": "icon_clear_sky_day",
    "text": "—",
    "tempDay": "—",
    "tempNight": "—",
    "windDirection": "—",
    "windSpeed": "—",
    "windImpulses": "—",
    "warning": "",
  };

  bool changeMode = false;
  bool newWeather = false;
  bool prepareToChange = false;

  String changeModeIcon = "icon_clear_sky_day";

  TextEditingController textController = TextEditingController();
  TextEditingController windDirectionController = TextEditingController();
  TextEditingController windSpeedController = TextEditingController();
  TextEditingController windImpulsesController = TextEditingController();
  TextEditingController tempDayController = TextEditingController();
  TextEditingController tempNightController = TextEditingController();
  TextEditingController errorController = TextEditingController();

  double mainHeight = 0;

  @override
  void initState() {
    getWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (mainHeight == 0) {
      mainHeight = height;
    } else if (mainHeight < height) {
      mainHeight = height;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            Background(
              height: mainHeight,
            ),
            getContent(width, height),
            authPage
                ? getAuthPage(width, height)
                : Container(width: 0, height: 0),
            loading
                ? getLoading(width, height)
                : Container(width: 0, height: 0),
          ],
        ),
      ),
    );
  }

  Widget getLoading(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3645AF),
        ),
      ),
    );
  }

  void functionSignIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (this._loginController.text.trim() != "" &&
        this._passwordController.text.trim() != "") {
      errorEmail = false;
      errorPass = false;
      String result = await firebase.signIn(
        this._loginController.text.trim(),
        this._passwordController.text.trim(),
      );
      String? message;
      bool isOk = false;
      switch (result) {
        case "ok":
          message = "Вход выполнен успешно";
          isOk = true;
          break;
        case "user-not-found":
        case "wrong-password":
        case "invalid-email":
          message = "Неправильный логин или пароль";
          break;
        case "error":
          message = "Ошибка";
          break;
      }
      if (message != null) {
        getSnackBar(message, !isOk);
      }
      if (isOk) {
        _loginController.clear();
        _passwordController.clear();
        setState(() => {authPage = false});
      } else {
        errorEmail = true;
        errorPass = true;
      }
    } else {
      errorEmail = true;
      errorPass = true;
      getSnackBar("Пустое поле", true);
    }
  }

  Widget getAuthPage(double width, double height) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.8),
          width: width,
          height: height,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => setState(() => {
                    authPage = false,
                    changeMode = false,
                    newWeather = false,
                    _passwordController.clear(),
                    _loginController.clear(),
                  }),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: height * 0.15),
          child: Center(
            child: Container(
              width: width * 0.85,
              height: height * 0.5,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.045,
                vertical: height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Вход в аккаунт",
                    style: TextStyle(
                      color: Color(0xFF242424),
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "(только для админов)",
                    style: TextStyle(
                      color: Color(0xFF242424).withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.03),
                    child: Input(
                      hint: "E-mail",
                      controller: _loginController,
                      isPass: false,
                      keyboardType: TextInputType.emailAddress,
                      errorEnabled: errorEmail,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    child: Input(
                      hint: "Пароль",
                      controller: _passwordController,
                      isPass: true,
                      keyboardType: TextInputType.visiblePassword,
                      maxLenght: 24,
                      autocorrect: false,
                      errorEnabled: errorPass,
                    ),
                  ),
                  Expanded(child: Container(), flex: 5),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.015),
                    child: VkButton(
                      onClick: () => functionSignIn(),
                      text: "Войти",
                      mode: ButtonMode.primary,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.015),
                    child: VkButton(
                      onClick: () => resetPass(height),
                      text: "Восстановить пароль",
                      mode: ButtonMode.outlined,
                    ),
                  ),
                  Expanded(child: Container(), flex: 1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void resetPass(double height) {
    showBarModalBottomSheet(
      context: context,
      topControl: Container(),
      builder: (context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            AppBar(
              title: Text(
                "Восстановление пароля",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.03,
                left: 16,
                right: 16,
              ),
              child: Input(
                hint: "E-mail",
                controller: _loginController,
                isPass: false,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.015,
                left: 16,
                right: 16,
                bottom: height * 0.4,
              ),
              child: VkButton(
                onClick: () => checkEmailForPassReset(),
                text: "Восстановить пароль",
                mode: ButtonMode.outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkEmailForPassReset() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_loginController.text.isNotEmpty) {
      String result = await firebase.resetPassword(_loginController.text);
      if (result == "ok") {
        getSnackBar("Письмо для сброса пароля отправлено на почту", false);
        Navigator.pop(context);
      } else {
        getSnackBar("Ошибка отправки письма для сброса пароля", true);
        _loginController.clear();
      }
    } else {
      getSnackBar("Пустое поле", true);
    }
  }

  void changeDate() async {
    DateTime? temp = await showDatePicker(
      context: context,
      initialDate: currentDate,
      currentDate: DateTime.now(),
      firstDate: DateTime(2021, 9, 10),
      lastDate: DateTime.now().add(Duration(days: 1)),
      helpText: "Прогноз на ",
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
              primaryColorDark: Colors.indigo,
              accentColor: Colors.indigoAccent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (temp != null && temp != currentDate) {
      setState(() => {
            currentDate = temp,
            loading = true,
            weather = {
              "iconName": "icon_clear_sky_day",
              "text": "—",
              "tempDay": "—",
              "tempNight": "—",
              "windDirection": "—",
              "windSpeed": "—",
              "windImpulses": "—",
              "warning": "",
            },
            getWeather(),
          });
    }
  }

  plusClick() {
    if (firebase.checkAdmin()) {
      if (weather["tempDay"] == "—") {
        changeModeIcon = "icon_clear_sky_day";
        textController.clear();
        windDirectionController.clear();
        windSpeedController.clear();
        windImpulsesController.clear();
        tempDayController.clear();
        tempNightController.clear();
        errorController.clear();
        setState(() {
          changeMode = true;
          newWeather = true;
        });
      } else {
        getSnackBar("На это число уже есть погода", true);
        changeModeIcon = "icon_clear_sky_day";
        textController.clear();
        windDirectionController.clear();
        windSpeedController.clear();
        windImpulsesController.clear();
        tempDayController.clear();
        tempNightController.clear();
        errorController.clear();
        newWeather = true;
        changeMode = true;
        changeDate();
      }
    } else
      setState(() {
        authPage = true;
        newWeather = true;
      });
  }

  pencilClick() {
    if (firebase.checkAdmin()) {
      if (weather["tempDay"] == "—") {
        getSnackBar(
            "Невозможно редактировать.\nПогода на это число не найдена", true);
      } else {
        changeModeIcon = weather["iconName"];
        textController = TextEditingController.fromValue(
            TextEditingValue(text: weather["text"]));
        windDirectionController = TextEditingController.fromValue(
            TextEditingValue(text: weather["windDirection"]));
        windImpulsesController = TextEditingController.fromValue(
            TextEditingValue(text: weather["windImpulses"]));
        windSpeedController = TextEditingController.fromValue(
            TextEditingValue(text: weather["windSpeed"]));
        tempDayController = TextEditingController.fromValue(
            TextEditingValue(text: weather["tempDay"]));
        tempNightController = TextEditingController.fromValue(
            TextEditingValue(text: weather["tempNight"]));
        errorController = TextEditingController.fromValue(
            weather["warning"] == null
                ? TextEditingValue.empty
                : TextEditingValue(text: weather["warning"]));
        setState(() {
          changeMode = true;
          newWeather = false;
        });
      }
    } else
      setState(() {
        authPage = true;
        newWeather = false;
      });
  }

  exitClick() {
    setState(() {
      changeMode = false;
      newWeather = false;
    });
  }

  saveClick() {
    if (tempDayController.text != "" && textController.text != "") {
      Map weatherForSave = {
        "iconName": changeModeIcon,
        "tempDay": tempDayController.text,
        "tempNight": tempNightController.text,
        "text": textController.text,
        "warning": errorController.text,
        "windDirection": windDirectionController.text,
        "windImpulses": windImpulsesController.text,
        "windSpeed": windSpeedController.text,
      };
      firebase.db
          .child("weather")
          .child(DateFormat('dd-MM-yyyy').format(currentDate))
          .set(weatherForSave)
          .whenComplete(
            () => {
              firebase.pushNotification(newWeather),
              setState(() => {
                    this.changeMode = false,
                    this.newWeather = false,
                    getWeather()
                  })
            },
          );
    } else {
      getSnackBar("Не заполнены обязательные поля", true);
    }
  }

  getWeather() async {
    Map weather = await firebase.getWeather(
      DateFormat('dd-MM-yyyy').format(currentDate),
    );
    print(weather["result"]);
    if (weather["result"] == "ok") {
      if (weather["tempDay"] != "" &&
          weather["text"] != "" &&
          weather["iconName"] != "") {
        if (weather["tempNight"] == "") {
          weather.update("tempNight", (value) => "—");
        }
        if (weather["windSpeed"] == "") {
          weather.update("windSpeed", (value) => "—");
        }
        if (weather["windDirection"] == "") {
          weather.update("windDirection", (value) => "—");
        }
        if (weather["windImpulses"] == "") {
          weather.update("windImpulses", (value) => "—");
        }
        setState(() {
          this.weather = weather;
          this.loading = false;
        });
      } else {
        setState(() {
          this.loading = false;
        });
        if (!changeMode) {
          getSnackBar("Ошибка получения погоды на это число", true);
        }
      }
    } else {
      setState(() {
        this.loading = false;
      });
      if (!changeMode) {
        getSnackBar("Ошибка получения погоды на это число", true);
      }
    }
  }

  getSnackBar(String text, bool error) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      backgroundColor: error ? Color(0xFFE64646) : Color(0xFF4BB34B),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  changeIcon(double width, double height) {
    showBarModalBottomSheet(
      context: context,
      topControl: Container(
        height: height * 0.007,
        width: width * 0.128,
        decoration: BoxDecoration(
          color: Color(0xFFD9DBE9),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      builder: (context) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(
                "Выберите иконку для погоды",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_broken_clouds_day"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_broken_clouds_night"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_clear_sky_day"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_clear_sky_night"),
                      Expanded(child: Container()),
                    ],
                  ),
                  Container(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_few_clouds_day"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_few_clouds_night"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_mist_day"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_rain_day"),
                      Expanded(child: Container()),
                    ],
                  ),
                  Container(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_rain_night"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_scattered_clouds_night"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_shower_rain_day"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_shower_rain_night"),
                      Expanded(child: Container()),
                    ],
                  ),
                  Container(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_snow_day"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_thunderstorm_day"),
                      Expanded(child: Container()),
                      changeIconWeather(width, "icon_thunderstorm_night"),
                      Expanded(child: Container()),
                      Container(width: width * 0.22),
                      Expanded(child: Container()),
                    ],
                  ),
                  Container(
                    height: 24.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeIconWeather(double width, String name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Color(0xFF3f8ae0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() {
            this.changeModeIcon = name;
            Navigator.pop(context);
          }),
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: width * 0.22,
            width: width * 0.22,
            padding: EdgeInsets.all(12.0),
            child: WeatherIcon(
              icon: name,
            ),
          ),
        ),
      ),
    );
  }

  getContent(double width, double height) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: EdgeInsets.only(top: height * 0.05),
          child: DateWidget(
            text: DateFormat('dd.MM.yyyy').format(currentDate),
            height: height,
            width: width,
            onCenterClick: () => changeMode ? () => {} : changeDate(),
            leftIconClick: () => changeMode ? exitClick() : plusClick(),
            rightIconClick: () => changeMode ? saveClick() : pencilClick(),
            changeMode: changeMode,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: height * 0.035),
            child: Text(
              "Тикси",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: height * 0.005),
            child: changeMode
                ? Container()
                : Text(
                    weather["text"],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
        Expanded(
          child: Container(
            child: CollapsingList(
              width: width,
              height: height,
              iconName: weather["iconName"],
              weather: weather,
              changeMode: changeMode,
              tempDayController: tempDayController,
              tempNightController: tempNightController,
              windDirectionController: windDirectionController,
              windImpulsesController: windImpulsesController,
              windSpeedController: windSpeedController,
              changeModeIcon: changeModeIcon,
              textController: textController,
              errorController: errorController,
              changeIcon: changeIcon,
            ),
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CollapsingList extends StatelessWidget {
  final double width;
  final double height;
  final String iconName;
  final Map weather;
  final bool changeMode;
  final String changeModeIcon;
  final TextEditingController textController;
  final TextEditingController windDirectionController;
  final TextEditingController windSpeedController;
  final TextEditingController windImpulsesController;
  final TextEditingController tempDayController;
  final TextEditingController tempNightController;
  final TextEditingController errorController;
  final Function changeIcon;

  CollapsingList({
    required this.width,
    required this.height,
    required this.iconName,
    required this.weather,
    required this.changeMode,
    required this.changeModeIcon,
    required this.textController,
    required this.windDirectionController,
    required this.windSpeedController,
    required this.windImpulsesController,
    required this.tempDayController,
    required this.tempNightController,
    required this.errorController,
    required this.changeIcon,
  });

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: height * 0.1,
        maxHeight: height * 0.1,
        child: Container(
          child: Center(
            child: Text(
              headerText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.042),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
      ),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            changeMode
                ? SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: height * 0.0,
                      maxHeight: height * 0.0,
                      child: Container(),
                    ),
                  )
                : SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: height * 0.01,
                      maxHeight: height * 0.025,
                      child: Container(),
                    ),
                  ),
            changeMode
                ? SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      maxHeight: width * 0.0,
                      minHeight: width * 0.0,
                      child: Container(),
                    ),
                  )
                : SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 0.0,
                      maxHeight: width * 0.25,
                      child: Container(
                        child: Center(
                          child: WeatherIcon(
                            icon: iconName,
                            size: width * 0.25,
                          ),
                        ),
                      ),
                    ),
                  ),
            changeMode
                ? SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: height * 0.07,
                      maxHeight: height * 0.07,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        height: height * 0.07,
                        width: width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Input(
                          hint: "Cводка",
                          controller: textController,
                          isPass: false,
                        ),
                      ),
                    ),
                  )
                : makeHeader(" " + weather["tempDay"] + "°"),
            changeMode
                ? SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: height * 0.03,
                      maxHeight: height * 0.05,
                      child: Container(),
                    ),
                  )
                : SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: height * 0.03,
                      maxHeight: height * 0.1,
                      child: Container(),
                    ),
                  ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  changeMode
                      ? Container(
                          width: width * 0.32,
                          margin: EdgeInsets.only(
                            top: 8.0,
                            left: width * 0.298,
                            right: width * 0.298,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF3f8ae0),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => changeIcon(width, height),
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                height: width * 0.32,
                                width: width * 0.32,
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: WeatherIcon(
                                        icon: changeModeIcon,
                                        size: width * 0.25,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Container()),
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 8.0,
                                                right: 8.0,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  100.0,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                size: width * 0.05,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  changeMode
                      ? Container(
                          height: height * 0.05,
                        )
                      : Container(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.015),
                          height: height * 0.007,
                          width: width * 0.128,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9DBE9),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.01,
                              left: width * 0.05,
                              right: width * 0.05,
                              bottom: height * 0.005),
                          child: Column(
                            children: [
                              changeMode
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.015),
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.015,
                                          horizontal: width * 0.035),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFFE2E2),
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "res/icon_subtract.svg"),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 0.04),
                                              child: Input(
                                                hint: "Предупреждение",
                                                controller: errorController,
                                                isPass: false,
                                                errorEnabled: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : weather["warning"] != ""
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: height * 0.015),
                                          padding: EdgeInsets.symmetric(
                                              vertical: height * 0.015,
                                              horizontal: width * 0.035),
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFFE2E2),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "res/icon_subtract.svg"),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.04),
                                                  child: Text(
                                                    weather["warning"],
                                                    style: TextStyle(
                                                      color: Color(0xFFE33F3F),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 6,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                              ),
                              getListItem(
                                "compass",
                                "Направление ветра",
                                weather["windDirection"],
                                windDirectionController,
                                "СЗ",
                                TextInputType.text,
                              ),
                              getSeporator(),
                              getListItem(
                                "windy",
                                "Скорость ветра",
                                weather["windSpeed"],
                                windSpeedController,
                                "м/с",
                                TextInputType.number,
                              ),
                              getSeporator(),
                              getListItem(
                                "tornado",
                                "Порывы",
                                weather["windImpulses"],
                                windImpulsesController,
                                "СЗ м/с",
                                TextInputType.text,
                              ),
                              getSeporator(),
                              getListItem(
                                "temp",
                                "Температура (день)",
                                weather["tempDay"] + "°",
                                tempDayController,
                                "19",
                                TextInputType.number,
                              ),
                              getSeporator(),
                              getListItem(
                                "temp_night",
                                "Температура (ночь)",
                                weather["tempNight"] + "°",
                                tempNightController,
                                "8",
                                TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //itemExtent: height * 0.6,
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 0,
                maxHeight: height * 0.03,
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getListItem(
      String iconName,
      String h1,
      String text,
      TextEditingController controller,
      String hint,
      TextInputType keyboardType) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: changeMode ? height * 0.017 : height * 0.027),
      child: Row(
        children: [
          SvgPicture.asset(
            "res/list_icons/" + iconName + ".svg",
            width: width * 0.055,
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.01),
            child: Text(
              h1,
              style: TextStyle(
                color: Color(0xFF868AA0),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            width: width * 0.25,
            margin: EdgeInsets.only(left: width * 0.01),
            child: changeMode
                ? Input(
                    hint: hint,
                    controller: controller,
                    isPass: false,
                    keyboardType: keyboardType,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: Color(0xFF242424),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                  ),
          ),
        ],
      ),
    );
  }

  getSeporator() {
    return Container(
      height: 1,
      color: Color(0xFFEAECF6),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
