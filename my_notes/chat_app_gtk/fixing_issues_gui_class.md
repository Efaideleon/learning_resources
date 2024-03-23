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


## Message not being received

### diagnosis

Message is empty here, after being called by SendMessage()
```c
void PingServer(const char *Message, char *RecvBuf, int SocketFD)
```

### solution

``` c
char st[500]; // not initialized correctly
//should be:
char st[500] = {};
```

## message not being sent or received

* request_message() in WindowManager.c is alway getting called like it's supposed to

* putting a breakpoint after clicking the Sent buton in the ChatWindow
* it's sending the message, and returns "sucess"
* Trying by using the request message button in the ChatWindow
  * shows no message received
* there was an error with opening the files that we fixed by using the abosulte path instead
* now the AcceptFriend popup window appears instantly on the friend_list window
  * OpenDialog varialbe in message_service was not initialized to 0 at the moment of cration
* maybe the request function is not getting called because the friend list ui is still open

### BUGS FIXED

* the ChatFlag and FriendFlag in CreateWindow() needed to be updated before every if statement
* was forgetting to destroy the window widget; now implemented
* To check if a string is empty compare the first character to '\0' 
* response[0] == '\0` //empty

## messages being received but sometimes shown to itself and accept friend request appear

* No solution found? fixed itself?

## The friend_request_widget_ui is null when closing the add friend window

```c
void destroy_friend_request_widget_ui(GtkWidget *widget, gpointer data)
{
    FriendRequestProxyData *friend_request_proxy_data = (FriendRequestProxyData*)data;
    gtk_widget_destroy(friend_request_proxy_data->friend_request_widget_ui->window);
    free(friend_request_proxy_data->friend_request_widget_ui);
}
```

### Fix

* made the `friend_request_widget_window` a global variable in the `friend_request_widget` file

## friend request are not beind received or sent

* message are being sent correct and the server does reply with Friend Request Sent
* the problem must lie with the recieiving friend request messages
  
### Fix

* it was working, the problem was that the friend request was being sent to itself

## updating friend_list_ui after accepting friend request to both users 

* when user a sends a friend request to user b and user b accepts, then user b's name will appear in user a's and user a's name will appear in user b's
    * Not posible with the current server messager, we will need to send a message from user b to user a that user b has accept their friend request and add them as a friend
* Instead, when user b clicks on accept, they should add user a and their friendlist will reload when they click accept
* there is a function `update_contanct_list` in `FriendRequestHandler`, the `friend_request_widget_ui` can call this function since it depends on FriendRequestHandler and pass given reference. the question is if when we update the contanct array, will it be updated in the `friend_list_ui`?
* `FriendList();` returns "\a\x9c" so nothing has been added to the friend list?
**Checking if the friendlist when its created in friendlistui is the same as the friendlist that gets passted to update_contact_list**

*it seems like the error appears when the second instance of guiapp sends the friend request to the first instance

### steps to add friends

1. only way to add friend:
2. user a sends friend requests to user b, user b accepts
3. user b sends to user a, user a accepts and program crashes
4. close both gui windows and quit the server
5. load the server and open the guis again, the friend names would appear int the friend_list_ui

## fixing error for when user b from guiapp2 sends friend request to user a (guiapp) it crashes the app

* in `send.c` on the `AcceptFriendRequest()` function during the first iteration of the while(findUser) loop, msgEntry->message is "addto efai"

* **possible explanation:** 
* the UserList contains the name "efai" then "abel"
* when "efai" (user a) sends the friend request

### fix

* add an if statement to check if `msgEntry->message` is not NULL so that there is no Bad memory exception.
* `msgEntry->message` contains the message from the sends to `addto name` add a user

## need the user to refresh their own friend list after accepting the friend request?

* this will add the friend name to their friend list
* the sender will not see that the other friend has accepted their friend request until they receive a friend request.

### Observations

* the friend's name does get added to the user's Physical friend list during the `AcceptFriendRequest()` function in send.c
* the gui is not updating to read from the physical list to reflect it on the screen instantly, only when the window is closed and opened again.
* **possible ideas to fix**
* we add a refresh button
* we'll need to re-read the physical friend list
* to do this we need to send a message to the server with the user name to retrive the current friend list.
* we'll need to modify the service to accept our message and send back the friend list
* The server will need to find the right user in the server from their username and send back the right friend list 
* The client will need to pass the username to the function pinging the server for the friend list
