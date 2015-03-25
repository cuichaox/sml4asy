Introduce
===
Sml4asy is a module for Asympote. Make UML diagram quickly from script.<br>
Asympote Homepage: http://asymptote.sourceforge.net/

INSTALL
===
Copy "asy/*.asy" to a directory that Asympote will search for system files. Asympote will search the folloing paths, in the order listed.<br>
1. The current directory;<br>
2. A list of one or more directories specified by the configuration variable dir (separated by : under UNIX and ; under MSDOS);<br>
3. The directory specified by the environment variable ASYMPTOTE_HOME; if this variable is not set, the directory .asy in the user¡¯s home directory (%USERPROFILE%\.asy under  MSDOS) is used;<br>
4. The Asymptote system directory (by default, /usr/local/share/asymptote under UNIX and C:\Program Files\Asymptote under MSDOS).<br>

Examples
===
Run `asy examples/*.asy` to building examples.(output: eps/pdf)
See  examples/*.pdf.



