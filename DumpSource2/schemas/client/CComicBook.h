// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CComicBook
{
	// MPropertyDescription = "ID of the comic book.  Must be unique.  Changing will disrupt graphs."
	int32 m_nId;
	// MPropertyDescription = "Name of the comic book.  Must be unique.  Changing will disrupt graphs."
	CUtlString m_Name;
	// MPropertyDescription = "User facing name or localization token to the user facing name."
	CUtlString m_strNameToken;
	// MPropertyDescription = "Cover image to use. Likely starts with file://{images}/comics/..."
	CPanoramaImageName m_CoverImage;
	// MPropertyDescription = "Number Of Images"
	int32 m_nNumberOfImages;
	// MPropertyDescription = "URL for images.  Supports %CDN% and %LANGUAGE% variables to be replaced at runtime."
	CUtlString m_URLForImages;
	// MPropertyDescription = "Num digits in filename.  Will be zero padded (i.e. 001, 002, 003, etc)"
	int32 m_nNumDigitsInFilename;
	// MPropertyDescription = "Image file extension."
	CUtlString m_ImageFileExtension;
	// MPropertyDescription = "Allowed languages for this comic book.  Anything not specified here will default to English."
	CUtlVector< ELanguage > m_AllowedLanguages;
	// MPropertyDescription = "Language mapping for overrides. This is used when we don't have content like tchinese but have schinese and want to map one to the other."
	CUtlOrderedMap< ELanguage, ELanguage > m_LanguageOverrideMap;
	// MPropertyDescription = "Indices of pages that are new pages to the user.  Useful if you have a series of images which are full screen but reveal new cells. If not specified, each page is a start page. Try setting the comic_viewer_popup_show_internal_page convar to help set this up."
	CUtlVector< int32 > m_StartPages;
	// MPropertyDescription = "Cache version to use. Increment this number if the files on the CDN have changed but the URL has not."
	int32 m_nCacheBustingVersion;
};
