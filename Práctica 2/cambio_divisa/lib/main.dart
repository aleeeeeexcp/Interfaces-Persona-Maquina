/* COMENTARIOS:

Para añadir la dependencia http al proyecto:
> flutter pub get
> flutter pub add http

Para cargar un nuevo emulator (MÓVIL PIXEL):
> sdkmanager --install "system-images;android-30;google_apis_playstore;x86_64"
> avdmanager create avd -n emulatorP2 -k "system-images;android-30;google_apis_playstore;x86_64"

Para cargar un emulador (TABLET NEXUS):
> emulator -avd emulatorTabletP2

Para cargar el programa:
- Cargar el emulador creado desde Paleta de Comandos
> flutter run -t lib/main.dart
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'currencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Descomentar para poner solo en vertical
  /*
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
    
  ]);
  */
  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrencyModel(),
      child: const CambioDivisa(),
    ),
  );
}

class CambioDivisa extends StatelessWidget {
  const CambioDivisa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambio Divisa',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const CambioDivisaHomePage(title: 'Conversor de divisas'),
    );
  }
}

class CambioDivisaHomePage extends StatelessWidget {
  const CambioDivisaHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: FutureBuilder(
            future: Provider.of<CurrencyModel>(context, listen: false)
                .getCurrencies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasError) {
                return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Error de conexión',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    const CircularProgressIndicator(),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Error al conseguir divisas de la API',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainApp(), // Contiene la conversión principal
                      SizedBox(height: 16.0),
                      ConversionWidget(), // Botón para ambas conversiones
                      SizedBox(height: 8.0),
                      Divider(),
                      SizedBox(height: 8.0),
                      SavedWidget(), // Contiene la conversión de favoritos
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

/* 
 * MainApp se encarga de realizar conversiones entre la divisa 'input'/'fromCurrency' y una única divisa 'output'/'toCurrency'
 * La conversión se realiza seleccionando la divisa de principal con un DropDown y el valor a convertir con un textController,
 * y la divisa 'output' se selecciona también con un DropDown. Para mostrar un resultado se clicka en un botón 'Convertir'.
*/

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainApp();
}

// Usa TextController para guardar un valor 'input'
// Usa DropDownButton para seleccionar una divisa 'input' y otra 'output'
// Usa un campo como Chip para el valor 'output' --> Provider.singleConverted
// Usa un ElevatedButton que permite convertir --> Provider.singleConverted

class _MainApp extends State<MainApp> {
  final fromTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fromTextController.addListener(_onFromValueChanged);
  }

  void _onFromValueChanged() {
    final currencyModel = Provider.of<CurrencyModel>(context, listen: false);
    currencyModel.setFromValue(fromTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    final currencyModel = Provider.of<CurrencyModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
        // TextField para ingresar el valor a convertir
          child: TextField(
            controller: fromTextController,
            keyboardType: TextInputType.number,
            decoration:
              const InputDecoration(labelText: 'Inserta un valor'),
            key: const ValueKey("amountTextField"),
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dropdown para la selección de la divisa de entrada
            DropdownWidget(
              currencyList: currencyModel.allCurrencies,
              onValueChanged: (String? value) {
                Provider.of<CurrencyModel>(context, listen: false)
                    .setFromCurrency(value);
              },
              key: const ValueKey("fromCurrencyDropdown"),
            ),
            const SizedBox(width: 16.0),
            // Flecha
            const Icon(
              Icons.arrow_forward_rounded,
              size: 35.0
            ),
            const SizedBox(width: 16.0),
            // Dropdown para la selección de la divisa de salida
            DropdownWidget(
              currencyList: currencyModel.allCurrencies,
              onValueChanged: (String? value) {
                Provider.of<CurrencyModel>(context, listen: false)
                  .setToCurrency(value);
              },
              key: const ValueKey("toCurrencyDropdown"),
            ),
          ],
        ),        
        const SizedBox(height: 16.0),
        // Chip para mostrar el resultado de la conversión
        Center(
          child: Chip(
            label: Text(currencyModel.conversionResult),
            key: const ValueKey("singleResult"),
          ),
        ),
      ],
    );
  }
}

/*
 * SavedWidget se encarga de guardar en una lista una serie de divisas ilimitadas como 'output' que el usuario puede
 * seleccionar desde un único DropDown con divisas. Se realiza la conversión entre la divisa 'input'/'fromCurrency de la MainApp,
 * y cada una de las divisas que se guardaron en la lista. Para mostrar el resultado se clicka en el mismo botón 'Convertir' de MainApp.
 * Para borrar una divisa guardada en la lista, simplemente pulsando encima de la ListTile debería eliminarse.
*/

class SavedWidget extends StatefulWidget {
  const SavedWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SavedWidget();
}

// Usa el mismo ElevatedButton que permite convertir --> Provider.savedConverted
// Usa un DropDownButton para seleccionar las divisas que queremos ir guardando
// Usa una List para añadir y mostrar las divisas guardadas --> Provider.addCurrency
// Usa una ListTiles para al cliquar en una divisa se borre --> Provider.removeCurrency
// Usa otra List para mostrar las respuestas despues de convertir --> Provider.savedConverted

class _SavedWidget extends State<SavedWidget> {
  List<String> savedResults = [];

  @override
  Widget build(BuildContext context) {
    final currencyModel = Provider.of<CurrencyModel>(context);
    return SingleChildScrollView(
      // Agregado un SingleChildScrollView
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Monedas favoritas',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Widget para seleccionar divisas guardadas
              DropdownWidget(
                currencyList: currencyModel.allCurrencies,
                onValueChanged: (String? value) {
                  Provider.of<CurrencyModel>(context, listen: false)
                      .setFavCurrency(value);
                },
                key: const ValueKey("savedCurrency"),
              ),
              const SizedBox(width: 32.0,),
              // Botón para guardar la divisa seleccionada
              ElevatedButton(
                onPressed: () {
                  // Lógica para guardar la divisa seleccionada
                  if (currencyModel.favCurrency != null) {
                    if (currencyModel.favCurrency == currencyModel.fromCurrency ||
                        currencyModel.favCurrency == currencyModel.toCurrency) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Elige una divisa distinta'),
                        ),
                      );
                    } else if (!currencyModel.currencies
                        .contains(currencyModel.favCurrency)) {
                      Provider.of<CurrencyModel>(context, listen: false)
                          .addCurrency(currencyModel.favCurrency!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Esta divisa ya está guardada')),
                      );
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),   
          Row(
            children: [
              SizedBox(
                width: 120,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: currencyModel.currencies.length,
                  itemBuilder: (context, index) {
                    String currency = currencyModel.currencies[index];
                    return ListTile(
                      title: Text(currency),
                      onTap: () {
                        // Lógica para borrar la divisa al hacer click
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Eliminando divisa')),
                        );
                        Provider.of<CurrencyModel>(context, listen: false)
                            .removeCurrency(currency);
                        
                      },
                    );
                  },
                ),
              ),
              // Lista para mostrar los resultados de las conversiones
              SizedBox(
                width: 120,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: currencyModel.conversionResults.length,
                  itemBuilder: (context, index) {
                    String currency = currencyModel.conversionResults[index];
                    return ListTile(
                      title: Text(currency),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ConversionWidget extends StatelessWidget {
  const ConversionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyModel = Provider.of<CurrencyModel>(context);
    return ElevatedButton(
      onPressed: () {
        // Lógica para realizar la conversión y actualizar el resultado con SnackBars
        String amount = currencyModel.fromValue;

        if (currencyModel.fromCurrency == null ||
            currencyModel.toCurrency == null ||
            currencyModel.fromValue.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, complete la información')),
          );
        } else if (currencyModel.fromCurrency == currencyModel.toCurrency) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Las divisas de origen y destino no pueden ser iguales')),
          );
        } else if (double.tryParse(amount) == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El valor debe ser mayor que 0')),
          );
        } else if (currencyModel.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Límite de solicitudes por minuto alcanzado'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Realizando conversión'),
              duration: Duration(seconds: 1)
            ),
          );
          Provider.of<CurrencyModel>(context, listen: false).singleConverted(
              currencyModel.fromCurrency, currencyModel.toCurrency, amount);

          Provider.of<CurrencyModel>(context, listen: false).savedConverted(
              currencyModel.fromCurrency, currencyModel.currencies, amount);
        }
      },
      child: const Text('Convertir'),
    );
  }
}

class DropdownWidget extends StatefulWidget {
  final List<String> currencyList;
  final Function(String?) onValueChanged;

  const DropdownWidget(
      {Key? key, required this.currencyList, required this.onValueChanged})
      : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (String? newValue) {
        if (widget.currencyList.contains(newValue)) {
          selectedCurrency = newValue;
          Provider.of<CurrencyModel>(context, listen: false)
              .setSelected(newValue);
          widget.onValueChanged(newValue);
        }
      },
      items: widget.currencyList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}