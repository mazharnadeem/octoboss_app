RegExp firstname_exp = RegExp(
  r'^[A-Za-z]*$',
  caseSensitive: false,
);
RegExp lastname_exp = RegExp(
  r'^[A-Za-z]*$',
  caseSensitive: false,
);
RegExp username_exp = RegExp(
  r'^[A-Za-z0-9_.-]*$',
  caseSensitive: false,
);
RegExp email_exp =
    new RegExp(r'^[A-Z0-9._]+@[a-z]+\.[a-z]{2,3}', caseSensitive: false);
RegExp password_exp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
    caseSensitive: false);
RegExp phone_exp = RegExp(
  r'^[0-9]*$',
  caseSensitive: false,
);
RegExp height_exp = RegExp(
  r'^[0-9]\.[0-9]$',
  caseSensitive: false,
);
RegExp weight_exp = RegExp(
  r'^[0-9]*$',
  caseSensitive: false,
);

String? firstname_Validation(String firstname) {
  if (firstname_exp.hasMatch(firstname.toString())) {
    return null;
  } else if (firstname.isEmpty) {
    return "Required!";
  }
  return "Only characters";
}

String? lastname_Validation(String lastname) {
  if (lastname_exp.hasMatch(lastname.toString())) {
    return null;
  } else if (lastname.isEmpty) {
    return "Required!";
  }
  return "Only characters";
}

String? username_Validation(String username) {
  if (username_exp.hasMatch(username.toString())) {
    return null;
  } else if (username == "") {
    return "Required!";
  } else
    return 'Only Chars, Numbers & (_ . -)';
}

String? email_Validation(String email) {
  if (email.isEmpty) {
    return "Required";
  }
  if (email_exp.hasMatch(email.toString())) {
    return null;
  }
  return 'Enter a valid Email';
}

String? password_Validation(String password) {
  if (password.isEmpty) {
    return "Required";
  }
  if (password_exp.hasMatch(password.toString())) {
    return null;
  }
  return """Atleast one character
Atleast one Number
Length>8""";
}

String? confirmPass_validation(String password, String confirmEmail) {
  if (password.isEmpty) {
    return "Required!";
  } else if (password != confirmEmail) {
    return "Password does not match";
  }
}

String? phone_Validation(String phone) {
  if (phone_exp.hasMatch(phone.toString())) {
    return null;
  } else if (phone.toString() == "") {
    return "Required!";
  }
  return 'Only Numbers Required!';
}

String? weight_Validation(String weight) {
  if (weight_exp.hasMatch(weight.toString())) {
    return null;
  }
  return """Enter a
valid Weight""";
}

String? height_Validation(String height) {
  if (height_exp.hasMatch(height.toString())) {
    return null;
  }
  return """Enter a
valid Height""";
}
