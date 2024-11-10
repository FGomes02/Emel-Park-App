import 'package:flutter/material.dart';
import 'package:projeto1/pages/dashboard_page.dart';
import 'package:projeto1/pages/list_page.dart';
import 'package:projeto1/pages/map_page.dart';
import 'package:projeto1/pages/report_page.dart';

final pages = [
  (title: 'Dashboard', icon: Icons.dashboard, widget: const DashboardPage()),
  (title: 'Lista', icon: Icons.list, widget: const ListPage()),
  (title: 'Mapa', icon: Icons.map, widget: const MapPage()),
  (title: 'Reportar', icon: Icons.report_problem, widget: const ReportPage()),
];
