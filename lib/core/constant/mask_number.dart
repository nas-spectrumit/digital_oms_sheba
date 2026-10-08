String maskPhoneNumber(String phoneNumber) {
  if (phoneNumber.length < 8) {
    return phoneNumber;
  } else if (phoneNumber.length == 11) {
    return phoneNumber.replaceRange(4, phoneNumber.length - 3, 'xxxx');
  } else if (phoneNumber.length > 11) {
    return phoneNumber.replaceRange(6, phoneNumber.length - 3, 'xxxx');
  } else {
    return phoneNumber.replaceRange(3, phoneNumber.length - 3, 'xxxxx');
  }
}

String maskNid(String nid) {
  if (nid.length <= 5) {
    // If NID has 5 or fewer digits, return as is (or handle differently)
    return nid;
  }

  // Keep first 2 and last 3, replace the middle with 'x'
  String middle = 'x' * (nid.length - 5);
  return nid.substring(0, 2) + middle + nid.substring(nid.length - 3);
}

String maskCardNo(String cardNo) {
  if (cardNo.length <= 7) {
    // If too short, just return as is
    return cardNo;
  }

  String first3 = cardNo.substring(0, 3);
  String last4 = cardNo.substring(cardNo.length - 4);
  String middle = 'x' * (cardNo.length - 7);

  return first3 + middle + last4;
}

String phoneNumberGet(String value) {
  return value.replaceFirst(RegExp(r'^(\+?88|088)'), '');
}

String maskId(String value) {
  if (value.isEmpty) return value;

  const maskChar = '•';

  // If total length <= 10
  if (value.length <= 10) {
    if (value.length <= 2) {
      return maskChar * value.length;
    }

    final start = value.substring(0, 1);
    final end = value.substring(value.length - 1);

    return '$start${maskChar * (value.length - 2)}$end';
  }

  // Always show ONLY 10 visible chars total
  const int startVisible = 3;
  const int endVisible = 3;

  final start = value.substring(0, startVisible);
  final end = value.substring(value.length - endVisible);

  return '$start${maskChar * 5}$end';
}
