import 'package:html/parser.dart' show parse;
import 'package:http_session/http_session.dart';

class Login {
  final String username;
  final String password;
  final HttpSession session;
  String loginUrl = "https://nlearn.nsbm.ac.lk/login/index.php";

  Login({required this.username, required this.password, required this.session});

  Future<Map<String, String?>?> getToken() async {
    try {
      var response = await session.get(Uri.parse(loginUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to load main login page');
      }

      var document = parse(response.body);
      var tokenInput = document.querySelector('input[name="logintoken"]');
      if (tokenInput == null) {
        throw Exception('Login token not found on login page');
      }
      String tokenValue = tokenInput.attributes['value'] ?? '';
      var loginData = {
        'username': username,
        'password': password,
        'logintoken': tokenValue,
      };

      var postResponse = await session.post(
        Uri.parse(loginUrl),
        body: loginData,
      );

      if (postResponse.statusCode != 200) {
        throw Exception('Failed to login. Status code: ${postResponse.statusCode}');
      }

      if (postResponse.request?.url == Uri.parse(loginUrl)) {
        throw Exception('Login failed. Check username and password');
      }
      var mainPageResponse = await session.get(Uri.parse("https://nlearn.nsbm.ac.lk/my/"));
      if (mainPageResponse.statusCode != 200) {
        throw Exception('Failed to get main page');
      }
      var mainPage = parse(mainPageResponse.body);
      var userNameElement = mainPage.querySelector(".d-md-inline-block")?.text.trim();
      var sesskey = mainPage.querySelector("input[name='sesskey']")?.attributes["value"];

      return {"cookie": session.cookieStore.cookies.first.value, "sesskey": sesskey, "username": userNameElement};
    } catch (e) {
      print(e);
      return {"error": e.toString()};
    }
  }
}
