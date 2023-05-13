----------------------------------------------
NO ONE LIVES FOREVER - Softimage 3.7 Exporters
January 11, 2001
----------------------------------------------

Softimage was the primary 3D package used in the creation of models and terrain for 
No One Lives Forever.  Exporters were used to translate the geometry, texture and animation 
information from Softimage 3.7 into a file format that could be read by one of our proprietary 
game creation tools (ModelEdit and Dedit).

There are the two Lithtech exporters for Softimage 3.7 that were used for No One Lives Forever,
LandExport and LithExport.  There are two files associated with each exporter:

LandExport.dll, LandExport.cus:
    - The terrain exporter for world geometry

LithExport.dll, LithExport.cus:
    - The model export for props, characters, weapons, etc.

In order to use these files in Softimage, it is necessary to put the .cus files in: 
SOFT3D_3.7SP1\3d\custom\tools and the .dll files in: SOFT3D_3.7SP1\3d\custom\bin.

Once those are in the appropriate directories in Softimage, they will appear under: 
    Tools>Export>Objects>.

LithExport
----------

When exporting a polygonal model as a prop, weapon or character, the LithExport exporter is 
used to create an .abc file, the file format for game models and used by the Lithtech model 
software ModelEdit.  

From Tools>Export>Objects>LithExport, a window will appear.  In this window you will need to 
set the appropriate directory and name for the object being exported: 
C:\NOLF\NOLF\props\models\tree.abc for example. Within this window there is also a place to 
define the animation name being exported (used primarily for characters and player view models.).

For more information on this specific to characters and player view weapons/gadgets/vehicles 
please review the ModelEdit section of the Lithtech documentation.


LandExport
----------

LandExport will export polygonal geometry as an .ed file, the file type used by DeEdit for 
creating environments.

From Tools>Export>Objects>LandExport, name the .ed file and point to where you would like this 
file saved.  The .ed file can now be opened from within DEdit.


*Note: all pieces of an object must be polygonal geometry and part of the same hierarchy in 
order to export it successfully.
