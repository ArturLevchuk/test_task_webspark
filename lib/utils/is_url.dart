bool isValidUrl(String url) {
  const urlPattern = r'^(https?:\/\/)' // required protocol (http or https)
      r'((([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})|' // domain with valid TLD
      r'localhost|' // or localhost
      r'((\d{1,3}\.){3}\d{1,3}))' // or IPv4
      r'(:\d+)?' // optional port
      r'(\/[-a-zA-Z0-9@:%._\+~#=]*)*' // path
      r'(\?[;&a-zA-Z0-9%_.~+=-]*)?' // query parameters
      r'(#[-a-zA-Z0-9_]*)?$'; // fragment
  final regex = RegExp(urlPattern);
  return regex.hasMatch(url);
}