import 'dart:convert';

import 'package:xml2json/xml2json.dart';

bool isNullEmptyOrFalse(Object o) => o == null || false == o || "" == o;

dynamic convertXMLtoJSON(String body) {
  final Xml2Json xml2json = Xml2Json();
  xml2json.parse(body);
  final String jsonData = xml2json.toBadgerfish();
  return jsonDecode(jsonData);
}
