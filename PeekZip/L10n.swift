import Foundation

enum L10n {
    struct PaywallFeatureRow: Hashable, Sendable {
        let iconName: String
        let title: String
        let subtitle: String
    }

    enum Key: String {
        case paywallTitle
        case paywallSubtitle
        case paywallHighlightFullIndex
        case paywallHighlightMultiArchive
        case paywallHighlightPassword
        case paywallHighlightBatchExtract
        case paywallHighlightRiskScanning
        case paywallFeatureFullIndexing
        case paywallFeatureMultiArchiveSearch
        case paywallFeaturePasswordSupport
        case paywallFeatureBatchExtract
        case paywallFeatureRiskDetection
        case paywallLifetimePro
        case paywallLaunchPrice
        case paywallOneTimePurchase
        case paywallPriceLoading
        case paywallUnlockPro
        case paywallRestorePurchase
        case paywallContinueFree
        case paywallUnlocking
        case paywallRestoring
        case paywallClose
        case paywallPurchaseSucceeded
        case paywallPurchasePending
        case paywallRestoreSucceeded
        case paywallRestoreNothingFound
        case paywallPurchaseUnavailable
        case paywallPurchaseFailed
        case archiveFewItemsHint
        case toolbarOpenShort
        case toolbarExtractShort
        case toolbarMoreAccessibility
        case toolbarUpgradeShort
        case statusReadyShort
        case statusInspectingShort
        case statusExtractingShort
        case toolbarNoArchiveOpen
        case toolbarReady
        case toolbarInspecting
        case toolbarExtracting
        case toolbarArchiveLoaded
        case toolbarNeedsAttention
        case archiveEmptyHeroTitle
        case archiveEmptyHeroSubtitle
        case archiveEmptyOpenArchive
        case archiveEmptyTrySampleArchive
        case archiveEmptySearchInsideArchives
        case archiveEmptyBrowseByFileType
        case archiveEmptyExtractSafely
        case archiveEmptyUpgradePrompt
        case archiveContentsTitle
        case archiveContentsSubtitleDefault
        case archiveContentsSearchPlaceholder
        case searchPlaceholderArchive
        case archiveFiltersTitle
        case archiveBrowseGroupTitle
        case archiveInspectGroupTitle
        case archiveSummaryGroupTitle
        case archiveArchivesGroupTitle
        case archiveAllArchivesTitle
        case archiveContentsInspectorTitle
        case archiveContentsInspectorSubtitle
        case archiveReadingTitle
        case archiveReadingSubtitle
        case archiveEmptyArchiveTitle
        case archiveChooseAnotherArchive
        case archiveNoMatchesTitle
        case archiveNoMatchesSubtitle
        case archiveNoFileSelectedTitle
        case archiveNoFileSelectedSubtitle
        case archivePreviewImagesText
        case archiveCopyPathsText
        case archiveExtractSelectedText
        case archiveNoPreviewTitle
        case archiveNoPreviewSubtitle
        case archiveNoPreviewFolderTitle
        case archiveNoPreviewFolderSubtitle
        case archiveNoPreviewPdfTitle
        case archiveNoPreviewPdfSubtitle
        case archiveDropTitle
        case archiveDropSubtitle
        case archiveDropOverlayTitle
        case archiveDropOverlaySubtitle
        case archiveDropOverlayHelp
        case archiveTableArchive
        case archiveTableName
        case archiveTablePath
        case archiveTableSize
        case archiveTableModified
        case archiveTableType
        case archiveMetadataTitle
        case archiveLocationTitle
        case archiveRiskTitle
        case archivePreviewTitle
        case archiveQuickActionsTitle
        case archiveMetadataType
        case archiveMetadataSize
        case archiveMetadataModified
        case archiveMetadataCompression
        case archiveMetadataCompressedSize
        case archiveMetadataPathInArchive
        case archiveMetadataArchiveName
        case archiveMetadataParentFolder
        case archiveCompressionDeflate
        case archiveCompressionStored
        case archiveKindFolder
        case archiveKindImage
        case archiveKindDocument
        case archiveKindCode
        case archiveKindVideo
        case archiveKindLargeFile
        case archiveKindArchive
        case archiveKindText
        case archiveKindFile
        case archiveKindExecutable
        case archiveMetadataLevel
        case archiveMetadataReason
        case archiveMetadataMessage
        case archiveActionExtractFolder
        case archiveActionExtractSelected
        case archiveActionRevealAfterExtract
        case archiveActionCopyFileName
        case archiveActionCopyPath
        case archiveActionReloadArchive
        case archiveActionActions
        case actionsShort
        case archiveActionInspector
        case inspectorShort
        case archiveActionOpenArchive
        case archiveActionExtract
        case archiveActionUpgradePro
        case archiveActionUnlockFullIndex
        case archiveActionContinueFree
        case menuSectionExtraction
        case menuSectionUtilities
        case menuSectionProTools
        case menuSectionApp
        case archiveMenuExtractAll
        case archiveMenuExtractSelected
        case archiveMenuRevealAfterExtract
        case archiveMenuCopyFileName
        case archiveMenuCopyPath
        case archiveMenuReloadArchive
        case archiveMenuSearchMultipleArchives
        case archiveMenuUpgradeToPro
        case archiveMenuSettings
        case archiveMenuExtractAllImages
        case archiveMenuExtractAllPDFs
        case archiveMenuExtractAllVideos
        case archiveMenuExtractAllDocuments
        case archiveMenuExtractAllCodeFiles
        case archiveMenuExtractCustomTypes
        case archiveMenuScanRiskyFiles
        case archiveShowingResultsFor
        case archiveShowingOfTotalPrefix
        case archiveLargeArchiveDetected
        case archiveFreePreviewIndexing
        case archiveSelectedSummary
        case archiveNoFileSelected
        case archiveSelectedItemHint
        case archivePreviewReading
        case archivePreviewNotAvailable
        case archivePreviewNotAvailableFolder
        case archivePreviewNotAvailablePdf
        case archiveUnableToReadTitle
        case archiveTryAgain
        case archiveSelectItemToInspect
        case archiveInspectBeforeExtracting
        case archiveNoArchiveSelected
        case filterAllItems
        case filterFolders
        case filterImages
        case filterDocuments
        case filterCode
        case filterVideos
        case filterArchives
        case filterLargeFiles
        case filterRecentlyViewed
        case filterRiskyFiles
        case filterHiddenJunkFiles
        case metricItems
        case metricCode
        case metricFolders
        case metricDocuments
        case metricImages
        case metricVideos
        case metricLarge
        case metricRisky
        case metricHidden
        case statusProActive
        case archiveBatchExtractByType
        case archiveReviewRiskyFiles
        case archiveExtractAnyway
        case archiveCancel
        case archiveMetricTopLevelOverview
        case archiveMetricMostRelevant
        case archiveRiskConfirmationMessage
        case archiveRiskConfirmationTitle
        case archiveHiddenBadge
        case archiveSummaryText
        case emptyHomeTitle
        case emptyHomeSubtitle
        case emptyPrimaryTitle
        case emptyPrimarySubtitle
        case emptyFeaturesTitle
        case emptyFeatureSearchTitle
        case emptyFeatureSearchSubtitle
        case emptyFeatureBrowseTitle
        case emptyFeatureBrowseSubtitle
        case emptyFeatureExtractTitle
        case emptyFeatureExtractSubtitle
        case emptyFormatsTitle
        case emptySectionRecent
        case emptySectionSamples
        case emptySectionFormats
        case emptyRecentNone
        case emptySamplesHint
        case emptyFeatureSearch
        case emptyFeatureBrowse
        case emptyFeatureExtract
        case archiveSafetyNothingExtracted
        case archiveToastArchiveEmpty
        case archiveToastNoArchivesOpened
        case archiveSafetyNoRiskyDetected
        case archiveSafetyRiskyFound
        case archiveFlavorCodeCompact
        case archiveFlavorImageCompact
        case archiveFlavorDocumentCompact
        case archiveFlavorVideoCompact
        case archiveFlavorMixedCompact
        case archiveFlavorSingleFileCompact
        case archiveArchiveLabel
        case statFilesCompact
        case statFoldersCompact
        case statSizeUnknown
        case archiveTypeMulti
        case archiveTypeArchive
        case archiveTypeUnknown
        case archiveToastNoRiskyFiles
        case archiveToastExtractedSuccessfully
        case archiveToastExtractionFailed
        case archiveToastNoMatchingFiles
        case archiveToastFileNameCopied
        case archiveToastPathCopied
        case archiveArchivesOpen
        case archiveShowingSuffix
        case toolbarActionsShort
        case toolbarProShort
        case toolbarProActiveShort
        case toolbarProTooltipUpgrade
        case toolbarProTooltipActive
        case archiveBatchExtractTitle
        case archiveBatchExtractCustomTitle
        case archiveProTag
        case archiveOpenArchivePanelMessage
        case archiveChooseDestinationFolderMessage
        case archiveExtractArchivePrompt
        case archiveExtractSelectedItemPrompt
        case badgeFolder
        case badgeImage
        case badgeDocument
        case badgePDF
        case badgeCode
        case badgeVideo
        case badgeArchive
        case badgeText
        case badgeLarge
        case badgeFile
        case badgeApp
        case badgeInstaller
        case badgeDiskImage
        case badgeScript
        case badgeWindows
        case badgePowerShell
        case badgeJava
        case badgeExec
        case badgeRisky
        case badgeConfig
        case passwordPromptTitle
        case passwordPromptMessage
        case passwordPromptRememberSession
        case passwordPromptPasswordPlaceholder
        case passwordPromptCancel
        case passwordPromptUnlockArchive
        case batchExtractCustomSubtitle
        case batchExtractCustomPlaceholder
        case batchExtractCustomCancel
        case batchExtractCustomExtract
        case settingsGeneralTitle
        case settingsLanguageTitle
        case settingsLanguageFollowSystem
        case settingsRevealAfterExtract
        case settingsKeepFolderStructure
        case settingsSkipJunkFilesOnExtract
        case settingsDefaultExtractLocationTitle
        case settingsChooseFolder
        case settingsUseSystemDefaultLocation
        case settingsProTitle
        case settingsLicenseStatus
        case settingsFree
        case settingsProActive
        case settingsDefaultExtractLocationPanelTitle
        case settingsDefaultExtractLocationPanelMessage
    }

    static var languageCode: String {
        let preferred = UserDefaults.standard.string(forKey: "PeekZip.pref.languageCode")
            ?? Locale.preferredLanguages.first
            ?? Locale.current.identifier
        let resolved = resolvedLanguageCode(for: preferred)
        return supportedLocaleCodes.contains(resolved) ? resolved : "en"
    }

    static func displayName(for localeCode: String) -> String {
        switch localeCode {
        case "zh-Hans":
            return "简体中文"
        case "zh-Hant":
            return "繁體中文"
        case "pt-BR":
            return "Português (Brasil)"
        case "pt-PT":
            return "Português (Portugal)"
        default:
            let baseCode = localeCode.split(separator: "-").first.map(String.init) ?? localeCode
            let locale = Locale(identifier: localeCode)
            return locale.localizedString(forLanguageCode: baseCode)
            ?? Locale.current.localizedString(forLanguageCode: baseCode)
            ?? localeCode
        }
    }

    private static func resolvedLanguageCode(for identifier: String) -> String {
        let normalized = identifier.replacingOccurrences(of: "_", with: "-")
        let lower = normalized.lowercased()

        if lower.hasPrefix("zh") {
            if lower.contains("hant") || lower.contains("tw") || lower.contains("hk") || lower.contains("mo") {
                return "zh-Hant"
            }
            return "zh-Hans"
        }

        if lower.hasPrefix("pt-br") {
            return "pt-BR"
        }

        if lower.hasPrefix("pt-pt") {
            return "pt-PT"
        }

        if lower.hasPrefix("pt") {
            return "pt-BR"
        }

        let parts = normalized.split(separator: "-")
        return parts.first.map(String.init) ?? "en"
    }

    static var isRTL: Bool {
        ["ar", "ur", "fa"].contains(languageCode)
    }

    static let supportedLocaleCodes: [String] = [
        "en",
        "zh-Hans", "zh-Hant",
        "hi", "es", "fr", "ar", "bn",
        "pt-BR", "pt-PT",
        "ru", "ur", "id", "de", "ja",
        "ko", "tr", "vi", "th", "it",
        "nl", "pl", "uk", "ms", "fil",
        "fa", "sw", "ta", "te", "mr"
    ]

    static let fallbackLocaleCodes: Set<String> = [
        "de", "es", "fr", "pt-BR", "pt-PT",
        "ru", "tr", "it", "nl", "pl",
        "uk", "fa", "sw", "ta", "te", "mr"
    ]

    private static let supplementalTranslations: [String: [String: String]] = {
        let en = translations["en"] ?? [:]
        func merged(_ overrides: [String: String]) -> [String: String] {
            en.merging(overrides, uniquingKeysWith: { _, new in new })
        }

        return [
            "ja": merged([
                "toolbarOpenShort": "開く",
                "toolbarExtractShort": "抽出",
                "toolbarMoreAccessibility": "その他の操作",
                "archiveContentsTitle": "アーカイブ内容",
                "archiveContentsSubtitleDefault": "展開前にファイルを検索・絞り込み・抽出します。",
                "searchPlaceholderArchive": "名前・拡張子・パスを検索…",
                "archiveInspectGroupTitle": "確認",
                "archiveSummaryGroupTitle": "概要",
                "archiveContentsInspectorTitle": "インスペクタ",
                "archiveContentsInspectorSubtitle": "メタデータを確認し、安全にプレビューして必要なものだけ抽出します。",
                "archiveMetadataTitle": "メタデータ",
                "archiveLocationTitle": "場所",
                "archivePreviewTitle": "プレビュー",
                "archiveMetadataType": "種類",
                "archiveMetadataSize": "サイズ",
                "archiveMetadataModified": "更新日",
                "archiveMetadataCompression": "圧縮方式",
                "archiveMetadataCompressedSize": "圧縮後サイズ",
                "archiveMetadataPathInArchive": "アーカイブ内パス",
                "archiveMetadataArchiveName": "アーカイブ名",
                "archiveMetadataParentFolder": "親フォルダ",
                "filterAllItems": "すべて",
                "filterFolders": "フォルダ",
                "filterImages": "画像",
                "filterDocuments": "書類",
                "filterCode": "コード",
                "filterVideos": "動画",
                "filterArchives": "アーカイブ",
                "filterLargeFiles": "大容量ファイル",
                "filterRecentlyViewed": "最近見た項目",
                "filterRiskyFiles": "危険ファイル",
                "filterHiddenJunkFiles": "隠し・不要",
                "metricItems": "項目",
                "metricCode": "コード",
                "metricFolders": "フォルダ",
                "metricDocuments": "書類",
                "metricImages": "画像",
                "metricVideos": "動画",
                "metricLarge": "大容量",
                "metricRisky": "危険",
                "metricHidden": "隠し",
                "archiveMetricTopLevelOverview": "トップレベル概要",
                "archiveMetricMostRelevant": "最も関連性が高い",
                "archiveNoArchiveSelected": "アーカイブ未選択",
                "archiveHiddenBadge": "隠し",
                "badgeFolder": "フォルダ",
                "badgeImage": "画像",
                "badgeDocument": "書類",
                "badgePDF": "PDF",
                "badgeCode": "コード",
                "badgeVideo": "動画",
                "badgeArchive": "圧縮",
                "badgeText": "テキスト",
                "badgeLarge": "大容量",
                "badgeFile": "ファイル",
                "badgeApp": "APP",
                "badgeInstaller": "インストーラ",
                "badgeDiskImage": "ディスクイメージ",
                "badgeScript": "スクリプト",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "実行ファイル",
                "badgeRisky": "危険",
                "badgeConfig": "設定"
            ]),
            "ko": merged([
                "toolbarOpenShort": "열기",
                "toolbarExtractShort": "추출",
                "toolbarMoreAccessibility": "추가 작업",
                "archiveContentsTitle": "압축 파일 내용",
                "archiveContentsSubtitleDefault": "압축 해제 전에 파일을 검색, 필터링하고 추출하세요.",
                "searchPlaceholderArchive": "이름, 확장자 또는 경로 검색…",
                "archiveInspectGroupTitle": "검사",
                "archiveSummaryGroupTitle": "요약",
                "archiveContentsInspectorTitle": "인스펙터",
                "archiveContentsInspectorSubtitle": "메타데이터를 확인하고 안전하게 미리 보기한 뒤 필요한 항목만 추출하세요.",
                "archiveMetadataTitle": "메타데이터",
                "archiveLocationTitle": "위치",
                "archivePreviewTitle": "미리보기",
                "archiveMetadataType": "유형",
                "archiveMetadataSize": "크기",
                "archiveMetadataModified": "수정됨",
                "archiveMetadataCompression": "압축 방식",
                "archiveMetadataCompressedSize": "압축 크기",
                "archiveMetadataPathInArchive": "압축 파일 내부 경로",
                "archiveMetadataArchiveName": "압축 파일 이름",
                "archiveMetadataParentFolder": "상위 폴더",
                "filterAllItems": "전체 항목",
                "filterFolders": "폴더",
                "filterImages": "이미지",
                "filterDocuments": "문서",
                "filterCode": "코드",
                "filterVideos": "동영상",
                "filterArchives": "압축 파일",
                "filterLargeFiles": "대용량 파일",
                "filterRecentlyViewed": "최근 본 항목",
                "filterRiskyFiles": "위험 파일",
                "filterHiddenJunkFiles": "숨김 및 정크",
                "metricItems": "항목",
                "metricCode": "코드",
                "metricFolders": "폴더",
                "metricDocuments": "문서",
                "metricImages": "이미지",
                "metricVideos": "동영상",
                "metricLarge": "대용량",
                "metricRisky": "위험",
                "metricHidden": "숨김",
                "archiveMetricTopLevelOverview": "최상위 개요",
                "archiveMetricMostRelevant": "가장 관련 높음",
                "archiveNoArchiveSelected": "선택된 압축 파일 없음",
                "archiveHiddenBadge": "숨김",
                "badgeFolder": "폴더",
                "badgeImage": "이미지",
                "badgeDocument": "문서",
                "badgePDF": "PDF",
                "badgeCode": "코드",
                "badgeVideo": "동영상",
                "badgeArchive": "압축",
                "badgeText": "텍스트",
                "badgeLarge": "대용량",
                "badgeFile": "파일",
                "badgeApp": "앱",
                "badgeInstaller": "설치 패키지",
                "badgeDiskImage": "디스크 이미지",
                "badgeScript": "스크립트",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "실행 파일",
                "badgeRisky": "위험",
                "badgeConfig": "설정"
            ]),
            "ar": merged([
                "toolbarOpenShort": "فتح",
                "toolbarExtractShort": "استخراج",
                "toolbarMoreAccessibility": "إجراءات إضافية",
                "archiveContentsTitle": "محتويات الأرشيف",
                "archiveContentsSubtitleDefault": "ابحث عن الملفات وصفِّها واستخرجها قبل فك الضغط.",
                "searchPlaceholderArchive": "ابحث بالاسم أو الامتداد أو المسار…",
                "archiveInspectGroupTitle": "فحص",
                "archiveSummaryGroupTitle": "الملخص",
                "archiveContentsInspectorTitle": "المفتش",
                "archiveContentsInspectorSubtitle": "افحص البيانات الوصفية واعرض بأمان واستخرج ما تحتاجه فقط.",
                "archiveMetadataTitle": "البيانات الوصفية",
                "archiveLocationTitle": "الموقع",
                "archivePreviewTitle": "المعاينة",
                "archiveMetadataType": "النوع",
                "archiveMetadataSize": "الحجم",
                "archiveMetadataModified": "التعديل",
                "archiveMetadataCompression": "الضغط",
                "archiveMetadataCompressedSize": "الحجم المضغوط",
                "archiveMetadataPathInArchive": "المسار داخل الأرشيف",
                "archiveMetadataArchiveName": "اسم الأرشيف",
                "archiveMetadataParentFolder": "المجلد الأب",
                "filterAllItems": "كل العناصر",
                "filterFolders": "المجلدات",
                "filterImages": "الصور",
                "filterDocuments": "المستندات",
                "filterCode": "الرمز",
                "filterVideos": "الفيديوهات",
                "filterArchives": "الأرشيفات",
                "filterLargeFiles": "الملفات الكبيرة",
                "filterRecentlyViewed": "شوهدت مؤخراً",
                "filterRiskyFiles": "الملفات الخطرة",
                "filterHiddenJunkFiles": "المخفية والمهملة",
                "metricItems": "العناصر",
                "metricCode": "الرمز",
                "metricFolders": "المجلدات",
                "metricDocuments": "المستندات",
                "metricImages": "الصور",
                "metricVideos": "الفيديوهات",
                "metricLarge": "كبير",
                "metricRisky": "خطر",
                "metricHidden": "مخفي",
                "archiveMetricTopLevelOverview": "نظرة عامة على المستوى الأعلى",
                "archiveMetricMostRelevant": "الأكثر صلة",
                "archiveNoArchiveSelected": "لم يتم تحديد أرشيف",
                "archiveHiddenBadge": "مخفي",
                "badgeFolder": "مجلد",
                "badgeImage": "صورة",
                "badgeDocument": "مستند",
                "badgePDF": "PDF",
                "badgeCode": "رمز",
                "badgeVideo": "فيديو",
                "badgeArchive": "أرشيف",
                "badgeText": "نص",
                "badgeLarge": "كبير",
                "badgeFile": "ملف",
                "badgeApp": "تطبيق",
                "badgeInstaller": "مثبّت",
                "badgeDiskImage": "صورة قرص",
                "badgeScript": "سكريبت",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "تنفيذي",
                "badgeRisky": "خطر",
                "badgeConfig": "إعداد"
            ]),
            "hi": merged([
                "toolbarOpenShort": "खोलें",
                "toolbarExtractShort": "निकालें",
                "toolbarMoreAccessibility": "और क्रियाएँ",
                "archiveContentsTitle": "आर्काइव सामग्री",
                "archiveContentsSubtitleDefault": "अनपैक करने से पहले फ़ाइलें खोजें, फ़िल्टर करें और निकालें।",
                "searchPlaceholderArchive": "नाम, एक्सटेंशन या पथ खोजें…",
                "archiveInspectGroupTitle": "जाँच",
                "archiveSummaryGroupTitle": "सारांश",
                "archiveContentsInspectorTitle": "इंस्पेक्टर",
                "archiveContentsInspectorSubtitle": "मेटाडेटा देखें, सुरक्षित प्रीव्यू करें और केवल आवश्यक चीज़ें निकालें।",
                "archiveMetadataTitle": "मेटाडेटा",
                "archiveLocationTitle": "स्थान",
                "archivePreviewTitle": "पूर्वावलोकन",
                "archiveMetadataType": "प्रकार",
                "archiveMetadataSize": "आकार",
                "archiveMetadataModified": "संशोधित",
                "archiveMetadataCompression": "कम्प्रेशन",
                "archiveMetadataCompressedSize": "संपीड़ित आकार",
                "archiveMetadataPathInArchive": "आर्काइव में पथ",
                "archiveMetadataArchiveName": "आर्काइव नाम",
                "archiveMetadataParentFolder": "मूल फ़ोल्डर",
                "filterAllItems": "सभी आइटम",
                "filterFolders": "फ़ोल्डर",
                "filterImages": "छवियाँ",
                "filterDocuments": "दस्तावेज़",
                "filterCode": "कोड",
                "filterVideos": "वीडियो",
                "filterArchives": "आर्काइव",
                "filterLargeFiles": "बड़ी फ़ाइलें",
                "filterRecentlyViewed": "हाल में देखे गए",
                "filterRiskyFiles": "जोखिमपूर्ण फ़ाइलें",
                "filterHiddenJunkFiles": "छिपी और जंक",
                "metricItems": "आइटम",
                "metricCode": "कोड",
                "metricFolders": "फ़ोल्डर",
                "metricDocuments": "दस्तावेज़",
                "metricImages": "छवियाँ",
                "metricVideos": "वीडियो",
                "metricLarge": "बड़ा",
                "metricRisky": "जोखिम",
                "metricHidden": "छिपा",
                "archiveMetricTopLevelOverview": "शीर्ष स्तर अवलोकन",
                "archiveMetricMostRelevant": "सबसे प्रासंगिक",
                "archiveNoArchiveSelected": "कोई आर्काइव चयनित नहीं",
                "archiveHiddenBadge": "छिपा",
                "badgeFolder": "फ़ोल्डर",
                "badgeImage": "छवि",
                "badgeDocument": "दस्तावेज़",
                "badgePDF": "PDF",
                "badgeCode": "कोड",
                "badgeVideo": "वीडियो",
                "badgeArchive": "आर्काइव",
                "badgeText": "पाठ",
                "badgeLarge": "बड़ी फ़ाइल",
                "badgeFile": "फ़ाइल",
                "badgeApp": "ऐप",
                "badgeInstaller": "इंस्टॉलर",
                "badgeDiskImage": "डिस्क इमेज",
                "badgeScript": "स्क्रिप्ट",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "एग्जीक्यूट",
                "badgeRisky": "जोखिम",
                "badgeConfig": "कॉन्फ़िग"
            ]),
            "id": merged([
                "toolbarOpenShort": "Buka",
                "toolbarExtractShort": "Ekstrak",
                "toolbarMoreAccessibility": "Tindakan lain",
                "archiveContentsTitle": "Isi arsip",
                "archiveContentsSubtitleDefault": "Cari, saring, dan ekstrak file sebelum membongkar arsip.",
                "searchPlaceholderArchive": "Cari nama, ekstensi, atau path…",
                "archiveInspectGroupTitle": "Inspeksi",
                "archiveSummaryGroupTitle": "Ringkasan",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "Periksa metadata, pratinjau dengan aman, dan ekstrak hanya yang Anda butuhkan.",
                "archiveMetadataTitle": "Metadata",
                "archiveLocationTitle": "Lokasi",
                "archivePreviewTitle": "Pratinjau",
                "archiveMetadataType": "Jenis",
                "archiveMetadataSize": "Ukuran",
                "archiveMetadataModified": "Diubah",
                "archiveMetadataCompression": "Kompresi",
                "archiveMetadataCompressedSize": "Ukuran terkompresi",
                "archiveMetadataPathInArchive": "Path di dalam arsip",
                "archiveMetadataArchiveName": "Nama arsip",
                "archiveMetadataParentFolder": "Folder induk",
                "filterAllItems": "Semua item",
                "filterFolders": "Folder",
                "filterImages": "Gambar",
                "filterDocuments": "Dokumen",
                "filterCode": "Kode",
                "filterVideos": "Video",
                "filterArchives": "Arsip",
                "filterLargeFiles": "File besar",
                "filterRecentlyViewed": "Baru dilihat",
                "filterRiskyFiles": "File berisiko",
                "filterHiddenJunkFiles": "Tersembunyi & sampah",
                "metricItems": "Item",
                "metricCode": "Kode",
                "metricFolders": "Folder",
                "metricDocuments": "Dokumen",
                "metricImages": "Gambar",
                "metricVideos": "Video",
                "metricLarge": "Besar",
                "metricRisky": "Berisiko",
                "metricHidden": "Tersembunyi",
                "archiveMetricTopLevelOverview": "Ikhtisar tingkat atas",
                "archiveMetricMostRelevant": "Paling relevan",
                "archiveNoArchiveSelected": "Tidak ada arsip dipilih",
                "archiveHiddenBadge": "TERSEMBUNYI",
                "badgeFolder": "FOLDER",
                "badgeImage": "GAMBAR",
                "badgeDocument": "DOKUMEN",
                "badgePDF": "PDF",
                "badgeCode": "KODE",
                "badgeVideo": "VIDEO",
                "badgeArchive": "ARSIP",
                "badgeText": "TEKS",
                "badgeLarge": "BESAR",
                "badgeFile": "FILE",
                "badgeApp": "APP",
                "badgeInstaller": "INSTALLER",
                "badgeDiskImage": "DISK IMAGE",
                "badgeScript": "SCRIPT",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "EXEC",
                "badgeRisky": "BERISIKO",
                "badgeConfig": "KONFIG"
            ]),
            "ms": merged([
                "toolbarOpenShort": "Buka",
                "toolbarExtractShort": "Ekstrak",
                "toolbarMoreAccessibility": "Tindakan lain",
                "archiveContentsTitle": "Kandungan arkib",
                "archiveContentsSubtitleDefault": "Cari, tapis dan ekstrak fail sebelum nyahmampat.",
                "searchPlaceholderArchive": "Cari nama, sambungan atau laluan…",
                "archiveInspectGroupTitle": "Periksa",
                "archiveSummaryGroupTitle": "Ringkasan",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "Periksa metadata, pratonton dengan selamat dan ekstrak hanya yang diperlukan.",
                "archiveMetadataTitle": "Metadata",
                "archiveLocationTitle": "Lokasi",
                "archivePreviewTitle": "Pratonton",
                "archiveMetadataType": "Jenis",
                "archiveMetadataSize": "Saiz",
                "archiveMetadataModified": "Diubah suai",
                "archiveMetadataCompression": "Pemampatan",
                "archiveMetadataCompressedSize": "Saiz termampat",
                "archiveMetadataPathInArchive": "Laluan dalam arkib",
                "archiveMetadataArchiveName": "Nama arkib",
                "archiveMetadataParentFolder": "Folder induk",
                "filterAllItems": "Semua item",
                "filterFolders": "Folder",
                "filterImages": "Imej",
                "filterDocuments": "Dokumen",
                "filterCode": "Kod",
                "filterVideos": "Video",
                "filterArchives": "Arkib",
                "filterLargeFiles": "Fail besar",
                "filterRecentlyViewed": "Baru dilihat",
                "filterRiskyFiles": "Fail berisiko",
                "filterHiddenJunkFiles": "Tersembunyi & sampah",
                "metricItems": "Item",
                "metricCode": "Kod",
                "metricFolders": "Folder",
                "metricDocuments": "Dokumen",
                "metricImages": "Imej",
                "metricVideos": "Video",
                "metricLarge": "Besar",
                "metricRisky": "Risiko",
                "metricHidden": "Tersembunyi",
                "archiveMetricTopLevelOverview": "Gambaran tahap atas",
                "archiveMetricMostRelevant": "Paling relevan",
                "archiveNoArchiveSelected": "Tiada arkib dipilih",
                "archiveHiddenBadge": "TERSEMBUNYI",
                "badgeFolder": "FOLDER",
                "badgeImage": "IMEJ",
                "badgeDocument": "DOKUMEN",
                "badgePDF": "PDF",
                "badgeCode": "KOD",
                "badgeVideo": "VIDEO",
                "badgeArchive": "ARKIB",
                "badgeText": "TEKS",
                "badgeLarge": "BESAR",
                "badgeFile": "FAIL",
                "badgeApp": "APP",
                "badgeInstaller": "INSTALLER",
                "badgeDiskImage": "DISK IMAGE",
                "badgeScript": "SKRIP",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "EXEC",
                "badgeRisky": "RISIKO",
                "badgeConfig": "KONFIG"
            ]),
            "vi": merged([
                "toolbarOpenShort": "Mở",
                "toolbarExtractShort": "Giải nén",
                "toolbarMoreAccessibility": "Thao tác khác",
                "archiveContentsTitle": "Nội dung tệp nén",
                "archiveContentsSubtitleDefault": "Tìm kiếm, lọc và trích xuất tệp trước khi giải nén.",
                "searchPlaceholderArchive": "Tìm tên, phần mở rộng hoặc đường dẫn…",
                "archiveInspectGroupTitle": "Kiểm tra",
                "archiveSummaryGroupTitle": "Tóm tắt",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "Kiểm tra metadata, xem trước an toàn và chỉ trích xuất những gì bạn cần.",
                "archiveMetadataTitle": "Metadata",
                "archiveLocationTitle": "Vị trí",
                "archivePreviewTitle": "Xem trước",
                "archiveMetadataType": "Loại",
                "archiveMetadataSize": "Kích thước",
                "archiveMetadataModified": "Đã sửa",
                "archiveMetadataCompression": "Nén",
                "archiveMetadataCompressedSize": "Kích thước nén",
                "archiveMetadataPathInArchive": "Đường dẫn trong tệp nén",
                "archiveMetadataArchiveName": "Tên tệp nén",
                "archiveMetadataParentFolder": "Thư mục cha",
                "filterAllItems": "Tất cả mục",
                "filterFolders": "Thư mục",
                "filterImages": "Hình ảnh",
                "filterDocuments": "Tài liệu",
                "filterCode": "Mã",
                "filterVideos": "Video",
                "filterArchives": "Tệp nén",
                "filterLargeFiles": "Tệp lớn",
                "filterRecentlyViewed": "Đã xem gần đây",
                "filterRiskyFiles": "Tệp rủi ro",
                "filterHiddenJunkFiles": "Ẩn & rác",
                "metricItems": "Mục",
                "metricCode": "Mã",
                "metricFolders": "Thư mục",
                "metricDocuments": "Tài liệu",
                "metricImages": "Hình ảnh",
                "metricVideos": "Video",
                "metricLarge": "Lớn",
                "metricRisky": "Rủi ro",
                "metricHidden": "Ẩn",
                "archiveMetricTopLevelOverview": "Tổng quan cấp cao nhất",
                "archiveMetricMostRelevant": "Liên quan nhất",
                "archiveNoArchiveSelected": "Chưa chọn tệp nén",
                "archiveHiddenBadge": "ẨN",
                "badgeFolder": "THƯ MỤC",
                "badgeImage": "HÌNH ẢNH",
                "badgeDocument": "TÀI LIỆU",
                "badgePDF": "PDF",
                "badgeCode": "MÃ",
                "badgeVideo": "VIDEO",
                "badgeArchive": "TỆP NÉN",
                "badgeText": "VĂN BẢN",
                "badgeLarge": "LỚN",
                "badgeFile": "TỆP",
                "badgeApp": "APP",
                "badgeInstaller": "INSTALLER",
                "badgeDiskImage": "DISK IMAGE",
                "badgeScript": "SCRIPT",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "EXEC",
                "badgeRisky": "RỦI RO",
                "badgeConfig": "CẤU HÌNH"
            ]),
            "th": merged([
                "toolbarOpenShort": "เปิด",
                "toolbarExtractShort": "แตกไฟล์",
                "toolbarMoreAccessibility": "การทำงานอื่น",
                "archiveContentsTitle": "เนื้อหาในไฟล์บีบอัด",
                "archiveContentsSubtitleDefault": "ค้นหา กรอง และแตกไฟล์ก่อนคลายการบีบอัด",
                "searchPlaceholderArchive": "ค้นหาชื่อ นามสกุล หรือพาธ…",
                "archiveInspectGroupTitle": "ตรวจสอบ",
                "archiveSummaryGroupTitle": "สรุป",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "ตรวจดูเมตะดาตา พรีวิวอย่างปลอดภัย และแตกเฉพาะสิ่งที่ต้องการ",
                "archiveMetadataTitle": "เมตะดาตา",
                "archiveLocationTitle": "ตำแหน่ง",
                "archivePreviewTitle": "ตัวอย่าง",
                "archiveMetadataType": "ประเภท",
                "archiveMetadataSize": "ขนาด",
                "archiveMetadataModified": "แก้ไข",
                "archiveMetadataCompression": "การบีบอัด",
                "archiveMetadataCompressedSize": "ขนาดหลังบีบอัด",
                "archiveMetadataPathInArchive": "พาธในไฟล์บีบอัด",
                "archiveMetadataArchiveName": "ชื่อไฟล์บีบอัด",
                "archiveMetadataParentFolder": "โฟลเดอร์แม่",
                "filterAllItems": "ทั้งหมด",
                "filterFolders": "โฟลเดอร์",
                "filterImages": "รูปภาพ",
                "filterDocuments": "เอกสาร",
                "filterCode": "โค้ด",
                "filterVideos": "วิดีโอ",
                "filterArchives": "ไฟล์บีบอัด",
                "filterLargeFiles": "ไฟล์ใหญ่",
                "filterRecentlyViewed": "ดูล่าสุด",
                "filterRiskyFiles": "ไฟล์เสี่ยง",
                "filterHiddenJunkFiles": "ซ่อนและขยะ",
                "metricItems": "รายการ",
                "metricCode": "โค้ด",
                "metricFolders": "โฟลเดอร์",
                "metricDocuments": "เอกสาร",
                "metricImages": "รูปภาพ",
                "metricVideos": "วิดีโอ",
                "metricLarge": "ใหญ่",
                "metricRisky": "เสี่ยง",
                "metricHidden": "ซ่อน",
                "archiveMetricTopLevelOverview": "ภาพรวมระดับบนสุด",
                "archiveMetricMostRelevant": "เกี่ยวข้องมากที่สุด",
                "archiveNoArchiveSelected": "ยังไม่ได้เลือกไฟล์บีบอัด",
                "archiveHiddenBadge": "ซ่อน",
                "badgeFolder": "โฟลเดอร์",
                "badgeImage": "รูปภาพ",
                "badgeDocument": "เอกสาร",
                "badgePDF": "PDF",
                "badgeCode": "โค้ด",
                "badgeVideo": "วิดีโอ",
                "badgeArchive": "ไฟล์บีบอัด",
                "badgeText": "ข้อความ",
                "badgeLarge": "ใหญ่",
                "badgeFile": "ไฟล์",
                "badgeApp": "APP",
                "badgeInstaller": "INSTALLER",
                "badgeDiskImage": "DISK IMAGE",
                "badgeScript": "SCRIPT",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "EXEC",
                "badgeRisky": "เสี่ยง",
                "badgeConfig": "ตั้งค่า"
            ]),
            "fil": merged([
                "toolbarOpenShort": "Buksan",
                "toolbarExtractShort": "I-extract",
                "toolbarMoreAccessibility": "Iba pang aksyon",
                "archiveContentsTitle": "Laman ng archive",
                "archiveContentsSubtitleDefault": "Maghanap, mag-filter, at mag-extract ng file bago i-unpack.",
                "searchPlaceholderArchive": "Hanapin ang pangalan, extension, o path…",
                "archiveInspectGroupTitle": "Suriin",
                "archiveSummaryGroupTitle": "Buod",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "Suriin ang metadata, mag-preview nang ligtas, at i-extract lang ang kailangan mo.",
                "archiveMetadataTitle": "Metadata",
                "archiveLocationTitle": "Lokasyon",
                "archivePreviewTitle": "Preview",
                "archiveMetadataType": "Uri",
                "archiveMetadataSize": "Laki",
                "archiveMetadataModified": "Binago",
                "archiveMetadataCompression": "Compression",
                "archiveMetadataCompressedSize": "Compressed size",
                "archiveMetadataPathInArchive": "Path sa archive",
                "archiveMetadataArchiveName": "Pangalan ng archive",
                "archiveMetadataParentFolder": "Parent folder",
                "filterAllItems": "Lahat ng item",
                "filterFolders": "Mga folder",
                "filterImages": "Mga larawan",
                "filterDocuments": "Mga dokumento",
                "filterCode": "Code",
                "filterVideos": "Mga video",
                "filterArchives": "Mga archive",
                "filterLargeFiles": "Malalaking file",
                "filterRecentlyViewed": "Kamakailang tiningnan",
                "filterRiskyFiles": "Mapanganib na file",
                "filterHiddenJunkFiles": "Nakatago at junk",
                "metricItems": "Item",
                "metricCode": "Code",
                "metricFolders": "Folder",
                "metricDocuments": "Dokumento",
                "metricImages": "Larawan",
                "metricVideos": "Video",
                "metricLarge": "Malaki",
                "metricRisky": "Panganib",
                "metricHidden": "Nakatago",
                "archiveMetricTopLevelOverview": "Pangkalahatang top level",
                "archiveMetricMostRelevant": "Pinakaangkop",
                "archiveNoArchiveSelected": "Walang napiling archive",
                "archiveHiddenBadge": "NAKATAGO",
                "badgeFolder": "FOLDER",
                "badgeImage": "LARAWAN",
                "badgeDocument": "DOKUMENTO",
                "badgePDF": "PDF",
                "badgeCode": "CODE",
                "badgeVideo": "VIDEO",
                "badgeArchive": "ARCHIVE",
                "badgeText": "TEKSTO",
                "badgeLarge": "MALAKI",
                "badgeFile": "FILE",
                "badgeApp": "APP",
                "badgeInstaller": "INSTALLER",
                "badgeDiskImage": "DISK IMAGE",
                "badgeScript": "SCRIPT",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "EXEC",
                "badgeRisky": "RISKY",
                "badgeConfig": "CONFIG"
            ]),
            "bn": merged([
                "toolbarOpenShort": "খুলুন",
                "toolbarExtractShort": "এক্সট্র্যাক্ট",
                "toolbarMoreAccessibility": "আরও কাজ",
                "archiveContentsTitle": "আর্কাইভের বিষয়বস্তু",
                "archiveContentsSubtitleDefault": "আনপ্যাক করার আগে ফাইল খুঁজুন, ফিল্টার করুন এবং এক্সট্র্যাক্ট করুন।",
                "searchPlaceholderArchive": "নাম, এক্সটেনশন বা পাথ খুঁজুন…",
                "archiveInspectGroupTitle": "পরিদর্শন",
                "archiveSummaryGroupTitle": "সারাংশ",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "মেটাডেটা দেখুন, নিরাপদে প্রিভিউ করুন এবং শুধু প্রয়োজনীয় জিনিস এক্সট্র্যাক্ট করুন।",
                "archiveMetadataTitle": "মেটাডেটা",
                "archiveLocationTitle": "অবস্থান",
                "archivePreviewTitle": "প্রিভিউ",
                "archiveMetadataType": "ধরন",
                "archiveMetadataSize": "আকার",
                "archiveMetadataModified": "পরিবর্তিত",
                "archiveMetadataCompression": "কম্প্রেশন",
                "archiveMetadataCompressedSize": "সংকুচিত আকার",
                "archiveMetadataPathInArchive": "আর্কাইভের ভিতরের পথ",
                "archiveMetadataArchiveName": "আর্কাইভের নাম",
                "archiveMetadataParentFolder": "মূল ফোল্ডার",
                "filterAllItems": "সব আইটেম",
                "filterFolders": "ফোল্ডার",
                "filterImages": "ছবি",
                "filterDocuments": "নথি",
                "filterCode": "কোড",
                "filterVideos": "ভিডিও",
                "filterArchives": "আর্কাইভ",
                "filterLargeFiles": "বড় ফাইল",
                "filterRecentlyViewed": "সম্প্রতি দেখা",
                "filterRiskyFiles": "ঝুঁকিপূর্ণ ফাইল",
                "filterHiddenJunkFiles": "লুকানো ও জাঙ্ক",
                "metricItems": "আইটেম",
                "metricCode": "কোড",
                "metricFolders": "ফোল্ডার",
                "metricDocuments": "নথি",
                "metricImages": "ছবি",
                "metricVideos": "ভিডিও",
                "metricLarge": "বড়",
                "metricRisky": "ঝুঁকি",
                "metricHidden": "লুকানো",
                "archiveMetricTopLevelOverview": "শীর্ষ স্তরের সারাংশ",
                "archiveMetricMostRelevant": "সবচেয়ে প্রাসঙ্গিক",
                "archiveNoArchiveSelected": "কোনো আর্কাইভ নির্বাচিত নয়",
                "archiveHiddenBadge": "লুকানো",
                "badgeFolder": "ফোল্ডার",
                "badgeImage": "ছবি",
                "badgeDocument": "নথি",
                "badgePDF": "PDF",
                "badgeCode": "কোড",
                "badgeVideo": "ভিডিও",
                "badgeArchive": "আর্কাইভ",
                "badgeText": "টেক্সট",
                "badgeLarge": "বড়",
                "badgeFile": "ফাইল",
                "badgeApp": "APP",
                "badgeInstaller": "INSTALLER",
                "badgeDiskImage": "DISK IMAGE",
                "badgeScript": "SCRIPT",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "EXEC",
                "badgeRisky": "ঝুঁকি",
                "badgeConfig": "কনফিগ"
            ]),
            "ur": merged([
                "toolbarOpenShort": "کھولیں",
                "toolbarExtractShort": "نکالیں",
                "toolbarMoreAccessibility": "مزید کارروائیاں",
                "archiveContentsTitle": "آرکائیو کا مواد",
                "archiveContentsSubtitleDefault": "کھولنے سے پہلے فائلیں تلاش کریں، فلٹر کریں اور نکالیں۔",
                "searchPlaceholderArchive": "نام، ایکسٹینشن یا راستہ تلاش کریں…",
                "archiveInspectGroupTitle": "معائنہ",
                "archiveSummaryGroupTitle": "خلاصہ",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "میٹا ڈیٹا دیکھیں، محفوظ پیش نظارہ کریں، اور صرف مطلوبہ چیزیں نکالیں۔",
                "archiveMetadataTitle": "میٹا ڈیٹا",
                "archiveLocationTitle": "مقام",
                "archivePreviewTitle": "پیش نظارہ",
                "archiveMetadataType": "قسم",
                "archiveMetadataSize": "سائز",
                "archiveMetadataModified": "ترمیم شدہ",
                "archiveMetadataCompression": "کمپریشن",
                "archiveMetadataCompressedSize": "کمپریس شدہ سائز",
                "archiveMetadataPathInArchive": "آرکائیو کے اندر راستہ",
                "archiveMetadataArchiveName": "آرکائیو کا نام",
                "archiveMetadataParentFolder": "والد فولڈر",
                "filterAllItems": "تمام آئٹمز",
                "filterFolders": "فولڈرز",
                "filterImages": "تصاویر",
                "filterDocuments": "دستاویزات",
                "filterCode": "کوڈ",
                "filterVideos": "ویڈیوز",
                "filterArchives": "آرکائیوز",
                "filterLargeFiles": "بڑی فائلیں",
                "filterRecentlyViewed": "حال ہی میں دیکھی گئی",
                "filterRiskyFiles": "خطرناک فائلیں",
                "filterHiddenJunkFiles": "پوشیدہ اور ردی",
                "metricItems": "آئٹمز",
                "metricCode": "کوڈ",
                "metricFolders": "فولڈرز",
                "metricDocuments": "دستاویزات",
                "metricImages": "تصاویر",
                "metricVideos": "ویڈیوز",
                "metricLarge": "بڑی",
                "metricRisky": "خطرہ",
                "metricHidden": "پوشیدہ",
                "archiveMetricTopLevelOverview": "اوپر کی سطح کا خلاصہ",
                "archiveMetricMostRelevant": "سب سے زیادہ متعلقہ",
                "archiveNoArchiveSelected": "کوئی آرکائیو منتخب نہیں",
                "archiveHiddenBadge": "پوشیدہ",
                "badgeFolder": "فولڈر",
                "badgeImage": "تصویر",
                "badgeDocument": "دستاویز",
                "badgePDF": "PDF",
                "badgeCode": "کوڈ",
                "badgeVideo": "ویڈیو",
                "badgeArchive": "آرکائیو",
                "badgeText": "متن",
                "badgeLarge": "بڑی",
                "badgeFile": "فائل",
                "badgeApp": "APP",
                "badgeInstaller": "INSTALLER",
                "badgeDiskImage": "DISK IMAGE",
                "badgeScript": "SCRIPT",
                "badgeWindows": "WINDOWS",
                "badgePowerShell": "POWERSHELL",
                "badgeJava": "JAVA",
                "badgeExec": "EXEC",
                "badgeRisky": "خطرہ",
                "badgeConfig": "کنفیگ"
            ]),
            "de": merged([
                "toolbarOpenShort": "Öffnen",
                "toolbarExtractShort": "Entpacken",
                "toolbarMoreAccessibility": "Weitere Aktionen",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Bereit",
                "statusInspectingShort": "Prüfen",
                "statusExtractingShort": "Entpacken",
                "toolbarNoArchiveOpen": "Kein Archiv geöffnet",
                "toolbarReady": "Bereit",
                "toolbarInspecting": "Prüfen",
                "toolbarExtracting": "Entpacken",
                "toolbarArchiveLoaded": "Archiv geladen",
                "toolbarNeedsAttention": "Aktion erforderlich",
                "archiveSummaryText": "Archiv ablegen oder „Archiv öffnen“ wählen, um Inhalte vorzuschauen.",
                "archiveSafetyNothingExtracted": "Sichere Vorschau. Nichts entpackt.",
                "archiveContentsTitle": "Archivinhalt",
                "archiveContentsSubtitleDefault": "Dateien durchsuchen, filtern und extrahieren, bevor entpackt wird.",
                "archiveContentsSearchPlaceholder": "Nach Name, Erweiterung oder Pfad suchen...",
                "searchPlaceholderArchive": "Name, Erweiterung oder Pfad suchen…",
                "archiveFiltersTitle": "Filter",
                "archiveBrowseGroupTitle": "Durchsuchen",
                "archiveInspectGroupTitle": "Prüfen",
                "archiveSummaryGroupTitle": "Übersicht",
                "archiveArchivesGroupTitle": "Archive",
                "archiveAllArchivesTitle": "Alle Archive",
                "archiveContentsInspectorTitle": "Inspektor",
                "archiveContentsInspectorSubtitle": "Metadaten prüfen, sicher ansehen und nur Gewünschtes extrahieren.",
                "archiveQuickActionsTitle": "Schnellaktionen",
                "archiveActionExtractFolder": "Ordner extrahieren",
                "archiveActionExtractSelected": "Auswahl extrahieren",
                "archiveActionRevealAfterExtract": "Nach dem Extrahieren anzeigen",
                "archiveActionCopyFileName": "Dateinamen kopieren",
                "archiveActionCopyPath": "Pfad kopieren",
                "archiveActionReloadArchive": "Archiv neu laden",
                "archiveActionActions": "Aktionen",
                "actionsShort": "Aktionen",
                "archiveActionInspector": "Inspektor",
                "inspectorShort": "Inspektor",
                "archiveActionOpenArchive": "Öffnen",
                "archiveActionExtract": "Entpacken",
                "archiveActionUpgradePro": "Pro",
                "archiveMenuExtractAll": "Alles extrahieren",
                "archiveMenuExtractSelected": "Ausgewählte extrahieren",
                "archiveMenuRevealAfterExtract": "Nach dem Extrahieren anzeigen",
                "archiveMenuCopyFileName": "Dateinamen kopieren",
                "archiveMenuCopyPath": "Pfad kopieren",
                "archiveMenuReloadArchive": "Archiv neu laden",
                "archiveMenuSearchMultipleArchives": "Mehrere Archive durchsuchen…",
                "archiveMenuUpgradeToPro": "Zu Pro upgraden…",
                "archiveMenuSettings": "Einstellungen…",
                "archiveMenuExtractAllImages": "Alle Bilder extrahieren",
                "archiveMenuExtractAllPDFs": "Alle PDFs extrahieren",
                "archiveMenuExtractAllVideos": "Alle Videos extrahieren",
                "archiveMenuExtractAllDocuments": "Alle Dokumente extrahieren",
                "archiveMenuExtractAllCodeFiles": "Alle Code-Dateien extrahieren",
                "archiveMenuExtractCustomTypes": "Eigene Typen extrahieren…",
                "archiveMenuScanRiskyFiles": "Riskante Dateien prüfen",
                "archiveShowingResultsFor": "Zeige %d Ergebnisse für „%@“.",
                "archiveShowingOfTotalPrefix": "Zeige %d von %d",
                "archiveLargeArchiveDetected": "Großes Archiv erkannt. Die kostenlose Vorschau indiziert 200 von %d Elementen.",
                "archiveFreePreviewIndexing": "Die kostenlose Vorschau indiziert 200 von %d Elementen.",
                "archiveSelectedSummary": "%d Element ausgewählt",
                "archiveNoFileSelected": "Keine Datei ausgewählt",
                "archiveSelectedItemHint": "Element auswählen, um Details zu sehen, oder Aktionen zum Extrahieren verwenden.",
                "archiveSelectItemToInspect": "Datei auswählen, um Details zu sehen",
                "archiveInspectBeforeExtracting": "Metadaten und Schnellaktionen vor dem Extrahieren anzeigen.",
                "archiveNoArchiveSelected": "Kein Archiv ausgewählt",
                "archiveNoFileSelectedTitle": "Datei auswählen, um Details zu sehen",
                "archiveNoFileSelectedSubtitle": "Metadaten und Schnellaktionen vor dem Extrahieren anzeigen.",
                "archiveNoMatchesTitle": "Keine passenden Dateien gefunden.",
                "archiveNoMatchesSubtitle": "Versuche einen anderen Suchbegriff oder wechsle den Filter.",
                "archiveNoPreviewTitle": "Keine Vorschau verfügbar",
                "archiveNoPreviewSubtitle": "Wähle eine Bild-, Text- oder Code-Datei für eine sichere Vorschau.",
                "archiveNoPreviewFolderTitle": "Keine Vorschau verfügbar",
                "archiveNoPreviewFolderSubtitle": "Ordner haben keine Dateivorschau.",
                "archiveNoPreviewPdfTitle": "PDF-Vorschau derzeit nicht verfügbar.",
                "archiveNoPreviewPdfSubtitle": "Wähle eine Bild-, Text- oder Code-Datei für eine sichere Vorschau.",
                "archiveEmptyHeroTitle": "Archive vor dem Extrahieren ansehen",
                "archiveEmptyHeroSubtitle": "Öffne ZIP, RAR, 7z, TAR und mehr. Suche, filtere und extrahiere nur, was du brauchst.",
                "archiveEmptyOpenArchive": "Archiv öffnen",
                "archiveEmptyTrySampleArchive": "Beispielarchiv testen",
                "archiveEmptySearchInsideArchives": "In Archiven suchen",
                "archiveEmptyBrowseByFileType": "Nach Dateityp durchsuchen",
                "archiveEmptyExtractSafely": "Ausgewählte Dateien sicher extrahieren",
                "archiveEmptyUpgradePrompt": "Großes Archiv, Passwörter oder Risikoerkennung benötigt? Auf Pro upgraden.",
                "archiveDropTitle": "Archiv hier ablegen",
                "archiveDropSubtitle": "Zum Prüfen ablegen",
                "archiveDropOverlayTitle": "Zum Prüfen ablegen",
                "archiveDropOverlaySubtitle": "PeekZip liest den Index, ohne etwas zu extrahieren.",
                "archiveDropOverlayHelp": "Archiv ablegen oder „Archiv öffnen“ wählen, um Inhalte vorzuschauen.",
                "archiveReadingTitle": "Archiv wird gelesen…",
                "archiveReadingSubtitle": "Bitte warten, während PeekZip das Archiv indiziert.",
                "archiveChooseAnotherArchive": "Anderes Archiv wählen",
                "archiveEmptyArchiveTitle": "Dieses Archiv ist leer.",
                "archiveOpenArchivePanelMessage": "Archiv auswählen, um Inhalte zu prüfen.",
                "archivePreviewImagesText": "Bilder und Textdateien ansehen",
                "archiveCopyPathsText": "Pfade ohne Extrahieren kopieren",
                "archiveExtractSelectedText": "Nur ausgewählte Elemente extrahieren",
                "archivePreviewReading": "Vorschau wird gelesen…",
                "archivePreviewNotAvailable": "Keine Vorschau verfügbar",
                "archivePreviewNotAvailableFolder": "Ordner haben keine Dateivorschau.",
                "archivePreviewNotAvailablePdf": "PDF-Vorschau derzeit nicht verfügbar.",
                "archivePreviewTitle": "Vorschau",
                "archiveMetadataTitle": "Metadaten",
                "archiveLocationTitle": "Ort",
                "archiveRiskTitle": "Risiko",
                "archiveMetadataType": "Typ",
                "archiveMetadataSize": "Größe",
                "archiveMetadataModified": "Geändert",
                "archiveMetadataCompression": "Komprimierung",
                "archiveMetadataCompressedSize": "Komprimierte Größe",
                "archiveMetadataPathInArchive": "Pfad im Archiv",
                "archiveMetadataArchiveName": "Archivname",
                "archiveMetadataParentFolder": "Übergeordneter Ordner",
                "archiveMetadataLevel": "Stufe",
                "archiveMetadataReason": "Grund",
                "archiveMetadataMessage": "Nachricht",
                "archiveRiskConfirmationTitle": "Dieses Archiv enthält %d riskante Dateien. Trotzdem extrahieren?",
                "archiveRiskConfirmationMessage": "Abbrechen, riskante Dateien prüfen oder mit dem Extrahieren fortfahren.",
                "archiveReviewRiskyFiles": "Riskante Dateien prüfen",
                "archiveExtractAnyway": "Trotzdem extrahieren",
                "archiveCancel": "Abbrechen",
                "archiveSafetyNoRiskyDetected": "Sichere Vorschau. Keine riskanten Dateien erkannt.",
                "archiveSafetyRiskyFound": "Sichere Vorschau. Vor dem Extrahieren wurden %d riskante Dateien gefunden.",
                "archiveMetricTopLevelOverview": "Übersicht auf oberster Ebene",
                "archiveMetricMostRelevant": "Am relevantesten",
                "archiveTableArchive": "Archiv",
                "archiveTableName": "Name",
                "archiveTablePath": "Pfad",
                "archiveTableSize": "Größe",
                "archiveTableModified": "Geändert",
                "archiveTableType": "Typ",
                "archiveToastNoMatchingFiles": "Keine passenden Dateien gefunden.",
                "archiveToastExtractedSuccessfully": "Erfolgreich extrahiert",
                "archiveToastExtractionFailed": "Extraktion fehlgeschlagen. Bitte wähle einen anderen Speicherort.",
                "archiveToastFileNameCopied": "Dateiname kopiert",
                "archiveToastPathCopied": "Pfad kopiert",
                "archiveToastNoRiskyFiles": "Keine ausführbaren oder Installationsdateien gefunden.",
                "archiveTryAgain": "Erneut versuchen",
                "archiveUnableToReadTitle": "Dieses Archiv kann nicht gelesen werden",
                "filterAllItems": "Alle Elemente",
                "filterFolders": "Ordner",
                "filterImages": "Bilder",
                "filterDocuments": "Dokumente",
                "filterCode": "Code",
                "filterVideos": "Videos",
                "filterArchives": "Archive",
                "filterLargeFiles": "Große Dateien",
                "filterRecentlyViewed": "Zuletzt angesehen",
                "filterRiskyFiles": "Riskante Dateien",
                "filterHiddenJunkFiles": "Versteckt & unnötig",
                "metricItems": "Elemente",
                "metricFolders": "Ordner",
                "metricImages": "Bilder",
                "metricDocuments": "Dokumente",
                "metricCode": "Code",
                "metricVideos": "Videos",
                "metricLarge": "Groß",
                "metricRisky": "Riskant",
                "metricHidden": "Versteckt",
                "statFilesCompact": "%d Dateien",
                "statFoldersCompact": "%d Ordner",
                "statSizeUnknown": "Unbekannt",
                "archiveFlavorCodeCompact": "Code",
                "archiveFlavorImageCompact": "Bilder",
                "archiveFlavorDocumentCompact": "Dokumente",
                "archiveFlavorVideoCompact": "Videos",
                "archiveFlavorMixedCompact": "Gemischt",
                "archiveFlavorSingleFileCompact": "Einzeldatei",
                "archiveTypeMulti": "MEHR",
                "archiveTypeArchive": "ARCHIV",
                "archiveTypeUnknown": "Unbekannt",
                "statusProActive": "PeekZip Pro aktiv",
                "archiveBatchExtractByType": "Nach Typ stapelweise extrahieren",
                "archiveBatchExtractTitle": "Extrahiere %@",
                "archiveBatchExtractCustomTitle": "Eigene Typen extrahieren",
                "archiveProTag": "Pro",
                "archiveArchivesOpen": "Archive geöffnet",
                "archiveFewItemsHint": "Element auswählen, um Details zu sehen, oder Aktionen zum Extrahieren verwenden.",
                "archiveHiddenBadge": "VERSTECKT",
                "archiveActionUnlockFullIndex": "Vollständigen Index freischalten",
                "archiveActionContinueFree": "Kostenlos fortfahren"
            ]),
            "es": merged([
                "toolbarOpenShort": "Abrir",
                "toolbarExtractShort": "Extraer",
                "toolbarMoreAccessibility": "Más acciones",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Listo",
                "statusInspectingShort": "Inspeccionando",
                "statusExtractingShort": "Extrayendo",
                "toolbarNoArchiveOpen": "Ningún archivo abierto",
                "toolbarReady": "Listo",
                "toolbarInspecting": "Inspeccionando",
                "toolbarExtracting": "Extrayendo",
                "toolbarArchiveLoaded": "Archivo cargado",
                "toolbarNeedsAttention": "Requiere atención",
                "archiveSummaryText": "Suelta un archivo o elige Abrir archivo para previsualizar el contenido.",
                "archiveSafetyNothingExtracted": "Vista segura. Nada extraído.",
                "archiveContentsTitle": "Contenido del archivo",
                "archiveContentsSubtitleDefault": "Busca, filtra y extrae archivos antes de descomprimir.",
                "archiveContentsSearchPlaceholder": "Buscar nombre, extensión o ruta...",
                "searchPlaceholderArchive": "Buscar nombre, extensión o ruta…",
                "archiveFiltersTitle": "Filtros",
                "archiveBrowseGroupTitle": "Explorar",
                "archiveInspectGroupTitle": "Inspeccionar",
                "archiveSummaryGroupTitle": "Resumen",
                "archiveArchivesGroupTitle": "Archivos",
                "archiveAllArchivesTitle": "Todos los archivos",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "Revisa metadatos, previsualiza con seguridad y extrae solo lo necesario.",
                "archiveQuickActionsTitle": "Acciones rápidas",
                "archiveActionExtractFolder": "Extraer carpeta",
                "archiveActionExtractSelected": "Extraer selección",
                "archiveActionRevealAfterExtract": "Mostrar tras extraer",
                "archiveActionCopyFileName": "Copiar nombre",
                "archiveActionCopyPath": "Copiar ruta",
                "archiveActionReloadArchive": "Recargar archivo",
                "archiveActionActions": "Acciones",
                "actionsShort": "Acciones",
                "archiveActionInspector": "Inspector",
                "inspectorShort": "Inspector",
                "archiveActionOpenArchive": "Abrir",
                "archiveActionExtract": "Extraer",
                "archiveActionUpgradePro": "Pro",
                "archiveMenuExtractAll": "Extraer todo",
                "archiveMenuExtractSelected": "Extraer selección",
                "archiveMenuRevealAfterExtract": "Mostrar tras extraer",
                "archiveMenuCopyFileName": "Copiar nombre",
                "archiveMenuCopyPath": "Copiar ruta",
                "archiveMenuReloadArchive": "Recargar archivo",
                "archiveMenuSearchMultipleArchives": "Buscar en varios archivos…",
                "archiveMenuUpgradeToPro": "Actualizar a Pro…",
                "archiveMenuSettings": "Ajustes…",
                "archiveMenuExtractAllImages": "Extraer todas las imágenes",
                "archiveMenuExtractAllPDFs": "Extraer todos los PDF",
                "archiveMenuExtractAllVideos": "Extraer todos los vídeos",
                "archiveMenuExtractAllDocuments": "Extraer todos los documentos",
                "archiveMenuExtractAllCodeFiles": "Extraer todos los archivos de código",
                "archiveMenuExtractCustomTypes": "Extraer tipos personalizados…",
                "archiveMenuScanRiskyFiles": "Analizar archivos de riesgo",
                "archiveShowingResultsFor": "Mostrando %d resultados para «%@».",
                "archiveShowingOfTotalPrefix": "Mostrando %d de %d",
                "archiveLargeArchiveDetected": "Se detectó un archivo grande. La vista previa gratuita indexa 200 de %d elementos.",
                "archiveFreePreviewIndexing": "La vista previa gratuita está indexando 200 de %d elementos.",
                "archiveSelectedSummary": "%d elemento seleccionado",
                "archiveNoFileSelected": "Ningún archivo seleccionado",
                "archiveSelectedItemHint": "Selecciona un elemento para inspeccionarlo o usa Acciones para extraer.",
                "archiveSelectItemToInspect": "Selecciona un archivo para inspeccionarlo",
                "archiveInspectBeforeExtracting": "Ver metadatos y acciones rápidas antes de extraer.",
                "archiveNoArchiveSelected": "Ningún archivo seleccionado",
                "archiveNoFileSelectedTitle": "Selecciona un archivo para inspeccionarlo",
                "archiveNoFileSelectedSubtitle": "Ver metadatos y acciones rápidas antes de extraer.",
                "archiveNoMatchesTitle": "No se encontraron archivos coincidentes.",
                "archiveNoMatchesSubtitle": "Prueba otro término de búsqueda o cambia de filtro.",
                "archiveNoPreviewTitle": "No hay vista previa disponible",
                "archiveNoPreviewSubtitle": "Selecciona una imagen, texto o código para una vista previa segura.",
                "archiveNoPreviewFolderTitle": "No hay vista previa disponible",
                "archiveNoPreviewFolderSubtitle": "Las carpetas no tienen vista previa.",
                "archiveNoPreviewPdfTitle": "La vista previa de PDF aún no está disponible.",
                "archiveNoPreviewPdfSubtitle": "Selecciona una imagen, texto o código para una vista previa segura.",
                "archiveEmptyHeroTitle": "Previsualiza archivos antes de extraer",
                "archiveEmptyHeroSubtitle": "Abre ZIP, RAR, 7z, TAR y más. Busca, filtra y extrae solo lo que necesitas.",
                "archiveEmptyOpenArchive": "Abrir archivo",
                "archiveEmptyTrySampleArchive": "Probar archivo de ejemplo",
                "archiveEmptySearchInsideArchives": "Buscar dentro de archivos",
                "archiveEmptyBrowseByFileType": "Explorar por tipo de archivo",
                "archiveEmptyExtractSafely": "Extraer archivos seleccionados con seguridad",
                "archiveEmptyUpgradePrompt": "¿Necesitas indexación grande, archivos con contraseña o detección de riesgo? Actualiza a Pro.",
                "archiveDropTitle": "Suelta un archivo aquí",
                "archiveDropSubtitle": "Suelta para inspeccionar el archivo",
                "archiveDropOverlayTitle": "Suelta para inspeccionar el archivo",
                "archiveDropOverlaySubtitle": "PeekZip leerá el índice del archivo sin extraer nada.",
                "archiveDropOverlayHelp": "Suelta un archivo o elige Abrir archivo para previsualizar el contenido.",
                "archiveReadingTitle": "Leyendo contenido del archivo…",
                "archiveReadingSubtitle": "Espera mientras PeekZip indexa el archivo.",
                "archiveChooseAnotherArchive": "Elegir otro archivo",
                "archiveEmptyArchiveTitle": "Este archivo está vacío.",
                "archiveOpenArchivePanelMessage": "Elige un archivo para inspeccionar.",
                "archivePreviewImagesText": "Vista previa de imágenes y texto",
                "archiveCopyPathsText": "Copiar rutas sin extraer",
                "archiveExtractSelectedText": "Extraer solo los elementos seleccionados",
                "archivePreviewReading": "Leyendo vista previa…",
                "archivePreviewNotAvailable": "No hay vista previa disponible",
                "archivePreviewNotAvailableFolder": "Las carpetas no tienen vista previa.",
                "archivePreviewNotAvailablePdf": "La vista previa de PDF aún no está disponible.",
                "archivePreviewTitle": "Vista previa",
                "archiveMetadataTitle": "Metadatos",
                "archiveLocationTitle": "Ubicación",
                "archiveRiskTitle": "Riesgo",
                "archiveMetadataType": "Tipo",
                "archiveMetadataSize": "Tamaño",
                "archiveMetadataModified": "Modificado",
                "archiveMetadataCompression": "Compresión",
                "archiveMetadataCompressedSize": "Tamaño comprimido",
                "archiveMetadataPathInArchive": "Ruta dentro del archivo",
                "archiveMetadataArchiveName": "Nombre del archivo",
                "archiveMetadataParentFolder": "Carpeta principal",
                "archiveMetadataLevel": "Nivel",
                "archiveMetadataReason": "Motivo",
                "archiveMetadataMessage": "Mensaje",
                "archiveRiskConfirmationTitle": "Este archivo contiene %d archivos de riesgo. ¿Extraer de todos modos?",
                "archiveRiskConfirmationMessage": "Cancelar, revisar los archivos de riesgo o continuar con la extracción.",
                "archiveReviewRiskyFiles": "Revisar archivos de riesgo",
                "archiveExtractAnyway": "Extraer de todos modos",
                "archiveCancel": "Cancelar",
                "archiveSafetyNoRiskyDetected": "Vista segura. No se detectaron archivos de riesgo.",
                "archiveSafetyRiskyFound": "Vista segura. Se encontraron %d archivos de riesgo antes de extraer.",
                "archiveMetricTopLevelOverview": "Resumen de nivel superior",
                "archiveMetricMostRelevant": "Más relevante",
                "archiveTableArchive": "Archivo",
                "archiveTableName": "Nombre",
                "archiveTablePath": "Ruta",
                "archiveTableSize": "Tamaño",
                "archiveTableModified": "Modificado",
                "archiveTableType": "Tipo",
                "archiveToastNoMatchingFiles": "No se encontraron archivos coincidentes.",
                "archiveToastExtractedSuccessfully": "Extraído correctamente",
                "archiveToastExtractionFailed": "La extracción falló. Prueba otra ubicación.",
                "archiveToastFileNameCopied": "Nombre copiado",
                "archiveToastPathCopied": "Ruta copiada",
                "archiveToastNoRiskyFiles": "No se encontraron ejecutables ni instaladores.",
                "archiveTryAgain": "Intentar de nuevo",
                "archiveUnableToReadTitle": "No se puede leer este archivo",
                "filterAllItems": "Todos",
                "filterFolders": "Carpetas",
                "filterImages": "Imágenes",
                "filterDocuments": "Documentos",
                "filterCode": "Código",
                "filterVideos": "Vídeos",
                "filterArchives": "Archivos",
                "filterLargeFiles": "Archivos grandes",
                "filterRecentlyViewed": "Vistos recientemente",
                "filterRiskyFiles": "Archivos de riesgo",
                "filterHiddenJunkFiles": "Ocultos y basura",
                "metricItems": "Elementos",
                "metricFolders": "Carpetas",
                "metricImages": "Imágenes",
                "metricDocuments": "Documentos",
                "metricCode": "Código",
                "metricVideos": "Vídeos",
                "metricLarge": "Grandes",
                "metricRisky": "Riesgo",
                "metricHidden": "Ocultos",
                "statFilesCompact": "%d archivos",
                "statFoldersCompact": "%d carpetas",
                "statSizeUnknown": "Desconocido",
                "archiveFlavorCodeCompact": "Código",
                "archiveFlavorImageCompact": "Imágenes",
                "archiveFlavorDocumentCompact": "Documentos",
                "archiveFlavorVideoCompact": "Vídeos",
                "archiveFlavorMixedCompact": "Mixto",
                "archiveFlavorSingleFileCompact": "Archivo único",
                "archiveTypeMulti": "VARIOS",
                "archiveTypeArchive": "ARCHIVO",
                "archiveTypeUnknown": "Desconocido",
                "statusProActive": "PeekZip Pro activo",
                "archiveBatchExtractByType": "Extraer por tipo",
                "archiveBatchExtractTitle": "Extraer %@",
                "archiveBatchExtractCustomTitle": "Extraer tipos personalizados",
                "archiveProTag": "Pro",
                "archiveArchivesOpen": "Archivos abiertos",
                "archiveFewItemsHint": "Selecciona un elemento para inspeccionarlo o usa Acciones para extraer.",
                "archiveHiddenBadge": "OCULTO",
                "archiveActionUnlockFullIndex": "Desbloquear índice completo",
                "archiveActionContinueFree": "Continuar gratis"
            ]),
            "fr": merged([
                "toolbarOpenShort": "Ouvrir",
                "toolbarExtractShort": "Extraire",
                "toolbarMoreAccessibility": "Plus d’actions",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Prêt",
                "statusInspectingShort": "Inspection",
                "statusExtractingShort": "Extraction",
                "toolbarNoArchiveOpen": "Aucune archive ouverte",
                "toolbarReady": "Prêt",
                "toolbarInspecting": "Inspection",
                "toolbarExtracting": "Extraction",
                "toolbarArchiveLoaded": "Archive chargée",
                "toolbarNeedsAttention": "Action requise",
                "archiveSummaryText": "Déposez une archive ou choisissez Ouvrir pour prévisualiser le contenu.",
                "archiveSafetyNothingExtracted": "Aperçu sécurisé. Rien n’a été extrait.",
                "archiveContentsTitle": "Contenu de l’archive",
                "archiveContentsSubtitleDefault": "Recherchez, filtrez et extrayez avant décompression.",
                "archiveContentsSearchPlaceholder": "Rechercher nom, extension ou chemin...",
                "searchPlaceholderArchive": "Rechercher nom, extension ou chemin…",
                "archiveFiltersTitle": "Filtres",
                "archiveBrowseGroupTitle": "Parcourir",
                "archiveInspectGroupTitle": "Inspecter",
                "archiveSummaryGroupTitle": "Résumé",
                "archiveArchivesGroupTitle": "Archives",
                "archiveAllArchivesTitle": "Toutes les archives",
                "archiveContentsInspectorTitle": "Inspecteur",
                "archiveContentsInspectorSubtitle": "Vérifiez les métadonnées, prévisualisez en toute sécurité et extrayez uniquement ce qu’il faut.",
                "archiveQuickActionsTitle": "Actions rapides",
                "archiveActionExtractFolder": "Extraire le dossier",
                "archiveActionExtractSelected": "Extraire la sélection",
                "archiveActionRevealAfterExtract": "Afficher après extraction",
                "archiveActionCopyFileName": "Copier le nom",
                "archiveActionCopyPath": "Copier le chemin",
                "archiveActionReloadArchive": "Recharger l’archive",
                "archiveActionActions": "Actions",
                "actionsShort": "Actions",
                "archiveActionInspector": "Inspecteur",
                "inspectorShort": "Inspecteur",
                "archiveActionOpenArchive": "Ouvrir",
                "archiveActionExtract": "Extraire",
                "archiveActionUpgradePro": "Pro",
                "archiveMenuExtractAll": "Extraire tout",
                "archiveMenuExtractSelected": "Extraire la sélection",
                "archiveMenuRevealAfterExtract": "Afficher après extraction",
                "archiveMenuCopyFileName": "Copier le nom",
                "archiveMenuCopyPath": "Copier le chemin",
                "archiveMenuReloadArchive": "Recharger l’archive",
                "archiveMenuSearchMultipleArchives": "Rechercher dans plusieurs archives…",
                "archiveMenuUpgradeToPro": "Passer à Pro…",
                "archiveMenuSettings": "Réglages…",
                "archiveMenuExtractAllImages": "Extraire toutes les images",
                "archiveMenuExtractAllPDFs": "Extraire tous les PDF",
                "archiveMenuExtractAllVideos": "Extraire toutes les vidéos",
                "archiveMenuExtractAllDocuments": "Extraire tous les documents",
                "archiveMenuExtractAllCodeFiles": "Extraire tous les fichiers de code",
                "archiveMenuExtractCustomTypes": "Extraire des types personnalisés…",
                "archiveMenuScanRiskyFiles": "Analyser les fichiers à risque",
                "archiveShowingResultsFor": "Affichage de %d résultats pour «%@».",
                "archiveShowingOfTotalPrefix": "Affichage de %d sur %d",
                "archiveLargeArchiveDetected": "Grande archive détectée. L’aperçu gratuit indexe 200 des %d éléments.",
                "archiveFreePreviewIndexing": "L’aperçu gratuit indexe 200 des %d éléments.",
                "archiveSelectedSummary": "%d élément sélectionné",
                "archiveNoFileSelected": "Aucun fichier sélectionné",
                "archiveSelectedItemHint": "Sélectionnez un élément pour l’inspecter ou utilisez Actions pour extraire.",
                "archiveSelectItemToInspect": "Sélectionnez un fichier à inspecter",
                "archiveInspectBeforeExtracting": "Voir les métadonnées et les actions rapides avant d’extraire.",
                "archiveNoArchiveSelected": "Aucune archive sélectionnée",
                "archiveNoFileSelectedTitle": "Sélectionnez un fichier à inspecter",
                "archiveNoFileSelectedSubtitle": "Voir les métadonnées et les actions rapides avant d’extraire.",
                "archiveNoMatchesTitle": "Aucun fichier correspondant trouvé.",
                "archiveNoMatchesSubtitle": "Essayez un autre terme de recherche ou changez de filtre.",
                "archiveNoPreviewTitle": "Aucun aperçu disponible",
                "archiveNoPreviewSubtitle": "Sélectionnez une image, un texte ou du code pour un aperçu sûr.",
                "archiveNoPreviewFolderTitle": "Aucun aperçu disponible",
                "archiveNoPreviewFolderSubtitle": "Les dossiers n’ont pas d’aperçu de fichier.",
                "archiveNoPreviewPdfTitle": "L’aperçu PDF n’est pas encore disponible.",
                "archiveNoPreviewPdfSubtitle": "Sélectionnez une image, un texte ou du code pour un aperçu sûr.",
                "archiveEmptyHeroTitle": "Prévisualisez les archives avant extraction",
                "archiveEmptyHeroSubtitle": "Ouvrez ZIP, RAR, 7z, TAR et plus. Recherchez, filtrez et extrayez seulement ce dont vous avez besoin.",
                "archiveEmptyOpenArchive": "Ouvrir une archive",
                "archiveEmptyTrySampleArchive": "Essayer une archive exemple",
                "archiveEmptySearchInsideArchives": "Rechercher dans les archives",
                "archiveEmptyBrowseByFileType": "Parcourir par type de fichier",
                "archiveEmptyExtractSafely": "Extraire les fichiers sélectionnés en toute sécurité",
                "archiveEmptyUpgradePrompt": "Besoin d’indexation de grandes archives, d’archives protégées ou de détection de risque ? Passez à Pro.",
                "archiveDropTitle": "Déposez une archive ici",
                "archiveDropSubtitle": "Déposez pour inspecter l’archive",
                "archiveDropOverlayTitle": "Déposez pour inspecter l’archive",
                "archiveDropOverlaySubtitle": "PeekZip lira l’index de l’archive sans rien extraire.",
                "archiveDropOverlayHelp": "Déposez une archive ou choisissez Ouvrir pour prévisualiser le contenu.",
                "archiveReadingTitle": "Lecture du contenu de l’archive…",
                "archiveReadingSubtitle": "Veuillez patienter pendant que PeekZip indexe l’archive.",
                "archiveChooseAnotherArchive": "Choisir une autre archive",
                "archiveEmptyArchiveTitle": "Cette archive est vide.",
                "archiveOpenArchivePanelMessage": "Choisissez une archive à inspecter.",
                "archivePreviewImagesText": "Prévisualiser les images et le texte",
                "archiveCopyPathsText": "Copier les chemins sans extraire",
                "archiveExtractSelectedText": "Extraire uniquement les éléments sélectionnés",
                "archivePreviewReading": "Lecture de l’aperçu…",
                "archivePreviewNotAvailable": "Aucun aperçu disponible",
                "archivePreviewNotAvailableFolder": "Les dossiers n’ont pas d’aperçu de fichier.",
                "archivePreviewNotAvailablePdf": "L’aperçu PDF n’est pas encore disponible.",
                "archivePreviewTitle": "Aperçu",
                "archiveMetadataTitle": "Métadonnées",
                "archiveLocationTitle": "Emplacement",
                "archiveRiskTitle": "Risque",
                "archiveMetadataType": "Type",
                "archiveMetadataSize": "Taille",
                "archiveMetadataModified": "Modifié",
                "archiveMetadataCompression": "Compression",
                "archiveMetadataCompressedSize": "Taille compressée",
                "archiveMetadataPathInArchive": "Chemin dans l’archive",
                "archiveMetadataArchiveName": "Nom de l’archive",
                "archiveMetadataParentFolder": "Dossier parent",
                "archiveMetadataLevel": "Niveau",
                "archiveMetadataReason": "Raison",
                "archiveMetadataMessage": "Message",
                "archiveRiskConfirmationTitle": "Cette archive contient %d fichiers à risque. Extraire quand même ?",
                "archiveRiskConfirmationMessage": "Annulez, examinez les fichiers à risque ou poursuivez l’extraction.",
                "archiveReviewRiskyFiles": "Examiner les fichiers à risque",
                "archiveExtractAnyway": "Extraire quand même",
                "archiveCancel": "Annuler",
                "archiveSafetyNoRiskyDetected": "Aperçu sécurisé. Aucun fichier à risque détecté.",
                "archiveSafetyRiskyFound": "Aperçu sécurisé. %d fichiers à risque trouvés avant extraction.",
                "archiveMetricTopLevelOverview": "Aperçu du premier niveau",
                "archiveMetricMostRelevant": "Le plus pertinent",
                "archiveTableArchive": "Archive",
                "archiveTableName": "Nom",
                "archiveTablePath": "Chemin",
                "archiveTableSize": "Taille",
                "archiveTableModified": "Modifié",
                "archiveTableType": "Type",
                "archiveToastNoMatchingFiles": "Aucun fichier correspondant trouvé.",
                "archiveToastExtractedSuccessfully": "Extraction réussie",
                "archiveToastExtractionFailed": "L’extraction a échoué. Essayez un autre emplacement.",
                "archiveToastFileNameCopied": "Nom du fichier copié",
                "archiveToastPathCopied": "Chemin copié",
                "archiveToastNoRiskyFiles": "Aucun exécutable ni installateur trouvé.",
                "archiveTryAgain": "Réessayer",
                "archiveUnableToReadTitle": "Impossible de lire cette archive",
                "filterAllItems": "Tous",
                "filterFolders": "Dossiers",
                "filterImages": "Images",
                "filterDocuments": "Documents",
                "filterCode": "Code",
                "filterVideos": "Vidéos",
                "filterArchives": "Archives",
                "filterLargeFiles": "Fichiers volumineux",
                "filterRecentlyViewed": "Récemment vus",
                "filterRiskyFiles": "Fichiers à risque",
                "filterHiddenJunkFiles": "Cachés et inutiles",
                "metricItems": "Éléments",
                "metricFolders": "Dossiers",
                "metricImages": "Images",
                "metricDocuments": "Documents",
                "metricCode": "Code",
                "metricVideos": "Vidéos",
                "metricLarge": "Volumineux",
                "metricRisky": "À risque",
                "metricHidden": "Cachés",
                "statFilesCompact": "%d fichiers",
                "statFoldersCompact": "%d dossiers",
                "statSizeUnknown": "Inconnu",
                "archiveFlavorCodeCompact": "Code",
                "archiveFlavorImageCompact": "Images",
                "archiveFlavorDocumentCompact": "Documents",
                "archiveFlavorVideoCompact": "Vidéos",
                "archiveFlavorMixedCompact": "Mixte",
                "archiveFlavorSingleFileCompact": "Fichier unique",
                "archiveTypeMulti": "MULTI",
                "archiveTypeArchive": "ARCHIVE",
                "archiveTypeUnknown": "Inconnu",
                "statusProActive": "PeekZip Pro actif",
                "archiveBatchExtractByType": "Extraction par type",
                "archiveBatchExtractTitle": "Extraire %@",
                "archiveBatchExtractCustomTitle": "Extraire des types personnalisés",
                "archiveProTag": "Pro",
                "archiveArchivesOpen": "Archives ouvertes",
                "archiveFewItemsHint": "Sélectionnez un élément pour l’inspecter ou utilisez Actions pour extraire.",
                "archiveHiddenBadge": "CACHÉ",
                "archiveActionUnlockFullIndex": "Débloquer l’index complet",
                "archiveActionContinueFree": "Continuer gratuitement"
            ]),
            "pt-BR": merged([
                "toolbarOpenShort": "Abrir",
                "toolbarExtractShort": "Extrair",
                "toolbarMoreAccessibility": "Mais ações",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Pronto",
                "statusInspectingShort": "Inspecionando",
                "statusExtractingShort": "Extraindo",
                "toolbarNoArchiveOpen": "Nenhum arquivo aberto",
                "toolbarReady": "Pronto",
                "toolbarInspecting": "Inspecionando",
                "toolbarExtracting": "Extraindo",
                "toolbarArchiveLoaded": "Arquivo carregado",
                "toolbarNeedsAttention": "Requer atenção",
                "archiveSummaryText": "Solte um arquivo ou escolha Abrir arquivo para pré-visualizar o conteúdo.",
                "archiveSafetyNothingExtracted": "Pré-visualização segura. Nada extraído.",
                "archiveContentsTitle": "Conteúdo do arquivo",
                "archiveContentsSubtitleDefault": "Pesquise, filtre e extraia arquivos antes de descompactar.",
                "archiveContentsSearchPlaceholder": "Pesquisar nome, extensão ou caminho...",
                "searchPlaceholderArchive": "Pesquisar nome, extensão ou caminho…",
                "archiveFiltersTitle": "Filtros",
                "archiveBrowseGroupTitle": "Navegar",
                "archiveInspectGroupTitle": "Inspecionar",
                "archiveSummaryGroupTitle": "Resumo",
                "archiveArchivesGroupTitle": "Arquivos",
                "archiveAllArchivesTitle": "Todos os arquivos",
                "archiveContentsInspectorTitle": "Inspetor",
                "archiveContentsInspectorSubtitle": "Veja metadados, pré-visualize com segurança e extraia só o que precisa.",
                "archiveQuickActionsTitle": "Ações rápidas",
                "archiveActionExtractFolder": "Extrair pasta",
                "archiveActionExtractSelected": "Extrair seleção",
                "archiveActionRevealAfterExtract": "Mostrar após extrair",
                "archiveActionCopyFileName": "Copiar nome",
                "archiveActionCopyPath": "Copiar caminho",
                "archiveActionReloadArchive": "Recarregar arquivo",
                "archiveActionActions": "Ações",
                "actionsShort": "Ações",
                "archiveActionInspector": "Inspetor",
                "inspectorShort": "Inspetor",
                "archiveActionOpenArchive": "Abrir",
                "archiveActionExtract": "Extrair",
                "archiveActionUpgradePro": "Pro",
                "archiveMenuExtractAll": "Extrair tudo",
                "archiveMenuExtractSelected": "Extrair seleção",
                "archiveMenuRevealAfterExtract": "Mostrar após extrair",
                "archiveMenuCopyFileName": "Copiar nome",
                "archiveMenuCopyPath": "Copiar caminho",
                "archiveMenuReloadArchive": "Recarregar arquivo",
                "archiveMenuSearchMultipleArchives": "Pesquisar em vários arquivos…",
                "archiveMenuUpgradeToPro": "Atualizar para Pro…",
                "archiveMenuSettings": "Ajustes…",
                "archiveMenuExtractAllImages": "Extrair todas as imagens",
                "archiveMenuExtractAllPDFs": "Extrair todos os PDFs",
                "archiveMenuExtractAllVideos": "Extrair todos os vídeos",
                "archiveMenuExtractAllDocuments": "Extrair todos os documentos",
                "archiveMenuExtractAllCodeFiles": "Extrair todos os arquivos de código",
                "archiveMenuExtractCustomTypes": "Extrair tipos personalizados…",
                "archiveMenuScanRiskyFiles": "Analisar arquivos de risco",
                "archiveShowingResultsFor": "Mostrando %d resultados para “%@”.",
                "archiveShowingOfTotalPrefix": "Mostrando %d de %d",
                "archiveLargeArchiveDetected": "Arquivo grande detectado. A pré-visualização gratuita indexa 200 de %d itens.",
                "archiveFreePreviewIndexing": "A pré-visualização gratuita está indexando 200 de %d itens.",
                "archiveSelectedSummary": "%d item selecionado",
                "archiveNoFileSelected": "Nenhum arquivo selecionado",
                "archiveSelectedItemHint": "Selecione um item para inspecionar ou use Ações para extrair.",
                "archiveSelectItemToInspect": "Selecione um arquivo para inspecionar",
                "archiveInspectBeforeExtracting": "Veja metadados e ações rápidas antes de extrair.",
                "archiveNoArchiveSelected": "Nenhum arquivo selecionado",
                "archiveNoFileSelectedTitle": "Selecione um arquivo para inspecionar",
                "archiveNoFileSelectedSubtitle": "Veja metadados e ações rápidas antes de extrair.",
                "archiveNoMatchesTitle": "Nenhum arquivo correspondente encontrado.",
                "archiveNoMatchesSubtitle": "Tente outro termo de pesquisa ou mude o filtro.",
                "archiveNoPreviewTitle": "Nenhuma pré-visualização disponível",
                "archiveNoPreviewSubtitle": "Selecione uma imagem, texto ou código para uma pré-visualização segura.",
                "archiveNoPreviewFolderTitle": "Nenhuma pré-visualização disponível",
                "archiveNoPreviewFolderSubtitle": "Pastas não têm pré-visualização de arquivo.",
                "archiveNoPreviewPdfTitle": "A pré-visualização de PDF ainda não está disponível.",
                "archiveNoPreviewPdfSubtitle": "Selecione uma imagem, texto ou código para uma pré-visualização segura.",
                "archiveEmptyHeroTitle": "Visualize arquivos antes de extrair",
                "archiveEmptyHeroSubtitle": "Abra ZIP, RAR, 7z, TAR e mais. Pesquise, filtre e extraia apenas o que precisa.",
                "archiveEmptyOpenArchive": "Abrir arquivo",
                "archiveEmptyTrySampleArchive": "Testar arquivo de exemplo",
                "archiveEmptySearchInsideArchives": "Pesquisar dentro dos arquivos",
                "archiveEmptyBrowseByFileType": "Navegar por tipo de arquivo",
                "archiveEmptyExtractSafely": "Extrair arquivos selecionados com segurança",
                "archiveEmptyUpgradePrompt": "Precisa de indexação grande, arquivos com senha ou detecção de risco? Atualize para Pro.",
                "archiveDropTitle": "Solte um arquivo aqui",
                "archiveDropSubtitle": "Solte para inspecionar o arquivo",
                "archiveDropOverlayTitle": "Solte para inspecionar o arquivo",
                "archiveDropOverlaySubtitle": "O PeekZip lerá o índice do arquivo sem extrair nada.",
                "archiveDropOverlayHelp": "Solte um arquivo ou escolha Abrir arquivo para pré-visualizar o conteúdo.",
                "archiveReadingTitle": "Lendo o conteúdo do arquivo…",
                "archiveReadingSubtitle": "Aguarde enquanto o PeekZip indexa o arquivo.",
                "archiveChooseAnotherArchive": "Escolher outro arquivo",
                "archiveEmptyArchiveTitle": "Este arquivo está vazio.",
                "archiveOpenArchivePanelMessage": "Escolha um arquivo para inspecionar.",
                "archivePreviewImagesText": "Pré-visualizar imagens e texto",
                "archiveCopyPathsText": "Copiar caminhos sem extrair",
                "archiveExtractSelectedText": "Extrair apenas os itens selecionados",
                "archivePreviewReading": "Lendo pré-visualização…",
                "archivePreviewNotAvailable": "Nenhuma pré-visualização disponível",
                "archivePreviewNotAvailableFolder": "Pastas não têm pré-visualização de arquivo.",
                "archivePreviewNotAvailablePdf": "A pré-visualização de PDF ainda não está disponível.",
                "archivePreviewTitle": "Pré-visualização",
                "archiveMetadataTitle": "Metadados",
                "archiveLocationTitle": "Localização",
                "archiveRiskTitle": "Risco",
                "archiveMetadataType": "Tipo",
                "archiveMetadataSize": "Tamanho",
                "archiveMetadataModified": "Modificado",
                "archiveMetadataCompression": "Compactação",
                "archiveMetadataCompressedSize": "Tamanho compactado",
                "archiveMetadataPathInArchive": "Caminho no arquivo",
                "archiveMetadataArchiveName": "Nome do arquivo",
                "archiveMetadataParentFolder": "Pasta pai",
                "archiveMetadataLevel": "Nível",
                "archiveMetadataReason": "Motivo",
                "archiveMetadataMessage": "Mensagem",
                "archiveRiskConfirmationTitle": "Este arquivo contém %d arquivos de risco. Extrair mesmo assim?",
                "archiveRiskConfirmationMessage": "Cancelar, revisar os arquivos de risco ou continuar com a extração.",
                "archiveReviewRiskyFiles": "Revisar arquivos de risco",
                "archiveExtractAnyway": "Extrair mesmo assim",
                "archiveCancel": "Cancelar",
                "archiveSafetyNoRiskyDetected": "Pré-visualização segura. Nenhum arquivo de risco detectado.",
                "archiveSafetyRiskyFound": "Pré-visualização segura. %d arquivos de risco encontrados antes da extração.",
                "archiveMetricTopLevelOverview": "Visão geral do nível superior",
                "archiveMetricMostRelevant": "Mais relevante",
                "archiveTableArchive": "Arquivo",
                "archiveTableName": "Nome",
                "archiveTablePath": "Caminho",
                "archiveTableSize": "Tamanho",
                "archiveTableModified": "Modificado",
                "archiveTableType": "Tipo",
                "archiveToastNoMatchingFiles": "Nenhum arquivo correspondente encontrado.",
                "archiveToastExtractedSuccessfully": "Extraído com sucesso",
                "archiveToastExtractionFailed": "A extração falhou. Tente outro local.",
                "archiveToastFileNameCopied": "Nome do arquivo copiado",
                "archiveToastPathCopied": "Caminho copiado",
                "archiveToastNoRiskyFiles": "Nenhum executável ou instalador encontrado.",
                "archiveTryAgain": "Tentar novamente",
                "archiveUnableToReadTitle": "Não foi possível ler este arquivo",
                "filterAllItems": "Todos",
                "filterFolders": "Pastas",
                "filterImages": "Imagens",
                "filterDocuments": "Documentos",
                "filterCode": "Código",
                "filterVideos": "Vídeos",
                "filterArchives": "Arquivos",
                "filterLargeFiles": "Arquivos grandes",
                "filterRecentlyViewed": "Vistos recentemente",
                "filterRiskyFiles": "Arquivos de risco",
                "filterHiddenJunkFiles": "Ocultos e lixo",
                "metricItems": "Itens",
                "metricFolders": "Pastas",
                "metricImages": "Imagens",
                "metricDocuments": "Documentos",
                "metricCode": "Código",
                "metricVideos": "Vídeos",
                "metricLarge": "Grandes",
                "metricRisky": "Risco",
                "metricHidden": "Ocultos",
                "statFilesCompact": "%d arquivos",
                "statFoldersCompact": "%d pastas",
                "statSizeUnknown": "Desconhecido",
                "archiveFlavorCodeCompact": "Código",
                "archiveFlavorImageCompact": "Imagens",
                "archiveFlavorDocumentCompact": "Documentos",
                "archiveFlavorVideoCompact": "Vídeos",
                "archiveFlavorMixedCompact": "Misto",
                "archiveFlavorSingleFileCompact": "Arquivo único",
                "archiveTypeMulti": "MÚLTIPLO",
                "archiveTypeArchive": "ARQUIVO",
                "archiveTypeUnknown": "Desconhecido",
                "statusProActive": "PeekZip Pro ativo",
                "archiveBatchExtractByType": "Extrair por tipo",
                "archiveBatchExtractTitle": "Extrair %@",
                "archiveBatchExtractCustomTitle": "Extrair tipos personalizados",
                "archiveProTag": "Pro",
                "archiveArchivesOpen": "Arquivos abertos",
                "archiveFewItemsHint": "Selecione um item para inspecionar ou use Ações para extrair.",
                "archiveHiddenBadge": "OCULTO",
                "archiveActionUnlockFullIndex": "Desbloquear índice completo",
                "archiveActionContinueFree": "Continuar grátis"
            ]),
            "pt-PT": merged([
                "toolbarOpenShort": "Abrir",
                "toolbarExtractShort": "Extrair",
                "toolbarMoreAccessibility": "Mais ações",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Pronto",
                "statusInspectingShort": "A inspecionar",
                "statusExtractingShort": "A extrair",
                "toolbarNoArchiveOpen": "Nenhum arquivo aberto",
                "toolbarReady": "Pronto",
                "toolbarInspecting": "A inspecionar",
                "toolbarExtracting": "A extrair",
                "toolbarArchiveLoaded": "Arquivo carregado",
                "toolbarNeedsAttention": "Requer atenção",
                "archiveSummaryText": "Largue um arquivo ou escolha Abrir arquivo para pré-visualizar o conteúdo.",
                "archiveSafetyNothingExtracted": "Pré-visualização segura. Nada foi extraído.",
                "archiveContentsTitle": "Conteúdo do arquivo",
                "archiveContentsSubtitleDefault": "Pesquise, filtre e extraia ficheiros antes de descompactar.",
                "archiveContentsSearchPlaceholder": "Pesquisar nome, extensão ou caminho...",
                "searchPlaceholderArchive": "Pesquisar nome, extensão ou caminho…",
                "archiveFiltersTitle": "Filtros",
                "archiveBrowseGroupTitle": "Explorar",
                "archiveInspectGroupTitle": "Inspecionar",
                "archiveSummaryGroupTitle": "Resumo",
                "archiveArchivesGroupTitle": "Arquivos",
                "archiveAllArchivesTitle": "Todos os arquivos",
                "archiveContentsInspectorTitle": "Inspeção",
                "archiveContentsInspectorSubtitle": "Veja metadados, pré-visualize com segurança e extraia só o que precisa.",
                "archiveQuickActionsTitle": "Ações rápidas",
                "archiveActionExtractFolder": "Extrair pasta",
                "archiveActionExtractSelected": "Extrair seleção",
                "archiveActionRevealAfterExtract": "Mostrar após extrair",
                "archiveActionCopyFileName": "Copiar nome",
                "archiveActionCopyPath": "Copiar caminho",
                "archiveActionReloadArchive": "Recarregar arquivo",
                "archiveActionActions": "Ações",
                "actionsShort": "Ações",
                "archiveActionInspector": "Inspeção",
                "inspectorShort": "Inspeção",
                "archiveActionOpenArchive": "Abrir",
                "archiveActionExtract": "Extrair",
                "archiveActionUpgradePro": "Pro",
                "archiveMenuExtractAll": "Extrair tudo",
                "archiveMenuExtractSelected": "Extrair seleção",
                "archiveMenuRevealAfterExtract": "Mostrar após extrair",
                "archiveMenuCopyFileName": "Copiar nome",
                "archiveMenuCopyPath": "Copiar caminho",
                "archiveMenuReloadArchive": "Recarregar arquivo",
                "archiveMenuSearchMultipleArchives": "Pesquisar em vários arquivos…",
                "archiveMenuUpgradeToPro": "Atualizar para Pro…",
                "archiveMenuSettings": "Definições…",
                "archiveMenuExtractAllImages": "Extrair todas as imagens",
                "archiveMenuExtractAllPDFs": "Extrair todos os PDFs",
                "archiveMenuExtractAllVideos": "Extrair todos os vídeos",
                "archiveMenuExtractAllDocuments": "Extrair todos os documentos",
                "archiveMenuExtractAllCodeFiles": "Extrair todos os ficheiros de código",
                "archiveMenuExtractCustomTypes": "Extrair tipos personalizados…",
                "archiveMenuScanRiskyFiles": "Analisar ficheiros de risco",
                "archiveShowingResultsFor": "A mostrar %d resultados para «%@».",
                "archiveShowingOfTotalPrefix": "A mostrar %d de %d",
                "archiveLargeArchiveDetected": "Arquivo grande detetado. A pré-visualização gratuita indexa 200 de %d itens.",
                "archiveFreePreviewIndexing": "A pré-visualização gratuita está a indexar 200 de %d itens.",
                "archiveSelectedSummary": "%d item selecionado",
                "archiveNoFileSelected": "Nenhum ficheiro selecionado",
                "archiveSelectedItemHint": "Selecione um item para inspecionar ou use Ações para extrair.",
                "archiveSelectItemToInspect": "Selecione um ficheiro para inspecionar",
                "archiveInspectBeforeExtracting": "Veja metadados e ações rápidas antes de extrair.",
                "archiveNoArchiveSelected": "Nenhum arquivo selecionado",
                "archiveNoFileSelectedTitle": "Selecione um ficheiro para inspecionar",
                "archiveNoFileSelectedSubtitle": "Veja metadados e ações rápidas antes de extrair.",
                "archiveNoMatchesTitle": "Não foram encontrados ficheiros correspondentes.",
                "archiveNoMatchesSubtitle": "Experimente outro termo de pesquisa ou mude o filtro.",
                "archiveNoPreviewTitle": "Nenhuma pré-visualização disponível",
                "archiveNoPreviewSubtitle": "Selecione uma imagem, texto ou código para uma pré-visualização segura.",
                "archiveNoPreviewFolderTitle": "Nenhuma pré-visualização disponível",
                "archiveNoPreviewFolderSubtitle": "As pastas não têm pré-visualização de ficheiro.",
                "archiveNoPreviewPdfTitle": "A pré-visualização de PDF ainda não está disponível.",
                "archiveNoPreviewPdfSubtitle": "Selecione uma imagem, texto ou código para uma pré-visualização segura.",
                "archiveEmptyHeroTitle": "Visualize arquivos antes de extrair",
                "archiveEmptyHeroSubtitle": "Abra ZIP, RAR, 7z, TAR e mais. Pesquise, filtre e extraia apenas o que precisa.",
                "archiveEmptyOpenArchive": "Abrir arquivo",
                "archiveEmptyTrySampleArchive": "Testar arquivo de exemplo",
                "archiveEmptySearchInsideArchives": "Pesquisar dentro dos arquivos",
                "archiveEmptyBrowseByFileType": "Navegar por tipo de ficheiro",
                "archiveEmptyExtractSafely": "Extrair ficheiros selecionados com segurança",
                "archiveEmptyUpgradePrompt": "Precisa de indexação grande, arquivos com senha ou deteção de risco? Atualize para Pro.",
                "archiveDropTitle": "Largue um arquivo aqui",
                "archiveDropSubtitle": "Largue para inspecionar o arquivo",
                "archiveDropOverlayTitle": "Largue para inspecionar o arquivo",
                "archiveDropOverlaySubtitle": "O PeekZip lerá o índice do arquivo sem extrair nada.",
                "archiveDropOverlayHelp": "Largue um arquivo ou escolha Abrir arquivo para pré-visualizar o conteúdo.",
                "archiveReadingTitle": "A ler o conteúdo do arquivo…",
                "archiveReadingSubtitle": "Aguarde enquanto o PeekZip indexa o arquivo.",
                "archiveChooseAnotherArchive": "Escolher outro arquivo",
                "archiveEmptyArchiveTitle": "Este arquivo está vazio.",
                "archiveOpenArchivePanelMessage": "Escolha um arquivo para inspecionar.",
                "archivePreviewImagesText": "Pré-visualizar imagens e texto",
                "archiveCopyPathsText": "Copiar caminhos sem extrair",
                "archiveExtractSelectedText": "Extrair apenas os itens selecionados",
                "archivePreviewReading": "A ler pré-visualização…",
                "archivePreviewNotAvailable": "Nenhuma pré-visualização disponível",
                "archivePreviewNotAvailableFolder": "As pastas não têm pré-visualização de ficheiro.",
                "archivePreviewNotAvailablePdf": "A pré-visualização de PDF ainda não está disponível.",
                "archivePreviewTitle": "Pré-visualização",
                "archiveMetadataTitle": "Metadados",
                "archiveLocationTitle": "Localização",
                "archiveRiskTitle": "Risco",
                "archiveMetadataType": "Tipo",
                "archiveMetadataSize": "Tamanho",
                "archiveMetadataModified": "Modificado",
                "archiveMetadataCompression": "Compressão",
                "archiveMetadataCompressedSize": "Tamanho comprimido",
                "archiveMetadataPathInArchive": "Caminho no arquivo",
                "archiveMetadataArchiveName": "Nome do arquivo",
                "archiveMetadataParentFolder": "Pasta principal",
                "archiveMetadataLevel": "Nível",
                "archiveMetadataReason": "Motivo",
                "archiveMetadataMessage": "Mensagem",
                "archiveRiskConfirmationTitle": "Este arquivo contém %d ficheiros de risco. Extrair na mesma?",
                "archiveRiskConfirmationMessage": "Cancelar, rever os ficheiros de risco ou continuar com a extração.",
                "archiveReviewRiskyFiles": "Rever ficheiros de risco",
                "archiveExtractAnyway": "Extrair na mesma",
                "archiveCancel": "Cancelar",
                "archiveSafetyNoRiskyDetected": "Pré-visualização segura. Nenhum ficheiro de risco detetado.",
                "archiveSafetyRiskyFound": "Pré-visualização segura. Foram encontrados %d ficheiros de risco antes da extração.",
                "archiveMetricTopLevelOverview": "Visão geral do nível superior",
                "archiveMetricMostRelevant": "Mais relevante",
                "archiveTableArchive": "Arquivo",
                "archiveTableName": "Nome",
                "archiveTablePath": "Caminho",
                "archiveTableSize": "Tamanho",
                "archiveTableModified": "Modificado",
                "archiveTableType": "Tipo",
                "archiveToastNoMatchingFiles": "Não foram encontrados ficheiros correspondentes.",
                "archiveToastExtractedSuccessfully": "Extraído com sucesso",
                "archiveToastExtractionFailed": "A extração falhou. Tente outro local.",
                "archiveToastFileNameCopied": "Nome do ficheiro copiado",
                "archiveToastPathCopied": "Caminho copiado",
                "archiveToastNoRiskyFiles": "Não foram encontrados executáveis ou instaladores.",
                "archiveTryAgain": "Tentar novamente",
                "archiveUnableToReadTitle": "Não é possível ler este arquivo",
                "filterAllItems": "Todos",
                "filterFolders": "Pastas",
                "filterImages": "Imagens",
                "filterDocuments": "Documentos",
                "filterCode": "Código",
                "filterVideos": "Vídeos",
                "filterArchives": "Arquivos",
                "filterLargeFiles": "Ficheiros grandes",
                "filterRecentlyViewed": "Vistos recentemente",
                "filterRiskyFiles": "Ficheiros de risco",
                "filterHiddenJunkFiles": "Ocultos e lixo",
                "metricItems": "Itens",
                "metricFolders": "Pastas",
                "metricImages": "Imagens",
                "metricDocuments": "Documentos",
                "metricCode": "Código",
                "metricVideos": "Vídeos",
                "metricLarge": "Grandes",
                "metricRisky": "Risco",
                "metricHidden": "Ocultos",
                "statFilesCompact": "%d ficheiros",
                "statFoldersCompact": "%d pastas",
                "statSizeUnknown": "Desconhecido",
                "archiveFlavorCodeCompact": "Código",
                "archiveFlavorImageCompact": "Imagens",
                "archiveFlavorDocumentCompact": "Documentos",
                "archiveFlavorVideoCompact": "Vídeos",
                "archiveFlavorMixedCompact": "Misto",
                "archiveFlavorSingleFileCompact": "Ficheiro único",
                "archiveTypeMulti": "MÚLTIPLO",
                "archiveTypeArchive": "ARQUIVO",
                "archiveTypeUnknown": "Desconhecido",
                "statusProActive": "PeekZip Pro ativo",
                "archiveBatchExtractByType": "Extrair por tipo",
                "archiveBatchExtractTitle": "Extrair %@",
                "archiveBatchExtractCustomTitle": "Extrair tipos personalizados",
                "archiveProTag": "Pro",
                "archiveArchivesOpen": "Arquivos abertos",
                "archiveFewItemsHint": "Selecione um item para inspecionar ou use Ações para extrair.",
                "archiveHiddenBadge": "OCULTO",
                "archiveActionUnlockFullIndex": "Desbloquear índice completo",
                "archiveActionContinueFree": "Continuar grátis"
            ])
        ]
    }()

    static func string(_ key: Key) -> String {
        switch key {
        case .toolbarActionsShort:
            return string(.actionsShort)
        case .toolbarProShort:
            return string(.toolbarUpgradeShort)
        case .toolbarProActiveShort:
            return string(.archiveProTag)
        case .toolbarProTooltipUpgrade:
            return string(.archiveActionUpgradePro)
        case .toolbarProTooltipActive:
            return string(.statusProActive)
        case .archiveKindFolder:
            return localizedArchiveKindLabel(
                explicit: "Folder",
                chineseHans: "文件夹",
                chineseHant: "資料夾",
                fallbackKey: .filterFolders
            )
        case .archiveKindImage:
            return localizedArchiveKindLabel(
                explicit: "Image",
                chineseHans: "图片",
                chineseHant: "圖片",
                fallbackKey: .filterImages
            )
        case .archiveKindDocument:
            return localizedArchiveKindLabel(
                explicit: "Document",
                chineseHans: "文档",
                chineseHant: "文件",
                fallbackKey: .filterDocuments
            )
        case .archiveKindCode:
            return localizedArchiveKindLabel(
                explicit: "Code",
                chineseHans: "代码",
                chineseHant: "程式碼",
                fallbackKey: .filterCode
            )
        case .archiveKindVideo:
            return localizedArchiveKindLabel(
                explicit: "Video",
                chineseHans: "视频",
                chineseHant: "影片",
                fallbackKey: .filterVideos
            )
        case .archiveKindLargeFile:
            return localizedArchiveKindLabel(
                explicit: "Large File",
                chineseHans: "大文件",
                chineseHant: "大型檔案",
                fallbackKey: .filterLargeFiles
            )
        case .archiveKindArchive:
            return localizedArchiveKindLabel(
                explicit: "Archive",
                chineseHans: "压缩包",
                chineseHant: "壓縮檔",
                fallbackKey: .filterArchives
            )
        case .archiveKindText:
            return localizedArchiveKindFallback(
                explicit: "Text",
                chineseHans: "文本",
                chineseHant: "文字檔"
            )
        case .archiveKindFile:
            return localizedArchiveKindFallback(
                explicit: "File",
                chineseHans: "文件",
                chineseHant: "檔案"
            )
        case .archiveKindExecutable:
            return localizedArchiveKindFallback(
                explicit: "Executable",
                chineseHans: "可执行文件",
                chineseHant: "可執行檔"
            )
        case .archiveCompressionDeflate:
            return localizedArchiveKindFallback(
                explicit: "Deflate",
                chineseHans: "Deflate",
                chineseHant: "Deflate"
            )
        case .archiveCompressionStored:
            return localizedArchiveKindFallback(
                explicit: "Stored",
                chineseHans: "存储",
                chineseHant: "儲存"
            )
        default:
            break
        }
        return supplementalTranslations[languageCode]?[key.rawValue]
        ?? extraTranslations[languageCode]?[key.rawValue]
        ?? translations[languageCode]?[key.rawValue]
        ?? translations["en"]?[key.rawValue]
        ?? key.rawValue
    }

    static func highlight(for feature: ProFeature) -> String {
        switch feature {
        case .fullLargeArchiveIndex:
            return string(.paywallHighlightFullIndex)
        case .multiArchiveSearch:
            return string(.paywallHighlightMultiArchive)
        case .passwordArchive:
            return string(.paywallHighlightPassword)
        case .batchExtractByType:
            return string(.paywallHighlightBatchExtract)
        case .riskFileDetection:
            return string(.paywallHighlightRiskScanning)
        }
    }

    static func batchTypeTitle(_ type: ArchiveBatchType) -> String {
        switch languageCode {
        case "zh-Hans":
            switch type {
            case .images: return "图片"
            case .pdfs: return "PDF"
            case .videos: return "视频"
            case .documents: return "文档"
            case .code: return "代码文件"
            }
        case "zh-Hant":
            switch type {
            case .images: return "圖片"
            case .pdfs: return "PDF"
            case .videos: return "影片"
            case .documents: return "文件"
            case .code: return "程式碼檔案"
            }
        case "ja":
            switch type {
            case .images: return "画像"
            case .pdfs: return "PDF"
            case .videos: return "動画"
            case .documents: return "書類"
            case .code: return "コードファイル"
            }
        case "ko":
            switch type {
            case .images: return "이미지"
            case .pdfs: return "PDF"
            case .videos: return "동영상"
            case .documents: return "문서"
            case .code: return "코드 파일"
            }
        case "ar":
            switch type {
            case .images: return "الصور"
            case .pdfs: return "PDF"
            case .videos: return "الفيديوهات"
            case .documents: return "المستندات"
            case .code: return "ملفات الكود"
            }
        case "hi":
            switch type {
            case .images: return "छवियाँ"
            case .pdfs: return "PDF"
            case .videos: return "वीडियो"
            case .documents: return "दस्तावेज़"
            case .code: return "कोड फ़ाइलें"
            }
        case "id":
            switch type {
            case .images: return "Gambar"
            case .pdfs: return "PDF"
            case .videos: return "Video"
            case .documents: return "Dokumen"
            case .code: return "File Kode"
            }
        case "ms":
            switch type {
            case .images: return "Imej"
            case .pdfs: return "PDF"
            case .videos: return "Video"
            case .documents: return "Dokumen"
            case .code: return "Fail Kod"
            }
        case "vi":
            switch type {
            case .images: return "Hình ảnh"
            case .pdfs: return "PDF"
            case .videos: return "Video"
            case .documents: return "Tài liệu"
            case .code: return "Tệp mã"
            }
        case "th":
            switch type {
            case .images: return "รูปภาพ"
            case .pdfs: return "PDF"
            case .videos: return "วิดีโอ"
            case .documents: return "เอกสาร"
            case .code: return "ไฟล์โค้ด"
            }
        case "fil":
            switch type {
            case .images: return "Mga Larawan"
            case .pdfs: return "PDF"
            case .videos: return "Mga Video"
            case .documents: return "Mga Dokumento"
            case .code: return "Mga File ng Code"
            }
        case "bn":
            switch type {
            case .images: return "ছবি"
            case .pdfs: return "PDF"
            case .videos: return "ভিডিও"
            case .documents: return "ডকুমেন্ট"
            case .code: return "কোড ফাইল"
            }
        case "ur":
            switch type {
            case .images: return "تصاویر"
            case .pdfs: return "PDF"
            case .videos: return "ویڈیوز"
            case .documents: return "دستاویزات"
            case .code: return "کوڈ فائلیں"
            }
        case "de":
            switch type {
            case .images: return "Bilder"
            case .pdfs: return "PDFs"
            case .videos: return "Videos"
            case .documents: return "Dokumente"
            case .code: return "Codedateien"
            }
        case "es":
            switch type {
            case .images: return "Imágenes"
            case .pdfs: return "PDF"
            case .videos: return "Vídeos"
            case .documents: return "Documentos"
            case .code: return "Archivos de código"
            }
        case "fr":
            switch type {
            case .images: return "Images"
            case .pdfs: return "PDF"
            case .videos: return "Vidéos"
            case .documents: return "Documents"
            case .code: return "Fichiers de code"
            }
        case "pt-BR":
            switch type {
            case .images: return "Imagens"
            case .pdfs: return "PDFs"
            case .videos: return "Vídeos"
            case .documents: return "Documentos"
            case .code: return "Arquivos de código"
            }
        case "pt-PT":
            switch type {
            case .images: return "Imagens"
            case .pdfs: return "PDFs"
            case .videos: return "Vídeos"
            case .documents: return "Documentos"
            case .code: return "Ficheiros de código"
            }
        case "ru":
            switch type {
            case .images: return "Изображения"
            case .pdfs: return "PDF"
            case .videos: return "Видео"
            case .documents: return "Документы"
            case .code: return "Файлы кода"
            }
        case "tr":
            switch type {
            case .images: return "Görseller"
            case .pdfs: return "PDF'ler"
            case .videos: return "Videolar"
            case .documents: return "Belgeler"
            case .code: return "Kod dosyaları"
            }
        case "it":
            switch type {
            case .images: return "Immagini"
            case .pdfs: return "PDF"
            case .videos: return "Video"
            case .documents: return "Documenti"
            case .code: return "File di codice"
            }
        case "nl":
            switch type {
            case .images: return "Afbeeldingen"
            case .pdfs: return "PDF's"
            case .videos: return "Video's"
            case .documents: return "Documenten"
            case .code: return "Codebestanden"
            }
        case "pl":
            switch type {
            case .images: return "Obrazy"
            case .pdfs: return "PDF-y"
            case .videos: return "Wideo"
            case .documents: return "Dokumenty"
            case .code: return "Pliki kodu"
            }
        case "uk":
            switch type {
            case .images: return "Зображення"
            case .pdfs: return "PDF"
            case .videos: return "Відео"
            case .documents: return "Документи"
            case .code: return "Файли коду"
            }
        case "fa":
            switch type {
            case .images: return "تصاویر"
            case .pdfs: return "PDF"
            case .videos: return "ویدیوها"
            case .documents: return "اسناد"
            case .code: return "فایل‌های کد"
            }
        case "sw":
            switch type {
            case .images: return "Picha"
            case .pdfs: return "PDF"
            case .videos: return "Video"
            case .documents: return "Hati"
            case .code: return "Faili za msimbo"
            }
        case "ta":
            switch type {
            case .images: return "படங்கள்"
            case .pdfs: return "PDF"
            case .videos: return "வீடியோக்கள்"
            case .documents: return "ஆவணங்கள்"
            case .code: return "குறியீட்டு கோப்புகள்"
            }
        case "te":
            switch type {
            case .images: return "చిత్రాలు"
            case .pdfs: return "PDF"
            case .videos: return "వీడియోలు"
            case .documents: return "పత్రాలు"
            case .code: return "కోడ్ ఫైళ్లు"
            }
        case "mr":
            switch type {
            case .images: return "प्रतिमा"
            case .pdfs: return "PDF"
            case .videos: return "व्हिडिओ"
            case .documents: return "दस्तऐवज"
            case .code: return "कोड फाइल्स"
            }
        default:
            switch type {
            case .images: return "Images"
            case .pdfs: return "PDFs"
            case .videos: return "Videos"
            case .documents: return "Documents"
            case .code: return "Code Files"
            }
        }
    }

    static func riskBadgeTitle(for level: ArchiveRiskLevel?) -> String {
        switch languageCode {
        case "zh-Hans":
            switch level {
            case .high: return "高风险"
            case .medium: return "中风险"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "风险"
            }
        case "zh-Hant":
            switch level {
            case .high: return "高風險"
            case .medium: return "中風險"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "風險"
            }
        case "ja":
            switch level {
            case .high: return "高リスク"
            case .medium: return "中リスク"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "リスク"
            }
        case "ko":
            switch level {
            case .high: return "높은 위험"
            case .medium: return "중간 위험"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "위험"
            }
        case "ar":
            switch level {
            case .high: return "خطر مرتفع"
            case .medium: return "خطر متوسط"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "خطر"
            }
        case "hi":
            switch level {
            case .high: return "उच्च जोखिम"
            case .medium: return "मध्यम जोखिम"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "जोखिम"
            }
        case "id":
            switch level {
            case .high: return "Risiko tinggi"
            case .medium: return "Risiko sedang"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risiko"
            }
        case "ms":
            switch level {
            case .high: return "Risiko tinggi"
            case .medium: return "Risiko sederhana"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risiko"
            }
        case "vi":
            switch level {
            case .high: return "Rủi ro cao"
            case .medium: return "Rủi ro trung bình"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Rủi ro"
            }
        case "th":
            switch level {
            case .high: return "ความเสี่ยงสูง"
            case .medium: return "ความเสี่ยงปานกลาง"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "ความเสี่ยง"
            }
        case "fil":
            switch level {
            case .high: return "Mataas na panganib"
            case .medium: return "Katamtamang panganib"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Panganib"
            }
        case "bn":
            switch level {
            case .high: return "উচ্চ ঝুঁকি"
            case .medium: return "মাঝারি ঝুঁকি"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "ঝুঁকি"
            }
        case "ur":
            switch level {
            case .high: return "زیادہ خطرہ"
            case .medium: return "درمیانی خطرہ"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "خطرہ"
            }
        case "de":
            switch level {
            case .high: return "Hohes Risiko"
            case .medium: return "Mittleres Risiko"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risiko"
            }
        case "es":
            switch level {
            case .high: return "Riesgo alto"
            case .medium: return "Riesgo medio"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Riesgo"
            }
        case "fr":
            switch level {
            case .high: return "Risque élevé"
            case .medium: return "Risque moyen"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risque"
            }
        case "pt-BR":
            switch level {
            case .high: return "Alto risco"
            case .medium: return "Médio risco"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risco"
            }
        case "pt-PT":
            switch level {
            case .high: return "Risco elevado"
            case .medium: return "Risco médio"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risco"
            }
        case "ru":
            switch level {
            case .high: return "Высокий риск"
            case .medium: return "Средний риск"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Риск"
            }
        case "tr":
            switch level {
            case .high: return "Yüksek risk"
            case .medium: return "Orta risk"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risk"
            }
        case "it":
            switch level {
            case .high: return "Alto rischio"
            case .medium: return "Rischio medio"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Rischio"
            }
        case "nl":
            switch level {
            case .high: return "Hoog risico"
            case .medium: return "Gemiddeld risico"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Risico"
            }
        case "pl":
            switch level {
            case .high: return "Wysokie ryzyko"
            case .medium: return "Średnie ryzyko"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Ryzyko"
            }
        case "uk":
            switch level {
            case .high: return "Високий ризик"
            case .medium: return "Середній ризик"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Ризик"
            }
        case "fa":
            switch level {
            case .high: return "خطر بالا"
            case .medium: return "خطر متوسط"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "خطر"
            }
        case "sw":
            switch level {
            case .high: return "Hatari kubwa"
            case .medium: return "Hatari ya wastani"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "Hatari"
            }
        case "ta":
            switch level {
            case .high: return "அதிக ஆபத்து"
            case .medium: return "நடுத்தர ஆபத்து"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "ஆபத்து"
            }
        case "te":
            switch level {
            case .high: return "అధిక ప్రమాదం"
            case .medium: return "మధ్యస్థ ప్రమాదం"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "ప్రమాదం"
            }
        case "mr":
            switch level {
            case .high: return "उच्च जोखीम"
            case .medium: return "मध्यम जोखीम"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "जोखीम"
            }
        default:
            switch level {
            case .high: return "HIGH RISK"
            case .medium: return "MEDIUM RISK"
            case .notice: return string(.archiveHiddenBadge)
            case .none: return "RISK"
            }
        }
    }

    private static func localizedArchiveKindLabel(
        explicit: String,
        chineseHans: String,
        chineseHant: String,
        fallbackKey: Key
    ) -> String {
        switch languageCode {
        case "en":
            return explicit
        case "zh-Hans":
            return chineseHans
        case "zh-Hant":
            return chineseHant
        default:
            return string(fallbackKey)
        }
    }

    private static func localizedArchiveKindFallback(
        explicit: String,
        chineseHans: String,
        chineseHant: String
    ) -> String {
        switch languageCode {
        case "en":
            return explicit
        case "zh-Hans":
            return chineseHans
        case "zh-Hant":
            return chineseHant
        default:
            return explicit
        }
    }

    static var featureRows: [PaywallFeatureRow] {
        [
            .init(
                iconName: "tray.full.fill",
                title: string(.paywallFeatureFullIndexing),
                subtitle: string(.paywallHighlightFullIndex)
            ),
            .init(
                iconName: "magnifyingglass.circle.fill",
                title: string(.paywallFeatureMultiArchiveSearch),
                subtitle: string(.paywallHighlightMultiArchive)
            ),
            .init(
                iconName: "lock.fill",
                title: string(.paywallFeaturePasswordSupport),
                subtitle: string(.paywallHighlightPassword)
            ),
            .init(
                iconName: "square.stack.3d.down.right.fill",
                title: string(.paywallFeatureBatchExtract),
                subtitle: string(.paywallHighlightBatchExtract)
            ),
            .init(
                iconName: "exclamationmark.shield.fill",
                title: string(.paywallFeatureRiskDetection),
                subtitle: string(.paywallHighlightRiskScanning)
            )
        ]
    }

    static var paywallPriceBadge: String {
        let raw = string(.paywallLaunchPrice)
        let separators: [Character] = [":", "："]
        for separator in separators {
            if let index = raw.firstIndex(of: separator) {
                let badge = raw[..<index].trimmingCharacters(in: .whitespacesAndNewlines)
                if !badge.isEmpty { return badge }
            }
        }
        return raw
    }

    private static let translations: [String: [String: String]] = [
        "en": [
            "paywallTitle": "Unlock PeekZip Pro",
            "paywallSubtitle": "Inspect large, protected and complex archives faster.",
            "paywallHighlightFullIndex": "Unlock full indexing for this archive.",
            "paywallHighlightMultiArchive": "Open and search across multiple archives at once.",
            "paywallHighlightPassword": "Preview and extract password-protected archives.",
            "paywallHighlightBatchExtract": "Extract all images, PDFs, videos or code files in one click.",
            "paywallHighlightRiskScanning": "Detect risky executables and scripts before extracting.",
            "paywallFeatureFullIndexing": "Full indexing for large archives",
            "paywallFeatureMultiArchiveSearch": "Search across multiple archives",
            "paywallFeaturePasswordSupport": "Password-protected archive support",
            "paywallFeatureBatchExtract": "Batch extract by file type",
            "paywallFeatureRiskDetection": "Risky file detection before extraction",
            "paywallLifetimePro": "Lifetime Pro",
            "paywallLaunchPrice": "Launch price",
            "paywallOneTimePurchase": "One-time purchase · No subscription",
            "paywallPriceLoading": "Loading…",
            "paywallUnlockPro": "Unlock Pro",
            "paywallRestorePurchase": "Restore Purchase",
            "paywallContinueFree": "Continue Free",
            "paywallUnlocking": "Processing…",
            "paywallRestoring": "Restoring…",
            "paywallClose": "Close",
            "paywallPurchaseSucceeded": "PeekZip Pro unlocked.",
            "paywallPurchasePending": "Purchase is pending approval.",
            "paywallRestoreSucceeded": "Purchase restored.",
            "paywallRestoreNothingFound": "No previous purchase found.",
            "paywallPurchaseUnavailable": "PeekZip Pro is temporarily unavailable.",
            "paywallPurchaseFailed": "Could not verify this purchase.",
            "archiveFewItemsHint": "Select an item to inspect, or use Actions to extract.",
            "toolbarOpenShort": "Open",
            "toolbarExtractShort": "Extract",
            "toolbarMoreAccessibility": "More actions",
            "toolbarUpgradeShort": "Pro",
            "statusReadyShort": "Ready",
            "statusInspectingShort": "Inspecting",
            "statusExtractingShort": "Extracting",
            "toolbarNoArchiveOpen": "No archive open",
            "toolbarReady": "Ready",
            "toolbarInspecting": "Inspecting",
            "toolbarExtracting": "Extracting",
            "toolbarArchiveLoaded": "Archive Loaded",
            "toolbarNeedsAttention": "Needs Attention",
            "archiveEmptyHeroTitle": "Preview archives before extracting",
            "archiveEmptyHeroSubtitle": "Open ZIP, RAR, 7z, TAR and more. Search, filter and extract only what you need.",
            "emptyHomeTitle": "Preview archives before extracting",
            "emptyHomeSubtitle": "Search, inspect and extract only what you need.",
            "emptyPrimaryTitle": "Open an archive to start",
            "emptyPrimarySubtitle": "Choose a file, or drag an archive into PeekZip.",
            "emptyFeaturesTitle": "What you can do",
            "emptyFeatureSearchTitle": "Search inside archives",
            "emptyFeatureSearchSubtitle": "Find files by name, extension or path",
            "emptyFeatureBrowseTitle": "Browse by file type",
            "emptyFeatureBrowseSubtitle": "View images, documents, code and videos quickly",
            "emptyFeatureExtractTitle": "Extract only what you need",
            "emptyFeatureExtractSubtitle": "No need to unpack the entire archive",
            "emptyFormatsTitle": "Supported formats",
            "emptySectionRecent": "Recent",
            "emptySectionSamples": "Samples",
            "emptySectionFormats": "Supported formats",
            "emptyRecentNone": "No recent archives",
            "emptySamplesHint": "Try the bundled sample archive or open a file from Finder.",
            "emptyFeatureSearch": "Search inside archives",
            "emptyFeatureBrowse": "Browse by file type",
            "emptyFeatureExtract": "Extract only what you need",
            "archiveEmptyOpenArchive": "Open Archive",
            "archiveEmptyTrySampleArchive": "Try Sample Archive",
            "archiveEmptySearchInsideArchives": "Search inside archives",
            "archiveEmptyBrowseByFileType": "Browse by file type",
            "archiveEmptyExtractSafely": "Extract selected files safely",
            "archiveEmptyUpgradePrompt": "Need large archive indexing, password archives or risk detection? Upgrade to Pro.",
            "archiveContentsTitle": "Archive Contents",
            "archiveContentsSubtitleDefault": "Search, filter and extract files before unpacking.",
            "archiveContentsSearchPlaceholder": "Search by name, extension or folder path...",
            "searchPlaceholderArchive": "Search name, extension or path…",
            "archiveFiltersTitle": "Filters",
            "archiveBrowseGroupTitle": "Browse",
            "archiveInspectGroupTitle": "Inspect",
            "archiveSummaryGroupTitle": "Summary",
            "archiveArchivesGroupTitle": "Archives",
            "archiveAllArchivesTitle": "All Archives",
            "archiveContentsInspectorTitle": "Inspector",
            "archiveContentsInspectorSubtitle": "Inspect metadata, preview safely and extract only what you need.",
            "archiveReadingTitle": "Reading archive contents…",
            "archiveReadingSubtitle": "Please wait while PeekZip indexes the archive.",
            "archiveEmptyArchiveTitle": "This archive is empty.",
            "archiveChooseAnotherArchive": "Choose Another Archive",
            "archiveNoMatchesTitle": "No matching files found.",
            "archiveNoMatchesSubtitle": "Try a different search term or switch filters.",
            "archiveNoFileSelectedTitle": "Select a file to inspect",
            "archiveNoFileSelectedSubtitle": "View metadata and quick actions before extracting.",
            "archivePreviewImagesText": "Preview images and text files",
            "archiveCopyPathsText": "Copy paths without extracting",
            "archiveExtractSelectedText": "Extract selected items only",
            "archiveNoPreviewTitle": "No preview available",
            "archiveNoPreviewSubtitle": "Select an image, text or code file for a safe preview.",
            "archiveNoPreviewFolderTitle": "No preview available",
            "archiveNoPreviewFolderSubtitle": "Folders do not have a file preview.",
            "archiveNoPreviewPdfTitle": "PDF preview not available yet.",
            "archiveNoPreviewPdfSubtitle": "Select an image, text or code file for a safe preview.",
            "archiveDropTitle": "Drop an archive here",
            "archiveDropSubtitle": "Drop to inspect archive",
            "archiveDropOverlayTitle": "Drop to inspect archive",
            "archiveDropOverlaySubtitle": "PeekZip will read the archive index without extracting anything.",
            "archiveDropOverlayHelp": "Drop an archive or choose Open Archive to preview contents.",
            "archiveTableArchive": "Archive",
            "archiveTableName": "Name",
            "archiveTablePath": "Path",
            "archiveTableSize": "Size",
            "archiveTableModified": "Modified",
            "archiveTableType": "Type",
            "archiveMetadataTitle": "Metadata",
            "archiveLocationTitle": "Location",
            "archiveRiskTitle": "Risk",
            "archivePreviewTitle": "Preview",
            "archiveQuickActionsTitle": "Quick Actions",
            "archiveMetadataType": "Type",
            "archiveMetadataSize": "Size",
            "archiveMetadataModified": "Modified",
            "archiveMetadataCompression": "Compression",
            "archiveMetadataCompressedSize": "Compressed size",
            "archiveMetadataPathInArchive": "Path in archive",
            "archiveMetadataArchiveName": "Archive name",
            "archiveMetadataParentFolder": "Parent folder",
            "archiveMetadataLevel": "Level",
            "archiveMetadataReason": "Reason",
            "archiveMetadataMessage": "Message",
            "archiveActionExtractFolder": "Extract Folder",
            "archiveActionExtractSelected": "Extract Selected",
            "archiveActionRevealAfterExtract": "Reveal After Extract",
            "archiveActionCopyFileName": "Copy File Name",
            "archiveActionCopyPath": "Copy Path",
            "archiveActionReloadArchive": "Reload Archive",
            "archiveActionActions": "Actions",
            "actionsShort": "Actions",
            "archiveActionInspector": "Inspector",
            "inspectorShort": "Inspector",
            "archiveActionOpenArchive": "Open Archive",
            "archiveActionExtract": "Extract",
            "archiveActionUpgradePro": "Upgrade Pro",
            "archiveActionUnlockFullIndex": "Unlock Full Index",
            "archiveActionContinueFree": "Continue Free",
            "archiveMenuExtractAll": "Extract All",
            "archiveMenuExtractSelected": "Extract Selected",
            "archiveMenuRevealAfterExtract": "Reveal After Extract",
            "archiveMenuCopyFileName": "Copy File Name",
            "archiveMenuCopyPath": "Copy Path",
            "archiveMenuReloadArchive": "Reload Archive",
            "archiveMenuSearchMultipleArchives": "Search Multiple Archives…",
            "archiveMenuUpgradeToPro": "Upgrade to Pro…",
            "archiveMenuSettings": "Settings…",
            "menuSectionExtraction": "Extraction",
            "menuSectionUtilities": "Utilities",
            "menuSectionProTools": "Pro Tools",
            "menuSectionApp": "App",
            "archiveMenuExtractAllImages": "Extract All Images",
            "archiveMenuExtractAllPDFs": "Extract All PDFs",
            "archiveMenuExtractAllVideos": "Extract All Videos",
            "archiveMenuExtractAllDocuments": "Extract All Documents",
            "archiveMenuExtractAllCodeFiles": "Extract All Code Files",
            "archiveMenuExtractCustomTypes": "Extract Custom Types…",
            "archiveMenuScanRiskyFiles": "Scan Risky Files",
            "archiveShowingResultsFor": "Showing %d results for ‘%@’.",
            "archiveShowingOfTotalPrefix": "Showing %d of %d",
            "archiveLargeArchiveDetected": "Large archive detected. Free preview indexes 200 of %d items.",
            "archiveFreePreviewIndexing": "Free preview is indexing 200 of %d items.",
            "archiveSelectedSummary": "%d item selected",
            "archiveNoFileSelected": "No file selected",
            "archiveSelectedItemHint": "Select an item to inspect, or use Actions to extract.",
            "archivePreviewReading": "Reading preview…",
            "archivePreviewNotAvailable": "No preview available",
            "archivePreviewNotAvailableFolder": "Folders do not have a file preview.",
            "archivePreviewNotAvailablePdf": "PDF preview not available yet.",
            "archiveUnableToReadTitle": "Unable to read this archive",
            "archiveTryAgain": "Try Again",
            "archiveSelectItemToInspect": "Select a file to inspect",
            "archiveInspectBeforeExtracting": "View metadata and quick actions before extracting.",
            "archiveNoArchiveSelected": "No archive selected",
            "filterAllItems": "All Items",
            "filterFolders": "Folders",
            "filterImages": "Images",
            "filterDocuments": "Documents",
            "filterCode": "Code",
            "filterVideos": "Videos",
            "filterArchives": "Archives",
            "filterLargeFiles": "Large Files",
            "filterRecentlyViewed": "Recently Viewed",
            "filterRiskyFiles": "Risky Files",
            "filterHiddenJunkFiles": "Hidden & Junk",
            "metricItems": "Items",
            "metricCode": "Code",
            "metricFolders": "Folders",
            "metricDocuments": "Documents",
            "metricImages": "Images",
            "metricVideos": "Videos",
            "metricLarge": "Large",
            "metricRisky": "Risky",
            "metricHidden": "Hidden",
            "statusProActive": "PeekZip Pro Active",
            "archiveBatchExtractByType": "Batch Extract by Type",
            "archiveReviewRiskyFiles": "Review Risky Files",
            "archiveExtractAnyway": "Extract Anyway",
            "archiveCancel": "Cancel",
            "archiveMetricTopLevelOverview": "Top level overview",
            "archiveMetricMostRelevant": "Most relevant",
            "archiveRiskConfirmationTitle": "This archive contains %d risky files. Extract anyway?",
            "archiveRiskConfirmationMessage": "Cancel, review the risky files, or continue with extraction.",
            "archiveHiddenBadge": "HIDDEN",
            "archiveSummaryText": "Drop an archive or choose Open Archive to preview contents.",
            "archiveSafetyNothingExtracted": "Previewing safely. Nothing extracted yet.",
            "archiveToastArchiveEmpty": "This archive is empty.",
            "archiveToastNoArchivesOpened": "No archives could be opened.",
            "archiveSafetyNoRiskyDetected": "Previewing safely. No risky files detected.",
            "archiveSafetyRiskyFound": "Previewing safely. %d risky files found before extraction.",
            "archiveFlavorCodeCompact": "Code",
            "archiveFlavorImageCompact": "Images",
            "archiveFlavorDocumentCompact": "Documents",
            "archiveFlavorVideoCompact": "Videos",
            "archiveFlavorMixedCompact": "Mixed",
            "archiveFlavorSingleFileCompact": "Single file",
            "archiveArchiveLabel": "Archive",
            "statFilesCompact": "%d files",
            "statFoldersCompact": "%d folders",
            "statSizeUnknown": "Unknown",
            "archiveTypeMulti": "MULTI",
            "archiveTypeArchive": "ARCHIVE",
            "archiveTypeUnknown": "Unknown",
            "archiveToastNoRiskyFiles": "No executable or installer files found.",
            "archiveToastExtractedSuccessfully": "Extracted successfully",
            "archiveToastExtractionFailed": "Extraction failed. Please try another location.",
            "archiveToastNoMatchingFiles": "No matching files found.",
            "archiveToastFileNameCopied": "File name copied",
            "archiveToastPathCopied": "Path copied",
            "archiveArchivesOpen": "Archives Open",
            "archiveShowingSuffix": "showing",
            "archiveBatchExtractTitle": "Extract %@",
            "archiveBatchExtractCustomTitle": "Extract Custom Types",
            "archiveProTag": "Pro",
            "archiveOpenArchivePanelMessage": "Choose an archive to inspect.",
            "archiveChooseDestinationFolderMessage": "Choose a destination folder.",
            "archiveExtractArchivePrompt": "Extract Archive",
            "archiveExtractSelectedItemPrompt": "Extract Selected Item",
            "badgeFolder": "FOLDER",
            "badgeImage": "IMAGE",
            "badgeDocument": "DOCUMENT",
            "badgePDF": "PDF",
            "badgeCode": "CODE",
            "badgeVideo": "VIDEO",
            "badgeArchive": "ARCHIVE",
            "badgeText": "TEXT",
            "badgeLarge": "LARGE",
            "badgeFile": "FILE",
            "badgeApp": "APP",
            "badgeInstaller": "INSTALLER",
            "badgeDiskImage": "DISK IMAGE",
            "badgeScript": "SCRIPT",
            "badgeWindows": "WINDOWS",
            "badgePowerShell": "POWERSHELL",
            "badgeJava": "JAVA",
            "badgeExec": "EXEC",
            "badgeRisky": "RISKY",
            "badgeConfig": "CONFIG",
            "passwordPromptTitle": "Unlock Archive",
            "passwordPromptMessage": "Enter the password to preview and extract this archive.",
            "passwordPromptRememberSession": "Remember password for this session",
            "passwordPromptPasswordPlaceholder": "Password",
            "passwordPromptCancel": "Cancel",
            "passwordPromptUnlockArchive": "Unlock Archive",
            "batchExtractCustomSubtitle": "Enter extensions separated by commas, for example: pdf, csv, png",
            "batchExtractCustomPlaceholder": "pdf, csv, png",
            "batchExtractCustomCancel": "Cancel",
            "batchExtractCustomExtract": "Extract",
            "settingsGeneralTitle": "General",
            "settingsLanguageTitle": "Language",
            "settingsLanguageFollowSystem": "Follow System",
            "settingsRevealAfterExtract": "Reveal after extract",
            "settingsKeepFolderStructure": "Keep folder structure when extracting selected files",
            "settingsSkipJunkFilesOnExtract": "Skip junk files on extract",
            "settingsDefaultExtractLocationTitle": "Default Extract Location",
            "settingsChooseFolder": "Choose Folder…",
            "settingsUseSystemDefaultLocation": "Use the system default location.",
            "settingsProTitle": "Pro",
            "settingsLicenseStatus": "License status",
            "settingsFree": "Free",
            "settingsProActive": "PeekZip Pro Active",
            "settingsUnlockPro": "Unlock Pro",
            "settingsDefaultExtractLocationPanelTitle": "Default Extract Location",
            "settingsDefaultExtractLocationPanelMessage": "Choose a default folder for extracted archives."
        ],
        "zh-Hans": [
            "paywallTitle": "解锁 PeekZip Pro",
            "paywallSubtitle": "更快查看大型、加密和复杂压缩包。",
            "paywallHighlightFullIndex": "解锁此压缩包的完整索引。",
            "paywallHighlightMultiArchive": "一次打开并搜索多个压缩包。",
            "paywallHighlightPassword": "预览并解压密码保护的压缩包。",
            "paywallHighlightBatchExtract": "一键提取所有图片、PDF、视频或代码文件。",
            "paywallHighlightRiskScanning": "在解压前检测可疑可执行文件和脚本。",
            "paywallFeatureFullIndexing": "大型压缩包完整索引",
            "paywallFeatureMultiArchiveSearch": "跨多个压缩包搜索",
            "paywallFeaturePasswordSupport": "支持密码保护压缩包",
            "paywallFeatureBatchExtract": "按文件类型批量提取",
            "paywallFeatureRiskDetection": "解压前检测可疑文件",
            "paywallLifetimePro": "终身 Pro",
            "paywallLaunchPrice": "首发价格",
            "paywallOneTimePurchase": "一次购买 · 无订阅",
            "paywallPriceLoading": "加载中…",
            "paywallUnlockPro": "解锁 Pro",
            "paywallRestorePurchase": "恢复购买",
            "paywallContinueFree": "继续免费版",
            "paywallUnlocking": "处理中…",
            "paywallRestoring": "恢复中…",
            "paywallClose": "关闭",
            "paywallPurchaseSucceeded": "已解锁 PeekZip Pro。",
            "paywallPurchasePending": "购买正在等待确认。",
            "paywallRestoreSucceeded": "已恢复购买。",
            "paywallRestoreNothingFound": "没有找到可恢复的购买记录。",
            "paywallPurchaseUnavailable": "PeekZip Pro 暂时不可用。",
            "paywallPurchaseFailed": "无法验证此次购买。",
            "archiveFewItemsHint": "选择项目查看详情，或使用 Actions 提取文件。",
            "toolbarOpenShort": "打开",
            "toolbarExtractShort": "提取",
            "toolbarMoreAccessibility": "更多操作",
            "toolbarUpgradeShort": "Pro",
            "statusReadyShort": "就绪",
            "statusInspectingShort": "预览中",
            "statusExtractingShort": "提取中",
            "toolbarNoArchiveOpen": "未打开压缩包",
            "toolbarReady": "就绪",
            "toolbarInspecting": "检查中",
            "toolbarExtracting": "解压中",
            "toolbarArchiveLoaded": "已加载压缩包",
            "toolbarNeedsAttention": "需要处理",
            "archiveEmptyHeroTitle": "解压前预览压缩包",
            "archiveEmptyHeroSubtitle": "打开 ZIP、RAR、7z、TAR 等文件。搜索、筛选并仅提取需要的内容。",
            "emptyHomeTitle": "解压前预览压缩包",
            "emptyHomeSubtitle": "搜索、查看并只提取需要的内容。",
            "emptyPrimaryTitle": "打开压缩包开始预览",
            "emptyPrimarySubtitle": "选择文件，或直接拖入 PeekZip。",
            "emptyFeaturesTitle": "你可以做什么",
            "emptyFeatureSearchTitle": "搜索压缩包内容",
            "emptyFeatureSearchSubtitle": "按名称、扩展名或路径快速定位文件",
            "emptyFeatureBrowseTitle": "按文件类型浏览",
            "emptyFeatureBrowseSubtitle": "快速查看图片、文档、代码和视频",
            "emptyFeatureExtractTitle": "只提取需要的文件",
            "emptyFeatureExtractSubtitle": "无需完整解压整个压缩包",
            "emptyFormatsTitle": "支持格式",
            "emptySectionRecent": "最近使用",
            "emptySectionSamples": "示例文件",
            "emptySectionFormats": "支持的格式",
            "emptyRecentNone": "暂无最近压缩包",
            "emptySamplesHint": "试试内置示例压缩包，或从 Finder 打开文件。",
            "emptyFeatureSearch": "在压缩包内搜索",
            "emptyFeatureBrowse": "按文件类型浏览",
            "emptyFeatureExtract": "仅提取需要的文件",
            "archiveEmptyOpenArchive": "打开压缩包",
            "archiveEmptyTrySampleArchive": "试用示例压缩包",
            "archiveEmptySearchInsideArchives": "在压缩包内搜索",
            "archiveEmptyBrowseByFileType": "按文件类型浏览",
            "archiveEmptyExtractSafely": "安全提取所选文件",
            "archiveEmptyUpgradePrompt": "需要大型压缩包索引、密码压缩包或风险检测？升级到 Pro。",
            "archiveContentsTitle": "压缩包内容",
            "archiveContentsSubtitleDefault": "搜索、筛选并提取文件后再解压。",
            "archiveContentsSearchPlaceholder": "按名称、扩展名或文件夹路径搜索...",
            "searchPlaceholderArchive": "搜索名称、扩展名或路径…",
            "archiveFiltersTitle": "筛选",
            "archiveBrowseGroupTitle": "浏览",
            "archiveInspectGroupTitle": "检查",
            "archiveSummaryGroupTitle": "概览",
            "archiveArchivesGroupTitle": "压缩包",
            "archiveAllArchivesTitle": "全部压缩包",
            "archiveContentsInspectorTitle": "检查器",
            "archiveContentsInspectorSubtitle": "查看元数据、安全预览，并只提取你需要的内容。",
            "archiveReadingTitle": "正在读取压缩包内容…",
            "archiveReadingSubtitle": "请稍候，PeekZip 正在索引压缩包。",
            "archiveEmptyArchiveTitle": "这个压缩包是空的。",
            "archiveChooseAnotherArchive": "选择另一个压缩包",
            "archiveNoMatchesTitle": "没有匹配的文件。",
            "archiveNoMatchesSubtitle": "试试其他搜索词或切换筛选器。",
            "archiveNoFileSelectedTitle": "选择一个文件查看详情",
            "archiveNoFileSelectedSubtitle": "提取前查看元数据和快速操作。",
            "archivePreviewImagesText": "预览图片和文本文件",
            "archiveCopyPathsText": "不解压也能复制路径",
            "archiveExtractSelectedText": "仅提取所选项目",
            "archiveNoPreviewTitle": "暂无预览",
            "archiveNoPreviewSubtitle": "选择图片、文本或代码文件即可安全预览。",
            "archiveNoPreviewFolderTitle": "暂无预览",
            "archiveNoPreviewFolderSubtitle": "文件夹没有文件预览。",
            "archiveNoPreviewPdfTitle": "PDF 预览暂不可用。",
            "archiveNoPreviewPdfSubtitle": "选择图片、文本或代码文件即可安全预览。",
            "archiveDropTitle": "将压缩包拖到这里",
            "archiveDropSubtitle": "拖放即可检查压缩包",
            "archiveDropOverlayTitle": "拖放即可检查压缩包",
            "archiveDropOverlaySubtitle": "PeekZip 会读取压缩包索引，不会解压任何内容。",
            "archiveDropOverlayHelp": "拖入压缩包，或选择“打开压缩包”来预览内容。",
            "archiveTableArchive": "压缩包",
            "archiveTableName": "名称",
            "archiveTablePath": "路径",
            "archiveTableSize": "大小",
            "archiveTableModified": "修改时间",
            "archiveTableType": "类型",
            "archiveMetadataTitle": "元数据",
            "archiveLocationTitle": "位置",
            "archiveRiskTitle": "风险",
            "archivePreviewTitle": "预览",
            "archiveQuickActionsTitle": "快速操作",
            "archiveMetadataType": "类型",
            "archiveMetadataSize": "大小",
            "archiveMetadataModified": "修改时间",
            "archiveMetadataCompression": "压缩方式",
            "archiveMetadataCompressedSize": "压缩后大小",
            "archiveMetadataPathInArchive": "压缩包内路径",
            "archiveMetadataArchiveName": "压缩包名称",
            "archiveMetadataParentFolder": "父文件夹",
            "archiveMetadataLevel": "级别",
            "archiveMetadataReason": "原因",
            "archiveMetadataMessage": "说明",
            "archiveActionExtractFolder": "提取文件夹",
            "archiveActionExtractSelected": "提取所选",
            "archiveActionRevealAfterExtract": "提取后显示",
            "archiveActionCopyFileName": "复制文件名",
            "archiveActionCopyPath": "复制路径",
            "archiveActionReloadArchive": "重新加载压缩包",
            "archiveActionActions": "Actions",
            "actionsShort": "操作",
            "archiveActionInspector": "检查器",
            "inspectorShort": "检查器",
            "archiveActionOpenArchive": "打开压缩包",
            "archiveActionExtract": "提取",
            "archiveActionUpgradePro": "升级到 Pro",
            "archiveActionUnlockFullIndex": "解锁完整索引",
            "archiveActionContinueFree": "继续免费版",
            "archiveMenuExtractAll": "提取全部",
            "archiveMenuExtractSelected": "提取所选",
            "archiveMenuRevealAfterExtract": "提取后显示",
            "archiveMenuCopyFileName": "复制文件名",
            "archiveMenuCopyPath": "复制路径",
            "archiveMenuReloadArchive": "重新加载压缩包",
            "archiveMenuSearchMultipleArchives": "搜索多个压缩包…",
            "archiveMenuUpgradeToPro": "升级到 Pro…",
            "archiveMenuSettings": "设置…",
            "menuSectionExtraction": "提取",
            "menuSectionUtilities": "工具",
            "menuSectionProTools": "Pro 功能",
            "menuSectionApp": "应用",
            "archiveMenuExtractAllImages": "提取所有图片",
            "archiveMenuExtractAllPDFs": "提取所有 PDF",
            "archiveMenuExtractAllVideos": "提取所有视频",
            "archiveMenuExtractAllDocuments": "提取所有文档",
            "archiveMenuExtractAllCodeFiles": "提取所有代码文件",
            "archiveMenuExtractCustomTypes": "提取自定义类型…",
            "archiveMenuScanRiskyFiles": "扫描风险文件",
            "archiveShowingResultsFor": "显示 %d 个‘%@’的结果。",
            "archiveShowingOfTotalPrefix": "显示 %d / %d",
            "archiveLargeArchiveDetected": "检测到大型压缩包。免费预览只索引 %d 个文件。",
            "archiveFreePreviewIndexing": "免费预览正在索引 %d 个文件。",
            "archiveSelectedSummary": "已选择 %d 个项目",
            "archiveNoFileSelected": "未选择文件",
            "archiveSelectedItemHint": "选择一个项目查看详情，或使用 Actions 提取文件。",
            "archivePreviewReading": "正在读取预览…",
            "archivePreviewNotAvailable": "暂无预览",
            "archivePreviewNotAvailableFolder": "文件夹没有文件预览。",
            "archivePreviewNotAvailablePdf": "PDF 预览暂不可用。",
            "archiveUnableToReadTitle": "无法读取此压缩包",
            "archiveTryAgain": "重试",
            "archiveSelectItemToInspect": "选择一个文件查看详情",
            "archiveInspectBeforeExtracting": "提取前查看元数据和快速操作。",
            "archiveNoArchiveSelected": "未选择压缩包",
            "filterAllItems": "全部项目",
            "filterFolders": "文件夹",
            "filterImages": "图片",
            "filterDocuments": "文档",
            "filterCode": "代码",
            "filterVideos": "视频",
            "filterArchives": "压缩包",
            "filterLargeFiles": "大文件",
            "filterRecentlyViewed": "最近查看",
            "filterRiskyFiles": "风险文件",
            "filterHiddenJunkFiles": "隐藏和垃圾",
            "metricItems": "项目",
            "metricCode": "代码",
            "metricFolders": "文件夹",
            "metricDocuments": "文档",
            "metricImages": "图片",
            "metricVideos": "视频",
            "metricLarge": "大型",
            "metricRisky": "风险",
            "metricHidden": "隐藏",
            "statusProActive": "PeekZip Pro 已启用",
            "archiveBatchExtractByType": "按类型批量提取",
            "archiveReviewRiskyFiles": "查看风险文件",
            "archiveExtractAnyway": "仍然提取",
            "archiveCancel": "取消",
            "archiveMetricTopLevelOverview": "顶层概览",
            "archiveMetricMostRelevant": "最相关",
            "archiveRiskConfirmationTitle": "此压缩包包含 %d 个风险文件。仍然提取吗？",
            "archiveRiskConfirmationMessage": "取消、查看风险文件，或继续提取。",
            "archiveHiddenBadge": "隐藏",
            "archiveSummaryText": "拖入压缩包，或选择“打开压缩包”来预览内容。",
            "archiveSafetyNothingExtracted": "安全预览中，尚未解压。",
            "archiveToastArchiveEmpty": "这个压缩包是空的。",
            "archiveToastNoArchivesOpened": "没有可打开的压缩包。",
            "archiveSafetyNoRiskyDetected": "预览安全。未检测到风险文件。",
            "archiveSafetyRiskyFound": "预览安全。解压前发现 %d 个风险文件。",
            "archiveFlavorCodeCompact": "代码",
            "archiveFlavorImageCompact": "图片",
            "archiveFlavorDocumentCompact": "文档",
            "archiveFlavorVideoCompact": "视频",
            "archiveFlavorMixedCompact": "混合",
            "archiveFlavorSingleFileCompact": "单文件",
            "archiveArchiveLabel": "压缩包",
            "statFilesCompact": "文件 %d",
            "statFoldersCompact": "文件夹 %d",
            "statSizeUnknown": "未知",
            "archiveTypeMulti": "多压缩包",
            "archiveTypeArchive": "压缩包",
            "archiveTypeUnknown": "未知",
            "archiveToastNoRiskyFiles": "未发现可执行或安装包文件。",
            "archiveToastExtractedSuccessfully": "提取成功",
            "archiveToastExtractionFailed": "提取失败。请尝试其他位置。",
            "archiveToastNoMatchingFiles": "没有匹配的文件。",
            "archiveToastFileNameCopied": "已复制文件名",
            "archiveToastPathCopied": "已复制路径",
            "archiveArchivesOpen": "个压缩包已打开",
            "archiveShowingSuffix": "显示",
            "archiveBatchExtractTitle": "提取%@",
            "archiveBatchExtractCustomTitle": "提取自定义类型",
            "archiveProTag": "Pro",
            "archiveOpenArchivePanelMessage": "选择一个压缩包进行检查。",
            "archiveChooseDestinationFolderMessage": "选择一个目标文件夹。",
            "archiveExtractArchivePrompt": "提取压缩包",
            "archiveExtractSelectedItemPrompt": "提取所选项目",
            "badgeFolder": "文件夹",
            "badgeImage": "图片",
            "badgeDocument": "文档",
            "badgePDF": "PDF",
            "badgeCode": "代码",
            "badgeVideo": "视频",
            "badgeArchive": "压缩包",
            "badgeText": "文本",
            "badgeLarge": "大文件",
            "badgeFile": "文件",
            "badgeApp": "应用",
            "badgeInstaller": "安装包",
            "badgeDiskImage": "磁盘镜像",
            "badgeScript": "脚本",
            "badgeWindows": "Windows",
            "badgePowerShell": "PowerShell",
            "badgeJava": "Java",
            "badgeExec": "可执行",
            "badgeRisky": "风险",
            "badgeConfig": "配置",
            "passwordPromptTitle": "解锁压缩包",
            "passwordPromptMessage": "输入密码以预览并解压此压缩包。",
            "passwordPromptRememberSession": "记住本次会话密码",
            "passwordPromptPasswordPlaceholder": "密码",
            "passwordPromptCancel": "取消",
            "passwordPromptUnlockArchive": "解锁压缩包",
            "batchExtractCustomSubtitle": "输入扩展名并用逗号分隔，例如：pdf, csv, png",
            "batchExtractCustomPlaceholder": "pdf, csv, png",
            "batchExtractCustomCancel": "取消",
            "batchExtractCustomExtract": "提取",
            "settingsGeneralTitle": "通用",
            "settingsLanguageTitle": "语言",
            "settingsLanguageFollowSystem": "跟随系统",
            "settingsRevealAfterExtract": "提取后显示",
            "settingsKeepFolderStructure": "提取所选文件时保留文件夹结构",
            "settingsSkipJunkFilesOnExtract": "提取时跳过垃圾文件",
            "settingsDefaultExtractLocationTitle": "默认提取位置",
            "settingsChooseFolder": "选择文件夹…",
            "settingsUseSystemDefaultLocation": "使用系统默认位置。",
            "settingsProTitle": "Pro",
            "settingsLicenseStatus": "许可证状态",
            "settingsFree": "免费版",
            "settingsProActive": "PeekZip Pro 已启用",
            "settingsUnlockPro": "解锁 Pro",
            "settingsDefaultExtractLocationPanelTitle": "默认提取位置",
            "settingsDefaultExtractLocationPanelMessage": "选择一个用于提取压缩包的默认文件夹。"
        ],
        "zh-Hant": [
            "paywallTitle": "解鎖 PeekZip Pro",
            "paywallSubtitle": "更快查看大型、加密與複雜壓縮檔。",
            "paywallHighlightFullIndex": "解鎖此壓縮檔的完整索引。",
            "paywallHighlightMultiArchive": "一次開啟並搜尋多個壓縮檔。",
            "paywallHighlightPassword": "預覽並解壓密碼保護的壓縮檔。",
            "paywallHighlightBatchExtract": "一鍵擷取所有圖片、PDF、影片或程式碼檔案。",
            "paywallHighlightRiskScanning": "在解壓前偵測可疑可執行檔與腳本。",
            "paywallFeatureFullIndexing": "大型壓縮檔完整索引",
            "paywallFeatureMultiArchiveSearch": "跨多個壓縮檔搜尋",
            "paywallFeaturePasswordSupport": "支援密碼保護壓縮檔",
            "paywallFeatureBatchExtract": "依檔案類型批次擷取",
            "paywallFeatureRiskDetection": "解壓前偵測可疑檔案",
            "paywallLifetimePro": "終身 Pro",
            "paywallLaunchPrice": "首發價格",
            "paywallOneTimePurchase": "一次購買 · 無訂閱",
            "paywallPriceLoading": "載入中…",
            "paywallUnlockPro": "解鎖 Pro",
            "paywallRestorePurchase": "恢復購買",
            "paywallContinueFree": "繼續免費版",
            "paywallUnlocking": "處理中…",
            "paywallRestoring": "恢復中…",
            "paywallClose": "關閉",
            "paywallPurchaseSucceeded": "已解鎖 PeekZip Pro。",
            "paywallPurchasePending": "購買正在等待確認。",
            "paywallRestoreSucceeded": "已恢復購買。",
            "paywallRestoreNothingFound": "找不到可恢復的購買紀錄。",
            "paywallPurchaseUnavailable": "PeekZip Pro 暫時無法使用。",
            "paywallPurchaseFailed": "無法驗證這次購買。",
            "archiveFewItemsHint": "選擇項目查看詳情，或使用 Actions 擷取檔案。",
            "toolbarOpenShort": "開啟",
            "toolbarExtractShort": "擷取",
            "toolbarMoreAccessibility": "更多操作",
            "toolbarUpgradeShort": "Pro",
            "statusReadyShort": "就緒",
            "statusInspectingShort": "預覽中",
            "statusExtractingShort": "擷取中",
            "toolbarNoArchiveOpen": "尚未開啟壓縮檔",
            "toolbarReady": "就緒",
            "toolbarInspecting": "檢查中",
            "toolbarExtracting": "解壓中",
            "toolbarArchiveLoaded": "已載入壓縮檔",
            "toolbarNeedsAttention": "需要處理",
            "archiveEmptyHeroTitle": "解壓前預覽壓縮檔",
            "archiveEmptyHeroSubtitle": "開啟 ZIP、RAR、7z、TAR 等檔案。搜尋、篩選並只擷取需要的內容。",
            "emptyHomeTitle": "解壓前預覽壓縮檔",
            "emptyHomeSubtitle": "開啟 ZIP、RAR、7Z、TAR 等檔案。搜尋、查看並只擷取需要的內容。",
            "emptyPrimaryTitle": "開啟壓縮檔開始預覽",
            "emptyPrimarySubtitle": "選擇一個檔案，或把壓縮檔拖入 PeekZip。",
            "emptyFeaturesTitle": "你可以做什麼",
            "emptyFeatureSearchTitle": "搜尋壓縮檔內容",
            "emptyFeatureSearchSubtitle": "依名稱、擴充名或路徑快速定位檔案",
            "emptyFeatureBrowseTitle": "依檔案類型瀏覽",
            "emptyFeatureBrowseSubtitle": "快速查看圖片、文件、程式碼和影片",
            "emptyFeatureExtractTitle": "只擷取需要的檔案",
            "emptyFeatureExtractSubtitle": "無需完整解壓整個壓縮檔",
            "emptyFormatsTitle": "支援格式",
            "emptySectionRecent": "最近使用",
            "emptySectionSamples": "範例檔案",
            "emptySectionFormats": "支援格式",
            "emptyRecentNone": "暫無最近壓縮檔",
            "emptySamplesHint": "試試內建範例壓縮檔，或從 Finder 開啟檔案。",
            "emptyFeatureSearch": "在壓縮檔內搜尋",
            "emptyFeatureBrowse": "依檔案類型瀏覽",
            "emptyFeatureExtract": "僅擷取需要的檔案",
            "archiveEmptyOpenArchive": "開啟壓縮檔",
            "archiveEmptyTrySampleArchive": "試用範例壓縮檔",
            "archiveEmptySearchInsideArchives": "在壓縮檔內搜尋",
            "archiveEmptyBrowseByFileType": "依檔案類型瀏覽",
            "archiveEmptyExtractSafely": "安全擷取所選檔案",
            "archiveEmptyUpgradePrompt": "需要大型壓縮檔索引、密碼壓縮檔或風險檢測？升級到 Pro。",
            "archiveContentsTitle": "壓縮檔內容",
            "archiveContentsSubtitleDefault": "搜尋、篩選並擷取檔案後再解壓。",
            "archiveContentsSearchPlaceholder": "依名稱、擴充名或資料夾路徑搜尋...",
            "searchPlaceholderArchive": "搜尋名稱、擴充名或路徑…",
            "archiveFiltersTitle": "篩選",
            "archiveBrowseGroupTitle": "瀏覽",
            "archiveInspectGroupTitle": "檢查",
            "archiveSummaryGroupTitle": "概覽",
            "archiveArchivesGroupTitle": "壓縮檔",
            "archiveAllArchivesTitle": "所有壓縮檔",
            "archiveContentsInspectorTitle": "檢查器",
            "archiveContentsInspectorSubtitle": "查看中繼資料、安全預覽，並只擷取你需要的內容。",
            "archiveReadingTitle": "正在讀取壓縮檔內容…",
            "archiveReadingSubtitle": "請稍候，PeekZip 正在索引壓縮檔。",
            "archiveEmptyArchiveTitle": "這個壓縮檔是空的。",
            "archiveChooseAnotherArchive": "選擇另一個壓縮檔",
            "archiveNoMatchesTitle": "沒有符合的檔案。",
            "archiveNoMatchesSubtitle": "試試其他搜尋詞或切換篩選器。",
            "archiveNoFileSelectedTitle": "選擇一個檔案查看詳情",
            "archiveNoFileSelectedSubtitle": "擷取前查看中繼資料和快速操作。",
            "archivePreviewImagesText": "預覽圖片與文字檔",
            "archiveCopyPathsText": "不解壓也能複製路徑",
            "archiveExtractSelectedText": "僅擷取所選項目",
            "archiveNoPreviewTitle": "暫無預覽",
            "archiveNoPreviewSubtitle": "選擇圖片、文字或程式碼檔案即可安全預覽。",
            "archiveNoPreviewFolderTitle": "暫無預覽",
            "archiveNoPreviewFolderSubtitle": "資料夾沒有檔案預覽。",
            "archiveNoPreviewPdfTitle": "PDF 預覽暫不可用。",
            "archiveNoPreviewPdfSubtitle": "選擇圖片、文字或程式碼檔案即可安全預覽。",
            "archiveDropTitle": "將壓縮檔拖到這裡",
            "archiveDropSubtitle": "拖放即可檢查壓縮檔",
            "archiveDropOverlayTitle": "拖放即可檢查壓縮檔",
            "archiveDropOverlaySubtitle": "PeekZip 會讀取壓縮檔索引，不會擷取任何內容。",
            "archiveDropOverlayHelp": "拖入壓縮檔，或選擇「開啟壓縮檔」來預覽內容。",
            "archiveTableArchive": "壓縮檔",
            "archiveTableName": "名稱",
            "archiveTablePath": "路徑",
            "archiveTableSize": "大小",
            "archiveTableModified": "修改時間",
            "archiveTableType": "類型",
            "archiveMetadataTitle": "中繼資料",
            "archiveLocationTitle": "位置",
            "archiveRiskTitle": "風險",
            "archivePreviewTitle": "預覽",
            "archiveQuickActionsTitle": "快速操作",
            "archiveMetadataType": "類型",
            "archiveMetadataSize": "大小",
            "archiveMetadataModified": "修改時間",
            "archiveMetadataCompression": "壓縮方式",
            "archiveMetadataCompressedSize": "壓縮後大小",
            "archiveMetadataPathInArchive": "壓縮檔內路徑",
            "archiveMetadataArchiveName": "壓縮檔名稱",
            "archiveMetadataParentFolder": "父資料夾",
            "archiveMetadataLevel": "級別",
            "archiveMetadataReason": "原因",
            "archiveMetadataMessage": "說明",
            "archiveActionExtractFolder": "擷取資料夾",
            "archiveActionExtractSelected": "擷取所選",
            "archiveActionRevealAfterExtract": "擷取後顯示",
            "archiveActionCopyFileName": "複製檔名",
            "archiveActionCopyPath": "複製路徑",
            "archiveActionReloadArchive": "重新載入壓縮檔",
            "archiveActionActions": "Actions",
            "actionsShort": "操作",
            "archiveActionInspector": "檢查器",
            "inspectorShort": "檢查器",
            "archiveActionOpenArchive": "開啟壓縮檔",
            "archiveActionExtract": "擷取",
            "archiveActionUpgradePro": "升級到 Pro",
            "archiveActionUnlockFullIndex": "解鎖完整索引",
            "archiveActionContinueFree": "繼續免費版",
            "archiveMenuExtractAll": "擷取全部",
            "archiveMenuExtractSelected": "擷取所選",
            "archiveMenuRevealAfterExtract": "擷取後顯示",
            "archiveMenuCopyFileName": "複製檔名",
            "archiveMenuCopyPath": "複製路徑",
            "archiveMenuReloadArchive": "重新載入壓縮檔",
            "archiveMenuSearchMultipleArchives": "搜尋多個壓縮檔…",
            "archiveMenuUpgradeToPro": "升級到 Pro…",
            "archiveMenuSettings": "設定…",
            "menuSectionExtraction": "提取",
            "menuSectionUtilities": "工具",
            "menuSectionProTools": "Pro 功能",
            "menuSectionApp": "應用",
            "archiveMenuExtractAllImages": "擷取所有圖片",
            "archiveMenuExtractAllPDFs": "擷取所有 PDF",
            "archiveMenuExtractAllVideos": "擷取所有影片",
            "archiveMenuExtractAllDocuments": "擷取所有文件",
            "archiveMenuExtractAllCodeFiles": "擷取所有程式碼檔案",
            "archiveMenuExtractCustomTypes": "擷取自訂類型…",
            "archiveMenuScanRiskyFiles": "掃描風險檔案",
            "archiveShowingResultsFor": "顯示 %d 個‘%@’的結果。",
            "archiveShowingOfTotalPrefix": "顯示 %d / %d",
            "archiveLargeArchiveDetected": "偵測到大型壓縮檔。免費預覽只索引 %d 個檔案。",
            "archiveFreePreviewIndexing": "免費預覽正在索引 %d 個檔案。",
            "archiveSelectedSummary": "已選擇 %d 個項目",
            "archiveNoFileSelected": "未選擇檔案",
            "archiveSelectedItemHint": "選擇一個項目查看詳情，或使用 Actions 擷取檔案。",
            "archivePreviewReading": "正在讀取預覽…",
            "archivePreviewNotAvailable": "暫無預覽",
            "archivePreviewNotAvailableFolder": "資料夾沒有檔案預覽。",
            "archivePreviewNotAvailablePdf": "PDF 預覽暫不可用。",
            "archiveUnableToReadTitle": "無法讀取此壓縮檔",
            "archiveTryAgain": "重試",
            "archiveSelectItemToInspect": "選擇一個檔案查看詳情",
            "archiveInspectBeforeExtracting": "擷取前查看中繼資料和快速操作。",
            "archiveNoArchiveSelected": "未選擇壓縮檔",
            "filterAllItems": "全部項目",
            "filterFolders": "資料夾",
            "filterImages": "圖片",
            "filterDocuments": "文件",
            "filterCode": "程式碼",
            "filterVideos": "影片",
            "filterArchives": "壓縮檔",
            "filterLargeFiles": "大型檔案",
            "filterRecentlyViewed": "最近瀏覽",
            "filterRiskyFiles": "風險檔案",
            "filterHiddenJunkFiles": "隱藏與垃圾",
            "metricItems": "項目",
            "metricCode": "程式碼",
            "metricFolders": "資料夾",
            "metricDocuments": "文件",
            "metricImages": "圖片",
            "metricVideos": "影片",
            "metricLarge": "大型",
            "metricRisky": "風險",
            "metricHidden": "隱藏",
            "statusProActive": "PeekZip Pro 已啟用",
            "archiveBatchExtractByType": "依類型批次擷取",
            "archiveReviewRiskyFiles": "檢視風險檔案",
            "archiveExtractAnyway": "仍然擷取",
            "archiveCancel": "取消",
            "archiveMetricTopLevelOverview": "頂層概覽",
            "archiveMetricMostRelevant": "最相關",
            "archiveRiskConfirmationTitle": "此壓縮檔包含 %d 個風險檔案。仍然擷取嗎？",
            "archiveRiskConfirmationMessage": "取消、檢視風險檔案，或繼續擷取。",
            "archiveHiddenBadge": "隱藏",
            "archiveSummaryText": "拖入壓縮檔，或選擇「開啟壓縮檔」來預覽內容。",
            "archiveSafetyNothingExtracted": "安全預覽中，尚未解壓。",
            "archiveToastArchiveEmpty": "這個壓縮檔是空的。",
            "archiveToastNoArchivesOpened": "沒有可開啟的壓縮檔。",
            "archiveSafetyNoRiskyDetected": "預覽安全。未偵測到風險檔案。",
            "archiveSafetyRiskyFound": "預覽安全。擷取前發現 %d 個風險檔案。",
            "archiveFlavorCodeCompact": "程式碼",
            "archiveFlavorImageCompact": "圖片",
            "archiveFlavorDocumentCompact": "文件",
            "archiveFlavorVideoCompact": "影片",
            "archiveFlavorMixedCompact": "混合",
            "archiveFlavorSingleFileCompact": "單檔",
            "archiveArchiveLabel": "壓縮檔",
            "statFilesCompact": "檔案 %d",
            "statFoldersCompact": "資料夾 %d",
            "statSizeUnknown": "未知",
            "archiveTypeMulti": "多個壓縮檔",
            "archiveTypeArchive": "壓縮檔",
            "archiveTypeUnknown": "未知",
            "archiveToastNoRiskyFiles": "未發現可執行或安裝包檔案。",
            "archiveToastExtractedSuccessfully": "擷取成功",
            "archiveToastExtractionFailed": "擷取失敗。請嘗試其他位置。",
            "archiveToastNoMatchingFiles": "沒有符合的檔案。",
            "archiveToastFileNameCopied": "已複製檔名",
            "archiveToastPathCopied": "已複製路徑",
            "archiveArchivesOpen": "個壓縮檔已開啟",
            "archiveShowingSuffix": "顯示",
            "archiveBatchExtractTitle": "擷取%@",
            "archiveBatchExtractCustomTitle": "擷取自訂類型",
            "archiveProTag": "Pro",
            "archiveOpenArchivePanelMessage": "選擇一個壓縮檔進行檢查。",
            "archiveChooseDestinationFolderMessage": "選擇一個目標資料夾。",
            "archiveExtractArchivePrompt": "擷取壓縮檔",
            "archiveExtractSelectedItemPrompt": "擷取所選項目",
            "badgeFolder": "資料夾",
            "badgeImage": "圖片",
            "badgeDocument": "文件",
            "badgePDF": "PDF",
            "badgeCode": "程式碼",
            "badgeVideo": "影片",
            "badgeArchive": "壓縮檔",
            "badgeText": "文字",
            "badgeLarge": "大型檔案",
            "badgeFile": "檔案",
            "badgeApp": "App",
            "badgeInstaller": "安裝包",
            "badgeDiskImage": "磁碟映像",
            "badgeScript": "腳本",
            "badgeWindows": "Windows",
            "badgePowerShell": "PowerShell",
            "badgeJava": "Java",
            "badgeExec": "可執行",
            "badgeRisky": "風險",
            "badgeConfig": "設定",
            "passwordPromptTitle": "解鎖壓縮檔",
            "passwordPromptMessage": "輸入密碼以預覽並解壓此壓縮檔。",
            "passwordPromptRememberSession": "記住本次工作階段密碼",
            "passwordPromptPasswordPlaceholder": "密碼",
            "passwordPromptCancel": "取消",
            "passwordPromptUnlockArchive": "解鎖壓縮檔",
            "batchExtractCustomSubtitle": "輸入副檔名並以逗號分隔，例如：pdf, csv, png",
            "batchExtractCustomPlaceholder": "pdf, csv, png",
            "batchExtractCustomCancel": "取消",
            "batchExtractCustomExtract": "擷取",
            "settingsGeneralTitle": "一般",
            "settingsLanguageTitle": "語言",
            "settingsLanguageFollowSystem": "跟隨系統",
            "settingsRevealAfterExtract": "擷取後顯示",
            "settingsKeepFolderStructure": "擷取所選檔案時保留資料夾結構",
            "settingsSkipJunkFilesOnExtract": "擷取時跳過垃圾檔案",
            "settingsDefaultExtractLocationTitle": "預設擷取位置",
            "settingsChooseFolder": "選擇資料夾…",
            "settingsUseSystemDefaultLocation": "使用系統預設位置。",
            "settingsProTitle": "Pro",
            "settingsLicenseStatus": "授權狀態",
            "settingsFree": "免費版",
            "settingsProActive": "PeekZip Pro 已啟用",
            "settingsUnlockPro": "解鎖 Pro",
            "settingsDefaultExtractLocationPanelTitle": "預設擷取位置",
            "settingsDefaultExtractLocationPanelMessage": "選擇一個用於擷取壓縮檔的預設資料夾。"
        ],
            "ja": [
            "paywallTitle": "PeekZip Pro を解放",
            "paywallSubtitle": "大きく、保護された複雑なアーカイブをすばやく確認。",
            "paywallHighlightFullIndex": "このアーカイブの完全インデックスを有効化。",
            "paywallHighlightMultiArchive": "複数のアーカイブをまとめて開いて検索。",
            "paywallHighlightPassword": "パスワード保護されたアーカイブをプレビュー・展開。",
            "paywallHighlightBatchExtract": "画像、PDF、動画、コードを一括抽出。",
            "paywallHighlightRiskScanning": "展開前に危険な実行ファイルやスクリプトを検出。",
            "paywallFeatureFullIndexing": "大容量アーカイブの完全インデックス",
            "paywallFeatureMultiArchiveSearch": "複数アーカイブを横断検索",
            "paywallFeaturePasswordSupport": "パスワード保護アーカイブ対応",
            "paywallFeatureBatchExtract": "種類別の一括抽出",
            "paywallFeatureRiskDetection": "展開前の危険ファイル検出",
            "paywallLifetimePro": "買い切り Pro",
            "paywallLaunchPrice": "発売価格",
            "paywallOneTimePurchase": "買い切り · サブスクリプションなし",
            "paywallUnlockPro": "Pro を解放",
            "paywallRestorePurchase": "購入を復元",
            "paywallContinueFree": "無料版を続ける",
            "paywallUnlocking": "処理中…",
            "paywallRestoring": "復元中…",
            "paywallClose": "閉じる",
            "archiveFewItemsHint": "項目を選択して詳細を確認するか、Actions で抽出してください。"
        ],
        "ko": [
            "paywallTitle": "PeekZip Pro 잠금 해제",
            "paywallSubtitle": "크고 보호된 복잡한 압축 파일을 더 빠르게 살펴보세요.",
            "paywallHighlightFullIndex": "이 압축 파일의 전체 인덱싱을 잠금 해제합니다.",
            "paywallHighlightMultiArchive": "여러 압축 파일을 한 번에 열고 검색합니다.",
            "paywallHighlightPassword": "암호로 보호된 압축 파일을 미리 보고 추출합니다.",
            "paywallHighlightBatchExtract": "이미지, PDF, 동영상, 코드 파일을 한 번에 추출합니다.",
            "paywallHighlightRiskScanning": "추출 전에 위험한 실행 파일과 스크립트를 감지합니다.",
            "paywallFeatureFullIndexing": "대형 압축 파일 전체 인덱싱",
            "paywallFeatureMultiArchiveSearch": "여러 압축 파일 검색",
            "paywallFeaturePasswordSupport": "암호 보호 압축 파일 지원",
            "paywallFeatureBatchExtract": "파일 형식별 일괄 추출",
            "paywallFeatureRiskDetection": "추출 전 위험 파일 감지",
            "paywallLifetimePro": "평생 Pro",
            "paywallLaunchPrice": "출시 가격",
            "paywallOneTimePurchase": "1회 결제 · 구독 없음",
            "paywallUnlockPro": "Pro 잠금 해제",
            "paywallRestorePurchase": "구매 복원",
            "paywallContinueFree": "무료 버전 계속",
            "paywallUnlocking": "처리 중…",
            "paywallRestoring": "복원 중…",
            "paywallClose": "닫기",
            "archiveFewItemsHint": "항목을 선택해 자세히 보거나 Actions로 추출하세요."
        ],
        "ar": [
            "paywallTitle": "فتح PeekZip Pro",
            "paywallSubtitle": "استعرض الأرشيفات الكبيرة والمحمية والمعقدة بسرعة.",
            "paywallHighlightFullIndex": "افتح الفهرسة الكاملة لهذا الأرشيف.",
            "paywallHighlightMultiArchive": "افتح وابحث عبر عدة أرشيفات دفعة واحدة.",
            "paywallHighlightPassword": "اعرض واستخرج الأرشيفات المحمية بكلمة مرور.",
            "paywallHighlightBatchExtract": "استخرج الصور وملفات PDF والفيديو والبرامج دفعة واحدة.",
            "paywallHighlightRiskScanning": "اكتشف الملفات التنفيذية والبرامج النصية الخطرة قبل الاستخراج.",
            "paywallFeatureFullIndexing": "فهرسة كاملة للأرشيفات الكبيرة",
            "paywallFeatureMultiArchiveSearch": "البحث عبر عدة أرشيفات",
            "paywallFeaturePasswordSupport": "دعم الأرشيفات المحمية بكلمة مرور",
            "paywallFeatureBatchExtract": "استخراج دفعي حسب نوع الملف",
            "paywallFeatureRiskDetection": "اكتشاف الملفات الخطرة قبل الاستخراج",
            "paywallLifetimePro": "Pro مدى الحياة",
            "paywallLaunchPrice": "سعر الإطلاق",
            "paywallOneTimePurchase": "شراء لمرة واحدة · بدون اشتراك",
            "paywallUnlockPro": "فتح Pro",
            "paywallRestorePurchase": "استعادة الشراء",
            "paywallContinueFree": "متابعة المجانية",
            "paywallUnlocking": "جارٍ المعالجة…",
            "paywallRestoring": "جارٍ الاستعادة…",
            "paywallClose": "إغلاق",
            "archiveFewItemsHint": "حدّد عنصرًا لعرض التفاصيل، أو استخدم Actions للاستخراج."
        ],
        "hi": [
            "paywallTitle": "PeekZip Pro अनलॉक करें",
            "paywallSubtitle": "बड़े, सुरक्षित और जटिल आर्काइव को तेज़ी से देखें।",
            "paywallHighlightFullIndex": "इस आर्काइव के लिए पूर्ण इंडेक्सिंग अनलॉक करें।",
            "paywallHighlightMultiArchive": "एक साथ कई आर्काइव खोलें और खोजें।",
            "paywallHighlightPassword": "पासवर्ड-संरक्षित आर्काइव का पूर्वावलोकन और एक्सट्रैक्ट करें।",
            "paywallHighlightBatchExtract": "सभी छवियाँ, PDF, वीडियो या कोड फ़ाइलें एक क्लिक में निकालें।",
            "paywallHighlightRiskScanning": "एक्सट्रैक्ट करने से पहले जोखिमपूर्ण फ़ाइलों का पता लगाएँ।",
            "paywallFeatureFullIndexing": "बड़े आर्काइव के लिए पूर्ण इंडेक्सिंग",
            "paywallFeatureMultiArchiveSearch": "कई आर्काइव में खोज",
            "paywallFeaturePasswordSupport": "पासवर्ड-संरक्षित आर्काइव समर्थन",
            "paywallFeatureBatchExtract": "फ़ाइल प्रकार के अनुसार बैच एक्सट्रैक्ट",
            "paywallFeatureRiskDetection": "एक्सट्रैक्ट से पहले जोखिमपूर्ण फ़ाइल पहचान",
            "paywallLifetimePro": "Lifetime Pro",
            "paywallLaunchPrice": "लॉन्च मूल्य",
            "paywallOneTimePurchase": "एक बार खरीदें · कोई सब्सक्रिप्शन नहीं",
            "paywallUnlockPro": "Pro अनलॉक करें",
            "paywallRestorePurchase": "खरीद पुनर्स्थापित करें",
            "paywallContinueFree": "मुफ़्त संस्करण जारी रखें",
            "paywallUnlocking": "प्रोसेस हो रहा है…",
            "paywallRestoring": "पुनर्स्थापित हो रहा है…",
            "paywallClose": "बंद करें",
            "archiveFewItemsHint": "विवरण देखने के लिए कोई आइटम चुनें, या निकालने के लिए Actions का उपयोग करें।"
        ],
        "id": [
            "paywallTitle": "Buka PeekZip Pro",
            "paywallSubtitle": "Lihat arsip besar, terlindungi, dan kompleks lebih cepat.",
            "paywallHighlightFullIndex": "Buka pengindeksan penuh untuk arsip ini.",
            "paywallHighlightMultiArchive": "Buka dan cari di beberapa arsip sekaligus.",
            "paywallHighlightPassword": "Pratinjau dan ekstrak arsip yang dilindungi kata sandi.",
            "paywallHighlightBatchExtract": "Ekstrak semua gambar, PDF, video, atau file kode dalam satu klik.",
            "paywallHighlightRiskScanning": "Deteksi file eksekusi dan skrip berisiko sebelum ekstraksi.",
            "paywallFeatureFullIndexing": "Pengindeksan penuh untuk arsip besar",
            "paywallFeatureMultiArchiveSearch": "Pencarian lintas beberapa arsip",
            "paywallFeaturePasswordSupport": "Dukungan arsip berpassword",
            "paywallFeatureBatchExtract": "Ekstrak batch berdasarkan jenis file",
            "paywallFeatureRiskDetection": "Deteksi file berisiko sebelum ekstraksi",
            "paywallLifetimePro": "Pro seumur hidup",
            "paywallLaunchPrice": "Harga peluncuran",
            "paywallOneTimePurchase": "Beli sekali · Tanpa langganan",
            "paywallUnlockPro": "Buka Pro",
            "paywallRestorePurchase": "Pulihkan pembelian",
            "paywallContinueFree": "Lanjutkan gratis",
            "paywallUnlocking": "Sedang diproses…",
            "paywallRestoring": "Sedang memulihkan…",
            "paywallClose": "Tutup",
            "archiveFewItemsHint": "Pilih item untuk melihat detail, atau gunakan Actions untuk mengekstrak."
        ],
        "ms": [
            "paywallTitle": "Buka PeekZip Pro",
            "paywallSubtitle": "Periksa arkib besar, dilindungi dan kompleks dengan lebih pantas.",
            "paywallHighlightFullIndex": "Buka pengindeksan penuh untuk arkib ini.",
            "paywallHighlightMultiArchive": "Buka dan cari merentasi beberapa arkib serentak.",
            "paywallHighlightPassword": "Pratonton dan ekstrak arkib yang dilindungi kata laluan.",
            "paywallHighlightBatchExtract": "Ekstrak semua imej, PDF, video atau fail kod sekali tekan.",
            "paywallHighlightRiskScanning": "Kesan fail boleh laksana dan skrip berisiko sebelum ekstrak.",
            "paywallFeatureFullIndexing": "Pengindeksan penuh untuk arkib besar",
            "paywallFeatureMultiArchiveSearch": "Carian merentas beberapa arkib",
            "paywallFeaturePasswordSupport": "Sokongan arkib dilindungi kata laluan",
            "paywallFeatureBatchExtract": "Ekstrak kumpulan mengikut jenis fail",
            "paywallFeatureRiskDetection": "Pengesanan fail berisiko sebelum ekstrak",
            "paywallLifetimePro": "Pro seumur hidup",
            "paywallLaunchPrice": "Harga pelancaran",
            "paywallOneTimePurchase": "Bayar sekali · Tiada langganan",
            "paywallUnlockPro": "Buka Pro",
            "paywallRestorePurchase": "Pulihkan pembelian",
            "paywallContinueFree": "Teruskan percuma",
            "paywallUnlocking": "Sedang diproses…",
            "paywallRestoring": "Sedang dipulihkan…",
            "paywallClose": "Tutup",
            "archiveFewItemsHint": "Pilih item untuk melihat butiran, atau gunakan Actions untuk mengekstrak."
        ],
        "vi": [
            "paywallTitle": "Mở khóa PeekZip Pro",
            "paywallSubtitle": "Xem nhanh các tệp nén lớn, được bảo vệ và phức tạp.",
            "paywallHighlightFullIndex": "Mở khóa lập chỉ mục đầy đủ cho tệp nén này.",
            "paywallHighlightMultiArchive": "Mở và tìm kiếm nhiều tệp nén cùng lúc.",
            "paywallHighlightPassword": "Xem trước và giải nén tệp nén có mật khẩu.",
            "paywallHighlightBatchExtract": "Giải nén tất cả ảnh, PDF, video hoặc mã nguồn chỉ với một lần bấm.",
            "paywallHighlightRiskScanning": "Phát hiện tệp thực thi và script rủi ro trước khi giải nén.",
            "paywallFeatureFullIndexing": "Lập chỉ mục đầy đủ cho tệp nén lớn",
            "paywallFeatureMultiArchiveSearch": "Tìm kiếm trên nhiều tệp nén",
            "paywallFeaturePasswordSupport": "Hỗ trợ tệp nén có mật khẩu",
            "paywallFeatureBatchExtract": "Trích xuất hàng loạt theo loại tệp",
            "paywallFeatureRiskDetection": "Phát hiện tệp rủi ro trước khi giải nén",
            "paywallLifetimePro": "Pro trọn đời",
            "paywallLaunchPrice": "Giá ra mắt",
            "paywallOneTimePurchase": "Thanh toán một lần · Không đăng ký",
            "paywallUnlockPro": "Mở Pro",
            "paywallRestorePurchase": "Khôi phục mua hàng",
            "paywallContinueFree": "Tiếp tục miễn phí",
            "paywallUnlocking": "Đang xử lý…",
            "paywallRestoring": "Đang khôi phục…",
            "paywallClose": "Đóng",
            "archiveFewItemsHint": "Chọn một mục để xem chi tiết, hoặc dùng Actions để trích xuất."
        ],
        "th": [
            "paywallTitle": "ปลดล็อก PeekZip Pro",
            "paywallSubtitle": "ดูไฟล์บีบอัดขนาดใหญ่ ไฟล์ที่ป้องกัน และซับซ้อนได้เร็วขึ้น",
            "paywallHighlightFullIndex": "ปลดล็อกการทำดัชนีเต็มรูปแบบสำหรับไฟล์นี้",
            "paywallHighlightMultiArchive": "เปิดและค้นหาหลายไฟล์บีบอัดพร้อมกัน",
            "paywallHighlightPassword": "ดูตัวอย่างและแตกไฟล์บีบอัดที่ป้องกันด้วยรหัสผ่าน",
            "paywallHighlightBatchExtract": "แตกไฟล์รูปภาพ PDF วิดีโอ หรือโค้ดทั้งหมดได้ในคลิกเดียว",
            "paywallHighlightRiskScanning": "ตรวจหาไฟล์ปฏิบัติการและสคริปต์ที่เสี่ยงก่อนแตกไฟล์",
            "paywallFeatureFullIndexing": "การทำดัชนีเต็มสำหรับไฟล์บีบอัดขนาดใหญ่",
            "paywallFeatureMultiArchiveSearch": "ค้นหาข้ามหลายไฟล์บีบอัด",
            "paywallFeaturePasswordSupport": "รองรับไฟล์บีบอัดที่มีรหัสผ่าน",
            "paywallFeatureBatchExtract": "แตกไฟล์ตามประเภทแบบกลุ่ม",
            "paywallFeatureRiskDetection": "ตรวจหาไฟล์เสี่ยงก่อนแตกไฟล์",
            "paywallLifetimePro": "Pro ตลอดชีพ",
            "paywallLaunchPrice": "ราคาเปิดตัว",
            "paywallOneTimePurchase": "จ่ายครั้งเดียว · ไม่มีค่าสมาชิก",
            "paywallUnlockPro": "ปลดล็อก Pro",
            "paywallRestorePurchase": "กู้คืนการซื้อ",
            "paywallContinueFree": "ใช้เวอร์ชันฟรีต่อ",
            "paywallUnlocking": "กำลังประมวลผล…",
            "paywallRestoring": "กำลังกู้คืน…",
            "paywallClose": "ปิด",
            "archiveFewItemsHint": "เลือกรายการเพื่อดูรายละเอียด หรือใช้ Actions เพื่อแยกไฟล์"
        ],
        "fil": [
            "paywallTitle": "I-unlock ang PeekZip Pro",
            "paywallSubtitle": "Mas mabilis na silipin ang malalaki, protektado, at komplikadong archive.",
            "paywallHighlightFullIndex": "I-unlock ang buong indexing para sa archive na ito.",
            "paywallHighlightMultiArchive": "Buksan at hanapin ang maraming archive nang sabay-sabay.",
            "paywallHighlightPassword": "I-preview at i-extract ang password-protected na archive.",
            "paywallHighlightBatchExtract": "I-extract ang lahat ng larawan, PDF, video, o code sa isang click.",
            "paywallHighlightRiskScanning": "Tuklasin ang mga risky executable at script bago mag-extract.",
            "paywallFeatureFullIndexing": "Buong indexing para sa malalaking archive",
            "paywallFeatureMultiArchiveSearch": "Paghahanap sa maraming archive",
            "paywallFeaturePasswordSupport": "Suporta sa password-protected na archive",
            "paywallFeatureBatchExtract": "Batch extract ayon sa file type",
            "paywallFeatureRiskDetection": "Pagtukoy ng risky file bago mag-extract",
            "paywallLifetimePro": "Lifetime Pro",
            "paywallLaunchPrice": "Launch price",
            "paywallOneTimePurchase": "Isang beses na bayad · Walang subscription",
            "paywallUnlockPro": "I-unlock ang Pro",
            "paywallRestorePurchase": "I-restore ang purchase",
            "paywallContinueFree": "Magpatuloy sa Free",
            "paywallUnlocking": "Pinoproseso…",
            "paywallRestoring": "Nire-restore…",
            "paywallClose": "Isara",
            "archiveFewItemsHint": "Pumili ng item para tingnan ang detalye, o gamitin ang Actions para mag-extract."
        ],
        "bn": [
            "paywallTitle": "PeekZip Pro আনলক করুন",
            "paywallSubtitle": "বড়, সুরক্ষিত এবং জটিল আর্কাইভ দ্রুত দেখুন।",
            "paywallHighlightFullIndex": "এই আর্কাইভের পূর্ণ ইনডেক্সিং আনলক করুন।",
            "paywallHighlightMultiArchive": "একসাথে একাধিক আর্কাইভ খুলুন এবং খুঁজুন।",
            "paywallHighlightPassword": "পাসওয়ার্ড-সুরক্ষিত আর্কাইভ প্রিভিউ ও এক্সট্র্যাক্ট করুন।",
            "paywallHighlightBatchExtract": "ছবি, PDF, ভিডিও বা কোড এক ক্লিকে এক্সট্র্যাক্ট করুন।",
            "paywallHighlightRiskScanning": "এক্সট্র্যাক্টের আগে ঝুঁকিপূর্ণ executable ও স্ক্রিপ্ট শনাক্ত করুন।",
            "paywallFeatureFullIndexing": "বড় আর্কাইভের জন্য সম্পূর্ণ ইনডেক্সিং",
            "paywallFeatureMultiArchiveSearch": "একাধিক আর্কাইভে অনুসন্ধান",
            "paywallFeaturePasswordSupport": "পাসওয়ার্ড-সুরক্ষিত আর্কাইভ সাপোর্ট",
            "paywallFeatureBatchExtract": "ফাইল টাইপ অনুযায়ী ব্যাচ এক্সট্র্যাক্ট",
            "paywallFeatureRiskDetection": "এক্সট্র্যাক্টের আগে ঝুঁকিপূর্ণ ফাইল শনাক্তকরণ",
            "paywallLifetimePro": "লাইফটাইম Pro",
            "paywallLaunchPrice": "প্রারম্ভিক মূল্য",
            "paywallOneTimePurchase": "একবারের ক্রয় · সাবস্ক্রিপশন নেই",
            "paywallUnlockPro": "Pro আনলক করুন",
            "paywallRestorePurchase": "ক্রয় পুনরুদ্ধার",
            "paywallContinueFree": "ফ্রি চালিয়ে যান",
            "paywallUnlocking": "প্রক্রিয়াকরণ চলছে…",
            "paywallRestoring": "পুনরুদ্ধার করা হচ্ছে…",
            "paywallClose": "বন্ধ",
            "archiveFewItemsHint": "বিস্তারিত দেখতে একটি আইটেম নির্বাচন করুন, অথবা বের করতে Actions ব্যবহার করুন।"
        ],
        "ur": [
            "paywallTitle": "PeekZip Pro کھولیں",
            "paywallSubtitle": "بڑے، محفوظ اور پیچیدہ آرکائیوز کو تیزی سے دیکھیں۔",
            "paywallHighlightFullIndex": "اس آرکائیو کے لیے مکمل انڈیکسنگ کھولیں۔",
            "paywallHighlightMultiArchive": "ایک ساتھ متعدد آرکائیوز کھولیں اور تلاش کریں۔",
            "paywallHighlightPassword": "پاس ورڈ سے محفوظ آرکائیوز کا پیش نظارہ اور استخراج کریں۔",
            "paywallHighlightBatchExtract": "تمام تصاویر، PDF، ویڈیو یا کوڈ فائلیں ایک کلک میں نکالیں۔",
            "paywallHighlightRiskScanning": "استخراج سے پہلے خطرناک executable اور scripts کی شناخت کریں۔",
            "paywallFeatureFullIndexing": "بڑے آرکائیوز کے لیے مکمل انڈیکسنگ",
            "paywallFeatureMultiArchiveSearch": "متعدد آرکائیوز میں تلاش",
            "paywallFeaturePasswordSupport": "پاس ورڈ سے محفوظ آرکائیوز کی معاونت",
            "paywallFeatureBatchExtract": "فائل قسم کے مطابق بیچ استخراج",
            "paywallFeatureRiskDetection": "استخراج سے پہلے خطرناک فائلوں کی شناخت",
            "paywallLifetimePro": "لائف ٹائم Pro",
            "paywallLaunchPrice": "آغاز قیمت",
            "paywallOneTimePurchase": "ایک بار خریدیں · کوئی سبسکرپشن نہیں",
            "paywallUnlockPro": "Pro کھولیں",
            "paywallRestorePurchase": "خریداری بحال کریں",
            "paywallContinueFree": "مفت جاری رکھیں",
            "paywallUnlocking": "عمل جاری ہے…",
            "paywallRestoring": "بحال کیا جا رہا ہے…",
            "paywallClose": "بند کریں",
            "archiveFewItemsHint": "تفصیلات دیکھنے کے لیے کوئی آئٹم منتخب کریں، یا نکالنے کے لیے Actions استعمال کریں۔"
        ]
    ]

    private static let extraTranslations: [String: [String: String]] = {
        let en = translations["en"] ?? [:]
        func merged(_ overrides: [String: String]) -> [String: String] {
            en.merging(overrides, uniquingKeysWith: { _, new in new })
        }

        return [
            "de": merged([
                "toolbarOpenShort": "Öffnen",
                "toolbarExtractShort": "Entpacken",
                "toolbarMoreAccessibility": "Weitere Aktionen",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Bereit",
                "statusInspectingShort": "Prüfen",
                "statusExtractingShort": "Entpacken",
                "archiveSummaryText": "Archiv ablegen oder „Archiv öffnen“ wählen, um Inhalte vorzuschauen.",
                "archiveSafetyNothingExtracted": "Sichere Vorschau. Nichts entpackt.",
                "archiveContentsTitle": "Archivinhalt",
                "archiveContentsSubtitleDefault": "Dateien durchsuchen, filtern und extrahieren, bevor entpackt wird.",
                "searchPlaceholderArchive": "Name, Erweiterung oder Pfad suchen…",
                "archiveFiltersTitle": "Filter",
                "archiveBrowseGroupTitle": "Durchsuchen",
                "archiveInspectGroupTitle": "Prüfen",
                "archiveAllArchivesTitle": "Alle Archive",
                "archiveContentsInspectorTitle": "Inspektor",
                "archiveContentsInspectorSubtitle": "Metadaten prüfen, sicher ansehen und nur Gewünschtes extrahieren.",
                "archiveQuickActionsTitle": "Schnellaktionen",
                "archiveActionExtractFolder": "Ordner entpacken",
                "archiveActionExtractSelected": "Auswahl entpacken",
                "archiveActionRevealAfterExtract": "Nach dem Entpacken zeigen",
                "archiveActionCopyFileName": "Dateinamen kopieren",
                "archiveActionCopyPath": "Pfad kopieren",
                "archiveActionActions": "Aktionen",
                "actionsShort": "Aktionen",
                "inspectorShort": "Inspektor",
                "archiveArchiveLabel": "Archiv",
                "statFilesCompact": "Dateien %d",
                "statFoldersCompact": "Ordner %d",
                "archiveFlavorMixedCompact": "Gemischt",
                "archiveFlavorSingleFileCompact": "Einzeldatei",
                "archiveTypeArchive": "Archiv",
                "archiveTypeUnknown": "Unbekannt",
                "archiveToastExtractedSuccessfully": "Erfolgreich extrahiert",
                "archiveToastNoMatchingFiles": "Keine passenden Dateien gefunden.",
                "archiveToastNoRiskyFiles": "Keine ausführbaren oder Installationsdateien gefunden.",
                "paywallTitle": "PeekZip Pro freischalten",
                "paywallSubtitle": "Große, geschützte und komplexe Archive schneller prüfen.",
                "paywallHighlightFullIndex": "Vollständige Indizierung für dieses Archiv freischalten.",
                "paywallHighlightMultiArchive": "Mehrere Archive gleichzeitig öffnen und durchsuchen.",
                "paywallHighlightPassword": "Passwortgeschützte Archive anzeigen und extrahieren.",
                "paywallHighlightBatchExtract": "Bilder, PDFs, Videos oder Code mit einem Klick extrahieren.",
                "paywallHighlightRiskScanning": "Gefährliche ausführbare Dateien und Skripte vor dem Extrahieren erkennen.",
                "paywallFeatureFullIndexing": "Vollständige Indizierung großer Archive",
                "paywallFeatureMultiArchiveSearch": "Mehrere Archive durchsuchen",
                "paywallFeaturePasswordSupport": "Passwortgeschützte Archive",
                "paywallFeatureBatchExtract": "Nach Dateityp stapelweise extrahieren",
                "paywallFeatureRiskDetection": "Risikohinweise vor dem Extrahieren",
                "paywallLifetimePro": "Lifetime Pro",
                "paywallOneTimePurchase": "Einmalzahlung · Kein Abo",
                "paywallLaunchPrice": "Einführungspreis",
                "paywallUnlockPro": "Pro freischalten",
                "paywallRestorePurchase": "Kauf wiederherstellen",
                "paywallContinueFree": "Kostenlos fortfahren",
                "paywallUnlocking": "Wird verarbeitet…",
                "paywallRestoring": "Wird wiederhergestellt…",
                "paywallClose": "Schließen",
                "passwordPromptTitle": "Archiv entsperren",
                "passwordPromptMessage": "Passwort eingeben, um dieses Archiv anzusehen und zu extrahieren.",
                "passwordPromptRememberSession": "Passwort für diese Sitzung merken",
                "passwordPromptPasswordPlaceholder": "Passwort",
                "passwordPromptCancel": "Abbrechen",
                "passwordPromptUnlockArchive": "Archiv entsperren",
                "batchExtractCustomSubtitle": "Endungen durch Kommas getrennt eingeben, z. B. pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Abbrechen",
                "batchExtractCustomExtract": "Extrahieren",
                "settingsGeneralTitle": "Allgemein",
                "settingsRevealAfterExtract": "Nach dem Extrahieren anzeigen",
                "settingsKeepFolderStructure": "Ordnerstruktur beim Extrahieren ausgewählter Dateien beibehalten",
                "settingsSkipJunkFilesOnExtract": "Junk-Dateien beim Extrahieren überspringen",
                "settingsDefaultExtractLocationTitle": "Standard-Extraktionsort",
                "settingsChooseFolder": "Ordner auswählen…",
                "settingsUseSystemDefaultLocation": "Systemstandardort verwenden.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Lizenzstatus",
                "settingsFree": "Kostenlos",
                "settingsProActive": "PeekZip Pro aktiv",
                "settingsUnlockPro": "Pro freischalten",
                "settingsDefaultExtractLocationPanelTitle": "Standard-Extraktionsort",
                "settingsDefaultExtractLocationPanelMessage": "Wähle einen Standardordner für extrahierte Archive.",            ]),
            "es": merged([
                "toolbarOpenShort": "Abrir",
                "toolbarExtractShort": "Extraer",
                "toolbarMoreAccessibility": "Más acciones",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Listo",
                "statusInspectingShort": "Inspeccionando",
                "statusExtractingShort": "Extrayendo",
                "archiveSummaryText": "Suelta un archivo o elige Abrir archivo para previsualizar el contenido.",
                "archiveSafetyNothingExtracted": "Vista segura. Nada extraído.",
                "archiveContentsTitle": "Contenido del archivo",
                "archiveContentsSubtitleDefault": "Busca, filtra y extrae archivos antes de descomprimir.",
                "searchPlaceholderArchive": "Buscar nombre, extensión o ruta…",
                "archiveFiltersTitle": "Filtros",
                "archiveBrowseGroupTitle": "Explorar",
                "archiveInspectGroupTitle": "Inspeccionar",
                "archiveAllArchivesTitle": "Todos los archivos",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "Revisa metadatos, previsualiza con seguridad y extrae solo lo necesario.",
                "archiveQuickActionsTitle": "Acciones rápidas",
                "archiveActionExtractFolder": "Extraer carpeta",
                "archiveActionExtractSelected": "Extraer selección",
                "archiveActionRevealAfterExtract": "Mostrar tras extraer",
                "archiveActionCopyFileName": "Copiar nombre",
                "archiveActionCopyPath": "Copiar ruta",
                "archiveActionActions": "Acciones",
                "actionsShort": "Acciones",
                "inspectorShort": "Inspector",
                "archiveArchiveLabel": "Archivo",
                "statFilesCompact": "%d archivos",
                "statFoldersCompact": "%d carpetas",
                "archiveFlavorMixedCompact": "Mixto",
                "archiveFlavorSingleFileCompact": "Archivo único",
                "archiveTypeArchive": "Archivo",
                "archiveTypeUnknown": "Desconocido",
                "archiveToastExtractedSuccessfully": "Extraído correctamente",
                "archiveToastNoMatchingFiles": "No se encontraron archivos coincidentes.",
                "archiveToastNoRiskyFiles": "No se encontraron ejecutables ni instaladores.",
                "paywallTitle": "Desbloquear PeekZip Pro",
                "paywallSubtitle": "Revisa archivos grandes, protegidos y complejos más rápido.",
                "paywallHighlightFullIndex": "Desbloquea el índice completo de este archivo.",
                "paywallHighlightMultiArchive": "Abre y busca en varios archivos a la vez.",
                "paywallHighlightPassword": "Previsualiza y extrae archivos protegidos con contraseña.",
                "paywallHighlightBatchExtract": "Extrae imágenes, PDF, vídeos o código con un clic.",
                "paywallHighlightRiskScanning": "Detecta ejecutables y scripts antes de extraer.",
                "paywallFeatureFullIndexing": "Indexación completa para archivos grandes",
                "paywallFeatureMultiArchiveSearch": "Buscar en varios archivos",
                "paywallFeaturePasswordSupport": "Archivos protegidos con contraseña",
                "paywallFeatureBatchExtract": "Extracción por tipo de archivo",
                "paywallFeatureRiskDetection": "Avisos de riesgo antes de extraer",
                "paywallLifetimePro": "Pro de por vida",
                "paywallOneTimePurchase": "Pago único · Sin suscripción",
                "paywallLaunchPrice": "Precio de lanzamiento",
                "paywallUnlockPro": "Desbloquear Pro",
                "paywallRestorePurchase": "Restaurar compra",
                "paywallContinueFree": "Continuar gratis",
                "paywallUnlocking": "Procesando…",
                "paywallRestoring": "Restaurando…",
                "paywallClose": "Cerrar",
                "passwordPromptTitle": "Desbloquear archivo",
                "passwordPromptMessage": "Introduce la contraseña para previsualizar y extraer este archivo.",
                "passwordPromptRememberSession": "Recordar contraseña para esta sesión",
                "passwordPromptPasswordPlaceholder": "Contraseña",
                "passwordPromptCancel": "Cancelar",
                "passwordPromptUnlockArchive": "Desbloquear archivo",
                "batchExtractCustomSubtitle": "Escribe extensiones separadas por comas, por ejemplo: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Cancelar",
                "batchExtractCustomExtract": "Extraer",
                "settingsGeneralTitle": "General",
                "settingsRevealAfterExtract": "Mostrar tras extraer",
                "settingsKeepFolderStructure": "Mantener la estructura de carpetas al extraer archivos seleccionados",
                "settingsSkipJunkFilesOnExtract": "Omitir archivos basura al extraer",
                "settingsDefaultExtractLocationTitle": "Ubicación de extracción predeterminada",
                "settingsChooseFolder": "Elegir carpeta…",
                "settingsUseSystemDefaultLocation": "Usar la ubicación predeterminada del sistema.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Estado de licencia",
                "settingsFree": "Gratis",
                "settingsProActive": "PeekZip Pro activo",
                "settingsUnlockPro": "Desbloquear Pro",
                "settingsDefaultExtractLocationPanelTitle": "Ubicación de extracción predeterminada",
                "settingsDefaultExtractLocationPanelMessage": "Elige una carpeta predeterminada para los archivos extraídos.",            ]),
            "fr": merged([
                "toolbarOpenShort": "Ouvrir",
                "toolbarExtractShort": "Extraire",
                "toolbarMoreAccessibility": "Plus d’actions",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Prêt",
                "statusInspectingShort": "Inspection",
                "statusExtractingShort": "Extraction",
                "archiveSummaryText": "Déposez une archive ou choisissez Ouvrir pour prévisualiser le contenu.",
                "archiveSafetyNothingExtracted": "Aperçu sécurisé. Rien n’a été extrait.",
                "archiveContentsTitle": "Contenu de l’archive",
                "archiveContentsSubtitleDefault": "Recherchez, filtrez et extrayez avant décompression.",
                "searchPlaceholderArchive": "Rechercher nom, extension ou chemin…",
                "archiveFiltersTitle": "Filtres",
                "archiveBrowseGroupTitle": "Parcourir",
                "archiveInspectGroupTitle": "Inspecter",
                "archiveAllArchivesTitle": "Toutes les archives",
                "archiveContentsInspectorTitle": "Inspecteur",
                "archiveContentsInspectorSubtitle": "Vérifiez les métadonnées, prévisualisez en toute sécurité et extrayez uniquement ce qu’il faut.",
                "archiveQuickActionsTitle": "Actions rapides",
                "archiveActionExtractFolder": "Extraire le dossier",
                "archiveActionExtractSelected": "Extraire la sélection",
                "archiveActionRevealAfterExtract": "Afficher après extraction",
                "archiveActionCopyFileName": "Copier le nom",
                "archiveActionCopyPath": "Copier le chemin",
                "archiveActionActions": "Actions",
                "actionsShort": "Actions",
                "inspectorShort": "Inspecteur",
                "archiveArchiveLabel": "Archive",
                "statFilesCompact": "%d fichiers",
                "statFoldersCompact": "%d dossiers",
                "archiveFlavorMixedCompact": "Mixte",
                "archiveFlavorSingleFileCompact": "Fichier unique",
                "archiveTypeArchive": "Archive",
                "archiveTypeUnknown": "Inconnu",
                "archiveToastExtractedSuccessfully": "Extraction réussie",
                "archiveToastNoMatchingFiles": "Aucun fichier correspondant.",
                "archiveToastNoRiskyFiles": "Aucun exécutable ni installateur trouvé.",
                "paywallTitle": "Débloquer PeekZip Pro",
                "paywallSubtitle": "Inspectez plus vite les archives volumineuses, protégées et complexes.",
                "paywallHighlightFullIndex": "Débloquer l’indexation complète de cette archive.",
                "paywallHighlightMultiArchive": "Ouvrir et rechercher plusieurs archives à la fois.",
                "paywallHighlightPassword": "Prévisualiser et extraire les archives protégées par mot de passe.",
                "paywallHighlightBatchExtract": "Extraire images, PDF, vidéos ou code en un clic.",
                "paywallHighlightRiskScanning": "Détecter les exécutables et scripts avant l’extraction.",
                "paywallFeatureFullIndexing": "Indexation complète pour les grandes archives",
                "paywallFeatureMultiArchiveSearch": "Recherche dans plusieurs archives",
                "paywallFeaturePasswordSupport": "Archives protégées par mot de passe",
                "paywallFeatureBatchExtract": "Extraction par type de fichier",
                "paywallFeatureRiskDetection": "Avertissements avant extraction",
                "paywallLifetimePro": "Pro à vie",
                "paywallOneTimePurchase": "Paiement unique · Sans abonnement",
                "paywallLaunchPrice": "Prix de lancement",
                "paywallUnlockPro": "Débloquer Pro",
                "paywallRestorePurchase": "Restaurer l’achat",
                "paywallContinueFree": "Continuer gratuitement",
                "paywallUnlocking": "Traitement…",
                "paywallRestoring": "Restauration…",
                "paywallClose": "Fermer",
                "passwordPromptTitle": "Déverrouiller l’archive",
                "passwordPromptMessage": "Saisissez le mot de passe pour prévisualiser et extraire cette archive.",
                "passwordPromptRememberSession": "Mémoriser le mot de passe pour cette session",
                "passwordPromptPasswordPlaceholder": "Mot de passe",
                "passwordPromptCancel": "Annuler",
                "passwordPromptUnlockArchive": "Déverrouiller l’archive",
                "batchExtractCustomSubtitle": "Saisissez des extensions séparées par des virgules, par exemple : pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Annuler",
                "batchExtractCustomExtract": "Extraire",
                "settingsGeneralTitle": "Général",
                "settingsRevealAfterExtract": "Afficher après extraction",
                "settingsKeepFolderStructure": "Conserver la structure des dossiers lors de l’extraction des fichiers sélectionnés",
                "settingsSkipJunkFilesOnExtract": "Ignorer les fichiers inutiles lors de l’extraction",
                "settingsDefaultExtractLocationTitle": "Emplacement d’extraction par défaut",
                "settingsChooseFolder": "Choisir un dossier…",
                "settingsUseSystemDefaultLocation": "Utiliser l’emplacement par défaut du système.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "État de la licence",
                "settingsFree": "Gratuit",
                "settingsProActive": "PeekZip Pro actif",
                "settingsUnlockPro": "Déverrouiller Pro",
                "settingsDefaultExtractLocationPanelTitle": "Emplacement d’extraction par défaut",
                "settingsDefaultExtractLocationPanelMessage": "Choisissez un dossier par défaut pour les archives extraites.",            ]),
            "pt-BR": merged([
                "toolbarOpenShort": "Abrir",
                "toolbarExtractShort": "Extrair",
                "toolbarMoreAccessibility": "Mais ações",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Pronto",
                "statusInspectingShort": "Inspecionando",
                "statusExtractingShort": "Extraindo",
                "archiveSummaryText": "Solte um arquivo ou escolha Abrir arquivo para pré-visualizar o conteúdo.",
                "archiveSafetyNothingExtracted": "Pré-visualização segura. Nada extraído.",
                "archiveContentsTitle": "Conteúdo do arquivo",
                "archiveContentsSubtitleDefault": "Pesquise, filtre e extraia arquivos antes de descompactar.",
                "searchPlaceholderArchive": "Pesquisar nome, extensão ou caminho…",
                "archiveFiltersTitle": "Filtros",
                "archiveBrowseGroupTitle": "Navegar",
                "archiveInspectGroupTitle": "Inspecionar",
                "archiveAllArchivesTitle": "Todos os arquivos",
                "archiveContentsInspectorTitle": "Inspetor",
                "archiveContentsInspectorSubtitle": "Veja metadados, pré-visualize com segurança e extraia só o que precisa.",
                "archiveQuickActionsTitle": "Ações rápidas",
                "archiveActionExtractFolder": "Extrair pasta",
                "archiveActionExtractSelected": "Extrair seleção",
                "archiveActionRevealAfterExtract": "Mostrar após extrair",
                "archiveActionCopyFileName": "Copiar nome",
                "archiveActionCopyPath": "Copiar caminho",
                "archiveActionActions": "Ações",
                "actionsShort": "Ações",
                "inspectorShort": "Inspetor",
                "archiveArchiveLabel": "Arquivo",
                "statFilesCompact": "%d arquivos",
                "statFoldersCompact": "%d pastas",
                "archiveFlavorMixedCompact": "Misto",
                "archiveFlavorSingleFileCompact": "Arquivo único",
                "archiveTypeArchive": "Arquivo",
                "archiveTypeUnknown": "Desconhecido",
                "archiveToastExtractedSuccessfully": "Extraído com sucesso",
                "archiveToastNoMatchingFiles": "Nenhum arquivo correspondente encontrado.",
                "archiveToastNoRiskyFiles": "Nenhum executável ou instalador encontrado.",
                "paywallTitle": "Desbloquear PeekZip Pro",
                "paywallSubtitle": "Inspecione arquivos grandes, protegidos e complexos com mais rapidez.",
                "paywallHighlightFullIndex": "Desbloqueie a indexação completa deste arquivo.",
                "paywallHighlightMultiArchive": "Abra e pesquise vários arquivos ao mesmo tempo.",
                "paywallHighlightPassword": "Pré-visualize e extraia arquivos protegidos por senha.",
                "paywallHighlightBatchExtract": "Extraia imagens, PDFs, vídeos ou código com um clique.",
                "paywallHighlightRiskScanning": "Detecte executáveis e scripts antes de extrair.",
                "paywallFeatureFullIndexing": "Indexação completa para arquivos grandes",
                "paywallFeatureMultiArchiveSearch": "Pesquisar em vários arquivos",
                "paywallFeaturePasswordSupport": "Arquivos protegidos por senha",
                "paywallFeatureBatchExtract": "Extração por tipo de arquivo",
                "paywallFeatureRiskDetection": "Avisos antes de extrair",
                "paywallLifetimePro": "Pro vitalício",
                "paywallOneTimePurchase": "Compra única · Sem assinatura",
                "paywallLaunchPrice": "Preço de lançamento",
                "paywallUnlockPro": "Desbloquear Pro",
                "paywallRestorePurchase": "Restaurar compra",
                "paywallContinueFree": "Continuar grátis",
                "paywallUnlocking": "Processando…",
                "paywallRestoring": "Restaurando…",
                "paywallClose": "Fechar",
                "passwordPromptTitle": "Desbloquear arquivo",
                "passwordPromptMessage": "Digite a senha para pré-visualizar e extrair este arquivo.",
                "passwordPromptRememberSession": "Lembrar senha desta sessão",
                "passwordPromptPasswordPlaceholder": "Senha",
                "passwordPromptCancel": "Cancelar",
                "passwordPromptUnlockArchive": "Desbloquear arquivo",
                "batchExtractCustomSubtitle": "Digite extensões separadas por vírgulas, por exemplo: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Cancelar",
                "batchExtractCustomExtract": "Extrair",
                "settingsGeneralTitle": "Geral",
                "settingsRevealAfterExtract": "Mostrar após extrair",
                "settingsKeepFolderStructure": "Manter a estrutura de pastas ao extrair arquivos selecionados",
                "settingsSkipJunkFilesOnExtract": "Ignorar arquivos inúteis ao extrair",
                "settingsDefaultExtractLocationTitle": "Local padrão de extração",
                "settingsChooseFolder": "Escolher pasta…",
                "settingsUseSystemDefaultLocation": "Usar o local padrão do sistema.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Status da licença",
                "settingsFree": "Grátis",
                "settingsProActive": "PeekZip Pro ativo",
                "settingsUnlockPro": "Desbloquear Pro",
                "settingsDefaultExtractLocationPanelTitle": "Local padrão de extração",
                "settingsDefaultExtractLocationPanelMessage": "Escolha uma pasta padrão para os arquivos extraídos.",            ]),
            "pt-PT": merged([
                "toolbarOpenShort": "Abrir",
                "toolbarExtractShort": "Extrair",
                "toolbarMoreAccessibility": "Mais ações",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Pronto",
                "statusInspectingShort": "A inspecionar",
                "statusExtractingShort": "A extrair",
                "archiveSummaryText": "Largue um arquivo ou escolha Abrir arquivo para pré-visualizar o conteúdo.",
                "archiveSafetyNothingExtracted": "Pré-visualização segura. Nada foi extraído.",
                "archiveContentsTitle": "Conteúdo do arquivo",
                "archiveContentsSubtitleDefault": "Pesquise, filtre e extraia ficheiros antes de descompactar.",
                "searchPlaceholderArchive": "Pesquisar nome, extensão ou caminho…",
                "archiveFiltersTitle": "Filtros",
                "archiveBrowseGroupTitle": "Explorar",
                "archiveInspectGroupTitle": "Inspecionar",
                "archiveAllArchivesTitle": "Todos os arquivos",
                "archiveContentsInspectorTitle": "Inspeção",
                "archiveContentsInspectorSubtitle": "Veja metadados, pré-visualize com segurança e extraia só o que precisa.",
                "archiveQuickActionsTitle": "Ações rápidas",
                "archiveActionExtractFolder": "Extrair pasta",
                "archiveActionExtractSelected": "Extrair seleção",
                "archiveActionRevealAfterExtract": "Mostrar após extrair",
                "archiveActionCopyFileName": "Copiar nome",
                "archiveActionCopyPath": "Copiar caminho",
                "archiveActionActions": "Ações",
                "actionsShort": "Ações",
                "inspectorShort": "Inspeção",
                "archiveArchiveLabel": "Arquivo",
                "statFilesCompact": "%d ficheiros",
                "statFoldersCompact": "%d pastas",
                "archiveFlavorMixedCompact": "Misto",
                "archiveFlavorSingleFileCompact": "Ficheiro único",
                "archiveTypeArchive": "Arquivo",
                "archiveTypeUnknown": "Desconhecido",
                "archiveToastExtractedSuccessfully": "Extraído com sucesso",
                "archiveToastNoMatchingFiles": "Não foram encontrados ficheiros correspondentes.",
                "archiveToastNoRiskyFiles": "Não foram encontrados executáveis ou instaladores.",
                "paywallTitle": "Desbloquear PeekZip Pro",
                "paywallSubtitle": "Inspecione arquivos grandes, protegidos e complexos mais rapidamente.",
                "paywallHighlightFullIndex": "Desbloqueie a indexação completa deste arquivo.",
                "paywallHighlightMultiArchive": "Abra e pesquise vários arquivos ao mesmo tempo.",
                "paywallHighlightPassword": "Pré-visualize e extraia arquivos protegidos por palavra-passe.",
                "paywallHighlightBatchExtract": "Extraia imagens, PDFs, vídeos ou código com um clique.",
                "paywallHighlightRiskScanning": "Detete executáveis e scripts antes de extrair.",
                "paywallFeatureFullIndexing": "Indexação completa para arquivos grandes",
                "paywallFeatureMultiArchiveSearch": "Pesquisar em vários arquivos",
                "paywallFeaturePasswordSupport": "Arquivos protegidos por palavra-passe",
                "paywallFeatureBatchExtract": "Extração por tipo de ficheiro",
                "paywallFeatureRiskDetection": "Avisos antes de extrair",
                "paywallLifetimePro": "Pro vitalício",
                "paywallOneTimePurchase": "Compra única · Sem subscrição",
                "paywallLaunchPrice": "Preço de lançamento",
                "paywallUnlockPro": "Desbloquear Pro",
                "paywallRestorePurchase": "Restaurar compra",
                "paywallContinueFree": "Continuar grátis",
                "paywallUnlocking": "A processar…",
                "paywallRestoring": "A restaurar…",
                "paywallClose": "Fechar",
                "passwordPromptTitle": "Desbloquear arquivo",
                "passwordPromptMessage": "Digite a senha para pré-visualizar e extrair este arquivo.",
                "passwordPromptRememberSession": "Lembrar senha desta sessão",
                "passwordPromptPasswordPlaceholder": "Senha",
                "passwordPromptCancel": "Cancelar",
                "passwordPromptUnlockArchive": "Desbloquear arquivo",
                "batchExtractCustomSubtitle": "Digite extensões separadas por vírgulas, por exemplo: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Cancelar",
                "batchExtractCustomExtract": "Extrair",
                "settingsGeneralTitle": "Geral",
                "settingsRevealAfterExtract": "Mostrar após extrair",
                "settingsKeepFolderStructure": "Manter a estrutura de pastas ao extrair ficheiros selecionados",
                "settingsSkipJunkFilesOnExtract": "Ignorar ficheiros inúteis ao extrair",
                "settingsDefaultExtractLocationTitle": "Local padrão de extração",
                "settingsChooseFolder": "Escolher pasta…",
                "settingsUseSystemDefaultLocation": "Usar o local padrão do sistema.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Estado da licença",
                "settingsFree": "Grátis",
                "settingsProActive": "PeekZip Pro ativo",
                "settingsUnlockPro": "Desbloquear Pro",
                "settingsDefaultExtractLocationPanelTitle": "Local padrão de extração",
                "settingsDefaultExtractLocationPanelMessage": "Escolha uma pasta padrão para os arquivos extraídos.",            ]),
            "ru": merged([
                "toolbarOpenShort": "Открыть",
                "toolbarExtractShort": "Извлечь",
                "toolbarMoreAccessibility": "Ещё действия",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Готово",
                "statusInspectingShort": "Проверка",
                "statusExtractingShort": "Извлечение",
                "archiveSummaryText": "Перетащите архив или выберите «Открыть архив», чтобы просмотреть содержимое.",
                "archiveSafetyNothingExtracted": "Безопасный просмотр. Ничего не извлечено.",
                "archiveContentsTitle": "Содержимое архива",
                "archiveContentsSubtitleDefault": "Ищите, фильтруйте и извлекайте файлы до распаковки.",
                "searchPlaceholderArchive": "Поиск по имени, расширению или пути…",
                "archiveFiltersTitle": "Фильтры",
                "archiveBrowseGroupTitle": "Обзор",
                "archiveInspectGroupTitle": "Проверка",
                "archiveAllArchivesTitle": "Все архивы",
                "archiveContentsInspectorTitle": "Инспектор",
                "archiveContentsInspectorSubtitle": "Смотрите метаданные, безопасно просматривайте и извлекайте только нужное.",
                "archiveQuickActionsTitle": "Быстрые действия",
                "archiveActionExtractFolder": "Извлечь папку",
                "archiveActionExtractSelected": "Извлечь выбранное",
                "archiveActionRevealAfterExtract": "Показать после извлечения",
                "archiveActionCopyFileName": "Копировать имя файла",
                "archiveActionCopyPath": "Копировать путь",
                "archiveActionActions": "Действия",
                "actionsShort": "Действия",
                "inspectorShort": "Инспектор",
                "archiveArchiveLabel": "Архив",
                "statFilesCompact": "%d файлов",
                "statFoldersCompact": "%d папок",
                "archiveFlavorMixedCompact": "Смешанный",
                "archiveFlavorSingleFileCompact": "Одиночный файл",
                "archiveTypeArchive": "Архив",
                "archiveTypeUnknown": "Неизвестно",
                "archiveToastExtractedSuccessfully": "Успешно извлечено",
                "archiveToastNoMatchingFiles": "Совпадающих файлов не найдено.",
                "archiveToastNoRiskyFiles": "Исполняемые файлы и установщики не найдены.",
                "paywallTitle": "Разблокировать PeekZip Pro",
                "paywallSubtitle": "Быстрее просматривайте большие, защищённые и сложные архивы.",
                "paywallHighlightFullIndex": "Разблокировать полный индекс этого архива.",
                "paywallHighlightMultiArchive": "Открывать и искать в нескольких архивах сразу.",
                "paywallHighlightPassword": "Просматривать и извлекать архивы с паролем.",
                "paywallHighlightBatchExtract": "Извлекать изображения, PDF, видео или код одним нажатием.",
                "paywallHighlightRiskScanning": "Обнаруживать рискованные исполняемые файлы и скрипты до извлечения.",
                "paywallFeatureFullIndexing": "Полная индексация больших архивов",
                "paywallFeatureMultiArchiveSearch": "Поиск по нескольким архивам",
                "paywallFeaturePasswordSupport": "Архивы с паролем",
                "paywallFeatureBatchExtract": "Пакетное извлечение по типу файла",
                "paywallFeatureRiskDetection": "Предупреждения о риске перед извлечением",
                "paywallLifetimePro": "Pro навсегда",
                "paywallOneTimePurchase": "Разовая покупка · Без подписки",
                "paywallLaunchPrice": "Стартовая цена",
                "paywallUnlockPro": "Разблокировать Pro",
                "paywallRestorePurchase": "Восстановить покупку",
                "paywallContinueFree": "Продолжить бесплатно",
                "paywallUnlocking": "Обработка…",
                "paywallRestoring": "Восстановление…",
                "paywallClose": "Закрыть",
                "passwordPromptTitle": "Разблокировать архив",
                "passwordPromptMessage": "Введите пароль, чтобы просмотреть и извлечь этот архив.",
                "passwordPromptRememberSession": "Запомнить пароль для этой сессии",
                "passwordPromptPasswordPlaceholder": "Пароль",
                "passwordPromptCancel": "Отмена",
                "passwordPromptUnlockArchive": "Разблокировать архив",
                "batchExtractCustomSubtitle": "Введите расширения через запятую, например: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Отмена",
                "batchExtractCustomExtract": "Извлечь",
                "settingsGeneralTitle": "Основные",
                "settingsRevealAfterExtract": "Показывать после извлечения",
                "settingsKeepFolderStructure": "Сохранять структуру папок при извлечении выбранных файлов",
                "settingsSkipJunkFilesOnExtract": "Пропускать мусорные файлы при извлечении",
                "settingsDefaultExtractLocationTitle": "Папка по умолчанию",
                "settingsChooseFolder": "Выбрать папку…",
                "settingsUseSystemDefaultLocation": "Использовать системную папку по умолчанию.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Статус лицензии",
                "settingsFree": "Бесплатно",
                "settingsProActive": "PeekZip Pro активен",
                "settingsUnlockPro": "Разблокировать Pro",
                "settingsDefaultExtractLocationPanelTitle": "Папка по умолчанию",
                "settingsDefaultExtractLocationPanelMessage": "Выберите папку по умолчанию для извлечённых архивов.",
            ]),
            "tr": merged([
                "toolbarOpenShort": "Aç",
                "toolbarExtractShort": "Çıkar",
                "toolbarMoreAccessibility": "Daha fazla işlem",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Hazır",
                "statusInspectingShort": "İnceleniyor",
                "statusExtractingShort": "Çıkarılıyor",
                "archiveSummaryText": "İçeriği önizlemek için bir arşivi bırakın veya Arşiv Aç’ı seçin.",
                "archiveSafetyNothingExtracted": "Güvenli önizleme. Henüz çıkarılmadı.",
                "archiveContentsTitle": "Arşiv İçeriği",
                "archiveContentsSubtitleDefault": "Çıkarmadan önce dosyaları arayın, filtreleyin ve çıkarın.",
                "searchPlaceholderArchive": "Ad, uzantı veya yol ara…",
                "archiveFiltersTitle": "Filtreler",
                "archiveBrowseGroupTitle": "Gözat",
                "archiveInspectGroupTitle": "İncele",
                "archiveAllArchivesTitle": "Tüm arşivler",
                "archiveContentsInspectorTitle": "Denetçi",
                "archiveContentsInspectorSubtitle": "Meta verileri inceleyin, güvenle önizleyin ve sadece gerekeni çıkarın.",
                "archiveQuickActionsTitle": "Hızlı işlemler",
                "archiveActionExtractFolder": "Klasörü çıkar",
                "archiveActionExtractSelected": "Seçimi çıkar",
                "archiveActionRevealAfterExtract": "Çıkardıktan sonra göster",
                "archiveActionCopyFileName": "Dosya adını kopyala",
                "archiveActionCopyPath": "Yolu kopyala",
                "archiveActionActions": "İşlemler",
                "actionsShort": "İşlemler",
                "inspectorShort": "Denetçi",
                "archiveArchiveLabel": "Arşiv",
                "statFilesCompact": "%d dosya",
                "statFoldersCompact": "%d klasör",
                "archiveFlavorMixedCompact": "Karışık",
                "archiveFlavorSingleFileCompact": "Tek dosya",
                "archiveTypeArchive": "Arşiv",
                "archiveTypeUnknown": "Bilinmiyor",
                "archiveToastExtractedSuccessfully": "Başarıyla çıkarıldı",
                "archiveToastNoMatchingFiles": "Eşleşen dosya bulunamadı.",
                "archiveToastNoRiskyFiles": "Çalıştırılabilir veya yükleyici bulunamadı.",
                "paywallTitle": "PeekZip Pro kilidini aç",
                "paywallSubtitle": "Büyük, korumalı ve karmaşık arşivleri daha hızlı inceleyin.",
                "paywallHighlightFullIndex": "Bu arşiv için tam dizinlemeyi açın.",
                "paywallHighlightMultiArchive": "Birden fazla arşivi aynı anda açıp arayın.",
                "paywallHighlightPassword": "Parolalı arşivleri önizleyin ve çıkarın.",
                "paywallHighlightBatchExtract": "Görselleri, PDF’leri, videoları veya kodu tek tıkla çıkarın.",
                "paywallHighlightRiskScanning": "Çıkarmadan önce riskli çalıştırılabilir dosyaları ve betikleri algılayın.",
                "paywallFeatureFullIndexing": "Büyük arşivler için tam dizinleme",
                "paywallFeatureMultiArchiveSearch": "Birden fazla arşivde arama",
                "paywallFeaturePasswordSupport": "Parolalı arşiv desteği",
                "paywallFeatureBatchExtract": "Dosya türüne göre toplu çıkarma",
                "paywallFeatureRiskDetection": "Çıkarmadan önce risk uyarıları",
                "paywallLifetimePro": "Ömür boyu Pro",
                "paywallOneTimePurchase": "Tek seferlik ödeme · Abonelik yok",
                "paywallLaunchPrice": "Çıkış fiyatı",
                "paywallUnlockPro": "Pro’yu aç",
                "paywallRestorePurchase": "Satın alımı geri yükle",
                "paywallContinueFree": "Ücretsiz devam et",
                "paywallUnlocking": "İşleniyor…",
                "paywallRestoring": "Geri yükleniyor…",
                "paywallClose": "Kapat",
                "passwordPromptTitle": "Arşivin Kilidini Aç",
                "passwordPromptMessage": "Bu arşivi önizlemek ve çıkarmak için parolayı girin.",
                "passwordPromptRememberSession": "Bu oturum için parolayı hatırla",
                "passwordPromptPasswordPlaceholder": "Parola",
                "passwordPromptCancel": "İptal",
                "passwordPromptUnlockArchive": "Arşivin Kilidini Aç",
                "batchExtractCustomSubtitle": "Uzantıları virgülle ayırarak girin, örneğin: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "İptal",
                "batchExtractCustomExtract": "Çıkar",
                "settingsGeneralTitle": "Genel",
                "settingsRevealAfterExtract": "Çıkarma sonrası göster",
                "settingsKeepFolderStructure": "Seçilen dosyaları çıkarırken klasör yapısını koru",
                "settingsSkipJunkFilesOnExtract": "Çıkarırken gereksiz dosyaları atla",
                "settingsDefaultExtractLocationTitle": "Varsayılan çıkarma konumu",
                "settingsChooseFolder": "Klasör seç…",
                "settingsUseSystemDefaultLocation": "Sistem varsayılan konumunu kullan.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Lisans durumu",
                "settingsFree": "Ücretsiz",
                "settingsProActive": "PeekZip Pro etkin",
                "settingsUnlockPro": "Pro kilidini aç",
                "settingsDefaultExtractLocationPanelTitle": "Varsayılan çıkarma konumu",
                "settingsDefaultExtractLocationPanelMessage": "Çıkarılan arşivler için varsayılan bir klasör seçin.",
            ]),
            "it": merged([
                "toolbarOpenShort": "Apri",
                "toolbarExtractShort": "Estrai",
                "toolbarMoreAccessibility": "Altre azioni",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Pronto",
                "statusInspectingShort": "Analisi",
                "statusExtractingShort": "Estrazione",
                "archiveSummaryText": "Rilascia un archivio o scegli Apri archivio per vedere il contenuto.",
                "archiveSafetyNothingExtracted": "Anteprima sicura. Nulla estratto.",
                "archiveContentsTitle": "Contenuto archivio",
                "archiveContentsSubtitleDefault": "Cerca, filtra ed estrai i file prima di decomprimere.",
                "searchPlaceholderArchive": "Cerca nome, estensione o percorso…",
                "archiveFiltersTitle": "Filtri",
                "archiveBrowseGroupTitle": "Sfoglia",
                "archiveInspectGroupTitle": "Ispeziona",
                "archiveAllArchivesTitle": "Tutti gli archivi",
                "archiveContentsInspectorTitle": "Ispettore",
                "archiveContentsInspectorSubtitle": "Controlla i metadati, visualizza in sicurezza ed estrai solo ciò che serve.",
                "archiveQuickActionsTitle": "Azioni rapide",
                "archiveActionExtractFolder": "Estrai cartella",
                "archiveActionExtractSelected": "Estrai selezione",
                "archiveActionRevealAfterExtract": "Mostra dopo l’estrazione",
                "archiveActionCopyFileName": "Copia nome file",
                "archiveActionCopyPath": "Copia percorso",
                "archiveActionActions": "Azioni",
                "actionsShort": "Azioni",
                "inspectorShort": "Ispettore",
                "archiveArchiveLabel": "Archivio",
                "statFilesCompact": "%d file",
                "statFoldersCompact": "%d cartelle",
                "archiveFlavorMixedCompact": "Misto",
                "archiveFlavorSingleFileCompact": "File singolo",
                "archiveTypeArchive": "Archivio",
                "archiveTypeUnknown": "Sconosciuto",
                "archiveToastExtractedSuccessfully": "Estratto con successo",
                "archiveToastNoMatchingFiles": "Nessun file corrispondente trovato.",
                "archiveToastNoRiskyFiles": "Nessun eseguibile o installatore trovato.",
                "paywallTitle": "Sblocca PeekZip Pro",
                "paywallSubtitle": "Esamina più velocemente archivi grandi, protetti e complessi.",
                "paywallHighlightFullIndex": "Sblocca l’indicizzazione completa di questo archivio.",
                "paywallHighlightMultiArchive": "Apri e cerca più archivi contemporaneamente.",
                "paywallHighlightPassword": "Visualizza ed estrai archivi protetti da password.",
                "paywallHighlightBatchExtract": "Estrai immagini, PDF, video o codice con un clic.",
                "paywallHighlightRiskScanning": "Rileva eseguibili e script rischiosi prima dell’estrazione.",
                "paywallFeatureFullIndexing": "Indicizzazione completa per archivi grandi",
                "paywallFeatureMultiArchiveSearch": "Ricerca in più archivi",
                "paywallFeaturePasswordSupport": "Supporto per archivi protetti da password",
                "paywallFeatureBatchExtract": "Estrazione in batch per tipo di file",
                "paywallFeatureRiskDetection": "Avvisi di rischio prima dell’estrazione",
                "paywallLifetimePro": "Pro a vita",
                "paywallOneTimePurchase": "Acquisto una tantum · Nessun abbonamento",
                "paywallLaunchPrice": "Prezzo lancio",
                "paywallUnlockPro": "Sblocca Pro",
                "paywallRestorePurchase": "Ripristina acquisto",
                "paywallContinueFree": "Continua gratis",
                "paywallUnlocking": "Elaborazione…",
                "paywallRestoring": "Ripristino…",
                "paywallClose": "Chiudi",
                "passwordPromptTitle": "Sblocca archivio",
                "passwordPromptMessage": "Inserisci la password per visualizzare ed estrarre questo archivio.",
                "passwordPromptRememberSession": "Ricorda la password per questa sessione",
                "passwordPromptPasswordPlaceholder": "Password",
                "passwordPromptCancel": "Annulla",
                "passwordPromptUnlockArchive": "Sblocca archivio",
                "batchExtractCustomSubtitle": "Inserisci le estensioni separate da virgole, ad esempio: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Annulla",
                "batchExtractCustomExtract": "Estrai",
                "settingsGeneralTitle": "Generale",
                "settingsRevealAfterExtract": "Mostra dopo l’estrazione",
                "settingsKeepFolderStructure": "Mantieni la struttura delle cartelle quando estrai i file selezionati",
                "settingsSkipJunkFilesOnExtract": "Salta i file inutili durante l’estrazione",
                "settingsDefaultExtractLocationTitle": "Percorso predefinito di estrazione",
                "settingsChooseFolder": "Scegli cartella…",
                "settingsUseSystemDefaultLocation": "Usa il percorso predefinito di sistema.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Stato licenza",
                "settingsFree": "Gratis",
                "settingsProActive": "PeekZip Pro attivo",
                "settingsUnlockPro": "Sblocca Pro",
                "settingsDefaultExtractLocationPanelTitle": "Percorso predefinito di estrazione",
                "settingsDefaultExtractLocationPanelMessage": "Scegli una cartella predefinita per gli archivi estratti.",
            ]),
            "nl": merged([
                "toolbarOpenShort": "Openen",
                "toolbarExtractShort": "Uitpakken",
                "toolbarMoreAccessibility": "Meer acties",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Klaar",
                "statusInspectingShort": "Controleren",
                "statusExtractingShort": "Uitpakken",
                "archiveSummaryText": "Sleep een archief of kies Archief openen om de inhoud te bekijken.",
                "archiveSafetyNothingExtracted": "Veilige preview. Niets uitgepakt.",
                "archiveContentsTitle": "Archiefinhoud",
                "archiveContentsSubtitleDefault": "Zoek, filter en extraheer bestanden vóór het uitpakken.",
                "searchPlaceholderArchive": "Zoek naam, extensie of pad…",
                "archiveFiltersTitle": "Filters",
                "archiveBrowseGroupTitle": "Bladeren",
                "archiveInspectGroupTitle": "Inspecteren",
                "archiveAllArchivesTitle": "Alle archieven",
                "archiveContentsInspectorTitle": "Inspector",
                "archiveContentsInspectorSubtitle": "Controleer metadata, bekijk veilig en extraheer alleen wat nodig is.",
                "archiveQuickActionsTitle": "Snelle acties",
                "archiveActionExtractFolder": "Map uitpakken",
                "archiveActionExtractSelected": "Selectie uitpakken",
                "archiveActionRevealAfterExtract": "Tonen na uitpakken",
                "archiveActionCopyFileName": "Bestandsnaam kopiëren",
                "archiveActionCopyPath": "Pad kopiëren",
                "archiveActionActions": "Acties",
                "actionsShort": "Acties",
                "inspectorShort": "Inspector",
                "archiveArchiveLabel": "Archief",
                "statFilesCompact": "%d bestanden",
                "statFoldersCompact": "%d mappen",
                "archiveFlavorMixedCompact": "Gemengd",
                "archiveFlavorSingleFileCompact": "Enkel bestand",
                "archiveTypeArchive": "Archief",
                "archiveTypeUnknown": "Onbekend",
                "archiveToastExtractedSuccessfully": "Succesvol uitgepakt",
                "archiveToastNoMatchingFiles": "Geen overeenkomende bestanden gevonden.",
                "archiveToastNoRiskyFiles": "Geen uitvoerbare of installatief bestanden gevonden.",
                "paywallTitle": "PeekZip Pro ontgrendelen",
                "paywallSubtitle": "Bekijk grote, beveiligde en complexe archieven sneller.",
                "paywallHighlightFullIndex": "Ontgrendel volledige indexering voor dit archief.",
                "paywallHighlightMultiArchive": "Open en doorzoek meerdere archieven tegelijk.",
                "paywallHighlightPassword": "Bekijk en extraheer met wachtwoord beveiligde archieven.",
                "paywallHighlightBatchExtract": "Extraheer afbeeldingen, PDF’s, video’s of code met één klik.",
                "paywallHighlightRiskScanning": "Detecteer riskante uitvoerbare bestanden en scripts vóór het uitpakken.",
                "paywallFeatureFullIndexing": "Volledige indexering voor grote archieven",
                "paywallFeatureMultiArchiveSearch": "Zoeken in meerdere archieven",
                "paywallFeaturePasswordSupport": "Archieven met wachtwoord",
                "paywallFeatureBatchExtract": "Batch-extractie per bestandstype",
                "paywallFeatureRiskDetection": "Risicomeldingen vóór het uitpakken",
                "paywallLifetimePro": "Levenslang Pro",
                "paywallOneTimePurchase": "Eenmalige aankoop · Geen abonnement",
                "paywallLaunchPrice": "Introductieprijs",
                "paywallUnlockPro": "Pro ontgrendelen",
                "paywallRestorePurchase": "Aankoop herstellen",
                "paywallContinueFree": "Gratis doorgaan",
                "paywallUnlocking": "Bezig…",
                "paywallRestoring": "Herstellen…",
                "paywallClose": "Sluiten",
                "passwordPromptTitle": "Archief ontgrendelen",
                "passwordPromptMessage": "Voer het wachtwoord in om dit archief te bekijken en uit te pakken.",
                "passwordPromptRememberSession": "Wachtwoord onthouden voor deze sessie",
                "passwordPromptPasswordPlaceholder": "Wachtwoord",
                "passwordPromptCancel": "Annuleren",
                "passwordPromptUnlockArchive": "Archief ontgrendelen",
                "batchExtractCustomSubtitle": "Voer extensies in, gescheiden door komma’s, bijvoorbeeld: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Annuleren",
                "batchExtractCustomExtract": "Uitpakken",
                "settingsGeneralTitle": "Algemeen",
                "settingsRevealAfterExtract": "Ton​en na uitpakken",
                "settingsKeepFolderStructure": "Mapstructuur behouden bij het uitpakken van geselecteerde bestanden",
                "settingsSkipJunkFilesOnExtract": "Junkbestanden overslaan bij uitpakken",
                "settingsDefaultExtractLocationTitle": "Standaard uitpaklocatie",
                "settingsChooseFolder": "Map kiezen…",
                "settingsUseSystemDefaultLocation": "Systeemstandaardlocatie gebruiken.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Licentiestatus",
                "settingsFree": "Gratis",
                "settingsProActive": "PeekZip Pro actief",
                "settingsUnlockPro": "Pro ontgrendelen",
                "settingsDefaultExtractLocationPanelTitle": "Standaard uitpaklocatie",
                "settingsDefaultExtractLocationPanelMessage": "Kies een standaardmap voor uitgepakte archieven.",
            ]),
            "pl": merged([
                "toolbarOpenShort": "Otwórz",
                "toolbarExtractShort": "Wyodrębnij",
                "toolbarMoreAccessibility": "Więcej akcji",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Gotowe",
                "statusInspectingShort": "Sprawdzanie",
                "statusExtractingShort": "Wyodrębnianie",
                "archiveSummaryText": "Upuść archiwum lub wybierz Otwórz archiwum, aby podejrzeć zawartość.",
                "archiveSafetyNothingExtracted": "Bezpieczny podgląd. Nic nie wyodrębniono.",
                "archiveContentsTitle": "Zawartość archiwum",
                "archiveContentsSubtitleDefault": "Szukaj, filtruj i wyodrębniaj pliki przed rozpakowaniem.",
                "searchPlaceholderArchive": "Szukaj nazwy, rozszerzenia lub ścieżki…",
                "archiveFiltersTitle": "Filtry",
                "archiveBrowseGroupTitle": "Przeglądaj",
                "archiveInspectGroupTitle": "Sprawdź",
                "archiveAllArchivesTitle": "Wszystkie archiwa",
                "archiveContentsInspectorTitle": "Inspektor",
                "archiveContentsInspectorSubtitle": "Sprawdzaj metadane, bezpiecznie podglądaj i wyodrębniaj tylko to, co potrzebne.",
                "archiveQuickActionsTitle": "Szybkie akcje",
                "archiveActionExtractFolder": "Wyodrębnij folder",
                "archiveActionExtractSelected": "Wyodrębnij zaznaczone",
                "archiveActionRevealAfterExtract": "Pokaż po wyodrębnieniu",
                "archiveActionCopyFileName": "Kopiuj nazwę pliku",
                "archiveActionCopyPath": "Kopiuj ścieżkę",
                "archiveActionActions": "Akcje",
                "actionsShort": "Akcje",
                "inspectorShort": "Inspektor",
                "archiveArchiveLabel": "Archiwum",
                "statFilesCompact": "%d plików",
                "statFoldersCompact": "%d folderów",
                "archiveFlavorMixedCompact": "Mieszane",
                "archiveFlavorSingleFileCompact": "Pojedynczy plik",
                "archiveTypeArchive": "Archiwum",
                "archiveTypeUnknown": "Nieznane",
                "archiveToastExtractedSuccessfully": "Wyodrębniono pomyślnie",
                "archiveToastNoMatchingFiles": "Nie znaleziono pasujących plików.",
                "archiveToastNoRiskyFiles": "Nie znaleziono plików wykonywalnych ani instalatorów.",
                "paywallTitle": "Odblokuj PeekZip Pro",
                "paywallSubtitle": "Szybciej sprawdzaj duże, chronione i złożone archiwa.",
                "paywallHighlightFullIndex": "Odblokuj pełne indeksowanie tego archiwum.",
                "paywallHighlightMultiArchive": "Otwieraj i przeszukuj wiele archiwów naraz.",
                "paywallHighlightPassword": "Podglądaj i wyodrębniaj archiwa chronione hasłem.",
                "paywallHighlightBatchExtract": "Wyodrębniaj obrazy, PDF-y, wideo lub kod jednym kliknięciem.",
                "paywallHighlightRiskScanning": "Wykrywaj ryzykowne pliki wykonywalne i skrypty przed wyodrębnianiem.",
                "paywallFeatureFullIndexing": "Pełne indeksowanie dużych archiwów",
                "paywallFeatureMultiArchiveSearch": "Wyszukiwanie w wielu archiwach",
                "paywallFeaturePasswordSupport": "Obsługa archiwów z hasłem",
                "paywallFeatureBatchExtract": "Wyodrębnianie wsadowe według typu",
                "paywallFeatureRiskDetection": "Ostrzeżenia przed wyodrębnianiem",
                "paywallLifetimePro": "Dożywotnie Pro",
                "paywallOneTimePurchase": "Jednorazowy zakup · Bez subskrypcji",
                "paywallLaunchPrice": "Cena startowa",
                "paywallUnlockPro": "Odblokuj Pro",
                "paywallRestorePurchase": "Przywróć zakup",
                "paywallContinueFree": "Kontynuuj za darmo",
                "paywallUnlocking": "Przetwarzanie…",
                "paywallRestoring": "Przywracanie…",
                "paywallClose": "Zamknij",
                "passwordPromptTitle": "Odblokuj archiwum",
                "passwordPromptMessage": "Wpisz hasło, aby podejrzeć i rozpakować to archiwum.",
                "passwordPromptRememberSession": "Zapamiętaj hasło na tę sesję",
                "passwordPromptPasswordPlaceholder": "Hasło",
                "passwordPromptCancel": "Anuluj",
                "passwordPromptUnlockArchive": "Odblokuj archiwum",
                "batchExtractCustomSubtitle": "Wpisz rozszerzenia oddzielone przecinkami, np.: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Anuluj",
                "batchExtractCustomExtract": "Wyodrębnij",
                "settingsGeneralTitle": "Ogólne",
                "settingsRevealAfterExtract": "Pokaż po wyodrębnieniu",
                "settingsKeepFolderStructure": "Zachowaj strukturę folderów przy wyodrębnianiu zaznaczonych plików",
                "settingsSkipJunkFilesOnExtract": "Pomijaj pliki śmieci podczas wyodrębniania",
                "settingsDefaultExtractLocationTitle": "Domyślna lokalizacja wyodrębniania",
                "settingsChooseFolder": "Wybierz folder…",
                "settingsUseSystemDefaultLocation": "Użyj domyślnej lokalizacji systemowej.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Status licencji",
                "settingsFree": "Darmowe",
                "settingsProActive": "PeekZip Pro aktywne",
                "settingsUnlockPro": "Odblokuj Pro",
                "settingsDefaultExtractLocationPanelTitle": "Domyślna lokalizacja wyodrębniania",
                "settingsDefaultExtractLocationPanelMessage": "Wybierz domyślny folder dla wyodrębnionych archiwów.",
            ]),
            "uk": merged([
                "toolbarOpenShort": "Відкрити",
                "toolbarExtractShort": "Витягти",
                "toolbarMoreAccessibility": "Більше дій",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Готово",
                "statusInspectingShort": "Перевірка",
                "statusExtractingShort": "Витягування",
                "archiveSummaryText": "Перетягніть архів або виберіть «Відкрити архів», щоб переглянути вміст.",
                "archiveSafetyNothingExtracted": "Безпечний перегляд. Нічого не витягнуто.",
                "archiveContentsTitle": "Вміст архіву",
                "archiveContentsSubtitleDefault": "Шукайте, фільтруйте та витягуйте файли до розпакування.",
                "searchPlaceholderArchive": "Пошук за назвою, розширенням або шляхом…",
                "archiveFiltersTitle": "Фільтри",
                "archiveBrowseGroupTitle": "Перегляд",
                "archiveInspectGroupTitle": "Перевірка",
                "archiveAllArchivesTitle": "Усі архіви",
                "archiveContentsInspectorTitle": "Інспектор",
                "archiveContentsInspectorSubtitle": "Перевіряйте метадані, безпечно переглядайте та витягуйте лише потрібне.",
                "archiveQuickActionsTitle": "Швидкі дії",
                "archiveActionExtractFolder": "Витягти папку",
                "archiveActionExtractSelected": "Витягти вибране",
                "archiveActionRevealAfterExtract": "Показати після витягування",
                "archiveActionCopyFileName": "Копіювати ім’я файлу",
                "archiveActionCopyPath": "Копіювати шлях",
                "archiveActionActions": "Дії",
                "actionsShort": "Дії",
                "inspectorShort": "Інспектор",
                "archiveArchiveLabel": "Архів",
                "statFilesCompact": "%d файлів",
                "statFoldersCompact": "%d папок",
                "archiveFlavorMixedCompact": "Змішаний",
                "archiveFlavorSingleFileCompact": "Окремий файл",
                "archiveTypeArchive": "Архів",
                "archiveTypeUnknown": "Невідомо",
                "archiveToastExtractedSuccessfully": "Успішно витягнуто",
                "archiveToastNoMatchingFiles": "Відповідних файлів не знайдено.",
                "archiveToastNoRiskyFiles": "Виконуваних файлів або інсталяторів не знайдено.",
                "paywallTitle": "Розблокувати PeekZip Pro",
                "paywallSubtitle": "Швидше переглядайте великі, захищені й складні архіви.",
                "paywallHighlightFullIndex": "Розблокувати повне індексування цього архіву.",
                "paywallHighlightMultiArchive": "Відкривайте й шукайте в кількох архівах одночасно.",
                "paywallHighlightPassword": "Переглядайте та витягуйте архіви з паролем.",
                "paywallHighlightBatchExtract": "Витягуйте зображення, PDF, відео або код одним натисканням.",
                "paywallHighlightRiskScanning": "Виявляйте ризиковані виконувані файли та скрипти перед витягуванням.",
                "paywallFeatureFullIndexing": "Повне індексування великих архівів",
                "paywallFeatureMultiArchiveSearch": "Пошук у кількох архівах",
                "paywallFeaturePasswordSupport": "Архіви з паролем",
                "paywallFeatureBatchExtract": "Пакетне витягування за типом файлу",
                "paywallFeatureRiskDetection": "Попередження перед витягуванням",
                "paywallLifetimePro": "Pro назавжди",
                "paywallOneTimePurchase": "Разова покупка · Без підписки",
                "paywallLaunchPrice": "Стартова ціна",
                "paywallUnlockPro": "Розблокувати Pro",
                "paywallRestorePurchase": "Відновити покупку",
                "paywallContinueFree": "Продовжити безкоштовно",
                "paywallUnlocking": "Обробка…",
                "paywallRestoring": "Відновлення…",
                "paywallClose": "Закрити",
                "passwordPromptTitle": "Розблокувати архів",
                "passwordPromptMessage": "Введіть пароль, щоб переглянути та витягти цей архів.",
                "passwordPromptRememberSession": "Запам’ятати пароль для цієї сесії",
                "passwordPromptPasswordPlaceholder": "Пароль",
                "passwordPromptCancel": "Скасувати",
                "passwordPromptUnlockArchive": "Розблокувати архів",
                "batchExtractCustomSubtitle": "Введіть розширення через кому, наприклад: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Скасувати",
                "batchExtractCustomExtract": "Витягти",
                "settingsGeneralTitle": "Загальні",
                "settingsRevealAfterExtract": "Показувати після витягування",
                "settingsKeepFolderStructure": "Зберігати структуру папок під час витягування вибраних файлів",
                "settingsSkipJunkFilesOnExtract": "Пропускати сміттєві файли під час витягування",
                "settingsDefaultExtractLocationTitle": "Типове розташування витягування",
                "settingsChooseFolder": "Вибрати папку…",
                "settingsUseSystemDefaultLocation": "Використовувати системне типове розташування.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Статус ліцензії",
                "settingsFree": "Безкоштовно",
                "settingsProActive": "PeekZip Pro активний",
                "settingsUnlockPro": "Розблокувати Pro",
                "settingsDefaultExtractLocationPanelTitle": "Типове розташування витягування",
                "settingsDefaultExtractLocationPanelMessage": "Виберіть типову папку для витягнутих архівів.",
            ]),
            "fa": merged([
                "toolbarOpenShort": "باز کردن",
                "toolbarExtractShort": "استخراج",
                "toolbarMoreAccessibility": "اقدامات بیشتر",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "آماده",
                "statusInspectingShort": "در حال بررسی",
                "statusExtractingShort": "در حال استخراج",
                "archiveSummaryText": "یک آرشیو را رها کنید یا «باز کردن آرشیو» را انتخاب کنید تا محتوا را ببینید.",
                "archiveSafetyNothingExtracted": "پیش‌نمایش امن. هنوز چیزی استخراج نشده است.",
                "archiveContentsTitle": "محتوای آرشیو",
                "archiveContentsSubtitleDefault": "پیش از استخراج، فایل‌ها را جست‌وجو، فیلتر و استخراج کنید.",
                "searchPlaceholderArchive": "جست‌وجوی نام، پسوند یا مسیر…",
                "archiveFiltersTitle": "فیلترها",
                "archiveBrowseGroupTitle": "مرور",
                "archiveInspectGroupTitle": "بررسی",
                "archiveAllArchivesTitle": "همه آرشیوها",
                "archiveContentsInspectorTitle": "بازرس",
                "archiveContentsInspectorSubtitle": "فراداده را ببینید، با خیال راحت پیش‌نمایش کنید و فقط موارد لازم را استخراج کنید.",
                "archiveQuickActionsTitle": "اقدام‌های سریع",
                "archiveActionExtractFolder": "استخراج پوشه",
                "archiveActionExtractSelected": "استخراج انتخاب‌شده",
                "archiveActionRevealAfterExtract": "نمایش پس از استخراج",
                "archiveActionCopyFileName": "کپی نام فایل",
                "archiveActionCopyPath": "کپی مسیر",
                "archiveActionActions": "اقدامات",
                "actionsShort": "اقدامات",
                "inspectorShort": "بازرس",
                "archiveArchiveLabel": "آرشیو",
                "statFilesCompact": "%d فایل",
                "statFoldersCompact": "%d پوشه",
                "archiveFlavorMixedCompact": "ترکیبی",
                "archiveFlavorSingleFileCompact": "فایل تکی",
                "archiveTypeArchive": "آرشیو",
                "archiveTypeUnknown": "نامشخص",
                "archiveToastExtractedSuccessfully": "با موفقیت استخراج شد",
                "archiveToastNoMatchingFiles": "فایل مطابقی پیدا نشد.",
                "archiveToastNoRiskyFiles": "فایل اجرایی یا نصب‌کننده‌ای پیدا نشد.",
                "paywallTitle": "باز کردن PeekZip Pro",
                "paywallSubtitle": "آرشیوهای بزرگ، محافظت‌شده و پیچیده را سریع‌تر بررسی کنید.",
                "paywallHighlightFullIndex": "فهرست‌سازی کامل این آرشیو را باز کنید.",
                "paywallHighlightMultiArchive": "چند آرشیو را هم‌زمان باز کنید و جست‌وجو کنید.",
                "paywallHighlightPassword": "آرشیوهای رمزدار را پیش‌نمایش و استخراج کنید.",
                "paywallHighlightBatchExtract": "تصاویر، PDF، ویدئو یا کد را با یک کلیک استخراج کنید.",
                "paywallHighlightRiskScanning": "فایل‌های اجرایی و اسکریپت‌های پرخطر را پیش از استخراج شناسایی کنید.",
                "paywallFeatureFullIndexing": "فهرست‌سازی کامل برای آرشیوهای بزرگ",
                "paywallFeatureMultiArchiveSearch": "جست‌وجو در چند آرشیو",
                "paywallFeaturePasswordSupport": "پشتیبانی از آرشیوهای رمزدار",
                "paywallFeatureBatchExtract": "استخراج گروهی بر اساس نوع فایل",
                "paywallFeatureRiskDetection": "هشدارهای ریسک پیش از استخراج",
                "paywallLifetimePro": "Pro همیشگی",
                "paywallOneTimePurchase": "پرداخت یک‌باره · بدون اشتراک",
                "paywallLaunchPrice": "قیمت آغازین",
                "paywallUnlockPro": "باز کردن Pro",
                "paywallRestorePurchase": "بازیابی خرید",
                "paywallContinueFree": "ادامه نسخه رایگان",
                "paywallUnlocking": "در حال پردازش…",
                "paywallRestoring": "در حال بازیابی…",
                "paywallClose": "بستن",
                "passwordPromptTitle": "باز کردن قفل آرشیو",
                "passwordPromptMessage": "رمز عبور را وارد کنید تا پیش‌نمایش و استخراج این آرشیو انجام شود.",
                "passwordPromptRememberSession": "رمز عبور را برای این جلسه به خاطر بسپار",
                "passwordPromptPasswordPlaceholder": "رمز عبور",
                "passwordPromptCancel": "لغو",
                "passwordPromptUnlockArchive": "باز کردن قفل آرشیو",
                "batchExtractCustomSubtitle": "پسوندها را با ویرگول جدا کنید، مانند: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "لغو",
                "batchExtractCustomExtract": "استخراج",
                "settingsGeneralTitle": "عمومی",
                "settingsRevealAfterExtract": "نمایش پس از استخراج",
                "settingsKeepFolderStructure": "هنگام استخراج فایل‌های انتخاب‌شده، ساختار پوشه‌ها را حفظ کن",
                "settingsSkipJunkFilesOnExtract": "هنگام استخراج، فایل‌های اضافی را رد کن",
                "settingsDefaultExtractLocationTitle": "مکان پیش‌فرض استخراج",
                "settingsChooseFolder": "انتخاب پوشه…",
                "settingsUseSystemDefaultLocation": "از مکان پیش‌فرض سیستم استفاده کن.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "وضعیت مجوز",
                "settingsFree": "رایگان",
                "settingsProActive": "PeekZip Pro فعال است",
                "settingsUnlockPro": "باز کردن قفل Pro",
                "settingsDefaultExtractLocationPanelTitle": "مکان پیش‌فرض استخراج",
                "settingsDefaultExtractLocationPanelMessage": "یک پوشه پیش‌فرض برای آرشیوهای استخراج‌شده انتخاب کنید.",
            ]),
            "sw": merged([
                "toolbarOpenShort": "Fungua",
                "toolbarExtractShort": "Toa",
                "toolbarMoreAccessibility": "Vitendo zaidi",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "Tayari",
                "statusInspectingShort": "Inakaguliwa",
                "statusExtractingShort": "Inatoa",
                "archiveSummaryText": "Dondosha kumbukumbu au chagua Fungua kumbukumbu kuona yaliyomo.",
                "archiveSafetyNothingExtracted": "Hakiki salama. Hakuna kilichotolewa.",
                "archiveContentsTitle": "Yaliyomo ya kumbukumbu",
                "archiveContentsSubtitleDefault": "Tafuta, chuja na toa faili kabla ya kufungua.",
                "searchPlaceholderArchive": "Tafuta jina, kiendelezi au njia…",
                "archiveFiltersTitle": "Vichujio",
                "archiveBrowseGroupTitle": "Vinjari",
                "archiveInspectGroupTitle": "Kagua",
                "archiveAllArchivesTitle": "Kumbukumbu zote",
                "archiveContentsInspectorTitle": "Kichunguzi",
                "archiveContentsInspectorSubtitle": "Kagua metadata, hakiki salama na toa unachohitaji tu.",
                "archiveQuickActionsTitle": "Vitendo vya haraka",
                "archiveActionExtractFolder": "Toa folda",
                "archiveActionExtractSelected": "Toa vilivyochaguliwa",
                "archiveActionRevealAfterExtract": "Onyesha baada ya kutoa",
                "archiveActionCopyFileName": "Nakili jina la faili",
                "archiveActionCopyPath": "Nakili njia",
                "archiveActionActions": "Vitendo",
                "actionsShort": "Vitendo",
                "inspectorShort": "Kichunguzi",
                "archiveArchiveLabel": "Kumbukumbu",
                "statFilesCompact": "%d faili",
                "statFoldersCompact": "%d folda",
                "archiveFlavorMixedCompact": "Mchanganyiko",
                "archiveFlavorSingleFileCompact": "Faili moja",
                "archiveTypeArchive": "Kumbukumbu",
                "archiveTypeUnknown": "Haijulikani",
                "archiveToastExtractedSuccessfully": "Imetolewa kwa mafanikio",
                "archiveToastNoMatchingFiles": "Hakuna faili zinazolingana zilizopatikana.",
                "archiveToastNoRiskyFiles": "Hakuna faili zinazotekelezeka au visakinishi vilivyopatikana.",
                "paywallTitle": "Fungua PeekZip Pro",
                "paywallSubtitle": "Kagua kumbukumbu kubwa, zilizolindwa na changamano kwa haraka zaidi.",
                "paywallHighlightFullIndex": "Fungua upangaji kamili wa kumbukumbu hii.",
                "paywallHighlightMultiArchive": "Fungua na utafute kwenye kumbukumbu nyingi kwa pamoja.",
                "paywallHighlightPassword": "Hakikisha na toa kumbukumbu zenye nenosiri.",
                "paywallHighlightBatchExtract": "Toa picha, PDF, video au msimbo kwa kubofya mara moja.",
                "paywallHighlightRiskScanning": "Gundua faili hatarishi zinazotekelezeka na hati kabla ya kutoa.",
                "paywallFeatureFullIndexing": "Upangaji kamili kwa kumbukumbu kubwa",
                "paywallFeatureMultiArchiveSearch": "Utafutaji kwenye kumbukumbu nyingi",
                "paywallFeaturePasswordSupport": "Msaada wa kumbukumbu zenye nenosiri",
                "paywallFeatureBatchExtract": "Uondoaji wa kundi kwa aina ya faili",
                "paywallFeatureRiskDetection": "Onyo la hatari kabla ya kutoa",
                "paywallLifetimePro": "Pro ya maisha",
                "paywallOneTimePurchase": "Malipo mara moja · Hakuna usajili",
                "paywallLaunchPrice": "Bei ya uzinduzi",
                "paywallUnlockPro": "Fungua Pro",
                "paywallRestorePurchase": "Rejesha ununuzi",
                "paywallContinueFree": "Endelea bure",
                "paywallUnlocking": "Inachakata…",
                "paywallRestoring": "Inarejesha…",
                "paywallClose": "Funga",
                "passwordPromptTitle": "Fungua kumbukumbu",
                "passwordPromptMessage": "Weka nenosiri ili kuona na kutoa kumbukumbu hii.",
                "passwordPromptRememberSession": "Kumbuka nenosiri kwa kipindi hiki",
                "passwordPromptPasswordPlaceholder": "Nenosiri",
                "passwordPromptCancel": "Ghairi",
                "passwordPromptUnlockArchive": "Fungua kumbukumbu",
                "batchExtractCustomSubtitle": "Weka viendelezi vikitenganishwa kwa koma, kwa mfano: pdf, csv, png",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "Ghairi",
                "batchExtractCustomExtract": "Toa",
                "settingsGeneralTitle": "Jumla",
                "settingsRevealAfterExtract": "Onyesha baada ya kutoa",
                "settingsKeepFolderStructure": "Hifadhi muundo wa folda unapotua faili zilizochaguliwa",
                "settingsSkipJunkFilesOnExtract": "Ruka faili taka unapotua",
                "settingsDefaultExtractLocationTitle": "Mahali pa msingi pa kutoa",
                "settingsChooseFolder": "Chagua folda…",
                "settingsUseSystemDefaultLocation": "Tumia mahali pa msingi pa mfumo.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "Hali ya leseni",
                "settingsFree": "Bure",
                "settingsProActive": "PeekZip Pro imewashwa",
                "settingsUnlockPro": "Fungua Pro",
                "settingsDefaultExtractLocationPanelTitle": "Mahali pa msingi pa kutoa",
                "settingsDefaultExtractLocationPanelMessage": "Chagua folda ya msingi kwa kumbukumbu zilizoondolewa.",
            ]),
            "ta": merged([
                "toolbarOpenShort": "திற",
                "toolbarExtractShort": "பிரித்தெடு",
                "toolbarMoreAccessibility": "மேலும் செயல்கள்",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "தயார்",
                "statusInspectingShort": "ஆய்வு",
                "statusExtractingShort": "பிரித்தெடுப்பு",
                "archiveSummaryText": "உள்ளடக்கத்தைப் பார்க்க ஒரு காப்பகத்தை விடுங்கள் அல்லது காப்பகத்தைத் திற என்பதைத் தேர்ந்தெடுக்கவும்.",
                "archiveSafetyNothingExtracted": "பாதுகாப்பான முன்னோட்டம். இன்னும் எதுவும் பிரித்தெடுக்கப்படவில்லை.",
                "archiveContentsTitle": "காப்பக உள்ளடக்கம்",
                "archiveContentsSubtitleDefault": "பிரித்தெடுப்பதற்கு முன் கோப்புகளைத் தேடி, வடிகட்டி, எடுத்தெடுக்கவும்.",
                "searchPlaceholderArchive": "பெயர், நீட்டிப்பு அல்லது பாதை தேடு…",
                "archiveFiltersTitle": "வடிகட்டிகள்",
                "archiveBrowseGroupTitle": "உலாவு",
                "archiveInspectGroupTitle": "ஆய்வு",
                "archiveAllArchivesTitle": "அனைத்து காப்பகங்கள்",
                "archiveContentsInspectorTitle": "ஆய்வி",
                "archiveContentsInspectorSubtitle": "மேடாடட்டாவைச் சரிபார்த்து, பாதுகாப்பாக முன்னோட்டம் காணவும் மற்றும் தேவையானவற்றை மட்டும் பிரித்தெடுக்கவும்.",
                "archiveQuickActionsTitle": "விரைவு செயல்கள்",
                "archiveActionExtractFolder": "கோப்புறை பிரித்தெடு",
                "archiveActionExtractSelected": "தேர்ந்தெடுத்ததை பிரித்தெடு",
                "archiveActionRevealAfterExtract": "பிரித்தெடுத்த பின் காட்டு",
                "archiveActionCopyFileName": "கோப்பு பெயரை நகலெடு",
                "archiveActionCopyPath": "பாதையை நகலெடு",
                "archiveActionActions": "செயல்கள்",
                "actionsShort": "செயல்கள்",
                "inspectorShort": "ஆய்வி",
                "archiveArchiveLabel": "காப்பகம்",
                "statFilesCompact": "%d கோப்புகள்",
                "statFoldersCompact": "%d கோப்புறைகள்",
                "archiveFlavorMixedCompact": "கலவை",
                "archiveFlavorSingleFileCompact": "ஒற்றை கோப்பு",
                "archiveTypeArchive": "காப்பகம்",
                "archiveTypeUnknown": "தெரியாது",
                "archiveToastExtractedSuccessfully": "வெற்றிகரமாக பிரித்தெடுக்கப்பட்டது",
                "archiveToastNoMatchingFiles": "பொருந்தும் கோப்புகள் எதுவும் இல்லை.",
                "archiveToastNoRiskyFiles": "இயக்கக்கூடிய அல்லது நிறுவுபவர் கோப்புகள் எதுவும் இல்லை.",
                "paywallTitle": "PeekZip Pro ஐ திறக்கவும்",
                "paywallSubtitle": "பெரிய, பாதுகாக்கப்பட்ட மற்றும் சிக்கலான காப்பகங்களை வேகமாகப் பாருங்கள்.",
                "paywallHighlightFullIndex": "இந்த காப்பகத்தின் முழு குறியீட்டையும் திறக்கவும்.",
                "paywallHighlightMultiArchive": "பல காப்பகங்களை ஒன்றாகத் திறந்து தேடவும்.",
                "paywallHighlightPassword": "கடவுச்சொல் பாதுகாக்கப்பட்ட காப்பகங்களை முன்னோட்டம் காணவும் மற்றும் பிரித்தெடுக்கவும்.",
                "paywallHighlightBatchExtract": "படங்கள், PDF, வீடியோ அல்லது குறியீட்டை ஒரே கிளிக்கில் பிரித்தெடுக்கவும்.",
                "paywallHighlightRiskScanning": "பிரித்தெடுக்கும் முன் ஆபத்தான இயக்கக்கூடிய கோப்புகள் மற்றும் ஸ்கிரிப்ட்களை கண்டறியவும்.",
                "paywallFeatureFullIndexing": "பெரிய காப்பகங்களுக்கு முழு குறியீட்டாக்கம்",
                "paywallFeatureMultiArchiveSearch": "பல காப்பகங்களில் தேடல்",
                "paywallFeaturePasswordSupport": "கடவுச்சொல் பாதுகாக்கப்பட்ட காப்பக ஆதரவு",
                "paywallFeatureBatchExtract": "கோப்பு வகைப்படி தொகுதி பிரித்தெடுப்பு",
                "paywallFeatureRiskDetection": "பிரித்தெடுக்கும் முன் ஆபத்து அறிவிப்புகள்",
                "paywallLifetimePro": "வாழ்நாள் Pro",
                "paywallOneTimePurchase": "ஒருமுறை கட்டணம் · சந்தா இல்லை",
                "paywallLaunchPrice": "தொடக்க விலை",
                "paywallUnlockPro": "Pro ஐ திறக்கவும்",
                "paywallRestorePurchase": "வாங்குதலை மீட்டமை",
                "paywallContinueFree": "இலவசமாகத் தொடரவும்",
                "paywallUnlocking": "செயலாக்கப்படுகிறது…",
                "paywallRestoring": "மீட்டமைக்கப்படுகிறது…",
                "paywallClose": "மூடு",
                "passwordPromptTitle": "காப்பகத்தை திற",
                "passwordPromptMessage": "இந்த காப்பகத்தை முன்னோட்டம் காணவும் பிரித்தெடுக்கவும் கடவுச்சொல்லை உள்ளிடவும்.",
                "passwordPromptRememberSession": "இந்த அமர்வுக்கு கடவுச்சொல்லை நினைவில் கொள்",
                "passwordPromptPasswordPlaceholder": "கடவுச்சொல்",
                "passwordPromptCancel": "ரத்து",
                "passwordPromptUnlockArchive": "காப்பகத்தை திற",
                "batchExtractCustomSubtitle": "pdf, csv, png போன்ற நீட்டிப்புகளை கமாவால் பிரித்து உள்ளிடவும்",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "ரத்து",
                "batchExtractCustomExtract": "பிரித்தெடு",
                "settingsGeneralTitle": "பொது",
                "settingsRevealAfterExtract": "பிரித்தெடுத்த பின் காட்டு",
                "settingsKeepFolderStructure": "தேர்ந்தெடுத்த கோப்புகளை பிரித்தெடுக்கும்போது கோப்புறை அமைப்பை வைத்திரு",
                "settingsSkipJunkFilesOnExtract": "பிரித்தெடுக்கும்போது குப்பை கோப்புகளை தவிர்",
                "settingsDefaultExtractLocationTitle": "இயல்புநிலை பிரித்தெடுக்கும் இடம்",
                "settingsChooseFolder": "கோப்புறையைத் தேர்ந்தெடு…",
                "settingsUseSystemDefaultLocation": "கணினியின் இயல்புநிலை இடத்தைப் பயன்படுத்து.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "உரிம நிலை",
                "settingsFree": "இலவசம்",
                "settingsProActive": "PeekZip Pro செயல்படுத்தப்பட்டது",
                "settingsUnlockPro": "Pro ஐ திற",
                "settingsDefaultExtractLocationPanelTitle": "இயல்புநிலை பிரித்தெடுக்கும் இடம்",
                "settingsDefaultExtractLocationPanelMessage": "பிரித்தெடுக்கப்பட்ட காப்பகங்களுக்கு ஒரு இயல்புநிலை கோப்புறையைத் தேர்ந்தெடுக்கவும்.",
            ]),
            "te": merged([
                "toolbarOpenShort": "తెరువు",
                "toolbarExtractShort": "వెలికి తీయి",
                "toolbarMoreAccessibility": "ఇంకా చర్యలు",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "సిద్ధం",
                "statusInspectingShort": "పరిశీలిస్తోంది",
                "statusExtractingShort": "వెలికి తీస్తోంది",
                "archiveSummaryText": "విషయాన్ని చూడటానికి ఒక ఆర్కైవ్‌ను వదలండి లేదా ఆర్కైవ్ తెరవండి.",
                "archiveSafetyNothingExtracted": "సురక్షిత ముందుచూపు. ఇంకా ఏమీ వెలికి తీయలేదు.",
                "archiveContentsTitle": "ఆర్కైవ్ విషయాలు",
                "archiveContentsSubtitleDefault": "వెలికి తీయడానికి ముందు ఫైళ్లను శోధించండి, ఫిల్టర్ చేయండి, వెలికి తీయండి.",
                "searchPlaceholderArchive": "పేరు, పొడిగింపు లేదా మార్గం వెతకండి…",
                "archiveFiltersTitle": "ఫిల్టర్లు",
                "archiveBrowseGroupTitle": "బ్రౌజ్",
                "archiveInspectGroupTitle": "పరిశీలన",
                "archiveAllArchivesTitle": "అన్ని ఆర్కైవ్‌లు",
                "archiveContentsInspectorTitle": "ఇన్స్పెక్టర్",
                "archiveContentsInspectorSubtitle": "మెటాడేటాను చూడండి, సురక్షితంగా ముందుచూపు చూడండి, కావలసినదాన్ని మాత్రమే వెలికి తీయండి.",
                "archiveQuickActionsTitle": "త్వరిత చర్యలు",
                "archiveActionExtractFolder": "ఫోల్డర్ వెలికి తీయి",
                "archiveActionExtractSelected": "ఎంచుకున్నవి వెలికి తీయి",
                "archiveActionRevealAfterExtract": "వెలికి తీయిన తర్వాత చూపించు",
                "archiveActionCopyFileName": "ఫైల్ పేరు కాపీ చేయి",
                "archiveActionCopyPath": "మార్గం కాపీ చేయి",
                "archiveActionActions": "చర్యలు",
                "actionsShort": "చర్యలు",
                "inspectorShort": "ఇన్స్పెక్టర్",
                "archiveArchiveLabel": "ఆర్కైవ్",
                "statFilesCompact": "%d ఫైళ్లు",
                "statFoldersCompact": "%d ఫోల్డర్లు",
                "archiveFlavorMixedCompact": "మిశ్రమం",
                "archiveFlavorSingleFileCompact": "ఒకే ఫైల్",
                "archiveTypeArchive": "ఆర్కైవ్",
                "archiveTypeUnknown": "తెలియదు",
                "archiveToastExtractedSuccessfully": "వెలికి తీయడం విజయవంతం",
                "archiveToastNoMatchingFiles": "సరిపోయే ఫైళ్లు లేవు.",
                "archiveToastNoRiskyFiles": "ఎగ్జిక్యూటబుల్ లేదా ఇన్‌స్టాలర్ ఫైళ్లు లేవు.",
                "paywallTitle": "PeekZip Pro ను అన్లాక్ చేయండి",
                "paywallSubtitle": "పెద్ద, రక్షిత మరియు సంక్లిష్ట ఆర్కైవ్‌లను వేగంగా చూడండి.",
                "paywallHighlightFullIndex": "ఈ ఆర్కైవ్‌కు పూర్తి ఇండెక్సింగ్‌ను అన్లాక్ చేయండి.",
                "paywallHighlightMultiArchive": "ఒకేసారి అనేక ఆర్కైవ్‌లను తెరవండి మరియు శోధించండి.",
                "paywallHighlightPassword": "పాస్‌వర్డ్-రక్షిత ఆర్కైవ్‌లను ముందుచూపు చేసి వెలికి తీయండి.",
                "paywallHighlightBatchExtract": "చిత్రాలు, PDF, వీడియో లేదా కోడ్‌ను ఒక్క క్లిక్‌లో వెలికి తీయండి.",
                "paywallHighlightRiskScanning": "వెలికి తీయడానికి ముందు ప్రమాదకర executableలు మరియు scripts‌ను గుర్తించండి.",
                "paywallFeatureFullIndexing": "పెద్ద ఆర్కైవ్‌లకు పూర్తి ఇండెక్సింగ్",
                "paywallFeatureMultiArchiveSearch": "అనేక ఆర్కైవ్‌లలో శోధన",
                "paywallFeaturePasswordSupport": "పాస్‌వర్డ్-రక్షిత ఆర్కైవ్ మద్దతు",
                "paywallFeatureBatchExtract": "ఫైల్ రకం ప్రకారం బ్యాచ్ ఎక్స్‌ట్రాక్ట్",
                "paywallFeatureRiskDetection": "వెలికి తీయడానికి ముందు రిస్క్ హెచ్చరికలు",
                "paywallLifetimePro": "జీవితకాల Pro",
                "paywallOneTimePurchase": "ఒకసారి కొనుగోలు · సబ్‌స్క్రిప్షన్ లేదు",
                "paywallLaunchPrice": "ప్రారంభ ధర",
                "paywallUnlockPro": "Pro అన్లాక్ చేయండి",
                "paywallRestorePurchase": "కొనుగోలు పునరుద్ధరించండి",
                "paywallContinueFree": "ఉచితంగా కొనసాగండి",
                "paywallUnlocking": "ప్రాసెస్ అవుతోంది…",
                "paywallRestoring": "పునరుద్ధరిస్తోంది…",
                "paywallClose": "మూసివేయి",
                "passwordPromptTitle": "ఆర్కైవ్‌ను అన్‌లాక్ చేయి",
                "passwordPromptMessage": "ఈ ఆర్కైవ్‌ను ప్రీవ్యూ చేసి వెలికి తీయడానికి పాస్‌వర్డ్‌ను నమోదు చేయండి.",
                "passwordPromptRememberSession": "ఈ సెషన్ కోసం పాస్‌వర్డ్‌ను గుర్తుంచుకో",
                "passwordPromptPasswordPlaceholder": "పాస్‌వర్డ్",
                "passwordPromptCancel": "రద్దు",
                "passwordPromptUnlockArchive": "ఆర్కైవ్‌ను అన్‌లాక్ చేయి",
                "batchExtractCustomSubtitle": "pdf, csv, png లాంటి ఎక్స్‌టెన్షన్‌లను కామాలతో వేరు చేసి నమోదు చేయండి",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "రద్దు",
                "batchExtractCustomExtract": "వెలికి తీయి",
                "settingsGeneralTitle": "సాధారణ",
                "settingsRevealAfterExtract": "వెలికి తీయిన తర్వాత చూపించు",
                "settingsKeepFolderStructure": "ఎంచుకున్న ఫైళ్లను వెలికి తీయేటప్పుడు ఫోల్డర్ నిర్మాణాన్ని ఉంచు",
                "settingsSkipJunkFilesOnExtract": "వెలికి తీయేటప్పుడు జంక్ ఫైళ్లను దాటవేయి",
                "settingsDefaultExtractLocationTitle": "డిఫాల్ట్ వెలికి తీసే స్థానం",
                "settingsChooseFolder": "ఫోల్డర్‌ను ఎంచుకో…",
                "settingsUseSystemDefaultLocation": "సిస్టమ్ డిఫాల్ట్ స్థానాన్ని ఉపయోగించు.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "లైసెన్స్ స్థితి",
                "settingsFree": "ఉచితం",
                "settingsProActive": "PeekZip Pro సక్రియంగా ఉంది",
                "settingsUnlockPro": "Pro ను అన్‌లాక్ చేయి",
                "settingsDefaultExtractLocationPanelTitle": "డిఫాల్ట్ వెలికి తీసే స్థానం",
                "settingsDefaultExtractLocationPanelMessage": "వెలికి తీసిన ఆర్కైవ్‌ల కోసం ఒక డిఫాల్ట్ ఫోల్డర్‌ను ఎంచుకోండి.",
            ]),
            "mr": merged([
                "toolbarOpenShort": "उघडा",
                "toolbarExtractShort": "काढा",
                "toolbarMoreAccessibility": "अधिक क्रिया",
                "toolbarUpgradeShort": "Pro",
                "statusReadyShort": "तयार",
                "statusInspectingShort": "तपासणी",
                "statusExtractingShort": "काढत आहे",
                "archiveSummaryText": "सामग्री पाहण्यासाठी एक आर्काइव्ह टाका किंवा आर्काइव्ह उघडा निवडा.",
                "archiveSafetyNothingExtracted": "सुरक्षित पूर्वावलोकन. अजून काहीही काढलेले नाही.",
                "archiveContentsTitle": "आर्काइव्ह सामग्री",
                "archiveContentsSubtitleDefault": "काढण्यापूर्वी फाइल्स शोधा, फिल्टर करा आणि काढा.",
                "searchPlaceholderArchive": "नाव, एक्स्टेन्शन किंवा मार्ग शोधा…",
                "archiveFiltersTitle": "फिल्टर्स",
                "archiveBrowseGroupTitle": "ब्राउझ",
                "archiveInspectGroupTitle": "तपासणी",
                "archiveAllArchivesTitle": "सर्व आर्काइव्ह्स",
                "archiveContentsInspectorTitle": "इन्स्पेक्टर",
                "archiveContentsInspectorSubtitle": "मेटाडेटा पहा, सुरक्षितपणे पूर्वावलोकन करा आणि फक्त आवश्यक ते काढा.",
                "archiveQuickActionsTitle": "द्रुत कृती",
                "archiveActionExtractFolder": "फोल्डर काढा",
                "archiveActionExtractSelected": "निवडलेले काढा",
                "archiveActionRevealAfterExtract": "काढल्यानंतर दाखवा",
                "archiveActionCopyFileName": "फाइल नाव कॉपी करा",
                "archiveActionCopyPath": "मार्ग कॉपी करा",
                "archiveActionActions": "क्रिया",
                "actionsShort": "क्रिया",
                "inspectorShort": "इन्स्पेक्टर",
                "archiveArchiveLabel": "आर्काइव्ह",
                "statFilesCompact": "%d फाइल्स",
                "statFoldersCompact": "%d फोल्डर्स",
                "archiveFlavorMixedCompact": "मिश्र",
                "archiveFlavorSingleFileCompact": "एक फाइल",
                "archiveTypeArchive": "आर्काइव्ह",
                "archiveTypeUnknown": "अज्ञात",
                "archiveToastExtractedSuccessfully": "यशस्वीरित्या काढले",
                "archiveToastNoMatchingFiles": "जुळणाऱ्या फाइल्स आढळल्या नाहीत.",
                "archiveToastNoRiskyFiles": "कार्यकारी किंवा इंस्टॉलर फाइल्स आढळल्या नाहीत.",
                "paywallTitle": "PeekZip Pro अनलॉक करा",
                "paywallSubtitle": "मोठे, संरक्षित आणि गुंतागुंतीचे आर्काइव्ह अधिक वेगाने पहा.",
                "paywallHighlightFullIndex": "या आर्काइव्हसाठी पूर्ण इंडेक्सिंग अनलॉक करा.",
                "paywallHighlightMultiArchive": "एकाच वेळी अनेक आर्काइव्ह उघडा आणि शोधा.",
                "paywallHighlightPassword": "पासवर्ड-संरक्षित आर्काइव्ह पूर्वावलोकन आणि काढा.",
                "paywallHighlightBatchExtract": "प्रतिमा, PDF, व्हिडिओ किंवा कोड एकाच क्लिकमध्ये काढा.",
                "paywallHighlightRiskScanning": "काढण्यापूर्वी धोकादायक executable आणि scripts ओळखा.",
                "paywallFeatureFullIndexing": "मोठ्या आर्काइव्हसाठी पूर्ण इंडेक्सिंग",
                "paywallFeatureMultiArchiveSearch": "अनेक आर्काइव्हमध्ये शोध",
                "paywallFeaturePasswordSupport": "पासवर्ड-संरक्षित आर्काइव्ह समर्थन",
                "paywallFeatureBatchExtract": "फाइल प्रकारानुसार बॅच काढणे",
                "paywallFeatureRiskDetection": "काढण्यापूर्वी जोखीम सूचना",
                "paywallLifetimePro": "आजीवन Pro",
                "paywallOneTimePurchase": "एकदाच खरेदी · सबस्क्रिप्शन नाही",
                "paywallLaunchPrice": "लॉन्च किंमत",
                "paywallUnlockPro": "Pro अनलॉक करा",
                "paywallRestorePurchase": "खरेदी पुनर्संचयित करा",
                "paywallContinueFree": "मोफत सुरू ठेवा",
                "paywallUnlocking": "प्रक्रिया करत आहे…",
                "paywallRestoring": "पुनर्संचयित करत आहे…",
                "paywallClose": "बंद करा",
                "passwordPromptTitle": "आर्काइव्ह अनलॉक करा",
                "passwordPromptMessage": "हे आर्काइव्ह पाहण्यासाठी आणि काढण्यासाठी पासवर्ड प्रविष्ट करा.",
                "passwordPromptRememberSession": "या सत्रासाठी पासवर्ड लक्षात ठेवा",
                "passwordPromptPasswordPlaceholder": "पासवर्ड",
                "passwordPromptCancel": "रद्द करा",
                "passwordPromptUnlockArchive": "आर्काइव्ह अनलॉक करा",
                "batchExtractCustomSubtitle": "pdf, csv, png यांसारखी एक्स्टेंशन्स स्वल्पविरामाने वेगळी करून प्रविष्ट करा",
                "batchExtractCustomPlaceholder": "pdf, csv, png",
                "batchExtractCustomCancel": "रद्द करा",
                "batchExtractCustomExtract": "काढा",
                "settingsGeneralTitle": "सामान्य",
                "settingsRevealAfterExtract": "काढल्यानंतर दाखवा",
                "settingsKeepFolderStructure": "निवडलेल्या फाइल्स काढताना फोल्डर रचना जपून ठेवा",
                "settingsSkipJunkFilesOnExtract": "काढताना जंक फाइल्स वगळा",
                "settingsDefaultExtractLocationTitle": "डीफॉल्ट काढण्याचे ठिकाण",
                "settingsChooseFolder": "फोल्डर निवडा…",
                "settingsUseSystemDefaultLocation": "सिस्टमचे डीफॉल्ट स्थान वापरा.",
                "settingsProTitle": "Pro",
                "settingsLicenseStatus": "परवाना स्थिती",
                "settingsFree": "मोफत",
                "settingsProActive": "PeekZip Pro सक्रिय आहे",
                "settingsUnlockPro": "Pro अनलॉक करा",
                "settingsDefaultExtractLocationPanelTitle": "डीफॉल्ट काढण्याचे ठिकाण",
                "settingsDefaultExtractLocationPanelMessage": "काढलेल्या आर्काइव्हसाठी डीफॉल्ट फोल्डर निवडा.",
                "settingsLanguageTitle": "भाषा",
                "settingsLanguageFollowSystem": "सिस्टमप्रमाणे",
                "emptyHomeTitle": "काढण्यापूर्वी आर्काइव्हचा पूर्वावलोकन करा",
                "emptyHomeSubtitle": "शोधा, पाहा आणि फक्त आवश्यक तेच काढा.",
                "emptyPrimaryTitle": "सुरुवात करण्यासाठी आर्काइव्ह उघडा",
                "emptyPrimarySubtitle": "फाइल निवडा किंवा आर्काइव्ह PeekZip मध्ये ओढा.",
                "emptyFeaturesTitle": "तुम्ही काय करू शकता",
                "emptyFeatureSearchTitle": "आर्काइव्हमध्ये शोधा",
                "emptyFeatureSearchSubtitle": "नाव, एक्स्टेंशन किंवा मार्गाने फाइल शोधा",
                "emptyFeatureBrowseTitle": "फाइल प्रकारानुसार ब्राउझ करा",
                "emptyFeatureBrowseSubtitle": "प्रतिमा, दस्तऐवज, कोड आणि व्हिडिओ पटकन पहा",
                "emptyFeatureExtractTitle": "फक्त आवश्यक तेच काढा",
                "emptyFeatureExtractSubtitle": "पूर्ण आर्काइव्ह उघडण्याची गरज नाही",
                "emptyFormatsTitle": "समर्थित स्वरूप",
                "archiveEmptyOpenArchive": "आर्काइव्ह उघडा",
                "archiveEmptyTrySampleArchive": "नमुना आर्काइव्ह वापरून पहा",
                "archiveDropTitle": "आर्काइव्ह येथे ओढा",
                "archiveDropSubtitle": "सामग्री तपासण्यासाठी सोडा",
            ])
            ,
            "ja": merged([
                "settingsLanguageTitle": "言語",
                "settingsLanguageFollowSystem": "システムに合わせる",
                "emptyHomeTitle": "解凍前にアーカイブを確認",
                "emptyHomeSubtitle": "検索、確認して、必要なものだけを取り出せます。",
                "emptyPrimaryTitle": "アーカイブを開いて開始",
                "emptyPrimarySubtitle": "ファイルを選択するか、PeekZip にドラッグしてください。",
                "emptyFeaturesTitle": "できること",
                "emptyFeatureSearchTitle": "アーカイブ内を検索",
                "emptyFeatureSearchSubtitle": "名前、拡張子、パスでファイルを探します",
                "emptyFeatureBrowseTitle": "種類別に閲覧",
                "emptyFeatureBrowseSubtitle": "画像、書類、コード、動画をすばやく確認",
                "emptyFeatureExtractTitle": "必要なものだけを抽出",
                "emptyFeatureExtractSubtitle": "アーカイブ全体を展開する必要はありません",
                "emptyFormatsTitle": "対応形式",
                "archiveEmptyOpenArchive": "アーカイブを開く",
                "archiveEmptyTrySampleArchive": "サンプルを試す",
                "archiveDropTitle": "ここにアーカイブをドラッグ",
                "archiveDropSubtitle": "ドロップして内容を確認",
            ]),
            "ko": merged([
                "settingsLanguageTitle": "언어",
                "settingsLanguageFollowSystem": "시스템 설정 따르기",
                "emptyHomeTitle": "압축 해제 전에 미리 보기",
                "emptyHomeSubtitle": "검색하고 확인한 뒤 필요한 것만 추출하세요.",
                "emptyPrimaryTitle": "압축 파일을 열어 시작",
                "emptyPrimarySubtitle": "파일을 선택하거나 PeekZip으로 끌어오세요.",
                "emptyFeaturesTitle": "할 수 있는 일",
                "emptyFeatureSearchTitle": "압축 파일 안 검색",
                "emptyFeatureSearchSubtitle": "이름, 확장자, 경로로 파일 찾기",
                "emptyFeatureBrowseTitle": "파일 형식별 탐색",
                "emptyFeatureBrowseSubtitle": "이미지, 문서, 코드, 비디오를 빠르게 확인",
                "emptyFeatureExtractTitle": "필요한 파일만 추출",
                "emptyFeatureExtractSubtitle": "전체 압축 파일을 풀 필요가 없습니다",
                "emptyFormatsTitle": "지원 형식",
                "archiveEmptyOpenArchive": "압축 파일 열기",
                "archiveEmptyTrySampleArchive": "샘플 압축 파일 사용해 보기",
                "archiveDropTitle": "여기로 압축 파일 끌어오기",
                "archiveDropSubtitle": "놓아서 내용 확인",
            ]),
            "ar": merged([
                "settingsLanguageTitle": "اللغة",
                "settingsLanguageFollowSystem": "اتباع إعدادات النظام",
                "emptyHomeTitle": "عاين الأرشيفات قبل الاستخراج",
                "emptyHomeSubtitle": "ابحث واستعرض واستخرج فقط ما تحتاج إليه.",
                "emptyPrimaryTitle": "افتح أرشيفًا للبدء",
                "emptyPrimarySubtitle": "اختر ملفًا أو اسحب الأرشيف إلى PeekZip.",
                "emptyFeaturesTitle": "ما الذي يمكنك فعله",
                "emptyFeatureSearchTitle": "البحث داخل الأرشيفات",
                "emptyFeatureSearchSubtitle": "اعثر على الملفات بالاسم أو الامتداد أو المسار",
                "emptyFeatureBrowseTitle": "التصفح حسب نوع الملف",
                "emptyFeatureBrowseSubtitle": "اعرض الصور والمستندات والكود والفيديو بسرعة",
                "emptyFeatureExtractTitle": "استخرج فقط ما تحتاج إليه",
                "emptyFeatureExtractSubtitle": "لا حاجة لفك ضغط الأرشيف بالكامل",
                "emptyFormatsTitle": "الأنواع المدعومة",
                "archiveEmptyOpenArchive": "فتح أرشيف",
                "archiveEmptyTrySampleArchive": "تجربة أرشيف نموذجي",
                "archiveDropTitle": "اسحب الأرشيف هنا",
                "archiveDropSubtitle": "أفلته لفحص المحتوى",
            ]),
            "hi": merged([
                "settingsLanguageTitle": "भाषा",
                "settingsLanguageFollowSystem": "सिस्टम के अनुसार",
                "emptyHomeTitle": "निकालने से पहले आर्काइव देखें",
                "emptyHomeSubtitle": "खोजें, देखें और केवल ज़रूरी चीज़ें निकालें।",
                "emptyPrimaryTitle": "शुरू करने के लिए आर्काइव खोलें",
                "emptyPrimarySubtitle": "फ़ाइल चुनें या आर्काइव को PeekZip में खींचें।",
                "emptyFeaturesTitle": "आप क्या कर सकते हैं",
                "emptyFeatureSearchTitle": "आर्काइव के अंदर खोजें",
                "emptyFeatureSearchSubtitle": "नाम, एक्सटेंशन या पथ से फ़ाइल ढूँढें",
                "emptyFeatureBrowseTitle": "फ़ाइल प्रकार के अनुसार देखें",
                "emptyFeatureBrowseSubtitle": "चित्र, दस्तावेज़, कोड और वीडियो जल्दी देखें",
                "emptyFeatureExtractTitle": "केवल ज़रूरी फ़ाइलें निकालें",
                "emptyFeatureExtractSubtitle": "पूरा आर्काइव अनज़िप करने की ज़रूरत नहीं",
                "emptyFormatsTitle": "समर्थित प्रारूप",
                "archiveEmptyOpenArchive": "आर्काइव खोलें",
                "archiveEmptyTrySampleArchive": "नमूना आर्काइव आज़माएँ",
                "archiveDropTitle": "आर्काइव यहाँ खींचें",
                "archiveDropSubtitle": "सामग्री देखने के लिए छोड़ें",
            ]),
            "id": merged([
                "settingsLanguageTitle": "Bahasa",
                "settingsLanguageFollowSystem": "Ikuti Sistem",
                "emptyHomeTitle": "Pratinjau arsip sebelum mengekstrak",
                "emptyHomeSubtitle": "Cari, periksa, dan ekstrak hanya yang Anda butuhkan.",
                "emptyPrimaryTitle": "Buka arsip untuk memulai",
                "emptyPrimarySubtitle": "Pilih file atau seret arsip ke PeekZip.",
                "emptyFeaturesTitle": "Yang dapat Anda lakukan",
                "emptyFeatureSearchTitle": "Cari di dalam arsip",
                "emptyFeatureSearchSubtitle": "Temukan file berdasarkan nama, ekstensi, atau jalur",
                "emptyFeatureBrowseTitle": "Jelajahi menurut jenis file",
                "emptyFeatureBrowseSubtitle": "Lihat gambar, dokumen, kode, dan video dengan cepat",
                "emptyFeatureExtractTitle": "Ekstrak hanya yang Anda perlukan",
                "emptyFeatureExtractSubtitle": "Tidak perlu membuka seluruh arsip",
                "emptyFormatsTitle": "Format yang didukung",
                "archiveEmptyOpenArchive": "Buka Arsip",
                "archiveEmptyTrySampleArchive": "Coba Arsip Contoh",
                "archiveDropTitle": "Seret arsip ke sini",
                "archiveDropSubtitle": "Lepaskan untuk memeriksa isi",
            ]),
            "ms": merged([
                "settingsLanguageTitle": "Bahasa",
                "settingsLanguageFollowSystem": "Ikut Sistem",
                "emptyHomeTitle": "Pratonton arkib sebelum mengekstrak",
                "emptyHomeSubtitle": "Cari, periksa dan ekstrak hanya yang anda perlukan.",
                "emptyPrimaryTitle": "Buka arkib untuk bermula",
                "emptyPrimarySubtitle": "Pilih fail atau seret arkib ke PeekZip.",
                "emptyFeaturesTitle": "Apa yang anda boleh lakukan",
                "emptyFeatureSearchTitle": "Cari dalam arkib",
                "emptyFeatureSearchSubtitle": "Cari fail mengikut nama, sambungan atau laluan",
                "emptyFeatureBrowseTitle": "Semak mengikut jenis fail",
                "emptyFeatureBrowseSubtitle": "Lihat imej, dokumen, kod dan video dengan cepat",
                "emptyFeatureExtractTitle": "Ekstrak hanya yang diperlukan",
                "emptyFeatureExtractSubtitle": "Tidak perlu membuka keseluruhan arkib",
                "emptyFormatsTitle": "Format disokong",
                "archiveEmptyOpenArchive": "Buka Arkib",
                "archiveEmptyTrySampleArchive": "Cuba Arkib Contoh",
                "archiveDropTitle": "Seret arkib ke sini",
                "archiveDropSubtitle": "Lepaskan untuk memeriksa kandungan",
            ]),
            "vi": merged([
                "settingsLanguageTitle": "Ngôn ngữ",
                "settingsLanguageFollowSystem": "Theo hệ thống",
                "emptyHomeTitle": "Xem trước tệp nén trước khi giải nén",
                "emptyHomeSubtitle": "Tìm kiếm, kiểm tra và chỉ trích xuất những gì bạn cần.",
                "emptyPrimaryTitle": "Mở tệp nén để bắt đầu",
                "emptyPrimarySubtitle": "Chọn tệp hoặc kéo tệp nén vào PeekZip.",
                "emptyFeaturesTitle": "Bạn có thể làm gì",
                "emptyFeatureSearchTitle": "Tìm kiếm trong tệp nén",
                "emptyFeatureSearchSubtitle": "Tìm tệp theo tên, phần mở rộng hoặc đường dẫn",
                "emptyFeatureBrowseTitle": "Duyệt theo loại tệp",
                "emptyFeatureBrowseSubtitle": "Xem nhanh ảnh, tài liệu, mã và video",
                "emptyFeatureExtractTitle": "Chỉ trích xuất những gì bạn cần",
                "emptyFeatureExtractSubtitle": "Không cần giải nén toàn bộ tệp nén",
                "emptyFormatsTitle": "Định dạng được hỗ trợ",
                "archiveEmptyOpenArchive": "Mở Tệp Nén",
                "archiveEmptyTrySampleArchive": "Thử Tệp Mẫu",
                "archiveDropTitle": "Kéo tệp nén vào đây",
                "archiveDropSubtitle": "Thả để kiểm tra nội dung",
            ]),
            "th": merged([
                "settingsLanguageTitle": "ภาษา",
                "settingsLanguageFollowSystem": "ตามระบบ",
                "emptyHomeTitle": "ดูตัวอย่างไฟล์บีบอัดก่อนแตกไฟล์",
                "emptyHomeSubtitle": "ค้นหา ตรวจสอบ และแตกเฉพาะสิ่งที่คุณต้องการ",
                "emptyPrimaryTitle": "เปิดไฟล์บีบอัดเพื่อเริ่มต้น",
                "emptyPrimarySubtitle": "เลือกไฟล์ หรือลากไฟล์บีบอัดเข้า PeekZip",
                "emptyFeaturesTitle": "สิ่งที่คุณทำได้",
                "emptyFeatureSearchTitle": "ค้นหาภายในไฟล์บีบอัด",
                "emptyFeatureSearchSubtitle": "ค้นหาไฟล์ตามชื่อ นามสกุล หรือเส้นทาง",
                "emptyFeatureBrowseTitle": "เรียกดูตามประเภทไฟล์",
                "emptyFeatureBrowseSubtitle": "ดูรูปภาพ เอกสาร โค้ด และวิดีโอได้อย่างรวดเร็ว",
                "emptyFeatureExtractTitle": "แตกเฉพาะไฟล์ที่ต้องการ",
                "emptyFeatureExtractSubtitle": "ไม่จำเป็นต้องแตกทั้งไฟล์บีบอัด",
                "emptyFormatsTitle": "รูปแบบที่รองรับ",
                "archiveEmptyOpenArchive": "เปิดไฟล์บีบอัด",
                "archiveEmptyTrySampleArchive": "ลองไฟล์ตัวอย่าง",
                "archiveDropTitle": "ลากไฟล์บีบอัดมาที่นี่",
                "archiveDropSubtitle": "ปล่อยเพื่อดูเนื้อหา",
            ]),
            "fil": merged([
                "settingsLanguageTitle": "Wika",
                "settingsLanguageFollowSystem": "Sundin ang System",
                "emptyHomeTitle": "I-preview ang mga archive bago i-extract",
                "emptyHomeSubtitle": "Maghanap, suriin, at i-extract lamang ang kailangan mo.",
                "emptyPrimaryTitle": "Magbukas ng archive para magsimula",
                "emptyPrimarySubtitle": "Pumili ng file o i-drag ang archive sa PeekZip.",
                "emptyFeaturesTitle": "Ano ang magagawa mo",
                "emptyFeatureSearchTitle": "Maghanap sa loob ng mga archive",
                "emptyFeatureSearchSubtitle": "Hanapin ang mga file ayon sa pangalan, extension, o path",
                "emptyFeatureBrowseTitle": "Mag-browse ayon sa uri ng file",
                "emptyFeatureBrowseSubtitle": "Tingnan agad ang mga larawan, dokumento, code at video",
                "emptyFeatureExtractTitle": "I-extract lamang ang kailangan mo",
                "emptyFeatureExtractSubtitle": "Hindi kailangang i-unpack ang buong archive",
                "emptyFormatsTitle": "Mga suportadong format",
                "archiveEmptyOpenArchive": "Buksan ang Archive",
                "archiveEmptyTrySampleArchive": "Subukan ang Halimbawang Archive",
                "archiveDropTitle": "I-drag ang archive dito",
                "archiveDropSubtitle": "I-drop para suriin ang laman",
            ]),
            "bn": merged([
                "settingsLanguageTitle": "ভাষা",
                "settingsLanguageFollowSystem": "সিস্টেম অনুযায়ী",
                "emptyHomeTitle": "এক্সট্র্যাক্ট করার আগে আর্কাইভ প্রিভিউ করুন",
                "emptyHomeSubtitle": "খুঁজুন, দেখুন এবং শুধু প্রয়োজনীয় জিনিসই বের করুন।",
                "emptyPrimaryTitle": "শুরু করতে আর্কাইভ খুলুন",
                "emptyPrimarySubtitle": "একটি ফাইল বেছে নিন, বা আর্কাইভটি PeekZip-এ টেনে আনুন।",
                "emptyFeaturesTitle": "আপনি কী করতে পারেন",
                "emptyFeatureSearchTitle": "আর্কাইভের ভিতরে খোঁজ করুন",
                "emptyFeatureSearchSubtitle": "নাম, এক্সটেনশন বা পাথ দিয়ে ফাইল খুঁজুন",
                "emptyFeatureBrowseTitle": "ফাইলের ধরন অনুযায়ী ব্রাউজ করুন",
                "emptyFeatureBrowseSubtitle": "ছবি, ডকুমেন্ট, কোড ও ভিডিও দ্রুত দেখুন",
                "emptyFeatureExtractTitle": "শুধু প্রয়োজনীয় ফাইল বের করুন",
                "emptyFeatureExtractSubtitle": "পুরো আর্কাইভ আনজিপ করার দরকার নেই",
                "emptyFormatsTitle": "সমর্থিত ফরম্যাট",
                "archiveEmptyOpenArchive": "আর্কাইভ খুলুন",
                "archiveEmptyTrySampleArchive": "নমুনা আর্কাইভ চেষ্টা করুন",
                "archiveDropTitle": "এখানে আর্কাইভ টেনে আনুন",
                "archiveDropSubtitle": "কনটেন্ট দেখতে ছেড়ে দিন",
            ]),
            "ur": merged([
                "settingsLanguageTitle": "زبان",
                "settingsLanguageFollowSystem": "سسٹم کے مطابق",
                "emptyHomeTitle": "نکالنے سے پہلے آرکائیو کا پیش منظر دیکھیں",
                "emptyHomeSubtitle": "تلاش کریں، دیکھیں اور صرف وہی نکالیں جس کی ضرورت ہو۔",
                "emptyPrimaryTitle": "شروع کرنے کے لیے آرکائیو کھولیں",
                "emptyPrimarySubtitle": "فائل منتخب کریں یا آرکائیو کو PeekZip میں گھسیٹیں۔",
                "emptyFeaturesTitle": "آپ کیا کر سکتے ہیں",
                "emptyFeatureSearchTitle": "آرکائیو کے اندر تلاش",
                "emptyFeatureSearchSubtitle": "نام، ایکسٹینشن یا راستے سے فائل تلاش کریں",
                "emptyFeatureBrowseTitle": "فائل کی قسم کے مطابق براؤز کریں",
                "emptyFeatureBrowseSubtitle": "تصاویر، دستاویزات، کوڈ اور ویڈیو تیزی سے دیکھیں",
                "emptyFeatureExtractTitle": "صرف ضروری فائلیں نکالیں",
                "emptyFeatureExtractSubtitle": "پورا آرکائیو کھولنے کی ضرورت نہیں",
                "emptyFormatsTitle": "معاون فارمیٹس",
                "archiveEmptyOpenArchive": "آرکائیو کھولیں",
                "archiveEmptyTrySampleArchive": "نمونہ آرکائیو آزمائیں",
                "archiveDropTitle": "آرکائیو یہاں گھسیٹیں",
                "archiveDropSubtitle": "مواد دیکھنے کے لیے چھوڑیں",
            ])
        ]
    }()
}
