const String appName = "Dashboard";

const String adminEmail = "admin@gmail.com";
const String adminPassword = "123456";

const List<String> countriesAvailable = ['VN', 'BE', 'AU'];

const String roleAdmin = "admin";
const String roleUser = "user";
const String roleGuest = "guest";

const List<String> roles = [roleAdmin, roleUser, roleGuest];

List<String> allowedExtensionsImage = [
  ..._allowedExtensionsImage,
  ..._allowedExtensionsImage.map((e) => e.toUpperCase()),
];

const List<String> _allowedExtensionsImage = [
  'jpg',
  'jpeg',
  'png',
  'gif',
  'bmp',
  'webp',
  'ico',
  'svg'
];
