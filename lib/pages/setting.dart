import 'package:days/model/update.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/l10n.dart';
import '../model/Backup.dart';
import '../model/LanguageProvider.dart';
import '../theme/theme.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Setting),
      ),
      body: ListView(
        padding: const EdgeInsets.all(2),
        children: [
          Center(
            child: Container(
                padding: const EdgeInsets.all(10),
                width: 200,
                height: 200,
                child: const Image(
                  image: AssetImage('assets/AppIcon/AppIcon.png'),
                )),
          ),
          const Divider(),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                title: Text(
                    "${S.of(context).ThemeType} ${_getThemeModeText(themeProvider.themeMode)}"),
                trailing: IconButton(
                  icon: _getThemeModeIcon(themeProvider.themeMode),
                  onPressed: () {
                    // 切换主题模式
                    themeProvider.toggleThemeMode();
                  },
                ),
              );
            },
          ),
          const Divider(),
          // 主题颜色选择
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ExpansionTile(
                title: Text(S.of(context).ThemeColor),
                trailing: Icon(
                  Icons.color_lens,
                  color: Theme.of(context).primaryColor,
                ),
                children: [
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: AppTheme.availableSchemes.length,
                      itemBuilder: (context, index) {
                        final scheme = AppTheme.availableSchemes[index];
                        return GestureDetector(
                          onTap: () => themeProvider.changeColorScheme(scheme),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeProvider.currentScheme == scheme
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3)
                                  : null,
                              border: Border.all(
                                color: themeProvider.currentScheme == scheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ColorSchemePreview(scheme: scheme),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return ListTile(
                title: Text(
                    "${S.of(context).language} ${languageProvider.locale.languageCode == 'zh' ? '中文' : 'English'}"),
                trailing: DropdownButton<String>(
                  value: languageProvider.locale.languageCode,
                  items: const [
                    DropdownMenuItem(
                      value: 'zh',
                      child: Text('中文'),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                  ],
                  onChanged: (String? newLanguageCode) {
                    if (newLanguageCode != null) {
                      languageProvider.changeLanguage(newLanguageCode);
                    }
                  },
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(S.of(context).UpDate),
            trailing: const Icon(Icons.update_rounded),
            onTap: () {
              Getpackgeinfo.githubrelease(context);
            },
          ),
          const Divider(),
          ListTile(
            title: Text(S.of(context).Code),
            trailing: const Icon(Icons.code_outlined),
            onTap: () async {
              //打开浏览器
              const url = 'https://github.com/Asseken/days';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw "Could not launch $url";
              }
            },
          ),
          const Divider(),
          ExpansionTile(
            initiallyExpanded: false,
            title: Text(S.of(context).BR),
            children: [
              ListTile(
                  title: Text(S.of(context).Backups),
                  trailing: const Icon(Icons.backup_outlined),
                  onTap: () async {
                    // 创建 BackupDate 的实例
                    BackupDate backupDate = BackupDate();
                    // 调用备份方法
                    await backupDate.backupDatabase(context);
                  }),
              ListTile(
                  title: Text(S.of(context).Restore),
                  trailing: const Icon(Icons.restore_outlined),
                  onTap: () async {
                    // 创建 BackupDate 的实例
                    BackupDate backupDate = BackupDate();
                    // 调用备份方法
                    await backupDate.restoreDatabase(context);
                  }),
            ],
          ),
          const Divider(),
          ListTile(
            title: Text(S.of(context).About),
            trailing: const Icon(Icons.info_outline),
            onTap: () async {
              await Getpackgeinfo.getPackageInfo();
              showAboutDialog(
                context: context,
                applicationName: 'Days',
                applicationVersion: Getpackgeinfo.appversion,
                applicationIcon: const Image(
                  image: AssetImage('assets/AppIcon/AppIcon.png'),
                  width: 50,
                  height: 50,
                ),
                children: [
                  Text(S.of(context).SPT),
                ],
              );
            },
          ),
          const Divider(),
          const Center(
            child: Text(
              "ZJL & ZDM 2024",
              style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  /// 根据主题模式返回对应的文字描述
  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return S.of(context).System;
      case ThemeMode.light:
        return S.of(context).Light;
      case ThemeMode.dark:
        return S.of(context).Dark;
    }
  }

// 添加一个方法来返回对应的图标
  Icon _getThemeModeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return const Icon(Icons.settings_brightness);
      case ThemeMode.light:
        return const Icon(Icons.light_mode);
      case ThemeMode.dark:
        return const Icon(Icons.dark_mode);
    }
  }
}

/// 颜色方案预览小组件
class ColorSchemePreview extends StatelessWidget {
  final FlexScheme scheme;

  const ColorSchemePreview({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final lightColors = FlexThemeData.light(scheme: scheme).colorScheme;
    final darkColors = FlexThemeData.dark(scheme: scheme).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: size / 2,
                height: size / 2,
                color: lightColors.primary,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: size / 2,
                height: size / 2,
                color: lightColors.secondary,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size / 2,
                height: size / 2,
                color: darkColors.primary,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size / 2,
                height: size / 2,
                color: darkColors.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
