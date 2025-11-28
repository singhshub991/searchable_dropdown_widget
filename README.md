# searchable_dropdown_widget

A Flutter package that provides customizable searchable dropdown widgets with filtering capabilities. Perfect for selecting items from large lists with search functionality.

## Features

- 🔍 **Searchable Dropdown**: Search and filter items in real-time
- 🎨 **Customizable**: Fully customizable appearance and behavior
- 📱 **Form Integration**: Works seamlessly with Flutter forms and validation
- ⚡ **Performance**: Efficient filtering and rendering
- 🎯 **Type-safe**: Generic implementation for type safety
- 🔄 **Async Support**: Support for async search operations
- 📏 **Dynamic Height**: Configurable min/max height constraints for dropdown results

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  searchable_dropdown_widget: ^0.3.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

First, create a model class that extends `Searchable`:

```dart
class Country implements Searchable {
  final String name;
  final String code;

  Country({required this.name, required this.code});

  @override
  String get text => name;

  @override
  String get comparableText => name.toLowerCase();
}
```

### Using SearchableDropdown

```dart
import 'package:searchable_dropdown_widget/searchable_dropdown_widget.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<Country> _countries = [
    Country(name: 'United States', code: 'US'),
    Country(name: 'United Kingdom', code: 'UK'),
    Country(name: 'Canada', code: 'CA'),
    // ... more countries
  ];

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown<Country>(
      items: _countries,
      textController: _controller,
      itemBuilder: (Country country) => ListTile(
        title: Text(country.name),
        subtitle: Text(country.code),
      ),
      filter: (String query) {
        return _countries.where((country) {
          return country.comparableText.contains(query.toLowerCase());
        }).toList();
      },
      onSelect: (Country country) {
        print('Selected: ${country.name}');
      },
      label: 'Select Country',
      decoration: InputDecoration(
        hintText: 'Search countries...',
      ),
      // Optional: Customize dropdown height
      minHeight: 50.0,  // Minimum height (default: 50.0)
      maxHeight: 250.0, // Maximum height (default: 250.0)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Using SearchableTextFormField

```dart
import 'package:searchable_dropdown_widget/searchable_dropdown_widget.dart';

class MyFormWidget extends StatefulWidget {
  @override
  _MyFormWidgetState createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final List<Country> _countries = [
    Country(name: 'United States', code: 'US'),
    Country(name: 'United Kingdom', code: 'UK'),
    // ... more countries
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SearchableTextFormField<Country>(
            controller: _controller,
            itemBuilder: (Country country) => ListTile(
              title: Text(country.name),
            ),
            searchFilter: (String query) {
              return _countries.where((country) {
                return country.comparableText.contains(query.toLowerCase());
              }).toList();
            },
            onSelect: (Country country) {
              print('Selected: ${country.name}');
            },
            decoration: InputDecoration(
              labelText: 'Country',
              hintText: 'Search and select a country',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please select a country';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## API Reference

### SearchableDropdown

A searchable dropdown widget that displays a list of items with search functionality.

#### Properties

- `items` (required): List of items to display
- `textController` (required): Controller for the text field
- `itemBuilder` (required): Builder function for each item
- `filter` (optional): Custom filter function
- `onSelect` (optional): Callback when an item is selected
- `decoration` (optional): Input decoration
- `searchIcon` (optional): Custom search icon
- `label` (optional): Label text
- `textStyle` (optional): Text style for the input
- `showCloseIconOnResultPanel` (optional): Show close icon on result panel
- `showTrailingIcon` (optional): Show trailing dropdown icon
- `onFocusChange` (optional): Callback when focus changes
- `validator` (optional): Form field validator
- `minHeight` (optional): Minimum height for dropdown results panel (default: 50.0)
- `maxHeight` (optional): Maximum height for dropdown results panel (default: 250.0)
- `backgroundColor` (optional): Background color for dropdown results panel
- `bottomPadding` (optional): Bottom padding for dropdown results panel
- `endPadding` (optional): End (right) padding for dropdown results panel
- `elevation` (optional): Shadow/elevation effect (default: 1.0)
- `borderRadius` (optional): Rounded bottom corners radius (default: 0.0)

### SearchableTextFormField

A searchable text form field with dropdown results.

#### Properties

- `controller` (required): Text editing controller
- `itemBuilder` (required): Builder function for each item
- `onSelect` (optional): Callback when an item is selected
- `onChanged` (optional): Callback when text changes
- `searchFilter` (optional): Filter function for local search
- `search` (optional): Async search function
- `decoration` (optional): Input decoration
- `resultView` (optional): View type for results (list or grid)
- `validator` (optional): Form field validator
- `hintText` (optional): Hint text
- `minHeight` (optional): Minimum height for dropdown results panel (default: 50.0)
- `maxHeight` (optional): Maximum height for dropdown results panel (default: 250.0)
- `backgroundColor` (optional): Background color for dropdown results panel
- `bottomPadding` (optional): Bottom padding for dropdown results panel
- `endPadding` (optional): End (right) padding for dropdown results panel
- `elevation` (optional): Shadow/elevation effect (default: 1.0)
- `borderRadius` (optional): Rounded bottom corners radius (default: 0.0)

### Searchable Interface

All items must implement the `Searchable` interface:

```dart
abstract class Searchable {
  String get text;           // Display text
  String get comparableText; // Text used for comparison/search
}
```

## Additional information

For more information, visit the [package homepage](https://github.com/singhshub991/searchable_dropdown_widget).

If you encounter any issues or have feature requests, please file them on the [issue tracker](https://github.com/singhshub991/searchable_dropdown_widget/issues).

## License

This package is licensed under the MIT License. See the LICENSE file for details.
