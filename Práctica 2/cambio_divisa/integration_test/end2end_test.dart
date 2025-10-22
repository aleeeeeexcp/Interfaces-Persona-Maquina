import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:cambio_divisa/currencies.dart'; // Modelo
import 'package:cambio_divisa/main.dart'; // Vista

// Los test se han ido probando de 3 en 3 ya que los límites de solicitudes de la API
// restringen realizar más de 3 llamadas por minuto y no tenemos el Stub configurado.

// Los test que comprueban errores de conversion hacen una única llamada
// (get ALL currencies) por lo que se pueden ejecutar 3 seguidos.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  ///*

  testWidgets(
    'Test de error para elegir moneda origen y destino igual',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<CurrencyModel>(
          create: (_) => CurrencyModel(),
          child: const CambioDivisa(),
        ),
      );

      await tester.pumpAndSettle();

      final fromCurrencyDropdown =
          find.byKey(const ValueKey('fromCurrencyDropdown'));
      expect(fromCurrencyDropdown, findsOneWidget);
      await tester.tap(fromCurrencyDropdown);
      await tester.pumpAndSettle();

      final fromCurrencyItem = find.text("USD").last;
      expect(fromCurrencyItem, findsOneWidget);
      await tester.tap(fromCurrencyItem);
      await tester.pumpAndSettle();

      final toCurrencyDropdown =
          find.byKey(const ValueKey('toCurrencyDropdown'));
      expect(toCurrencyDropdown, findsOneWidget);
      await tester.tap(toCurrencyDropdown);
      await tester.pumpAndSettle();

      final toCurrencyItem = find.text("USD").last; // Misma divisa
      expect(toCurrencyItem, findsOneWidget);
      await tester.tap(toCurrencyItem);
      await tester.pumpAndSettle();

      final amountTextField = find.byKey(const ValueKey('amountTextField'));
      expect(amountTextField, findsOneWidget);
      await tester.enterText(amountTextField, '100');

      final convertButton = find.text("Convertir");
      expect(convertButton, findsOneWidget);
      await tester.tap(convertButton);
      await tester.pumpAndSettle();

      // Snackbar
      expect(find.text('Las divisas de origen y destino no pueden ser iguales'),
          findsOneWidget);
    },
  );

  //*/

  ///*

  testWidgets(
    'Test de error para convertir valor inválido, 0',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<CurrencyModel>(
          create: (_) => CurrencyModel(),
          child: const CambioDivisa(),
        ),
      );

      await tester.pumpAndSettle();

      final fromCurrencyDropdown =
          find.byKey(const ValueKey('fromCurrencyDropdown'));
      expect(fromCurrencyDropdown, findsOneWidget);
      await tester.tap(fromCurrencyDropdown);
      await tester.pumpAndSettle();

      final fromCurrencyItem = find.text("USD").last;
      expect(fromCurrencyItem, findsOneWidget);
      await tester.tap(fromCurrencyItem);
      await tester.pumpAndSettle();

      final toCurrencyDropdown =
          find.byKey(const ValueKey('toCurrencyDropdown'));
      expect(toCurrencyDropdown, findsOneWidget);
      await tester.tap(toCurrencyDropdown);
      await tester.pumpAndSettle();

      final toCurrencyItem = find.text("EUR").last;
      expect(toCurrencyItem, findsOneWidget);
      await tester.tap(toCurrencyItem);
      await tester.pumpAndSettle();

      final amountTextField = find.byKey(const ValueKey('amountTextField'));
      expect(amountTextField, findsOneWidget);
      await tester.enterText(amountTextField, '0'); // Valor inválido -> 0

      final convertButton = find.text("Convertir");
      expect(convertButton, findsOneWidget);
      await tester.tap(convertButton);
      await tester.pumpAndSettle();

      // Snackbar
      expect(find.text('El valor debe ser mayor que 0'), findsOneWidget);
    },
  );

  //*/

  ///*

  testWidgets(
    'Test de error para convertir sin completar todos los campos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<CurrencyModel>(
          create: (_) => CurrencyModel(),
          child: const CambioDivisa(),
        ),
      );

      await tester.pumpAndSettle();

      final convertButton = find.text("Convertir");
      expect(convertButton, findsOneWidget);
      await tester.tap(convertButton);
      await tester.pumpAndSettle();

      // Snackbar
      expect(find.text('Por favor, complete la información'), findsOneWidget);
    },
  );

  //*/

  ///*

  testWidgets(
    'Test de error para guardar una moneda que coincida con la de origen o destino',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<CurrencyModel>(
          create: (_) => CurrencyModel(),
          child: const CambioDivisa(),
        ),
      );

      await tester.pumpAndSettle();

      final fromCurrencyDropdown =
          find.byKey(const ValueKey('fromCurrencyDropdown'));
      expect(fromCurrencyDropdown, findsOneWidget);
      await tester.tap(fromCurrencyDropdown);
      await tester.pumpAndSettle();

      final fromCurrencyItem = find.text("USD").last;
      expect(fromCurrencyItem, findsOneWidget);
      await tester.tap(fromCurrencyItem);
      await tester.pumpAndSettle();

      final toCurrencyDropdown =
          find.byKey(const ValueKey('toCurrencyDropdown'));
      expect(toCurrencyDropdown, findsOneWidget);
      await tester.tap(toCurrencyDropdown);
      await tester.pumpAndSettle();

      final toCurrencyItem = find.text("EUR").last;
      expect(toCurrencyItem, findsOneWidget);
      await tester.tap(toCurrencyItem);
      await tester.pumpAndSettle();

      final toSavedDropdown = find.byKey(const ValueKey('savedCurrency'));
      expect(toSavedDropdown, findsOneWidget);
      await tester.tap(toSavedDropdown);
      await tester.pumpAndSettle();

      final toSavedItem = find.text("EUR").last;
      expect(toSavedItem, findsOneWidget);
      await tester.tap(toSavedItem);
      await tester.pumpAndSettle();

      final saveButton = find.text("Guardar");
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Snackbar
      expect(find.text('Elige una divisa distinta'), findsOneWidget);
    },
  );

  //*/

  ///*

  testWidgets(
    'Test de error para guardar una divisa ya en la lista de favoritos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<CurrencyModel>(
          create: (_) => CurrencyModel(),
          child: const CambioDivisa(),
        ),
      );

      await tester.pumpAndSettle();

      final toSavedDropdown1 = find.byKey(const ValueKey('savedCurrency'));
      expect(toSavedDropdown1, findsOneWidget);
      await tester.tap(toSavedDropdown1);
      await tester.pumpAndSettle();

      final toSavedItem1 = find.text("EUR").last;
      expect(toSavedItem1, findsOneWidget);
      await tester.tap(toSavedItem1);
      await tester.pumpAndSettle();

      final saveButton1 = find.text("Guardar");
      expect(saveButton1, findsOneWidget);
      await tester.tap(saveButton1);
      await tester.pumpAndSettle();

      final saveButton2 = find.text("Guardar");
      expect(saveButton2, findsOneWidget);
      await tester.tap(saveButton2);
      await tester.pumpAndSettle();

      // Snackbar
      expect(find.text('Esta divisa ya está guardada'), findsOneWidget);
    },
  );

  //*/

  ///*

  testWidgets(
    'Test para eliminar favoritos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<CurrencyModel>(
          create: (_) => CurrencyModel(),
          child: const CambioDivisa(),
        ),
      );

      await tester.pumpAndSettle();

      final toSavedDropdown1 = find.byKey(const ValueKey('savedCurrency'));
      expect(toSavedDropdown1, findsOneWidget);
      await tester.tap(toSavedDropdown1);
      await tester.pumpAndSettle();

      final toSavedItem1 = find.text("TRY").last;
      expect(toSavedItem1, findsOneWidget);
      await tester.tap(toSavedItem1);
      await tester.pumpAndSettle();

      final saveButton1 = find.text("Guardar");
      expect(saveButton1, findsOneWidget);
      await tester.tap(saveButton1);
      await tester.pumpAndSettle();   

      final toDelete = find.text("TRY").last;
      expect(toDelete, findsOneWidget);
      await tester.tap(toDelete);
      await tester.pumpAndSettle();

      expect(find.text("Eliminando divisa"), findsOneWidget);
    },
  );

//*/
}
