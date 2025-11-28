import 'package:flutter/material.dart';
import 'package:searchable_dropdown_widget/searchable_dropdown.dart';

// Example model implementing Searchable
class Country implements Searchable {
  final String name;
  final String code;
  final String capital;

  Country({
    required this.name,
    required this.code,
    required this.capital,
  });

  @override
  String get text => name;

  @override
  String get comparableText => name.toLowerCase();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Searchable Dropdown Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _dropdownController = TextEditingController();

  final List<Country> _countries = [
    Country(name: 'United States', code: 'US', capital: 'Washington D.C.'),
    Country(name: 'United Kingdom', code: 'UK', capital: 'London'),
    Country(name: 'Canada', code: 'CA', capital: 'Ottawa'),
    Country(name: 'Australia', code: 'AU', capital: 'Canberra'),
    Country(name: 'Germany', code: 'DE', capital: 'Berlin'),
    Country(name: 'France', code: 'FR', capital: 'Paris'),
    Country(name: 'Japan', code: 'JP', capital: 'Tokyo'),
    Country(name: 'China', code: 'CN', capital: 'Beijing'),
    Country(name: 'India', code: 'IN', capital: 'New Delhi'),
    Country(name: 'Brazil', code: 'BR', capital: 'Brasília'),
    Country(name: 'Russia', code: 'RU', capital: 'Moscow'),
    Country(name: 'South Korea', code: 'KR', capital: 'Seoul'),
    Country(name: 'Italy', code: 'IT', capital: 'Rome'),
    Country(name: 'Spain', code: 'ES', capital: 'Madrid'),
    Country(name: 'Mexico', code: 'MX', capital: 'Mexico City'),
  ];

  Country? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Searchable Dropdown Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SearchableDropdown Example',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This widget provides a searchable dropdown with real-time filtering.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SearchableDropdown<Country>(
              items: _countries,
              textController: _dropdownController,
              itemBuilder: (Country country) => ListTile(
                title: Text(country.name),
                subtitle: Text('${country.code} - ${country.capital}'),
                leading: const Icon(Icons.flag, color: Colors.blue),
              ),
              filter: (String query) {
                return _countries.where((country) {
                  return country.comparableText.contains(query.toLowerCase());
                }).toList();
              },
              onSelect: (Country country) {
                setState(() {
                  _selectedCountry = country;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected: ${country.name}'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              label: 'Select Country',
              decoration: const InputDecoration(
                hintText: 'Search countries...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              backgroundColor: Colors.grey.shade50,
              bottomPadding: 8.0,
              endPadding: 8.0,
              elevation: 1.0,
              borderRadius: 12.0,
              // Optional height constraints (defaults: minHeight: 50.0, maxHeight: 250.0)
              minHeight: 10.0,  // Uncomment to set custom minimum height
              maxHeight: 100.0,  // Uncomment to set custom maximum height
            ),
            if (_selectedCountry != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Selected Country:',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Name', _selectedCountry!.name),
                      _buildInfoRow('Code', _selectedCountry!.code),
                      _buildInfoRow('Capital', _selectedCountry!.capital),
                    ],
                  ),
                ),
              ),
            ],

          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    super.dispose();
  }
}

