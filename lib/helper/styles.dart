import 'package:flutter/material.dart';

import '../constants.dart';

/////////////////////////////////
///   TEXT STYLES
////////////////////////////////

const logoStyle = TextStyle(
    fontSize: 30,
    color: Colors.black54,
    letterSpacing: 2);

const logoWhiteStyle = TextStyle(
    fontSize: 21,
    letterSpacing: 2,
    color: Colors.white);
const whiteText = TextStyle(color: Colors.white);
const disabledText = TextStyle(color: Colors.grey);
const contrastText = TextStyle(color: primaryColor);
const contrastTextBold = TextStyle(
    color: primaryColor, fontWeight: FontWeight.w600);

const h3 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w800);

const h4 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700);

const h5 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500);

const h6 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500);

const h7 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500);

const h8 = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w500);

const h9 = TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontWeight: FontWeight.w500);

const priceText = TextStyle(
    color: Colors.black,
    fontSize: 19,
    fontWeight: FontWeight.w800);

const foodNameText = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.w600);

const tabLinkStyle = TextStyle(fontWeight: FontWeight.w500);

const taglineText = TextStyle(color: Colors.grey);
const categoryText = TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w700);

const inputFieldTextStyle =
    TextStyle( fontWeight: FontWeight.w500);

const inputFieldHintTextStyle =
    TextStyle(color: Color(0xff444444));

const inputFieldPasswordTextStyle = TextStyle(fontWeight: FontWeight.w500, letterSpacing: 3);

const inputFieldHintPaswordTextStyle = TextStyle(color: Color(0xff444444), letterSpacing: 2);

///////////////////////////////////
/// BOX DECORATION STYLES
//////////////////////////////////

const authPlateDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
          color: Color.fromRGBO(0, 0, 0, .1),
          blurRadius: 10,
          spreadRadius: 5,
          offset: Offset(0, 1))
    ],
    borderRadius: BorderRadiusDirectional.only(
        bottomEnd: Radius.circular(20), bottomStart: Radius.circular(20)));

/////////////////////////////////////
/// INPUT FIELD DECORATION STYLES
////////////////////////////////////

const inputFieldFocusedBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(
      color: primaryColor,
    ));

const inputFieldDefaultBorderStyle = OutlineInputBorder(
    gapPadding: 0, borderRadius: BorderRadius.all(Radius.circular(6)));
