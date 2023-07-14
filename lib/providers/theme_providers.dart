import 'package:cosanostr/all_imports.dart';

// Bool provider for light/dark theme
final StateProvider<bool> isDarkThemeProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return true;
});

final StateProvider<bool> isThemeIndigoProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return true;
});

final StateProvider<FlexScheme> flexSchemeProvider =
    StateProvider<FlexScheme>((StateProviderRef<FlexScheme> ref) {
  if (ref.watch(isThemeIndigoProvider)) {
    return FlexScheme.indigo;
  } else {
    return FlexScheme.money;
  }
});

// ThemeMode provider for light/dark theme based on isThemeLightProvider
final StateProvider<ThemeMode> themeModeProvider =
    StateProvider<ThemeMode>((StateProviderRef<ThemeMode> ref) {
  final bool isThemeDark = ref.watch(isDarkThemeProvider);
  if (!isThemeDark) {
    return ThemeMode.light;
  } else {
    return ThemeMode.dark;
  }
});

final StateProvider<bool> isFontQuestrialProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return true;
});

final StateProvider<String?> fontProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) {
  if (ref.watch(isFontQuestrialProvider)) {
    return GoogleFonts.questrial().fontFamily;
  } else {
    return GoogleFonts.barlow().fontFamily;
  }
});

final StateProvider<ThemeData> lightThemeProvider =
    StateProvider<ThemeData>((StateProviderRef<ThemeData> ref) {
  return FlexThemeData.light(
    scheme: ref.watch(flexSchemeProvider),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      blendTextTheme: true,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      thinBorderWidth: 2.0,
      thickBorderWidth: 4.0,
      defaultRadius: 24.0,
      toggleButtonsSchemeColor: SchemeColor.primary,
      toggleButtonsUnselectedSchemeColor: SchemeColor.outline,
      switchSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
      radioSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      sliderBaseSchemeColor: SchemeColor.primary,
      sliderIndicatorSchemeColor: SchemeColor.primary,
      sliderValueTinted: true,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      fabSchemeColor: SchemeColor.primary,
      popupMenuRadius: 8.0,
      snackBarRadius: 24,
      snackBarElevation: 3,
      tabBarItemSchemeColor: SchemeColor.primary,
      tabBarUnselectedItemSchemeColor: SchemeColor.outline,
      tabBarIndicatorSchemeColor: SchemeColor.primary,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 8,
      drawerWidth: 300.0,
      drawerSelectedItemSchemeColor: SchemeColor.primary,
      drawerUnselectedItemSchemeColor: SchemeColor.outline,
      bottomSheetElevation: 3.0,
      bottomSheetModalElevation: 3.0,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.outline,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.outline,
      menuRadius: 8.0,
      menuPadding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
      menuBarRadius: 8.0,
      menuIndicatorRadius: 8.0,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.outline,
      navigationBarSelectedIconSchemeColor: SchemeColor.primary,
      navigationBarUnselectedIconSchemeColor: SchemeColor.outline,
      navigationBarHeight: 40.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailUnselectedLabelSchemeColor: SchemeColor.outline,
      navigationRailSelectedIconSchemeColor: SchemeColor.primary,
      navigationRailUnselectedIconSchemeColor: SchemeColor.outline,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
    ),
    useMaterial3ErrorColors: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: ref.watch(fontProvider),
  );
});

final StateProvider<ThemeData> darkThemeProvider =
    StateProvider<ThemeData>((StateProviderRef<ThemeData> ref) {
  return FlexThemeData.dark(
    scheme: ref.watch(flexSchemeProvider),
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 20,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendTextTheme: true,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 24.0,
      thinBorderWidth: 2.0,
      thickBorderWidth: 4.0,
      toggleButtonsSchemeColor: SchemeColor.primary,
      toggleButtonsUnselectedSchemeColor: SchemeColor.outline,
      switchSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
      radioSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      sliderBaseSchemeColor: SchemeColor.primary,
      sliderIndicatorSchemeColor: SchemeColor.primary,
      sliderValueTinted: true,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      fabSchemeColor: SchemeColor.primary,
      popupMenuRadius: 8.0,
      snackBarRadius: 24,
      snackBarElevation: 3,
      tabBarItemSchemeColor: SchemeColor.primary,
      tabBarUnselectedItemSchemeColor: SchemeColor.outline,
      tabBarIndicatorSchemeColor: SchemeColor.primary,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 8,
      drawerWidth: 300.0,
      drawerSelectedItemSchemeColor: SchemeColor.primary,
      drawerUnselectedItemSchemeColor: SchemeColor.outline,
      bottomSheetElevation: 3.0,
      bottomSheetModalElevation: 3.0,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.outline,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.outline,
      menuRadius: 8.0,
      menuPadding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
      menuBarRadius: 8.0,
      menuIndicatorRadius: 8.0,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.outline,
      navigationBarSelectedIconSchemeColor: SchemeColor.primary,
      navigationBarUnselectedIconSchemeColor: SchemeColor.outline,
      navigationBarHeight: 40.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailUnselectedLabelSchemeColor: SchemeColor.outline,
      navigationRailSelectedIconSchemeColor: SchemeColor.primary,
      navigationRailUnselectedIconSchemeColor: SchemeColor.outline,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
    ),
    useMaterial3ErrorColors: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: ref.watch(fontProvider),
  );
});
