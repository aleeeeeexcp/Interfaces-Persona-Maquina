# Diseño software

<!-- ## Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

> :warning: El diseño en un elemento "vivo". No olvideis actualizarlo
> a medida que cambia durante la realización de la práctica.

> :warning: Recordad que el diseño debe separar _vista_ y
> _estado/modelo_.
	 

El lenguaje de modelado es UML y debeis usar Mermaid para incluir los
diagramas dentro de este documento. Por ejemplo:

-->

```mermaid
classDiagram
  class Usuario {
    String nombre;
  }

  class AplicacionModel {
    +introducirCantidadEnMoneda(Usuario usuario)
    +configurarMonedasDestino(Usuario usuario)
    +realizarConversion(Usuario usuario)
  }

  class ServicioExterno {
    +utilizarFcsapiCom()
  }

  class ConversionWidget {
    -Provider<AplicacionModel> aplicacionModel
    +Widget build(BuildContext context)
  }

  class CurrencyModel {
    -List<String> _currencies
    -List<String> _allCurrencies
    -String _conversionResult
    -List<String> _conversionResults
    -bool _isLoading
    -bool _hasError
    -String? _fromCurrency
    -String? _toCurrency
    -String? _favCurrency
    -String? _selected
    -String _fromValue
    -String clave
    +List<String> currencies
    +List<String> allCurrencies
    +String conversionResult
    +List<String> conversionResults
    +bool isLoading
    +bool hasError
    +String? fromCurrency
    +String? toCurrency
    +String? favCurrency
    +String? selected
    +String fromValue
    +String clave
    +void addCurrency(String currency)
    +void removeCurrency(String currency)
    +void setFromCurrency(String? currency)
    +void setToCurrency(String? currency)
    +void setFavCurrency(String? currency)
    +void setConversionResult(String currency)
    +void setSelected(String? currency)
    +void setFromValue(String value)
    +Future<void> getCurrencies()
    +Future<String> doConversion(String uri, String amount)
    +Future<void> savedConverted(String? fromCurrency, List<String> toCurrencies, String amount)
    +Future<void> singleConverted(String? fromCurrency, String? toCurrency, String amount)
  }

  class CambioDivisa {
    +CambioDivisaHomePage(title: String)
  }

  class CambioDivisaHomePage {
    +CambioDivisaHomePage(title: String)
  }

  class MainApp {
    +MainApp()
  }

  class SavedWidget {
    +SavedWidget()
  }

  class ConversionWidget {
    +ConversionWidget()
  }

  class DropdownWidget {
    +DropdownWidget(currencyList: List<String>, onValueChanged: Function)
  }
  
  class FutureBuilder {
    +FutureBuilder(future: Future, builder: Function)
  }

  Usuario --> AplicacionModel : usa
  AplicacionModel --> ServicioExterno : usa
  AplicacionModel --> ConversionWidget : usa
  ConversionWidget --> AplicacionModel : usa
  CambioDivisa --> CambioDivisaHomePage : contiene
  CambioDivisaHomePage --> FutureBuilder : contiene
  FutureBuilder --> Provider : usa
  MainApp --> DropdownWidget : usa
  MainApp --> Provider : usa
  SavedWidget --> DropdownWidget : usa
  SavedWidget --> Provider : usa
  ConversionWidget --> Provider : usa


