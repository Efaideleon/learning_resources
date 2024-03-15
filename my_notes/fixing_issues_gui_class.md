# Fixing Issues

## Problem with using functions with structs instead of classes

The function can't be called from the given instance, so if the function wants to change the instance we have to pass the instance to function.

* We don't know what kind of data can be passed to the `G_CALLBACK` function on `g_signal_connect` ?

## Solving problem with `button_clicked` function

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

## Error with typedefs and headerfiles

`typedef redefinition with different types`

### Reason

Including header files multiple times: If a header file defines a typedef, and you include that header file multiple times in your code, you will get this error. This is because the compiler will see the typedef definition multiple times, which is equivalent to redefining it.

### Solution

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

### Solution

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

## Issue: Passing Multiple arguments to the `g_signal_connect` function `G_CALLBACK` 

### Solution

* Create a struct that holds all the data values you need to pass

```c
typedef struct {
    GtkWidget *entry;
    int some_value;
} MyData;

void button_clicked(GtkWidget *widget, gpointer data) {
    MyData *my_data = (MyData *)data;
    GtkWidget *entry = my_data->entry;
    int value = my_data->some_value;
    // Use the entry widget and value here
}

int main(int argc, char *argv[]) {
    // ... (Initialize GTK and create widgets)

    MyData *my_data = g_new(MyData, 1);
    my_data->entry = login_window_ui->entry;
    my_data->some_value = 42;

    g_signal_connect_data(login_window_ui->button, "clicked",
                         G_CALLBACK(button_clicked),
                         (gpointer)my_data,
                         NULL,
                         G_CONNECT_AFTER);

    // ... (Run the GTK main loop)
}

```

## Issue: Passing `char` to `const void*`

```c
error: [{ "resource": "/CredentialService/CredentialService.c", "owner": "makefile-tools", "severity": 8, "message": "incompatible integer to pointer conversion passing 'char' to parameter of type 'const void *' [-Wint-conversion]", "source": "gcc", "startLineNumber": 9, "startColumn": 10, "endLineNumber": 9, "endColumn": 10}]
```

### Solution

* Make sure that the variables have the right type
* e.i: change `char username` to `char username[50]`
* Make sure to use `GTK_LABEL` with `strncpy()` because `GTK_ENTRY` returns a `gchar` not `char`

```c
    GtkWidget* temp_data = gtk_label_new(""); // make sure that the GtkWidget* is initialized, in this nase with gtk_label_new
    gtk_label_set_text(GTK_LABEL(temp_data), gtk_entry_get_text(GTK_ENTRY(credentials_data->data)));
    
    strncpy(credentials_data->credential_service->name, gtk_label_get_text(GTK_LABEL(temp_data)), sizeof(credentials_data->credential_service->name));
```

## EXEC_BAD_ACCESS ERRORS

Most of this errors happen when a variable is not initialized and we are trying to access it or use it.

## Removing Deprecated Warnings from GTK at Compilation

### Solution

`-Wno-deprecated-declarations` : use in gcc

```Makefile
CC = gcc -Wno-deprecated-declarations # -Wno-deprecated-declarations: disables deprecated warnings from gtk
```

## Issue: Classes that have nothing to do with GUI/GTK should not depend on gtk/gtk.h

* Example: 

The `button_clicked` function which is part of the `CredentialService` should not depend on a `GtkWidget` and `gpointer` 

```c
void button_clicked(GtkWidget *widget, gpointer data)
{
    CredentialsData *credentials_data = (CredentialsData *)data;

    GtkWidget *temp_data = gtk_label_new("");
    gtk_label_set_text(GTK_LABEL(temp_data), gtk_entry_get_text(GTK_ENTRY(credentials_data->data)));

    strncpy(credentials_data->credential_service->name, gtk_label_get_text(GTK_LABEL(temp_data)), sizeof(credentials_data->credential_service->name));
    strncpy(credentials_data->credential_service->username, gtk_label_get_text(GTK_LABEL(temp_data)), sizeof(credentials_data->credential_service->username));
}

```

### Solution

* Use a proxy function in the GUI file in this case `LoginWindowUI` that cleans the data to send it to a `CredentialService` Function.


## Brainstorming `check_credentials()`

* the LoginWindowUI is doing quite a bit of credential logic when it shouldn't
* it should be able to call the check the credentials function and that function should return if the password and username are valid or not.

## Macros

* When defining a macro it should be:

```c
#define True 1 // note that there is no = sign and ;
```

## Issue: LoginWindowUI/LoginWindowUI.c:44:41: error: expected expression CredentialsData *credentials_data = g_new(CredentialsData, 1)

### Solution

The struct must be define above from where its being called

## Expression Expected

### Solution

This bug is usually caused because the variable/function/struct has not been defined, is define out of order, or is define incorretly

## Warning: address of stack memory associated with local variable 'string' returned [-Wreturn-stack-address]

Returning a char* from function will trigger this error.

### Solution

Modify the function to take a char * buffer as an argument, where the caller provides the memory to store the string. This way, the function doesn't need to allocate memory itself.

```c
void get_clean_string(GtkWidget *widget, char *buffer, int size) {
    GtkWidget *temp_data = gtk_label_new("");
    gtk_label_set_text(GTK_LABEL(temp_data), gtk_entry_get_text(GTK_ENTRY(widget)));
    strncpy(buffer, gtk_label_get_text(GTK_LABEL(temp_data)), size - 1); // Leave space for null terminator
    buffer[size - 1] = '\0'; // Ensure null termination
}
```

## Issue char * `name` becomes null before copying

### Problem

* `name` becomes null before copying

```c
void button_clicked(CredentialService *credential_service, char *name, char *username)
{
    printf("name: %s\n: ", name);
    printf("*name: %c\n", *name);
    strncpy(credential_service->name, name, NAME_SIZE);
    strncpy(credential_service->username, username, NAME_SIZE);
}
```

### Solution

**BEFORE:**

This version make name point to the content of `name_buffer`, but it doesn't copy, so when `credential_data->name` goes out of this function scope it point to a freed address

```c
void get_name_and_password(CredentialsData *credentials_data)
{
    char name_buffer[NAME_SIZE];
    char password_buffer[PASSWORD_SIZE];

    get_clean_string(credentials_data->entry_widget, name_buffer, NAME_SIZE);

    get_clean_string(credentials_data->entry2_widget, password_buffer, PASSWORD_SIZE);

    credentials_data->name, name_buffer;
    credentials_data->password, password_buffer; 
}
```

**AFTER:**

Here the content is copied into `credentials->name` not just a reference.

```c
void get_name_and_password(CredentialsData *credentials_data)
{
    char name_buffer[NAME_SIZE];
    char password_buffer[PASSWORD_SIZE];

    get_clean_string(credentials_data->entry_widget, name_buffer, NAME_SIZE);

    get_clean_string(credentials_data->entry2_widget, password_buffer, PASSWORD_SIZE);

    strncpy(credentials_data->name, name_buffer, NAME_SIZE);
    strncpy(credentials_data->password, password_buffer, PASSWORD_SIZE);
}
```

## Figuring out how the application manager creates and destroys windows

* The application manager will need to know when the user credentials have been approved.
* When they are approved it will destroy the login window
* Then it will create the friendlist window

## Allocating Memory to CredentialService, MessageService, FriendRequestHandler, NetworkService

* When creating the `application manager` on `create_application_manager()` we will use `create_blank_component()` from each component. Each one of this function returns an instance of the Component with allocated memory using `malloc()`
* each of the `create_blank_component()` function will take as parameter the necessary components that they depend on
