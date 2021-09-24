part of amberbrooch;

RegExp regExpEmail = RegExp(r'^(?:[a-z0-9!#$%&'
    "'"
    '*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#\$%&'
    "'"
    '*+/=?^_`{|}~-]+)*|"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])\$');

RegExp regExpWhiteSpace = RegExp(r"\s+\b|\b\s|\s|\b");

validateRequired(String? value) => value != null && value.isNotEmpty;

validateEmail(String? value) =>
    value == null || value.isEmpty || regExpEmail.hasMatch(value);

validatePassword(String? value) =>
    value == null ||
    value.isEmpty ||
    (value.length >= 8 &&
        (!regExpWhiteSpace.hasMatch(value)) &&
        ((RegExp(r'[0-9]').hasMatch(value) ? 1 : 0) +
                (RegExp(r'[A-Z]').hasMatch(value) ? 1 : 0) +
                (RegExp(r'[a-z]').hasMatch(value) ? 1 : 0) +
                (RegExp(r'[^0-9A-Za-z]').hasMatch(value) ? 1 : 0)) >=
            3);
