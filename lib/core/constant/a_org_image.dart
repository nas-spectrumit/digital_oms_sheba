String orgImage({required String string}) {
  if (string.toLowerCase().contains("tcb")) {
    return "https://raw.githubusercontent.com/nasshihab2/assets/main/images/tcb_logo.png";
  } else if (string.toLowerCase().contains("bdris")) {
    return "https://dashboard.bdris.gov.bd/assets/img/bdris-logo.png";
  } else if (string.toLowerCase().contains("election commision")) {
    return "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/%E0%A6%AC%E0%A6%BE%E0%A6%82%E0%A6%B2%E0%A6%BE%E0%A6%A6%E0%A7%87%E0%A6%B6_%E0%A6%A8%E0%A6%BF%E0%A6%B0%E0%A7%8D%E0%A6%AC%E0%A6%BE%E0%A6%9A%E0%A6%A8_%E0%A6%95%E0%A6%AE%E0%A6%BF%E0%A6%B6%E0%A6%A8%E0%A7%87%E0%A6%B0_%E0%A6%B2%E0%A7%8B%E0%A6%97%E0%A7%8B.svg/250px-%E0%A6%AC%E0%A6%BE%E0%A6%82%E0%A6%B2%E0%A6%BE%E0%A6%A6%E0%A7%87%E0%A6%B6_%E0%A6%A8%E0%A6%BF%E0%A6%B0%E0%A7%8D%E0%A6%AC%E0%A6%BE%E0%A6%9A%E0%A6%A8_%E0%A6%95%E0%A6%AE%E0%A6%BF%E0%A6%B6%E0%A6%A8%E0%A7%87%E0%A6%B0_%E0%A6%B2%E0%A7%8B%E0%A6%97%E0%A7%8B.svg.png";
  } else if (string.toLowerCase().contains("local government division")) {
    return "https://raw.githubusercontent.com/nasshihab2/assets/main/images/govt_logo.png";
  } else if (string.toLowerCase().contains("brta")) {
    return "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Emblem_of_Bangladesh_Road_Transport_Authority_%28BRTA%29.svg/3840px-Emblem_of_Bangladesh_Road_Transport_Authority_%28BRTA%29.svg.png";
  } else if (string.toLowerCase().contains("education boards of bangladesh")) {
    return "https://raw.githubusercontent.com/nasshihab2/assets/main/images/govt_logo.png";
  } else if (string.toLowerCase().contains("desco")) {
    return "https://medha.com.bd/wp-content/uploads/2025/07/Dhaka-Electric-Supply-Company-Limited-DESCO-logo.jpg";
  } else {
    return 'null';
  }
}
