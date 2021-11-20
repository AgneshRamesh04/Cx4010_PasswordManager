// // connection to flask
//
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// String url = "http://127.0.0.1:5000/";
//
// //function to upload CSV
// Future<Map<String,String>> uploadSelectedFile() async {
//   //this will be the return return for the function
//   Map<String,String> returnResults = {};
//
//   //Stream<List<String>> objFile;
//   PlatformFile objFile;
//   //file picker for the file, csv allowed only
//   var result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['csv'],
//     withReadStream: true, // this will return PlatformFile object with read stream
//   );
//
//   //assign and sent only if result is not null
//   if (result != null) {
//     objFile = result.files.single;
//
//     //generate a new request
//     final request = http.MultipartRequest(
//       "POST", Uri.parse(url + "uploadCSV"),
//     );
//     //Stream<List<String>> objFile;
//     //add the csv file to the request
//     request.files.add(http.MultipartFile(
//         "CSVFileUpload", objFile.readStream , objFile.size,
//         filename: objFile.name));
//
//     //try to send the request
//     try {
//       var resp = await request.send();
//       //read response
//       String results = await resp.stream.bytesToString();
//       final decoded = json.decode(results);
//
//       returnResults['results'] = decoded['results'];
//       returnResults['details'] = decoded['details'];
//     }
//     on Exception {
//       returnResults['results'] = 'fail';
//       returnResults['details'] = 'Unable to Connect to server';
//     }
//   }
//   //nothing is selected!
//   else{
//     returnResults['results'] = 'fail';
//     returnResults['details'] = 'No file selected';
//   }
//   return Future.value(returnResults);
// }
//
//
//
//
//
//
//
//
//
//
//
