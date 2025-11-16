## 0.0.1

- First version.

## 0.0.2

- Added NavigationStyles to choose the style of the bottom navigation bar. The preferred style can be selected and the ui will be organized accordingly.

## 0.0.3

### Features
- Added item-level and global customization for icons and text.

### Fixes
- Improved text rotation and sizing in circular navigation for better UI consistency.

### Improvements & Refactoring
- Enhanced state management by replacing `setState` with `ValueNotifier` for better performance.
- Separated navigation logic into distinct widgets managed by a `CircleBNBController`.
- Refactored `CircleBNB` to dynamically calculate its default size based on the screen dimensions.
- Improved animations for smoother transitions and a more polished user experience.
- Updated the example application with better structure and corrected navigation items.

### Documentation
- Added comprehensive dartdoc comments to all public properties of the `CircleBNB` widget.
