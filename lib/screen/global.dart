import 'package:flutter/material.dart';

abstract class Global {
  static const Color blue = const Color(0xff4A64FE);

  static const List lights = [
    {
      'location': 'Kitchen',
      'name': 'Snacks and Cookies',
      'status': true,
      'position': [0.0, 0.0],
      'tile': 1,
    },
    {
      'location': 'Office 01',
      'name': 'Candies',
      'status': true,
      'position': [-0.07, 0.0],
      'tile': 2,
    },
    {
      'location': 'Meeting room 01',
      'name': 'Masala\'s',
      'status': true,
      'position': [0.08, 0.0],
      'tile': 2,
    },
    {
      'location': 'Office 02',
      'name': 'Fruits',
      'status': true,
      'position': [0.0, 0.0],
      'tile': 3,
    },
    {
      'location': 'Box Office',
      'name': 'Rice',
      'status': true,
      'position': [-0.07, -0.02],
      'tile': 4,
    },
    {
      'location': 'Entrance',
      'name': 'Soaps',
      'status': true,
      'position': [0.05, 0.0],
      'tile': 4,
    },
    {
      'location': 'Entrance',
      'name': 'Other items',
      'status': true,
      'position': [-0.05, 0.1],
      'tile': 4,
    },
  ];
}
