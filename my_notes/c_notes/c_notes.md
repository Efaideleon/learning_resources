# C NOTES

## Copying `char[]` by reference

```c
int main() {
    char a[10] = { 'a', 'b', 'c'};
    char *b = a; // desn't need &a
    b[0] = 'z';
    printf("%c\n", a[0]); // prints z
    return 0;
}
```

## Comparing char * to NULL

if you have 

```c
    char *name;

    // WRONG:
    if (*name != NULL) // dereferencing name when it could be null crashes the program

    // CORRECT: 
    if (name != NULL) // is name pointing to NULL
```

## In gtk function calling from buttons

This two signals might be called out of order

```c
    g_signal_connect(login_window_ui->button, "clicked", G_CALLBACK(get_name_and_password), credentials_data);
    g_signal_connect(login_window_ui->button, "clicked", G_CALLBACK(login_in_user), credentials_data);
```

## `static` keyword

* `static` in front of a variable makes it retain its value until the program ends
* `static in front of a function limits the scope of the function to only that file

## Passing pointer by reference vs value

In C, when you pass arguments to a function, they are passed by value. This means that a copy of the argument is created and passed to the function. Any changes made to the argument within the function only affect the copy, not the original variable.

### Passing by reference

```c
void CreateWindow(ApplicationManager *app_manager, LoginWindowUI **login_window_ui, ChatWindowUI **chat_window_ui, FriendListUI **friend_list_ui) {
    // ...
    if ((ChatFlag == 1) && (*chat_window_ui == NULL)) {
        // ...
        *chat_window_ui = create_chat_window_ui(); // Assign to the dereferenced pointer
        // ...
    }
    // ...
}

CreateWindow(application_manager, &login_window_ui, &chat_window_ui, &friend_list_ui);
```

## Changing a value by reference

```c
void changeValue(int *value) {
    *value = 10; // Dereference the pointer to change the value of the variable it points to
}

int main() {
    int num = 5;
    printf("Before: %d\n", num);
    changeValue(&num); // Pass the address of num to the function
    printf("After: %d\n", num);
    return 0;
}
```

## Initializing all value in a char array to NULL character

```c
    char st[500] = {}; // withouth {} strcat adds "sendto" to a random part of the array
    strcat(st, "sendto "); // will add "sendto" to the beginning of the array
    strcat(st, send_to_user_name);
    strcat(st, " ");
    strcat(st, sent_message);
```

## Initialize values in struct

```c
typedef struct
{
    int age;
}Person;

// here age is undefined
// it will cause error when comparing
Person abel;
if (abel.age == 0) { // will cause unpredictable behaviour
    // do something
}
```

* usually when something works and something doesn't is because a variable is not initialized and there is a comparision somewhere

## Two pointers pointers pointing the same address; changing the one the address one of those pointers points to

* The connection between two pointers is broken when one of the pointers is asisgned a new adress.

```c
    for (int i = 0; i < 10; i++)
    {
        chat_window_ui->message_buffer[i] = gtk_text_buffer_new(NULL); // Create new buffers
        chat_window_proxy_data->message_buffer[i] = chat_window_ui->message_buffer[i];
    }

    // here the message_buffer pointer now points to a different address
    chat_window_ui->message_buffer[i] = gtk_text_view_get_buffer(GTK_TEXT_VIEW(chat_window_ui->text_area[i]));

    gtk_text_buffer_set_text(chat_window_ui->message_buffer[i], "Hello!", -1);

    // chat_window_ui_proxy_data will not be updated to point to that new adress
    // it will keep pointing the previous adress and will be out os sync from the chat_window_ui->message_buffer[] pointer
```

## Emptry string vs NULL initiazlied string

* The reponse string when using `strstr()` should be assigned to something that can't be an entered username
* when creating a username will need to check that it's not equal to whatever reposnse is assigned to

```c
    char response[400] = {}; //this fills everything with '\0' characters

    strcpy(response, " "); // this assigns the char array to an empty string

    // PRINTS ???
    char content[] = {'e', 'f', 'a', 'i', '\n', '\0', '\0'};
    char response [7] = {};
    if (strstr(content, response))
    {
            printf("???\n");   // '\0' is in reponse and content
    }

    // DOES NOT PRINT ???
    char content[] = {'e', 'f', 'a', 'i', '\n', '\0', '\0'};
    char response [7] = {};
    strcpy(response, " "); // assigns empty string to reponse
    if (strstr(content, response)) // empty string is not in content
    {
            printf("???\n");   
    }

    // PRINTS ???
    char content[] = {'e', 'f', 'a', 'i', '\n', ' ', '\0'};
    char response [7] = {};
    strcpy(response, " "); // there is an empty string in content 
    if (strstr(content, response))
    {
            printf("???\n");   
    }
```

## Variables in header files should not be initialized

* variables are only defined but not declared in a header file
* if there are declared they wil cause a linking error when compiling

## Passing a `char *name = NULL` as a parameter to a function

```c
char *name = NULL;
void function(char *arg);

function(name); // this is dangarous since name is NULL and we don't know if memory is going to be allocated to it or not

```

we should always pass an initialied char array such as:

```c
char *name = malloc(300 * sizeof(char));
char name[300] = {};
```