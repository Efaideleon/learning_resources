# Tips for improving at programming

* Always look for speical cases that blow up you code
* Dividing and reducing a problem
* Start by testing smaller output cases or a single ouput
* Using a Debugger to see variable values and testing one case with one output is a good way to find what's wrong in the code
* Debugging wiht a makefile and multiple executable can be found in the `Fixing Chat Application in C` Github repo (look for how the makefile is setup and the "-g" in ever file compilation as well as the launch.json and tasks.json in the vscode folder)
* When using libraries installed by brew make sure to `include.path` in vscode of the package found at `opt/homebrew`, find the .h file
* Need to learn the act of documentation through comments (use doxygen)
* Need to learn the act of catching erros to exit gracefully from errors instead of crashing
* Mast the art of specific, descriptive, consisten and unambigious names for everything
* Global variables makes debugging more diffiult because you don't know what the function depends on
* When programming its important to have a map, or a flow chart to have big picture of what needs to be done
* Create an outline and keep track of all the requirements of the project
* It's important to always adhere to speration of concerns: GUI is also for presentation and interactions logic would be handled by other classes. Each class would focus on a type of logic
* There are different kinds of classes: entities, managers, service, handlers
* Usually a service is the higher level considered the business rules, GUI are lower level (this might be there other way aroudn in a layered architecture)
* A big part of refactoring is see what parameters can be made local and which can change in type to a more generic one so that a more clean data, that can be passed by anyone can be used instead
* Passing classes to function parameters, and explicitly having an attribute in the class to show the dependency to another class is really useful to keep everything concise and clear to know who depends on who
* Document every function even if its just the brief section in doxygen
* Write unit tests for each component/function/struc; can test them on C Playground so that no need to write make file
* Having a tests folder directory is also important when programming, just like having an architecture, commentting and error checking
* Something that will help you with not making changes that are unnecessary and the make be a lot work to implement a single change is to always to constraint to the single module/file, that is adhering to the single responsibility principle as much as possible
* In c, a lot of module files should contain their own functions that change or find or delete something from the main object/struct like a doubly linked list, that has functions that take a reference to the head node `void insertAtBeginning(struct Node** head_ref, int new_data)`
* When writing a commnet describe what the code block does in general.
* It's importnat to create and update a specific software architecture class diagram