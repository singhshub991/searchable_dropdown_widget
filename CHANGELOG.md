## 0.3.0

* Added `minHeight` parameter to set minimum height for dropdown results panel (default: 50.0)
* Added `maxHeight` parameter to set maximum height for dropdown results panel (default: 250.0)
* Implemented dynamic height calculation based on content size
* Height now adjusts automatically between min and max constraints based on item count
* Fixed height constraints to work properly with ConstrainedBox
* Both `SearchableDropdown` and `SearchableTextFormField` now support height customization
* Improved dropdown panel sizing for better UX with varying content sizes

## 0.2.0

* Added `backgroundColor` parameter to customize dropdown options panel background color
* Added `bottomPadding` parameter for bottom padding of options widget
* Added `endPadding` parameter for end (right) padding of options widget
* Added `elevation` parameter to control shadow/elevation effect (default: 1.0)
* Added `borderRadius` parameter to customize rounded bottom corners (default: 0.0)
* Improved visual appearance with elevation and rounded corners support
* Enhanced customization options for both `SearchableDropdown` and `SearchableTextFormField`

## 0.1.0

* Initial release of searchable_dropdown package
* Added `SearchableDropdown` widget with search and filter functionality
* Added `SearchableTextFormField` widget for form integration
* Added `Searchable` interface for type-safe item implementation
* Support for custom filtering and async search operations
* Form validation support
* Customizable appearance and behavior
