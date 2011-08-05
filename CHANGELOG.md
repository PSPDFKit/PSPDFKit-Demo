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
*  fixed potential crash on rotate

__v1.2.1 - 04/Aug/2011__

*  detect rotation changes when offscreen

__v1.2.2 - 05/Aug/2011__

*  fixed a crash with < iOS 4.3

__v1.2.3 - 05/Aug/2011__

*  properly rotate pdfs if they have the /rotated property set
*  add option to disable outline in document
*  outline will be cached for faster access 
*  outline element has now a level property
*  fixed a bug with single-page pdfs
*  fixed a bug with caching and invalid page numbers
