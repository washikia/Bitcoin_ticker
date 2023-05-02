import 'package:http/http.dart' as http;
import 'dart:convert';
const apikey = "5112CCD5-193D-4078-958D-C1BF5A9A9151";

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<double> getCoinData(String fromCurrency, String toCurrency) async {
    // var url = Uri.http("https://rest.coinapi.io/v1/exchangerate", "/$fromCurrency/$toCurrency", {'apikey':apikey});
    var url = "https://rest.coinapi.io/v1/exchangerate/$fromCurrency/$toCurrency?apikey=$apikey";
    var uriurl = Uri.parse(url);
    http.Response response = await http.get(uriurl);
    if(response.statusCode == 200){
      return jsonDecode(response.body)['rate'];
    }
    else{
      throw "failed with status code: ${response.statusCode}";
    }
  }
}