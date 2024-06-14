# Simple Json Autocompleter for Swift

Primary use case: Parsing JSON stream from APIs (usually an LLM)

Example Usage:

```

let completedJson = JSONAutocompleter.completeJSON("{"name": "SwiftJsonAutocomplete", "purpose": ")
print(completedJson) // {"name": "SwiftJsonAutocomplete"}

```
