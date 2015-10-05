Comp 3020 - Assignment 1
========================

**Group members:** Aaron Wojnowski, Kieran Cairney, Lorenzo Gentile

**Note:** We were permitted to provide responses relevant to a Cocoa development environment on Mac OSX, versus a Windows environment.

**(a) "Creating a simple form": what is the method for showing a message box?**

Typically forms and message boxes are handled using the `NSAlert` class. An example of a message popup would be like so:

    let alert = NSAlert()
    alert.messageText = "Yes or no?"
    alert.addButtonWithTitle("Yes")
    alert.addButtonWithTitle("No")

    let result = alert.runModal()
    switch(result) {
    case NSAlertFirstButtonReturn:
        // yes clicked
    case NSAlertSecondButtonReturn:
        // no clicked
    default:
        break
    }

**(b) "Event Handling": what is an event handler?**

An event handler is a method that responds to a certain action (such as a timer firing). In Cocoa, this is commonly referred to as the delegate, or target-action pattern. In Cocoa, a button is typically implemented using provided a target object (the object in which the method will be invoked on) and a method to be called when the button is pressed. When pressed, the button will simply call the passed in method on the passed in target object.

**(c) "Creating a Windows Application project": what are the necessary steps in creating a Windows Forms application project?**

A new project can be created by opening Xcode and navigating to File > New Project. A project template can then be selected, and additional options can be configured (such as using Core Data, the language for the project, and more).

**(d) "Keeping a windows form on top": (a) describe one approach for maintaining a form as the topmost window in an application. (b) Give one example of when such a form would be useful.**

It is useful to keep a form on the topmost window in an application when that form requires and relies on immediate user input. For example, in an application that manages a music library with playlists, it would be useful to have a form on the top of the application when the user creates a new playlist, which would request the playlist's name and other configuration options.

**(e) "Menus and context menus": describe each of the following - menus, context menus, status bars, and toolbars.**

A menu provides a user with a list or series of options which facilitate the navigation of, or control of, an application. An example of a menu could be a program which comes up with six options on startup (one for each task within the program). Throughout the time using the application, a user can click a menu item to access a certain portion of the application, and can navigate back to the menu to access the options again.

A context menu is a list or series of options but instead being general, or global, to the application, they relate to a certain element in an application. An example of a context menu would be the menu that appears when you right-click a file. Options like "cut", "paste", "copy", or "delete" don't make sense in the context of an entire application, but when attached to the context of right-clicking a file, they provide meaningful information and actions for the user. Another example of a context menu is the 3d touch menu that was released for the new iPhone 6s. When pressing hard on an application's icon, users will see context specific options based on the application that they pressed on.

A status bar provides information about an application and is typically (although not always) globally available. One of the most notable examples of a status bar is the Mac OSX status bar which almost always appears at the top of the operating system. This status bar provides information about the system like battery life, time, date, wifi connectivity status, bluetooth status, and more. Another example of a status bar would be at the bottom of the Microsoft Word interface, where information about the current document's save status, word count, and more are revealed.

Finally, a toolbar is typically a series or list of icons that can facilitate certain actions in an application. An example of a toolbar would be the tools on the left side of a Photoshop document. A toolbar can be used to perform actions within an application, versus navigating around. In Photoshop's case, it uses a toolbar to facilitate the manipulation of a documents whereas it uses a menu to create new documents, save, etc.