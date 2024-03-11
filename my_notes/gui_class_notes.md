## Things to Do

* LoginWindowUI
* ChatWindowUI
* FrientListUI
* FriendRequestWidgetUI
* RemoveFriendWidgetUI
* CredentialService
* MessageService
* FriendRequestHandler
* WindowManager
* ApplicationManager
* NetworkService
* Need to define and implement creation functions to create an instance of each struct
* Gotta Test LoginWindow with CredentialService by itself. Will Need to get the LoginWindow Running and use dummy functions for CredentialService

## Things Done

* <strike> Define all the structs' attributes and function prototypes
* Create a makefile to test as we build the application
</strike>

---

## Fixing Issues

#### Problem with using functions with structs instead of classes

The function can't be called from the given instance, so if the function wants to change the instance we have to pass the instance to function.

* We don't know what kind of data can be passed to the `G_CALLBACK` function on `g_signal_connect` ?



#### Solving problem with `button_clicked` function

Entry is global now so we have to pass the entry to data

`GtkWidget *widget`: widget?
`gpointer data`: GtkWidget* label3

1. Change `data` to take `entry` instead of label
2. Get the text directly from the `entry`
3. Assign the text to `name` and `username`

```c
static void button_clicked(GtkWidget *widget, gpointer data)
{
    name = malloc(30 * sizeof(char));
    name[0] = '\0';
    strncpy(name, gtk_entry_get_text(GTK_ENTRY(data)), sizeof(name));
    strncpy(username, gtk_entry_get_text(GTK_ENTRY(data)), sizeof(username));
}
```

#### Error with typedefs and headerfiles

`typedef redefinition with different types`

**Reason**

Including header files multiple times: If a header file defines a typedef, and you include that header file multiple times in your code, you will get this error. This is because the compiler will see the typedef definition multiple times, which is equivalent to redefining it.

**Solution**

`#ifndef MY_HEADER_H:` This line checks if the macro `MY_HEADER_H` is not defined. If it is not defined, then the compiler will continue processing the header file.

```c
#ifndef MY_HEADER_H
#define MY_HEADER_H

// Contents of the header file go here

#endif
```

## Setting up Debugger for `guipapp` Makefile

Be careful with having different Makefiles one in the main directory, and another in another directory.

If the `Makefile` is in another directory specify it in the `tasks.json` with the line:

```json
 "options": {
                "cwd": "${workspaceFolder}/GUI"
            }
```

**`tasks.json` Attribute:**

```json
        {
            "type": "cppbuild",
            "label": "build-guiapp",
            "command": "make",
            "args": ["GuiApp"],
            "problemMatcher": "$gcc",
            "options": {
                "cwd": "${workspaceFolder}/GUI"
            }
        }
```

**`launch.json` Attribute:**

```json
        {
            "name": "Debug guiapp",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/GUI/guiapp",
            "cwd": "${workspaceFolder}/GUI",
            "preLaunchTask": "build-guiapp",
            "MIMode": "lldb",
            "args": []
        }
```

### Components

* launch.json
* tasks.json
* setting up debugger

### Steps

#### launch.json

* add a new attribute to handle the new makefile

#### tasks.json

* add a new attribute that handle all the command and argument setup



## Solving the following issues

```c
(process:62606): GLib-GObject-CRITICAL **: 18:55:09.692: invalid (NULL) pointer instance

(process:62606): GLib-GObject-CRITICAL **: 18:55:09.695: g_signal_connect_data: assertion 'G_TYPE_CHECK_INSTANCE (instance)' failed
```

### Solution

* Make sure that `gtk_init` is called before any initializing the uses the gtk functions.

```c
gtk_init(&argc, &argv);
```
