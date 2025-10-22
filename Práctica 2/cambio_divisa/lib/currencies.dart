import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyModel with ChangeNotifier {
  final List<String> _currencies = [];
  List<String> get currencies => _currencies;

  List<String> _allCurrencies = [];
  List<String> get allCurrencies => _allCurrencies;

  String _conversionResult = "";
  String get conversionResult => _conversionResult;

  List<String> _conversionResults = [];
  List<String> get conversionResults => _conversionResults;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _fromCurrency, _toCurrency, _favCurrency;

  String? get fromCurrency => _fromCurrency;
  String? get toCurrency => _toCurrency;
  String? get favCurrency => _favCurrency;

  String? _selected = "";
  String? get selected => _selected;

  String _fromValue = "";
  String get fromValue => _fromValue;

  String clave = "v1PgFaqohh8Ln7Ft5M1VOVz"; // CLAVE DE ANA
  // String clave = "2JqfeojmTXeHh8fuPZvq2B"; // CLAVE DE ALEX

  // Añadir a lista de divisas guardadas
  void addCurrency(String currency) {
    _currencies.add(currency);
    notifyListeners();
  }

  void removeCurrency(String currency) {
    int index = _currencies.indexOf(currency);
    _currencies.removeAt(index);
    if (conversionResult.isNotEmpty){
      _conversionResults.removeAt(index);
    }
    notifyListeners();
  }

  void setFromCurrency(String? currency) {
    _fromCurrency = currency;
    notifyListeners();
  }

  void setToCurrency(String? currency) {
    _toCurrency = currency;
    notifyListeners();
  }

  void setFavCurrency(String? currency) {
    _favCurrency = currency;
    notifyListeners();
  }

  void setConversionResult(String currency) {
    _conversionResult = currency;
    notifyListeners();
  }

  void setSelected(String? currency) {
    _selected = currency;
    notifyListeners();
  }

  void setFromValue(String value) {
    _fromValue = value;
    notifyListeners();
  }

  // LLamada al API para la lista de divisas disponibles
  Future<void> getCurrencies() async {
    String apiKey = clave;
    String endpoint =
        "https://fcsapi.com/api-v3/forex/list?type=forex&access_key=$apiKey";

    try {
      var response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        List<dynamic> currenciesList = responseBody['response'];
        Set<String> uniqueCurrencies = {};

        for (var currency in currenciesList) {
          String symbol = currency['symbol'];

          if (symbol.contains("/") && !symbol.endsWith("/")) {
            List<String> pairCurrencies = symbol.split("/");
            uniqueCurrencies.addAll(pairCurrencies);
          } else {
            uniqueCurrencies.add(symbol);
          }
        }
        _allCurrencies = List<String>.from(uniqueCurrencies);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception("Error al cargar las monedas: ${response.statusCode}");
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error: $error");
    }
  }

  // LLamada al API para hacer la conversión
  Future<String> doConversion(String uri, String amount) async {
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        double amountValue = double.tryParse(amount) ?? 0.0;

        if (data['response'] != null && data['response'].isNotEmpty) {
          double cValue = double.parse(data['response'][0]['c']);
          // Realizamos la operación una vez que sabemos el valor de 'c'.
          return (cValue * amountValue).toStringAsFixed(2);
        } else {
          notifyListeners();
          throw Exception('Respuesta de la API incompleta o vacía');
        }
      } else {
        notifyListeners();
        throw Exception("${response.statusCode}");
      }
    } catch (error) {
      notifyListeners();
      _hasError = true;
      return 'Límite alcanzado';
    }
  }

  // Lista de conversiones de la lista de divisas guardadas
  Future<void> savedConverted(String? fromCurrency, List<String> toCurrencies, String amount) async {
    if (fromCurrency != null) {
      String apiKey = clave;
      String symbols = toCurrencies.map((currency) => "$fromCurrency/$currency").join(",");
      String uri = "https://fcsapi.com/api-v3/forex/latest?symbol=$symbols&access_key=$apiKey";
      
      try {
        var response = await http.get(Uri.parse(uri));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['response'] != null && data['response'].isNotEmpty) {
            List<String> resultList = [];
            double amountValue = double.tryParse(amount) ?? 0.0;

            for (var currencyData in data['response']) {
              double cValue = double.parse(currencyData['c']);
              resultList.add((cValue * amountValue).toStringAsFixed(2));
            }

            _conversionResults = resultList;
            notifyListeners();
          } else {
            notifyListeners();
            throw Exception('Respuesta de la API incompleta o vacía');
          }
        } else {
          notifyListeners();
          throw Exception("${response.statusCode}");
        }
      } catch (error) {
        notifyListeners();
        _hasError = true;
        _conversionResults = ['Límite alcanzado'];
      }
    } else {
      notifyListeners();
      print("Error al realizar la conversion");
    }
    notifyListeners();
  }


  // String de una única conversión
  Future<void> singleConverted(
      String? fromCurrency, String? toCurrency, String amount) async {
    if (fromCurrency != null && toCurrency != null) {
      String apiKey = clave;
      String uri =
          "https://fcsapi.com/api-v3/forex/latest?symbol=$fromCurrency/$toCurrency&access_key=$apiKey";
      try {
        setConversionResult(await doConversion(uri, amount));
      } catch (error) {
        notifyListeners();
        print("$error");
      }
    } else {
      notifyListeners();
      print("Error al realizar la conversion");
    }
    notifyListeners();
  }
}
