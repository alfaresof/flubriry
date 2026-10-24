import 'package:flubriry/models/app_language.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/localized_text.dart';

/// All interface copy lives here, in both languages.
///
/// Keeping it as plain getters means adding a language is a compile-time
/// affair: no generated lookup can silently fall back to English.
class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  String pick(String en, String ar) => language.isArabic ? ar : en;

  // ── Header & navigation ────────────────────────────────────────────────
  String get brandTagline =>
      pick('A Flutter component library', 'مكتبة مكونات فلاتر');
  String get github => 'GitHub';
  String get xTwitter => 'X';
  String get siteTitle => pick(
    'flubriry — a Flutter component library',
    'flubriry — مكتبة مكونات فلاتر',
  );
  String componentPageTitle(String name) => '$name — flubriry';
  String get contributeOnGithub =>
      pick('Contribute on GitHub', 'ساهم على GitHub');
  String get componentsNav => pick('Components', 'المكونات');
  String get contributeNav => pick('Contribute', 'ساهم');
  String get repositoryLabel => pick('Repository', 'المستودع');
  String get appearance => pick('Appearance', 'المظهر');
  String get appearanceSubtitle =>
      pick('Language, theme, and color.', 'اللغة والمظهر واللون.');
  String get themeLabel => pick('Theme', 'المظهر');
  String get themeAuto => pick('Auto', 'تلقائي');
  String get themeLight => pick('Light', 'فاتح');
  String get themeDark => pick('Dark', 'داكن');
  String get accentLabel => pick('Color', 'اللون');
  String get accentHint => pick(
    'Every component follows this color.',
    'كل المكونات تتبع هذا اللون.',
  );
  String get languageLabel => pick('Language', 'اللغة');
  String get done => pick('Done', 'تم');
  String get close => pick('Close', 'إغلاق');
  String get english => pick('English', 'الإنجليزية');
  String get arabic => pick('Arabic', 'العربية');
  String get languageEnglish => 'English';
  String get languageArabic => 'العربية';

  // ── Hero ────────────────────────────────────────────────────────────────
  String get heroLineOne => pick('Stand out with components', 'تفرّد بمكونات');
  String get heroLineTwo => pick('beyond the ordinary.', 'خارج المألوف');
  String get browseShelf => pick('Browse the shelf', 'تصفح الرف');
  String metaComponents(int count) =>
      pick('$count components', '$count مكونًا');
  String metaCategories(int count) =>
      pick('$count categories', '$count تصنيفات');
  String get metaLicense => pick('MIT licensed', 'رخصة MIT');
  String get featuredLabel => pick('From the shelf', 'من الرف');
  String get featuredAction => pick('Open component', 'افتح المكون');

  // ── Toolbar ─────────────────────────────────────────────────────────────
  String get searchHint => pick('Search components…', 'ابحث في المكونات…');
  String get searchClear => pick('Clear search', 'امسح البحث');
  String get searchShortcutHint => pick('Press / to search', 'اضغط / للبحث');
  String get allCategory => pick('All', 'الكل');
  String categoryLabel(ComponentCategory category) {
    return switch (category) {
      ComponentCategory.buttons => pick('Buttons', 'الأزرار'),
      ComponentCategory.inputs => pick('Inputs', 'المدخلات'),
      ComponentCategory.navigation => pick('Navigation', 'التنقل'),
      ComponentCategory.display => pick('Display', 'العرض'),
      ComponentCategory.states => pick('States', 'الحالات'),
    };
  }

  String showingRange(int start, int end, int total) {
    if (total == 0) return pick('No results', 'لا نتائج');
    return pick('Showing $start–$end of $total', 'عرض $start–$end من $total');
  }

  String get clearFilters => pick('Clear filters', 'امسح التصفية');

  // ── Pagination ──────────────────────────────────────────────────────────
  String pageOf(int page, int count) =>
      pick('Page $page of $count', 'الصفحة $page من $count');
  String get previousPage => pick('Previous page', 'الصفحة السابقة');
  String get nextPage => pick('Next page', 'الصفحة التالية');
  String pageNumber(int page) => pick('Page $page', 'الصفحة $page');

  // ── Cards & catalogue ───────────────────────────────────────────────────
  String get copy => pick('Copy', 'نسخ');
  String get copied => pick('Copied', 'تم النسخ');
  String get copyCode => pick('Copy code', 'انسخ الكود');
  String get copyFailed => pick(
    'Could not copy. Try selecting the code.',
    'تعذّر النسخ. جرّب تحديد الكود.',
  );
  String get linkError =>
      pick('Could not open that link.', 'تعذّر فتح الرابط.');
  String get openComponent => pick('Open component', 'افتح المكون');
  String originName(String? origin) {
    return switch (origin) {
      'Qafelah' => pick('From Qafelah', 'من قافلة'),
      'Khaber' => pick('From Khaber', 'من خبر'),
      null => 'flubriry',
      _ => origin,
    };
  }

  String get originFactLabel => pick('Origin', 'الأصل');
  String get fileLabel => pick('File', 'الملف');
  String get noComponentsTitle => pick('The shelf is empty.', 'الرف فارغ.');
  String get noComponentsBody => pick(
    'Drop a component file into lib/components, then run the generator.',
    'أضف ملف مكون إلى lib/components، ثم شغّل المولّد.',
  );
  String get emptyTitle =>
      pick('Nothing on this shelf.', 'لا شيء على هذا الرف.');
  String get emptyBody => pick(
    'Try a different word, or clear the filters and start again.',
    'جرّب كلمة أخرى، أو امسح التصفية وابدأ من جديد.',
  );

  // ── Detail ──────────────────────────────────────────────────────────────
  String get backToLibrary => pick('All components', 'كل المكونات');
  String get sourceLabel => pick('Source', 'المصدر');
  String get dependenciesLabel => pick('Needs', 'يحتاج');
  String get pureFlutter => pick('Pure Flutter', 'فلاتر فقط');
  String get viewOnGithub =>
      pick('View source on GitHub', 'اعرض المصدر على GitHub');
  String get nextComponent => pick('Next component', 'المكون التالي');
  String get previousComponent => pick('Previous component', 'المكون السابق');
  String get previewLabel => pick('Live preview', 'معاينة حية');
  String get previewHint => pick('Try the controls', 'جرّب العناصر');
  String componentNumber(int n) =>
      language.isArabic ? 'المكون $n' : 'Component $n';

  // ── Contribute page ─────────────────────────────────────────────────────
  String get contributeTitle => pick(
    'Contribute with us and add your components.',
    'ساهم معنا وأضف مكوناتك',
  );
  String get contributeIntro => pick(
    'One file. One command. Your component joins the shelf in both languages.',
    'ملف واحد. أمر واحد. مكونك ينضم إلى المكتبة باللغتين.',
  );
  String get contributeEyebrow => pick('The shelf is open', 'الرف مفتوح');
  String get step1Title => pick('Copy the template', 'انسخ القالب');
  String get step1Body => pick(
    'Start from _template.dart inside the components folder.',
    'ابدأ من _template.dart داخل مجلد المكونات.',
  );
  String get step2Title => pick('Paste your component', 'الصق المكون');
  String get step2Body => pick(
    'Add your component in the file and give it a name.',
    'أضف مكونك والصقه داخل الملف وأعطه اسمًا.',
  );
  String get step3Title =>
      pick('To try it, run the generator', 'للتجربة شغّل المولد');
  String get step3Body => pick(
    'One command adds it to the catalogue, search, and navigation.',
    'أمر واحد يضيفه إلى المكتبة والبحث والتنقل.',
  );
  String get dropFolderLabel => pick('The drop folder', 'مجلد الإضافة');
  String get templateLabel => pick('The template', 'القالب');
  String get oneCommandLabel => pick('The one command', 'الأمر الواحد');
  String generatorOutput(int count) =>
      pick('✓ $count components registered', '✓ تم تسجيل $count مكونًا');
  String get contributeCta => pick('Start on GitHub', 'ابدأ على GitHub');
  String get openPullRequest => pick('Open a pull request', 'افتح طلب دمج');
  String get folderName => 'lib/components/';
  String get templateName => '_template.dart';
  String get placeholderComponentName => 'your_component.dart';
  String get howItWorks => pick('How it works', 'كيف تعمل');
  String get openTemplate => pick('Open the template', 'افتح القالب');
  String get readyToAdd => pick('Ready to add yours?', 'جاهز تضيف مكونك؟');
  String get contributeClosing => pick(
    'Open a pull request with the component file, and the shelf grows.',
    'افتح طلب دمج بملف المكون، وينمو الرف.',
  );
  String get localGeneratorNote => pick(
    'Local preview only. CI generates the registry on every pull request.',
    'للمعاينة المحلية فقط. يولّد GitHub Actions السجل في كل طلب دمج.',
  );
  String get rulesTitle => pick('A good component is…', 'المكون الجيد…');
  String get ruleStandalone => pick('Standalone', 'قائم بذاته');
  String get ruleBilingual => pick('Bilingual', 'ثنائي اللغة');
  String get ruleThemeAware => pick('Theme-aware', 'يتبع المظهر');
  String get ruleAccessible => pick('Accessible', 'يمكن الوصول إليه');

  // ── Creator & accounts ──────────────────────────────────────────────────
  String get creatorEyebrow => pick('Built by', 'صنعه');
  String get creatorName => 'Obida';
  String get creatorHandle => '@alfaresof';
  String get creatorBio => pick(
    'Flutter developer, on a mission to make the Arabic Flutter world stronger.',
    'مطوّر فلاتر، مهتم بجعل عالم فلاتر العربية أقوى وأفضل',
  );
  String get accountsLabel => pick('Find me', 'حسابي');
  String get followOnGithub => pick('GitHub', 'GitHub');
  String get followOnX => pick('X (Twitter)', 'X (تويتر)');

  // ── Footer ──────────────────────────────────────────────────────────────
  String get footerTagline =>
      pick('Small parts, carefully made.', 'أجزاء صغيرة، مصنوعة بعناية.');
  String get footerNote => pick(
    'Built with Flutter. Free to borrow under the MIT license.',
    'مبني بفلاتر. متاح للاقتباس تحت رخصة MIT.',
  );
  String get backToTop => pick('Back to top', 'إلى الأعلى');
  String get notFoundTitle =>
      pick('This page is not on the shelf.', 'هذه الصفحة ليست على الرف.');
  String get notFoundBody => pick(
    'The link may be old, or the component moved.',
    'قد يكون الرابط قديمًا، أو انتقل المكون.',
  );
  String get goHome => pick('Back to the library', 'إلى المكتبة');

  // ── Demo copy ───────────────────────────────────────────────────────────
  String get demoContinue => pick('Continue', 'متابعة');
  String get demoJourney => pick('Start a journey', 'ابدأ رحلة');
  String get demoEmailLabel => pick('Email', 'البريد الإلكتروني');
  String get demoEmailHint => 'you@example.com';
  String get demoEmailHelper =>
      pick('Only used for receipts.', 'يُستخدم للفواتير فقط.');
  String get demoTickets => pick('Tickets', 'التذاكر');
  String get demoAll => pick('All', 'الكل');
  String get demoSaved => pick('Saved', 'المحفوظ');
  String get demoNew => pick('New', 'الجديد');
  String get demoGrid => pick('Grid', 'شبكة');
  String get demoList => pick('List', 'قائمة');
  String get demoPoints => pick('points', 'نقطة');
  String get demoStoryTitle => pick('The quiet hour', 'الساعة الهادئة');
  String get demoStoryBody => pick(
    'A daily pause for reading, reflection, and one small page.',
    'توقف يومي للقراءة والتأمل وصفحة صغيرة.',
  );
  String get demoToastMessage => pick('Draft saved', 'تم حفظ المسودة');
  String get demoUndo => pick('Undo', 'تراجع');
  String get demoToastReplay => pick('Show it again', 'أظهره مجددًا');
  String get demoEmptyTitle => pick('Nothing here yet', 'لا شيء هنا بعد');
  String get demoEmptyBody => pick(
    'Add a component and it will show up in this space.',
    'أضف مكونًا وسيظهر في هذه المساحة.',
  );
  String get demoEmptyAction => pick('Add component', 'أضف مكونًا');
  String get demoUploading => pick('Uploading', 'جارٍ الرفع');
  String get demoAdd => pick('Add', 'إضافة');
  String get demoRemove => pick('Remove', 'إنقاص');
  String get demoHeart => pick('Save', 'حفظ');
  String get demoShare => pick('Share', 'مشاركة');

  // ── Khaber demo copy ────────────────────────────────────────────────────
  String get demoCrewName => pick('Noura Al-Harbi', 'نورة الحربي');
  String get demoCrewRole => pick('Editor', 'محررة');
  String get demoCrewActive => pick('Active now', 'نشطة الآن');
  String get demoPlanName => pick('Reader plan', 'خطة القارئ');
  String get demoPlanPrice => pick('SAR 19 / month', '19 ر.س / شهر');
  String get demoPlanRenewal => pick('Renews 12 Nov', 'تتجدد 12 نوفمبر');
  String get demoManage => pick('Manage', 'إدارة');
  String get demoAccessTitle => pick('Members only', 'للأعضاء فقط');
  String get demoAccessBody => pick(
    'This briefing is for Khaber subscribers.',
    'هذا الموجز لمشتركي خبر.',
  );
  String get demoUnlock => pick('Unlock', 'افتح');
  String get demoDateMonday => pick('Mon', 'الاثنين');
  String get demoDateTuesday => pick('Tue', 'الثلاثاء');
  String get demoDateWednesday => pick('Wed', 'الأربعاء');
  String get demoDateHint => pick('Choose a day', 'اختر يومًا');

  // ── Labels ──────────────────────────────────────────────────────────────
  String twoDigits(int value) => value.toString().padLeft(2, '0');

  String formatCount(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  String localizedName(LocalizedText text) => text.resolve(language);
  String otherName(LocalizedText text) => text.resolveOther(language);
}
