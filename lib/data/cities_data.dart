class CitiesData {
  // Popular cities with their countries
  static const List<String> popularCities = [
    'Kathmandu, Nepal',
    'Lalitpur, Nepal',
    'Pokhara, Nepal',
    'Chitwan, Nepal',
    'Bharatpur, Nepal',
    'Nepalgunj, Nepal',
    'New Delhi, India',
    'Mumbai, India',
    'New York, USA',
    'London, UK',
  ];

  static String getCityName(String fullCityName) {
    return fullCityName.split(',')[0];
  }
}
