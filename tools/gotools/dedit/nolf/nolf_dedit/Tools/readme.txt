---------------------------------------
NO ONE LIVES FOREVER EDITING TOOLS v1.0
January 11, 2001
---------------------------------------

Please note that these tools are provided "as-is" and not officially supported by Monolith 
Productions, LithTech Inc., or Fox Interactive. 


Overview
--------

What's included in this package:

- DEdit, the NOLF world editor (also contains texture and sprite utilities). 
- ModelEdit, the NOLF model editor.
- LithRez, a command-line program for packing and unpacking NOLF .REZ (Resource) files.
- Softimage 3.7 exporters.
- Sample level files.
- Documentation (including step by step instructions for using DEdit and ModelEdit).
- Links to on-line resources

Terms used in this Document:
----------------------------
 
GameDirPath - This refers to the full path to the folder where NOLF is installed.  By default
              NOLF is installed to "c:\Program Files\Fox\No One Lives Forever".  However since
              you may have changed this, paths will be defined in terms of GameDirPath (e.g., 
              GameDirPath\Tools is where the Tools are installed)


Installation Notes:
-------------------

The NOLF Tools Installer installs the NOLF Tools to the folder GameDirPath\Tools. 
(e.g. "c:\Program Files\Fox\No One Lives Forever\Tools").  The tools may not run properly if 
they are moved from this location!

In addition, the NOLF Game Resources must be unpacked (using the unrez.bat file discussed under
the LithRez section below) to the folder GameDirPath\Nolf (e.g. "c:\Program Files\Fox\No One 
Lives Forever\Nolf").  You will not be able to use DEdit if the NOLF Game Resources are not 
unpacked to this directory. 


-----
DEdit
-----

DEdit is the tool that you can use to create and modify levels.  Before you can do this, you must 
first unpack (extract) resources from the No One Lives Forever resource files.  For instructions, 
please see the "Lithrez" section of this document.  Once the resources have been extracted, you 
can use DEdit to integrate them into your levels.  

To run DEdit, just double click on GameDirPath\Tools\DEdit.exe. 

For detailed information on the use of DEdit, please see the DEdit documentation:

    GameDirPath\Tools\Docs\NolfDEdit.html
   

---------
ModelEdit
---------

ModelEdit is the tool that you can use to modify NOLF models (.abc files).  

To run ModelEdit, just double click on GameDirPath\Tools\ModelEdit.exe. 

For detailed information on the use of ModelEdit, please see the ModelEdit document:

    GameDirPath\Tools\Docs\NolfModelEdit.html


-------
LithRez
-------

Lithrez is a command-line utility which can pack and unpack NOLF '.REZ' files.  You must use this 
to "unlock" the media, models, textures, etc. that are contained in the Nolf .REZ files before you 
can edit them with DEdit or ModelEdit.  LithRez is located in the Tools folder and will display 
the following help if run without any parameters:

    Usage: LITHREZ <command> <rez file name> [parameters]

    Commands: c <rez file name> <root directory to read> - Create
              v <rez file name>                          - View
              x <rez file name> <directory to output to> - Extract
    Options:  ?v                                         - Verbose
    Options:  ?z                                         - Warn zero len
    Options:  ?l                                         - Lower case ok

    Example: lithrez cv foo.rez c:\foo
             (would create rez file foo.rez from the contents of the
              directory "c:\foo" the verbose option would be turned on)


A simple DOS batch file (unrez.bat) has been provided to simplify the process of unpacking the 
NOLF Game resources for you.  To unpack the NOLF Game Resources, just double click on "unrez.bat"
located in the Tools folder.
 
NOTE:  You will need approximately 900MB of free hard drive space to unpack the NOLF Game Resources.

If you create your own add-ons (that you plan to distribute), you will need to store your resources 
in a new .REZ file (e.g., MyMod.rez).  For these resources to be available to the game you must
add the following line in the advanced options section of the NOLF launcher: 

     -rez MyMod.rez

(NOTE: be sure to check the "Always specify these command line parameters" check-box so these
resources are always available to the game.)

You should only include new resources in your .REZ file.  For example, if you created a
new DeathMatch level (MyCoolLevel) that was based on existing NOLF textures, you would only 
need to include the MyCoolLevel.dat file in your add-on .REZ.  Your resource folders might 
look like something like this:

     c:\MyMod\Worlds\Multi\DeathMatch\MyCoolLevel.dat

To create the MyMod.rez file you would run LithRez as follows:

     GameDirPath\Tools\LithRez.exe cv MyMod.rez c:\MyMod


-----------------------
Softimage 3.7 Exporters
-----------------------

Softimage was the primary 3D package used in the creation of models and terrain for 
No One Lives Forever.  Exporters were used to translate the geometry, texture and animation 
information from Softimage 3.7 into a file format that could be read by one of our proprietary 
game creation tools (ModelEdit and Dedit).

These exporters, and documentation on how to use them can be found in:

     GameDirPath\Tools\Exporters


------------------
Sample Level Files
------------------

Included are four sample uncompiled NOLF level files (.ED files).  These levels will appear under
the GameDirPath\Nolf\Worlds directory after the NOLF Game resources have been unpacked (see 
LithRez section above).  These files are:

    GameDirPath\Nolf\Worlds\Sample1.ed

        - A simple reference level that demonstrates the use of several fundamental NOLF 
        objects, including:
            * GameStartPoint
            * WorldProperties
            * TranslucentWorldModel
            * Door
            * HingedDoor
            * Water

    GameDirPath\Nolf\Worlds\Sample2.ed
	
        - A copy of Mission one, Scene three.  This level demonstrates complex single player
        level design concepts including:
            * AI
            * Scripted events
            * Cinematics

    GameDirPath\Nolf\Worlds\Sample_simplesky.ed
	
        - A simple skybox.  This level demonstrates the level design concepts necessary to
        create a simple skybox, including the use of:
            * SkyPortals
            * DemoSkyWorldModel

    GameDirPath\Nolf\Worlds\Sample_complexsky.ed
	
        - A complex sky.  This level demonstrates the level design concepts necessary to
        create a complex sky, including:
            * Panning clouds
            * Sun/Sun flares
            * Indexing of sky objects

    GameDirPath\Nolf\Worlds\Multi\Deathmatch\Sample_DM.ed

        - A reference death match level that demonstrates basic NOLF death match concepts,
        including:
            * Spawn points
            * Powerups

    GameDirPath\Nolf\Worlds\Multi\AssaultMap\Sample_AM.ed

        - A reference assault match level that demonstrates basic NOLF death match concepts,
        including:
            * Team spawn points
            * Intelligence items


-----------------
On-line resources
-----------------

For more information, please visit the following websites:
 
     The Official Community Site
     http://www.nolfnews.com/mods
 
     The Official Site
     http://www.the-operative.com
 
     FOX Interactive
     http://www.foxinteractive.com
 
     Monolith Productions
     http://www.lith.com


Thanks
------

We hope you enjoy No One Lives Forever and we look forward to playing all the modifications 
that you make!

- The No One Lives Forever Team
- The LithTech Team


