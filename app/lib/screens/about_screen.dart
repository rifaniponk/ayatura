import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/core/package_info_provider.dart';
import '../widgets/common/tagged_rich_text.dart';
import '../widgets/common/gradient_app_bar.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final packageInfoAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: GradientAppBar(
        title: s.aboutTitle,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/logo/logo.png',
                        width: 96,
                        height: 96,
                        semanticLabel: s.brandLogoLabel,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    s.appTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.mainHeading,
                  ),
                  const SizedBox(height: 8),
                  packageInfoAsync.when(
                    data: (info) => Text(
                      s.aboutVersionBuild(info.version, info.buildNumber),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.meta.copyWith(color: AppColors.ink2),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  TaggedRichText(text: s.aboutBodyParagraph1),
                  const SizedBox(height: 16),
                  TaggedRichText(text: s.aboutBodyParagraph2),
                  const SizedBox(height: 24),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.privacy_tip_outlined),
                          title: Text(
                            s.aboutPrivacyPolicy,
                            style: AppTextStyles.cardLabel,
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _showTextDialog(
                            context: context,
                            title: s.aboutPrivacyPolicy,
                            body: s.aboutPrivacyBody,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(18, 8, 18, 16),
            child: Text(
              s.aboutCopyright,
              textAlign: TextAlign.center,
              style: AppTextStyles.meta.copyWith(color: AppColors.ink3),
            ),
          ),
        ],
      ),
    );
  }

  void _showTextDialog({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    final s = S.of(context)!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(s.dialogClose),
          ),
        ],
      ),
    );
  }
}
