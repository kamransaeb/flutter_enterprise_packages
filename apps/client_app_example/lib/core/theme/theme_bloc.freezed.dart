// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeEvent()';
}


}

/// @nodoc
class $ThemeEventCopyWith<$Res>  {
$ThemeEventCopyWith(ThemeEvent _, $Res Function(ThemeEvent) __);
}


/// Adds pattern-matching-related methods to [ThemeEvent].
extension ThemeEventPatterns on ThemeEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _EventLoaded value)?  loaded,TResult Function( _EventChanged value)?  changed,TResult Function( _EventToggleRequested value)?  toggleRequested,TResult Function( _EventDynamicColorToggled value)?  dynamicColorToggled,TResult Function( _EventFontSizeScaled value)?  fontSizeScaled,TResult Function( _EventHighContrastToggled value)?  hightContrastToggled,TResult Function( _EventResetToDefault value)?  resetToDefault,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventLoaded() when loaded != null:
return loaded(_that);case _EventChanged() when changed != null:
return changed(_that);case _EventToggleRequested() when toggleRequested != null:
return toggleRequested(_that);case _EventDynamicColorToggled() when dynamicColorToggled != null:
return dynamicColorToggled(_that);case _EventFontSizeScaled() when fontSizeScaled != null:
return fontSizeScaled(_that);case _EventHighContrastToggled() when hightContrastToggled != null:
return hightContrastToggled(_that);case _EventResetToDefault() when resetToDefault != null:
return resetToDefault(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _EventLoaded value)  loaded,required TResult Function( _EventChanged value)  changed,required TResult Function( _EventToggleRequested value)  toggleRequested,required TResult Function( _EventDynamicColorToggled value)  dynamicColorToggled,required TResult Function( _EventFontSizeScaled value)  fontSizeScaled,required TResult Function( _EventHighContrastToggled value)  hightContrastToggled,required TResult Function( _EventResetToDefault value)  resetToDefault,}){
final _that = this;
switch (_that) {
case _EventLoaded():
return loaded(_that);case _EventChanged():
return changed(_that);case _EventToggleRequested():
return toggleRequested(_that);case _EventDynamicColorToggled():
return dynamicColorToggled(_that);case _EventFontSizeScaled():
return fontSizeScaled(_that);case _EventHighContrastToggled():
return hightContrastToggled(_that);case _EventResetToDefault():
return resetToDefault(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _EventLoaded value)?  loaded,TResult? Function( _EventChanged value)?  changed,TResult? Function( _EventToggleRequested value)?  toggleRequested,TResult? Function( _EventDynamicColorToggled value)?  dynamicColorToggled,TResult? Function( _EventFontSizeScaled value)?  fontSizeScaled,TResult? Function( _EventHighContrastToggled value)?  hightContrastToggled,TResult? Function( _EventResetToDefault value)?  resetToDefault,}){
final _that = this;
switch (_that) {
case _EventLoaded() when loaded != null:
return loaded(_that);case _EventChanged() when changed != null:
return changed(_that);case _EventToggleRequested() when toggleRequested != null:
return toggleRequested(_that);case _EventDynamicColorToggled() when dynamicColorToggled != null:
return dynamicColorToggled(_that);case _EventFontSizeScaled() when fontSizeScaled != null:
return fontSizeScaled(_that);case _EventHighContrastToggled() when hightContrastToggled != null:
return hightContrastToggled(_that);case _EventResetToDefault() when resetToDefault != null:
return resetToDefault(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loaded,TResult Function( AppThemeStatus themeStatus)?  changed,TResult Function()?  toggleRequested,TResult Function( bool enabled)?  dynamicColorToggled,TResult Function( double scale)?  fontSizeScaled,TResult Function( bool enabled)?  hightContrastToggled,TResult Function()?  resetToDefault,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventLoaded() when loaded != null:
return loaded();case _EventChanged() when changed != null:
return changed(_that.themeStatus);case _EventToggleRequested() when toggleRequested != null:
return toggleRequested();case _EventDynamicColorToggled() when dynamicColorToggled != null:
return dynamicColorToggled(_that.enabled);case _EventFontSizeScaled() when fontSizeScaled != null:
return fontSizeScaled(_that.scale);case _EventHighContrastToggled() when hightContrastToggled != null:
return hightContrastToggled(_that.enabled);case _EventResetToDefault() when resetToDefault != null:
return resetToDefault();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loaded,required TResult Function( AppThemeStatus themeStatus)  changed,required TResult Function()  toggleRequested,required TResult Function( bool enabled)  dynamicColorToggled,required TResult Function( double scale)  fontSizeScaled,required TResult Function( bool enabled)  hightContrastToggled,required TResult Function()  resetToDefault,}) {final _that = this;
switch (_that) {
case _EventLoaded():
return loaded();case _EventChanged():
return changed(_that.themeStatus);case _EventToggleRequested():
return toggleRequested();case _EventDynamicColorToggled():
return dynamicColorToggled(_that.enabled);case _EventFontSizeScaled():
return fontSizeScaled(_that.scale);case _EventHighContrastToggled():
return hightContrastToggled(_that.enabled);case _EventResetToDefault():
return resetToDefault();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loaded,TResult? Function( AppThemeStatus themeStatus)?  changed,TResult? Function()?  toggleRequested,TResult? Function( bool enabled)?  dynamicColorToggled,TResult? Function( double scale)?  fontSizeScaled,TResult? Function( bool enabled)?  hightContrastToggled,TResult? Function()?  resetToDefault,}) {final _that = this;
switch (_that) {
case _EventLoaded() when loaded != null:
return loaded();case _EventChanged() when changed != null:
return changed(_that.themeStatus);case _EventToggleRequested() when toggleRequested != null:
return toggleRequested();case _EventDynamicColorToggled() when dynamicColorToggled != null:
return dynamicColorToggled(_that.enabled);case _EventFontSizeScaled() when fontSizeScaled != null:
return fontSizeScaled(_that.scale);case _EventHighContrastToggled() when hightContrastToggled != null:
return hightContrastToggled(_that.enabled);case _EventResetToDefault() when resetToDefault != null:
return resetToDefault();case _:
  return null;

}
}

}

/// @nodoc


class _EventLoaded extends ThemeEvent {
  const _EventLoaded(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventLoaded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeEvent.loaded()';
}


}




/// @nodoc


class _EventChanged extends ThemeEvent {
  const _EventChanged({required this.themeStatus}): super._();
  

 final  AppThemeStatus themeStatus;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventChangedCopyWith<_EventChanged> get copyWith => __$EventChangedCopyWithImpl<_EventChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventChanged&&(identical(other.themeStatus, themeStatus) || other.themeStatus == themeStatus));
}


@override
int get hashCode => Object.hash(runtimeType,themeStatus);

@override
String toString() {
  return 'ThemeEvent.changed(themeStatus: $themeStatus)';
}


}

/// @nodoc
abstract mixin class _$EventChangedCopyWith<$Res> implements $ThemeEventCopyWith<$Res> {
  factory _$EventChangedCopyWith(_EventChanged value, $Res Function(_EventChanged) _then) = __$EventChangedCopyWithImpl;
@useResult
$Res call({
 AppThemeStatus themeStatus
});




}
/// @nodoc
class __$EventChangedCopyWithImpl<$Res>
    implements _$EventChangedCopyWith<$Res> {
  __$EventChangedCopyWithImpl(this._self, this._then);

  final _EventChanged _self;
  final $Res Function(_EventChanged) _then;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? themeStatus = null,}) {
  return _then(_EventChanged(
themeStatus: null == themeStatus ? _self.themeStatus : themeStatus // ignore: cast_nullable_to_non_nullable
as AppThemeStatus,
  ));
}


}

/// @nodoc


class _EventToggleRequested extends ThemeEvent {
  const _EventToggleRequested(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventToggleRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeEvent.toggleRequested()';
}


}




/// @nodoc


class _EventDynamicColorToggled extends ThemeEvent {
  const _EventDynamicColorToggled({required this.enabled}): super._();
  

 final  bool enabled;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDynamicColorToggledCopyWith<_EventDynamicColorToggled> get copyWith => __$EventDynamicColorToggledCopyWithImpl<_EventDynamicColorToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDynamicColorToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'ThemeEvent.dynamicColorToggled(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$EventDynamicColorToggledCopyWith<$Res> implements $ThemeEventCopyWith<$Res> {
  factory _$EventDynamicColorToggledCopyWith(_EventDynamicColorToggled value, $Res Function(_EventDynamicColorToggled) _then) = __$EventDynamicColorToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$EventDynamicColorToggledCopyWithImpl<$Res>
    implements _$EventDynamicColorToggledCopyWith<$Res> {
  __$EventDynamicColorToggledCopyWithImpl(this._self, this._then);

  final _EventDynamicColorToggled _self;
  final $Res Function(_EventDynamicColorToggled) _then;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_EventDynamicColorToggled(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _EventFontSizeScaled extends ThemeEvent {
  const _EventFontSizeScaled({required this.scale}): super._();
  

 final  double scale;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventFontSizeScaledCopyWith<_EventFontSizeScaled> get copyWith => __$EventFontSizeScaledCopyWithImpl<_EventFontSizeScaled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventFontSizeScaled&&(identical(other.scale, scale) || other.scale == scale));
}


@override
int get hashCode => Object.hash(runtimeType,scale);

@override
String toString() {
  return 'ThemeEvent.fontSizeScaled(scale: $scale)';
}


}

/// @nodoc
abstract mixin class _$EventFontSizeScaledCopyWith<$Res> implements $ThemeEventCopyWith<$Res> {
  factory _$EventFontSizeScaledCopyWith(_EventFontSizeScaled value, $Res Function(_EventFontSizeScaled) _then) = __$EventFontSizeScaledCopyWithImpl;
@useResult
$Res call({
 double scale
});




}
/// @nodoc
class __$EventFontSizeScaledCopyWithImpl<$Res>
    implements _$EventFontSizeScaledCopyWith<$Res> {
  __$EventFontSizeScaledCopyWithImpl(this._self, this._then);

  final _EventFontSizeScaled _self;
  final $Res Function(_EventFontSizeScaled) _then;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? scale = null,}) {
  return _then(_EventFontSizeScaled(
scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _EventHighContrastToggled extends ThemeEvent {
  const _EventHighContrastToggled({required this.enabled}): super._();
  

 final  bool enabled;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventHighContrastToggledCopyWith<_EventHighContrastToggled> get copyWith => __$EventHighContrastToggledCopyWithImpl<_EventHighContrastToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventHighContrastToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'ThemeEvent.hightContrastToggled(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$EventHighContrastToggledCopyWith<$Res> implements $ThemeEventCopyWith<$Res> {
  factory _$EventHighContrastToggledCopyWith(_EventHighContrastToggled value, $Res Function(_EventHighContrastToggled) _then) = __$EventHighContrastToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$EventHighContrastToggledCopyWithImpl<$Res>
    implements _$EventHighContrastToggledCopyWith<$Res> {
  __$EventHighContrastToggledCopyWithImpl(this._self, this._then);

  final _EventHighContrastToggled _self;
  final $Res Function(_EventHighContrastToggled) _then;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_EventHighContrastToggled(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _EventResetToDefault extends ThemeEvent {
  const _EventResetToDefault(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventResetToDefault);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeEvent.resetToDefault()';
}


}




/// @nodoc
mixin _$ThemeState {

 AppThemeStatus get currentThemeStatus; bool get useDynamicColor; double get fontSizeScale; bool get useHighContrast;
/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeStateCopyWith<ThemeState> get copyWith => _$ThemeStateCopyWithImpl<ThemeState>(this as ThemeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeState&&(identical(other.currentThemeStatus, currentThemeStatus) || other.currentThemeStatus == currentThemeStatus)&&(identical(other.useDynamicColor, useDynamicColor) || other.useDynamicColor == useDynamicColor)&&(identical(other.fontSizeScale, fontSizeScale) || other.fontSizeScale == fontSizeScale)&&(identical(other.useHighContrast, useHighContrast) || other.useHighContrast == useHighContrast));
}


@override
int get hashCode => Object.hash(runtimeType,currentThemeStatus,useDynamicColor,fontSizeScale,useHighContrast);

@override
String toString() {
  return 'ThemeState(currentThemeStatus: $currentThemeStatus, useDynamicColor: $useDynamicColor, fontSizeScale: $fontSizeScale, useHighContrast: $useHighContrast)';
}


}

/// @nodoc
abstract mixin class $ThemeStateCopyWith<$Res>  {
  factory $ThemeStateCopyWith(ThemeState value, $Res Function(ThemeState) _then) = _$ThemeStateCopyWithImpl;
@useResult
$Res call({
 AppThemeStatus currentThemeStatus, bool useDynamicColor, double fontSizeScale, bool useHighContrast
});




}
/// @nodoc
class _$ThemeStateCopyWithImpl<$Res>
    implements $ThemeStateCopyWith<$Res> {
  _$ThemeStateCopyWithImpl(this._self, this._then);

  final ThemeState _self;
  final $Res Function(ThemeState) _then;

/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentThemeStatus = null,Object? useDynamicColor = null,Object? fontSizeScale = null,Object? useHighContrast = null,}) {
  return _then(_self.copyWith(
currentThemeStatus: null == currentThemeStatus ? _self.currentThemeStatus : currentThemeStatus // ignore: cast_nullable_to_non_nullable
as AppThemeStatus,useDynamicColor: null == useDynamicColor ? _self.useDynamicColor : useDynamicColor // ignore: cast_nullable_to_non_nullable
as bool,fontSizeScale: null == fontSizeScale ? _self.fontSizeScale : fontSizeScale // ignore: cast_nullable_to_non_nullable
as double,useHighContrast: null == useHighContrast ? _self.useHighContrast : useHighContrast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeState].
extension ThemeStatePatterns on ThemeState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StateInitial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StateInitial() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StateInitial value)  $default,){
final _that = this;
switch (_that) {
case _StateInitial():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StateInitial value)?  $default,){
final _that = this;
switch (_that) {
case _StateInitial() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppThemeStatus currentThemeStatus,  bool useDynamicColor,  double fontSizeScale,  bool useHighContrast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StateInitial() when $default != null:
return $default(_that.currentThemeStatus,_that.useDynamicColor,_that.fontSizeScale,_that.useHighContrast);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppThemeStatus currentThemeStatus,  bool useDynamicColor,  double fontSizeScale,  bool useHighContrast)  $default,) {final _that = this;
switch (_that) {
case _StateInitial():
return $default(_that.currentThemeStatus,_that.useDynamicColor,_that.fontSizeScale,_that.useHighContrast);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppThemeStatus currentThemeStatus,  bool useDynamicColor,  double fontSizeScale,  bool useHighContrast)?  $default,) {final _that = this;
switch (_that) {
case _StateInitial() when $default != null:
return $default(_that.currentThemeStatus,_that.useDynamicColor,_that.fontSizeScale,_that.useHighContrast);case _:
  return null;

}
}

}

/// @nodoc


class _StateInitial extends ThemeState {
  const _StateInitial({this.currentThemeStatus = AppThemeStatus.system, this.useDynamicColor = false, this.fontSizeScale = 1.0, this.useHighContrast = false}): super._();
  

@override@JsonKey() final  AppThemeStatus currentThemeStatus;
@override@JsonKey() final  bool useDynamicColor;
@override@JsonKey() final  double fontSizeScale;
@override@JsonKey() final  bool useHighContrast;

/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StateInitialCopyWith<_StateInitial> get copyWith => __$StateInitialCopyWithImpl<_StateInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StateInitial&&(identical(other.currentThemeStatus, currentThemeStatus) || other.currentThemeStatus == currentThemeStatus)&&(identical(other.useDynamicColor, useDynamicColor) || other.useDynamicColor == useDynamicColor)&&(identical(other.fontSizeScale, fontSizeScale) || other.fontSizeScale == fontSizeScale)&&(identical(other.useHighContrast, useHighContrast) || other.useHighContrast == useHighContrast));
}


@override
int get hashCode => Object.hash(runtimeType,currentThemeStatus,useDynamicColor,fontSizeScale,useHighContrast);

@override
String toString() {
  return 'ThemeState(currentThemeStatus: $currentThemeStatus, useDynamicColor: $useDynamicColor, fontSizeScale: $fontSizeScale, useHighContrast: $useHighContrast)';
}


}

/// @nodoc
abstract mixin class _$StateInitialCopyWith<$Res> implements $ThemeStateCopyWith<$Res> {
  factory _$StateInitialCopyWith(_StateInitial value, $Res Function(_StateInitial) _then) = __$StateInitialCopyWithImpl;
@override @useResult
$Res call({
 AppThemeStatus currentThemeStatus, bool useDynamicColor, double fontSizeScale, bool useHighContrast
});




}
/// @nodoc
class __$StateInitialCopyWithImpl<$Res>
    implements _$StateInitialCopyWith<$Res> {
  __$StateInitialCopyWithImpl(this._self, this._then);

  final _StateInitial _self;
  final $Res Function(_StateInitial) _then;

/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentThemeStatus = null,Object? useDynamicColor = null,Object? fontSizeScale = null,Object? useHighContrast = null,}) {
  return _then(_StateInitial(
currentThemeStatus: null == currentThemeStatus ? _self.currentThemeStatus : currentThemeStatus // ignore: cast_nullable_to_non_nullable
as AppThemeStatus,useDynamicColor: null == useDynamicColor ? _self.useDynamicColor : useDynamicColor // ignore: cast_nullable_to_non_nullable
as bool,fontSizeScale: null == fontSizeScale ? _self.fontSizeScale : fontSizeScale // ignore: cast_nullable_to_non_nullable
as double,useHighContrast: null == useHighContrast ? _self.useHighContrast : useHighContrast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
