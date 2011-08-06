# Changelog

__v1.0 - 01/Aug/2011__  

*  First public release


__v1.1 - 03/Aug/2011__

*  add PDF outline parser. If it doesn't work for you, please send me the pdf.
*  add verbose log level
*  improve search animation
*  fixes a warning log message when no external thumbs are used
*  fixes some potential crashes in PSPDFCache


__v1.2 - 04/Aug/2011__

*  add EmbeddedExample
*  allow embedding PSPDFViewController inside other viewControllers
*  add property to control toolbar settings
*  made delegate protocol @optional
*  fixes potential crash on rotate


__v1.2.1 - 04/Aug/2011__

*  detect rotation changes when offscreen


__v1.2.2 - 05/Aug/2011__

*  fixes a crash with < iOS 4.3


__v1.2.3 - 05/Aug/2011__

*  properly rotate pdfs if they have the /rotated property set
*  add option to disable outline in document
*  outline will be cached for faster access 
*  outline element has now a level property
*  fixes a bug with single-page pdfs
*  fixes a bug with caching and invalid page numbers


__v1.3 - 06/Aug/2011__

*  Major Update!
*  add support for pdf link annotations (site links and external links)
*  add delegate when viewMode is changed
*  add reloadData to PSPDFViewController
*  add scrollOnTapPageEndEnabled property to control prev/next tap
*  add animations for page change
*  improve scrollbar page changing
*  improve outline parsing speed
*  improve support for rotated PDFs
*  improve thumbnail display
*  fixes some analyzer warnings
*  fixes a timing problem when PSPDFCache was accessed from a background thread
*  fixes various other potential crashes