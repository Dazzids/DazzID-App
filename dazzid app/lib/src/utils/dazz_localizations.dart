import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class DazzLocalizations {
  final String localeName;
  YamlMap translations;
  YamlMap translationsES;

  static const LocalizationsDelegate<DazzLocalizations> delegate =
      _DazzLocalizationsDelegate();

  DazzLocalizations(this.localeName);

  Future load() async {
    String yamlString = await rootBundle.loadString('langs/es.yml');
    translations = loadYaml(yamlString);

    String yamlStringES = await rootBundle.loadString('langs/en.yml');
    translationsES = loadYaml(yamlStringES);
  }

  String t(String key) {
    try {
      var keys = key.split('.');
      dynamic translated = translations;
      keys.forEach((k) => translated = translated[k]);

      if (translated == null) {
        return _tES(key);
      }

      return translated;
    } catch (e) {
      return _tES(key);
    }
  }

  String _tES(String key) {
    try {
      var keys = key.split('.');
      dynamic translated = translationsES;
      keys.forEach((k) => translated = translated[k]);

      if (translated == null) {
        return "Key not found $key";
      }

      return translated;
    } catch (e) {
      return "Key not found $key";
    }
  }

  static DazzLocalizations of(BuildContext context) {
    return Localizations.of<DazzLocalizations>(context, DazzLocalizations);
  }
}

class _DazzLocalizationsDelegate
    extends LocalizationsDelegate<DazzLocalizations> {
  const _DazzLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<DazzLocalizations> load(Locale locale) async {
    var t = DazzLocalizations(locale.languageCode);
    await t.load();
    return t;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) {
    return false;
  }
}
