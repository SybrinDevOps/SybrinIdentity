# Sybrin.iOS.SDK.Identity

A standalone SDK used for identity document capture and verification.

## Release checklist:

### Functional:
- [x] Ensure access modifiers are appropriate for functions/properties. i.e. only methods that should be accessed by the library consumer can be public, rest should be internal/private.
- [x] Replace all `debugLog()`, `print()`, `NSLog()` and `debugPrint()` statements with `log()` function, and ensure all `log()` functions follow the appropriate logging levels and params are set appropriately.
- [x] Add guard statements instead of force unwrapping variables.
- [x] Make Objective C compliant (only add @objc attribute to functions/variables that should be callable in Objective C)

### Cleanup:
- [x] Remove dead code (unused functions/properties/code etc).
- [x] Remove unused imports.
- [x] Fix spelling mistakes.
- [x] Enforce coding standards. eg. camelCase public/open properties/functions, PascalCase internal/private properties/functions.
- [x] Move code around to structure according to a template/standard. eg. internal properties/constants should be defined first, then public functions and lastly (at the bottom of the class) should be the private functions.
- [x] Add MARK templates for classes. eg. 'MARK: Internal Properties' or 'MARK: Private methods' etc.
- [x] Move classes/structs/enums/extensions/handlers etc. into appropriate files/groups.

### Optimization:
- [x] Restrict inheritence by adding final to classes.
- [ ] Add documentation comments for all public functions/properties to help out the library consumer. eg. place '///this function will do awesome things' above an awesome function.
- [x] Remove untruthful comments and add better comments (comments are failures, only add comments when they are really needed and the code doesn't explain itself)
