class AppTranslations {
  static const String fr = 'fr';
  static const String en = 'en';

  // Referral Banner
  static String referralBanner(String lang) {
    return lang == en
        ? 'Wespee is invite-only. Drop your code, get your friends on board, and earn 10 XOF every time they pay.'
        : 'L\'accès à Wespee se fait uniquement par parrainage : invitez vos proches et recevez 10 XOF à chaque transaction.';
  }

  // Header
  static String downloadApp(String lang) {
    return lang == en ? 'Download the app' : 'Télécharger l\'application';
  }

  // Hero Section
  static String heroSubtitle(String lang) {
    return lang == en ? 'Rethinking Mobile money' : 'Le Mobile Money Autrement.';
  }

  static String heroTitle1(String lang) {
    return lang == en ? 'Wespee — Everything\nyou need, in one app.\n' : 'Wespee — tout ton\nunivers dans une app,\n';
  }

  static String heroDescription(String lang) {
    return lang == en
        ? 'Your money, reimagined. Made better.\nWith Wespee: send, pay, enjoy.'
        : 'Ton argent, autrement. En mieux.\nAvec Wespee : envoie, paye, profite.';
  }

  // Rethinking Section
  static String rethinkingText1(String lang) {
    return lang == en
        ? 'Wespee , for everything, everywhere.'
        : 'Wespee pour tout et partout.';
  }

  static String rethinkingText2(String lang) {
    return lang == en
        ? 'We\'re rethinking the way\nyou use your money every\nday.'
        : 'Nous repensons la\nfaçon dont tu utilises\nton Mobile Money au\nquotidien.';
  }

  // Security Section
  static String securityTagline(String lang) {
    return lang == en
        ? 'Wespee – Protecting your money where it matters most.'
        : 'Wespee – La protection essentielle pour votre argent.';
  }

  static String securityTitle(String lang) {
    return lang == en
        ? 'Your new secure\nshield.'
        : 'Ton nouveau bouclier\nsécurisé.';
  }

  static String securityText(String lang) {
    return lang == en
        ? 'Every day, users fall victim to Mobile Money scams : fake SMS, «customer service» calls, identity theft… Why? Because with every transaction, your phone number is shared and it can end up in the wrong hands. Often, that\'s all a scammer needs to trap you.'
        : 'Chaque jour, des utilisateurs se font piéger sur le mobile money : faux SMS, '
            'appels « service client », usurpations d\'identité... Pourquoi ? Parce qu\'à '
            'chaque transaction, votre numéro de téléphone circule et peut finir entre de '
            'mauvaises mains. Et c\'est souvent tout ce dont un fraudeur a besoin pour vous piéger.';
  }

  // Protection Section
  static String protectionText(String lang) {
    return lang == en
        ? 'To keep you protected, with Wespee your personal information stays private with every transaction. Sign up, choose your unique ID to replace your phone number in all your transactions, and share it to send and receive money. It\'s simple and secure.'
        : 'Pour te protéger, désormais avec Wespee, tes informations '
            'personnelles restent confidentielles à chaque transaction. '
            'Inscris-toi, choisis l\'identifiant unique de ton choix, qui '
            'remplacera ton numéro de téléphone lors de tes transactions. '
            'Partage-le pour envoyer et recevoir de l\'argent. '
            'C\'est simple et sécurisé.';
  }

  static String protectionText2(String lang) {
    return lang == en
        ? 'Wespee is committed to protecting your data and transactions. With our NextGen security methods, your payments stay safe and you enjoy peace of mind. Every transfer, every purchase, every money move is covered with advanced protection giving you confidence every day.'
        : 'Wespee s\'engage à protéger vos données et vos transactions.'
            'Grâce à nos méthodes de sécurité NextGen, vos paiements sont sûrs et'
            'vous gardez l\'esprit tranquille. Chaque transfert, chaque achat et chaque'
            'envoi d\'argent bénéficie d\'une protection avancée,'
            'conçue pour vous garantir confiance et sérénité au quotidien.';
  }

  // One App Section
  static String oneAppSubtitle(String lang) {
    return lang == en
        ? 'Do more with your money'
        : 'Tout pour te faire gagner en temps';
  }

  static String oneAppTitle(String lang) {
    return lang == en
        ? 'One app\nfor everything.'
        : 'Une App\npour tout.';
  }

  static String oneAppDescription(String lang) {
    return lang == en
        ? 'Now, you can unify all your Mobile Money\naccounts in one place: '
            'send, receive, spend, and track\nyour expenses without switching between multiple apps.\n'
            'With Wespee, it\'s all just one click away, saving you time.'
        : 'Désormais, tu peux unifier tous tes comptes mobile money\nen un seul endroit: '
            'pour envoyer, recevoir, dépenser, suivre\n tes dépenses, sans passer par plusieurs app.\n'
            'Avec Wespee, tout se fait en un clic et tu gagnes du temps.';
  }

  static String oneAppNote(String lang) {
    return lang == en
        ? '*Your money stays yours. Wespee never charges your Mobile Money without your OK.'
        : '*Wespee ne peut en aucun cas prélever de l\'argent sur vos comptes Mobile Money sans votre accord.';
  }

  // Connected Section
  static String connectedSubtitle(String lang) {
    return lang == en
        ? 'Do more with your money'
        : 'Fait plus avec ton argent';
  }

  static String connectedTitle(String lang) {
    return lang == en
        ? 'Even more\nconnected'
        : 'Encore plus\nconnectée';
  }

  static String connectedDescription(String lang) {
    return lang == en
        ? 'Wespee is your new world: more modern, more fun, and built for a unique user experience. Discover new features and smarter ways to use your money.\n'
            'All your services are connected in one ecosystem that makes your life easier and gives you more freedom every day.'
        : 'Wespee, c\'est ton nouveau monde : plus moderne, plus fun et avec une '
            'expérience utilisateur unique. Découvre de nouvelles fonctionnalités et des '
            'façons innovantes d\'utiliser ton argent.\n'
            'Tous tes services sont connectés entre eux, dans un seul écosystème qui '
            'simplifie ta vie et t\'offre plus de liberté au quotidien.';
  }

  // Footer Section
  static String footerWespeeTitle(String lang) {
    return 'Wespee'; // Same in both languages
  }

  static String footerWorldTitle(String lang) {
    return lang == en ? 'it\'s your world.' : 'it\'s your world.';
  }

  static String footerDownload(String lang) {
    return lang == en ? 'Download the Wespee app' : 'Télécharger l\'application Wespee';
  }

  static String footerCompanyName(String lang) {
    return 'Bicents'; // Same in both languages
  }

  // QR Code Widget
  static String qrCodeDownloadText(String lang) {
    return lang == en ? 'Download\nthe Wespee app' : 'Télécharger\nl\'application Wespee';
  }

  static String footerPrivacy(String lang) {
    return lang == en ? 'Privacy Policy' : 'Politique de confidentialité';
  }

  static String footerTerms(String lang) {
    return lang == en ? 'Terms of Service' : 'Conditions d\'utilisation du service';
  }

  static String footerCopyright(String lang) {
    return lang == en ? 'All rights reserved ©2025 ' : 'Tous droits reserves ©2025 ';
  }

  // Terms and Conditions
  static String term1(String lang) {
    return lang == en
        ? 'Acceptance of Terms : By creating an account and using Wespee, you accept our general terms and conditions, which define your rights and obligations as well as those of Wespee, ensuring a reliable and secure service.'
        : 'Acceptation des conditions : En créant un compte et en utilisant Wespee, vous acceptez l\'ensemble de nos conditions  générales. Elles encadrent vos droits et obligations, ainsi que ceux de Wespee, pour  garantir un service fiable et sécurisé.';
  }

  static String term2(String lang) {
    return lang == en
        ? 'Account Creation and Eligibility : To register, you must provide a valid phone number, a mandatory referral code, and link at least one Mobile Money account. Without these, your account cannot be activated.'
        : 'Création de compte et éligibilité : Pour vous inscrire, vous devez fournir un numéro de téléphone valide, un code de parrainage obligatoire, et lier au moins un compte Mobile Money. Sans ces éléments, votre compte ne pourra pas être activé.';
  }

  static String term3(String lang) {
    return lang == en
        ? 'Security and Transaction Protection : Your transactions are protected by enhanced authentication (OTP, PIN code) and data encryption to prevent fraud or unauthorized use.'
        : 'Sécurité et protection des transactions : Toutes les opérations sont protégées par un système d\'authentification renforcé (OTP, code PIN) et un chiffrement des données. Ces mesures visent à prévenir toute fraude ou utilisation non autorisée de votre compte.';
  }

  static String term4(String lang) {
    return lang == en
        ? 'Fees and Associated Costs : Each transaction incurs a fixed fee of 50 XOF. Additional fees may apply depending on Mobile Money operators or partner aggregators (e.g., InTouch, Magma).'
        : 'Frais et coûts associés : Chaque transaction effectuée via Wespee est soumise à des frais fixes de 50 XOF. Des frais supplémentaires peuvent s\'appliquer selon les opérateurs Mobile Money ou les agrégateurs partenaires.';
  }

  static String term5(String lang) {
    return lang == en
        ? 'Referral Program : Users can refer others using a unique code. The referrer receives 10 FCFA for each transaction made by the referred user starting from their first active use.'
        : 'Programme de parrainage : Vous pouvez parrainer d\'autres utilisateurs en leur partageant votre code unique. Le parrain perçoit 10 XOF pour chaque transaction effectuée par la personne parrainée dès sa première utilisation effective de l\'application.';
  }

  static String term6(String lang) {
    return lang == en
        ? 'Use and Privacy of Data : Your personal information is collected solely to provide our services and is processed according to Ivorian data protection laws. Wespee never sells your data.'
        : 'Utilisation et confidentialité des données : Vos informations personnelles sont collectées uniquement pour fournir nos services et sont traitées conformément à la législation ivoirienne sur la protection des données personnelles. Nous ne revendons jamais vos données.';
  }

  static String term7(String lang) {
    return lang == en
        ? 'User Responsibility : You are responsible for the confidentiality of your credentials and all actions taken from your account. Any negligence or sharing of codes makes you accountable.'
        : 'Responsabilité de l\'utilisateur : Vous êtes responsable de la confidentialité de vos identifiants et de toutes les actions effectuées depuis votre compte. Toute négligence ou partage de codes engage votre responsabilité.';
  }

  static String term8(String lang) {
    return lang == en
        ? 'Mobile Money Account Management : A Mobile Money account can only be linked to one Wespee profile. You can link up to 4 accounts per profile, with authentication required for each addition to ensure security'
        : 'Gestion des comptes Mobile Money : Un compte Mobile Money ne peut être lié qu\'à un seul profil Wespee. Vous pouvez lier jusqu\'à 4 comptes à votre profil, mais chaque ajout nécessite une authentification pour garantir la sécurité.';
  }

  static String term9(String lang) {
    return lang == en
        ? 'Fraud Monitoring and Control : In case of suspicious activity or fraudulent use, Wespee may suspend or block your account, request identity verification, or permanently close the account if fraud is confirmed.'
        : 'Contrôle et lutte contre la fraude : En cas d\'activité suspecte ou d\'utilisation frauduleuse, Wespee peut suspendre ou bloquer le compte, demander des pièces d\'identité ou, en cas de fraude avérée, procéder à la fermeture définitive du compte.';
  }

  static String term10(String lang) {
    return lang == en
        ? 'Updates and Notifications : Terms may change according to operational needs or regulations. You will be notified of major updates, and continued use constitutes acceptance of the new rules.'
        : 'Mises à jour et notifications : Les conditions peuvent évoluer en fonction des besoins et des réglementations. Vous serez informé des mises à jour importantes, et votre utilisation continue constituera votre acceptation des nouvelles règles.';
  }

  // Bold words for RichText formatting (French)
  static List<String> getBoldWordsFr() {
    return [
      'Acceptation des conditions',
      'Pour vous inscrire, vous devez fournir un numéro de téléphone valide, un code de parrainage obligatoire, et lier au moins un compte Mobile Money',
      'Chaque transaction effectuée via Wespee est soumise à des frais fixes de 50 XOF',
      'Le parrain perçoit 10 XOF pour chaque transaction effectuée par la personne parrainée dès sa première utilisation effective de l\'application',
      'Nous ne revendons jamais vos données',
      'Un compte Mobile Money ne peut être lié qu\'à un seul profil Wespee'
    ];
  }

  // Bold words for RichText formatting (English)
  static List<String> getBoldWordsEn() {
    return [
      'Acceptance of Terms',
      'To register, you must provide a valid phone number, a mandatory referral code, and link at least one Mobile Money account',
      'Each transaction incurs a fixed fee of 50 XOF',
      'The referrer receives 10 FCFA for each transaction made by the referred user starting from their first active use',
      'Wespee never sells your data',
      'A Mobile Money account can only be linked to one Wespee profile'
    ];
  }

  // Snackbar messages
  static String snackbarDownload(String lang) {
    return lang == en ? 'Download' : 'Téléchargement';
  }

  static String snackbarDownloadMessage(String lang) {
    return lang == en ? 'Feature coming soon' : 'Fonctionnalité bientôt disponible';
  }

  static String snackbarLanguage(String lang) {
    return lang == en ? 'Language' : 'Langue';
  }

  static String snackbarLanguageMessage(String lang) {
    return lang == en ? 'Language change coming soon' : 'Changement de langue bientôt disponible';
  }
}

