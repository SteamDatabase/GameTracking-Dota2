CURSOR PUBLISHING GUIDELINES

*NOTE* - as of April 2015, David White made changes that allowed us to use only .bmp files for Windows, Mac and Linux. .ani files are no longer needed. We shipped the TI5 cursors with .bmps only and will eventually remove the .ani files for the other cursors.


ORIGINAL NOTE-

Cursors have to be saved in two different formats to accommodate all platforms.

On Windows, cursors are simply .ani files, which contain all cursor data.

Under SDL (Linux/Mac/etc), .ani files are not supported. Instead, cursors are .bmp files. Whenever a cursor named e.g. abc.ani is saved, an equivalent abc.bmp should also be provided.

By default, SDL will assume the top-left most pixel of the cursor (0 0) is the hotspot. However, if a cursor has a different hotspot, the cursor.res file can be edited to provide the cursor's hotspot. Center hotspot is 14 14.
