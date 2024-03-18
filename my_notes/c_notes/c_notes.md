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