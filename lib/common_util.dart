import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CommonUtil {
  CommonUtil._();

  /// 获取asset中的jsonMap数据
  static Future<List<dynamic>> getAssetJsonList(String path) async {
    try {
      final js = await getAssetJson(path);
      if (js is List) {
        return js;
      }
      return [];
    } catch (e) {
      debugPrint('json文件不存在: $path');
      return [];
    }
  }

  /// 获取asset中的jsonMap数据
  static Future<Map<dynamic, dynamic>> getAssetJsonMap(String path) async {
    try {
      final js = await getAssetJson(path);
      if (js is Map) {
        return js;
      }
      return {};
    } catch (e) {
      debugPrint('json文件不存在: $path');
      return {};
    }
  }

  /// 获取asset中的json数据
  static Future<dynamic> getAssetJson(String path) async {
    final data = await rootBundle.loadString(
      'packages/flutter_z_location/$path',
    );

    return jsonDecode(data);
  }
}
