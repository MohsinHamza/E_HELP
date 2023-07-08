import 'dart:convert';


///Decodes arguemnt...
Map<String,dynamic> decodeArgument(_data) {
  List<int> _decode = base64Decode(_data.replaceAll(' ', '+'));
  return jsonDecode(utf8.decode(_decode));
}


///Send Me Model with toJson otherwise will throw error...
  String encodeArgument(model){
  return base64Encode(utf8.encode(jsonEncode(model.toJson())));
}