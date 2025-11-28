import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inmotechmovil/pages/login_page.dart';
import 'package:inmotechmovil/pages/register_page.dart';
import 'package:inmotechmovil/models/inmueble.dart';

void main() {
  testWidgets('LoginPage widget test', (WidgetTester tester) async {
    // Build the LoginPage widget directly
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    // Verify that the login page contains expected widgets
    expect(find.text('Iniciar Sesión'), findsAtLeastNWidgets(1));
    expect(find.byType(TextFormField), findsAtLeastNWidgets(2)); // Usuario y contraseña
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget); // Button para navegar a registro
  });

  testWidgets('RegisterPage widget test', (WidgetTester tester) async {
    // Build the RegisterPage widget directly
    await tester.pumpWidget(
      MaterialApp(
        home: RegisterPage(),
      ),
    );

    // Verify that the register page contains expected widgets
    expect(find.text('Registro'), findsAtLeastNWidgets(1));
    expect(find.byType(TextFormField), findsAtLeastNWidgets(3)); // Usuario, correo y contraseña
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget); // Button para navegar a login
  });

  testWidgets('LoginPage navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
        routes: {
          '/register': (context) => Scaffold(body: Text('Register Page')),
        },
      ),
    );

    // Find and tap the register button (buscar por TextButton)
    final registerButton = find.byType(TextButton);
    expect(registerButton, findsOneWidget);
    
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    // Verify navigation occurred
    expect(find.text('Register Page'), findsOneWidget);
  });

  test('Inmueble model test', () {
    // Test Inmueble model creation and JSON serialization
    final inmueble = Inmueble(
      id: 1,
      imagenes: ['image1.jpg', 'image2.jpg'],
      area: 100,
      terreno: 200,
      habitaciones: 3,
      banos: 2,
      descripcion: 'Test property',
      titulo: 'Test Title',
      precio: 150000.0,
    );

    expect(inmueble.id, equals(1));
    expect(inmueble.titulo, equals('Test Title'));
    expect(inmueble.area, equals(100));
    expect(inmueble.habitaciones, equals(3));

    // Test JSON serialization
    final json = inmueble.toJson();
    expect(json['id'], equals(1));
    expect(json['titulo'], equals('Test Title'));
    expect(json['imagenes'], equals(['image1.jpg', 'image2.jpg']));

    // Test JSON deserialization
    final inmuebleFromJson = Inmueble.fromJson(json);
    expect(inmuebleFromJson.id, equals(inmueble.id));
    expect(inmuebleFromJson.titulo, equals(inmueble.titulo));
  });
}
