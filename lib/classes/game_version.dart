class GameVersion{
  ///Used for indicating major changes
  static const String _majorVersion='01';

  ///Used for indicating large bug fixes or feature updates
  static const String _minorVersion='00';

  ///Used for small bug fixes
  static const String _patchVersion='00';

  static String getCurrentVersion(){
    return _majorVersion+'.'+_minorVersion+'.'+_patchVersion;
  }

}