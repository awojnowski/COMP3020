Comp 3020 - Assignment 1
========================

**Group members:** Aaron Wojnowski, Kieran Cairney, Lorenzo Gentile

**Note:** We were permitted to provide responses relevant to a Cocoa development environment on Mac OSX, versus a Windows environment.

**(a) "Creating a simple form": what is the method for showing a message box?**



**(b) "Event Handling": what is an event handler?**

An event handler is a method that responds to a certain action (such as a timer firing). In Cocoa, this is commonly referred to as the delegate, or target-action pattern. In Cocoa, a button is typically implemented using provided a target object (the object in which the method will be invoked on) and a method to be called when the button is pressed. When pressed, the button will simply call the passed in method on the passed in target object.

**(c) "Creating a Windows Application project": what are the necessary steps in creating a Windows Forms application project?**

A new project can be created by opening Xcode and navigating to File > New Project. A project template can then be selected, and additional options can be configured (such as using Core Data, the language for the project, and more).

**(d) "Keeping a windows form on top": (a) describe one approach for maintaining a form as the topmost window in an application. (b) Give one example of when such a form would be useful.**

It is useful to keep a form on the topmost window in an application when that form requires and relies on immediate user input. For example, in an application that manages a music library with playlists, it would be useful to have a form on the top of the application when the user creates a new playlist, which would request the playlist's name and other configuration options.

**(e) "Menus and context menus": describe each of the following - menus, context menus, status bars, and toolbars.**

