# About AppCoreLib #
Useful classes for building scalable Flex RIA's.

AppCoreLib is a collection of useful classes that facilitate easy RIA development with regards to XML based data being pulled in.  The general approach is that an application needs to load various content/setting files prior to loading the UI.  Through a series of simple checks, an application can then load the UI once those dependencies have been loaded or alert the user if they have not.

AppCoreLib provides simple XMLDataBroker classes with convenience methods that allows easy traversal of the XML data using simple IDs.

# News/Updates #

## **2008.05.12** ##
Added a tutorial using AppCoreLib's XMLDataBroker, mock XML data and a Cairngorm command.  Check it out [here](http://code.google.com/p/appcorelib/wiki/mockDataTut?updated=mockDataTut&ts=1210623889)

## **2008.04.30** ##
Added a much needed property for the XMLLoadEvent.  Now when an XMLLoadEvent.XML\_LOAD\_SUCCESS occurs, the event will have the actual XML attached via the xml and data (redundant and deprecated) properties.

## **2008.04.23** ##
There has been considerable dev efforts in getting the ClassUtil methods standardized.  As such I decided to start taking snapshots of the source so you can build from previous version if you want.

  * v1.0.20080214 svn url - [link](https://appcorelib.googlecode.com/svn/tags/v1.0.20080214)

## **2008.03.26** ##
Added asdocs finally.  Expect further development on ClassUtil as there are some missing conversion functions that need to be implemented.


## **2008.02.20** ##
Added a new class: ClassUtil.  ClassUtil contains methods to translate generic objects to specific class types.  Hopefully not too many folks have been using ObjectUtil just yet so this should affect very few of you.  If so, you can still continue to use ObjectUtil for awhile until I can finally remove it.

  * deprecated ObjectUtil (use ClassUtil instead)
  * added ClassUtil

## **2007.12.28** ##
I am currently having issues with my asdoc compiler.  So right now there are no docs.  I am working to resolve this issue as quickly as possible.  All the source code has asdoc comments in it.  I will also be uploading an example file.