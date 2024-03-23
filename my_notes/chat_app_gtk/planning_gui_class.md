# Planning Next Tasks Chat GUI Gtk

## Creating Chat Window

### Overview

When the user clicks on a friend's name on their contact list it will open the ChatWindowUI

The ChatWindowUI depends on the MessageService

1. We need to create the actual window using gtk
2. link the current function G_Callbacks to become proxy functions that will call the actual functions from the MessageService
3. Implement/Refactor the MessageService Function such that they depend on the MessageService struct attributes and NetworkService attributes

## FriendRequestWindowUI

### Overview
This is the window that when the user click on the + sign it opens to send a friend request to an user whose name is entered

## ChatWindow

**Proxy functions to implement:**

* `send_message()`
* `delete_chat_window()`
* `request_message()`
* `create_friend_window()` // removed
* `accept_friend()` // removed, may be implement in the future
* `remove_book()` // removed

Make sure to pass the Data to the G_Callback functions
