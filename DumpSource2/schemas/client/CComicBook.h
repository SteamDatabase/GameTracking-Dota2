class CComicBook
{
	int32 m_nId;
	CUtlString m_Name;
	CUtlString m_strNameToken;
	CPanoramaImageName m_CoverImage;
	int32 m_nNumberOfImages;
	CUtlString m_URLForImages;
	int32 m_nNumDigitsInFilename;
	CUtlString m_ImageFileExtension;
	CUtlVector< ELanguage > m_AllowedLanguages;
	CUtlOrderedMap< ELanguage, ELanguage > m_LanguageOverrideMap;
	CUtlVector< int32 > m_StartPages;
	int32 m_nCacheBustingVersion;
}
