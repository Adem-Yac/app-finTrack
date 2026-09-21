import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FinTrack'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your money, simply.'**
  String get tagline;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @languageHint.
  ///
  /// In en, this message translates to:
  /// **'You can change this later.'**
  String get languageHint;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'See what you have left.'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Add money in. Add money out. That’s it.'**
  String get welcomeBody;

  /// No description provided for @imNew.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get imNew;

  /// No description provided for @iHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get iHaveAccount;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}'**
  String hello(String name);

  /// No description provided for @leftThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Left this month'**
  String get leftThisMonth;

  /// No description provided for @moneyIn.
  ///
  /// In en, this message translates to:
  /// **'Money in'**
  String get moneyIn;

  /// No description provided for @moneyOut.
  ///
  /// In en, this message translates to:
  /// **'Money out'**
  String get moneyOut;

  /// No description provided for @lastMoves.
  ///
  /// In en, this message translates to:
  /// **'Last moves'**
  String get lastMoves;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @identifier.
  ///
  /// In en, this message translates to:
  /// **'Phone or email'**
  String get identifier;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get connect;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get createAccount;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get email;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dinar.
  ///
  /// In en, this message translates to:
  /// **'Algerian dinar (DA)'**
  String get dinar;

  /// No description provided for @rates.
  ///
  /// In en, this message translates to:
  /// **'Dinar rates'**
  String get rates;

  /// No description provided for @newMove.
  ///
  /// In en, this message translates to:
  /// **'New move'**
  String get newMove;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get income;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'What for?'**
  String get category;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @searchMoves.
  ///
  /// In en, this message translates to:
  /// **'Search a shop or note'**
  String get searchMoves;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your history'**
  String get historyTitle;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'One moment…'**
  String get preparing;

  /// No description provided for @hideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide amount'**
  String get hideBalance;

  /// No description provided for @showBalance.
  ///
  /// In en, this message translates to:
  /// **'Show amount'**
  String get showBalance;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send a link'**
  String get sendLink;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Create one'**
  String get noAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'A short note (optional)'**
  String get noteOptional;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @algeriaMarket.
  ///
  /// In en, this message translates to:
  /// **'Dinar & market'**
  String get algeriaMarket;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startNow;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableBalance;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @convert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get convert;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @algeriaBadge.
  ///
  /// In en, this message translates to:
  /// **'Algeria · DA'**
  String get algeriaBadge;

  /// No description provided for @calmBadge.
  ///
  /// In en, this message translates to:
  /// **'At ease'**
  String get calmBadge;

  /// No description provided for @trustTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear and calm'**
  String get trustTitle;

  /// No description provided for @trustBody.
  ///
  /// In en, this message translates to:
  /// **'Your money in Algerian dinar, without the noise.'**
  String get trustBody;

  /// No description provided for @easyRead.
  ///
  /// In en, this message translates to:
  /// **'Easy to read'**
  String get easyRead;

  /// No description provided for @bigNumbers.
  ///
  /// In en, this message translates to:
  /// **'Large numbers'**
  String get bigNumbers;

  /// No description provided for @secureSpace.
  ///
  /// In en, this message translates to:
  /// **'Your space'**
  String get secureSpace;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in simply'**
  String get loginSubtitle;

  /// No description provided for @connectSecure.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get connectSecure;

  /// No description provided for @biometrics.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint or Face ID'**
  String get biometrics;

  /// No description provided for @biometricsHint.
  ///
  /// In en, this message translates to:
  /// **'One tap, no password'**
  String get biometricsHint;

  /// No description provided for @registerHeadline.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerHeadline;

  /// No description provided for @registerHint.
  ///
  /// In en, this message translates to:
  /// **'One screen, then you’re in.'**
  String get registerHint;

  /// No description provided for @currencyOk.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get currencyOk;

  /// No description provided for @oneStep.
  ///
  /// In en, this message translates to:
  /// **'One step'**
  String get oneStep;

  /// No description provided for @comfortMode.
  ///
  /// In en, this message translates to:
  /// **'Comfort view'**
  String get comfortMode;

  /// No description provided for @largeType.
  ///
  /// In en, this message translates to:
  /// **'Large type'**
  String get largeType;

  /// No description provided for @guaranteed.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed'**
  String get guaranteed;

  /// No description provided for @footerSecure.
  ///
  /// In en, this message translates to:
  /// **'100% private and secure'**
  String get footerSecure;

  /// No description provided for @footerStandards.
  ///
  /// In en, this message translates to:
  /// **'Aligned with Algerian standards'**
  String get footerStandards;

  /// No description provided for @footerMeta.
  ///
  /// In en, this message translates to:
  /// **'FinTrack Algeria • Version 3.4'**
  String get footerMeta;

  /// No description provided for @identifierHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 05 50 12 34 56 or name@domain.dz'**
  String get identifierHint;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Adem Benali'**
  String get nameHint;

  /// No description provided for @requiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredLabel;

  /// No description provided for @passwordCode.
  ///
  /// In en, this message translates to:
  /// **'Choose your code'**
  String get passwordCode;

  /// No description provided for @biometricOr.
  ///
  /// In en, this message translates to:
  /// **'Or use biometrics'**
  String get biometricOr;

  /// No description provided for @bankProtect.
  ///
  /// In en, this message translates to:
  /// **'Bank-grade protection'**
  String get bankProtect;

  /// No description provided for @bankProtectBody.
  ///
  /// In en, this message translates to:
  /// **'Your financial data is encrypted.'**
  String get bankProtectBody;

  /// No description provided for @loginDirect.
  ///
  /// In en, this message translates to:
  /// **'Sign in directly'**
  String get loginDirect;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'I accept the protection of my financial data.'**
  String get terms;

  /// No description provided for @wealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth overview'**
  String get wealth;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified account'**
  String get verified;

  /// No description provided for @sendHint.
  ///
  /// In en, this message translates to:
  /// **'To a person or account'**
  String get sendHint;

  /// No description provided for @addHint.
  ///
  /// In en, this message translates to:
  /// **'Income or expense'**
  String get addHint;

  /// No description provided for @convertHint.
  ///
  /// In en, this message translates to:
  /// **'EUR, USD to dinar'**
  String get convertHint;

  /// No description provided for @reportsHint.
  ///
  /// In en, this message translates to:
  /// **'Budget follow-up'**
  String get reportsHint;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get noNotifications;

  /// No description provided for @noNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Budget and savings alerts will show up here.'**
  String get noNotificationsBody;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noMoves.
  ///
  /// In en, this message translates to:
  /// **'No moves this month'**
  String get noMoves;

  /// No description provided for @noMovesBody.
  ///
  /// In en, this message translates to:
  /// **'Add income or a spend to see your balance change.'**
  String get noMovesBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @monthlyBudgets.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get monthlyBudgets;

  /// No description provided for @savingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings goals'**
  String get savingsGoals;

  /// No description provided for @newBudget.
  ///
  /// In en, this message translates to:
  /// **'New monthly budget'**
  String get newBudget;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New savings goal'**
  String get newGoal;

  /// No description provided for @noBudget.
  ///
  /// In en, this message translates to:
  /// **'No budget this month'**
  String get noBudget;

  /// No description provided for @noBudgetBody.
  ///
  /// In en, this message translates to:
  /// **'Set how much you can spend, then split it by category.'**
  String get noBudgetBody;

  /// No description provided for @budgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Your envelope for the month'**
  String get budgetOverview;

  /// No description provided for @allocated.
  ///
  /// In en, this message translates to:
  /// **'Set aside'**
  String get allocated;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get remaining;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get addMoney;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalTitle;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get targetAmount;

  /// No description provided for @monthlyAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly amount'**
  String get monthlyAmount;

  /// No description provided for @createBudget.
  ///
  /// In en, this message translates to:
  /// **'Create budget'**
  String get createBudget;

  /// No description provided for @createGoal.
  ///
  /// In en, this message translates to:
  /// **'Create goal'**
  String get createGoal;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
