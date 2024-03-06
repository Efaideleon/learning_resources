# C Programming Style Guide

This style guide provide recommendations for writing consistent, clean, and maintainable C code. Following these guidelines will help you and your tam produce code that is easier to understand, debug, and collabaorate on.

## General Principles

* **Clarity:** Strive for code that is easy to read and understand. Avoid overly complex constructs and prioritize readability over cleverness.
* **Consistency:** Maintain a consistent coding style throughout your project. This include naming conventions, formatting, and indentation.
* **Modularity:** Break your code into well-defined functions and modules. This improves organization and resuability.
* **Documentation:** Write clear and concise comments to explain the purpose of your code and how it works.

## Naming Conventions

### Variables and Functions

* Use `lowercase_with_underscores` for variable and function names.
* Choose descriptive and meaningful names that reflect the purpose of the variable or function.
* Avoid abbreviations or jargon that might be unclear to others.
* Examples:

```c
int user_age;
void calculate_average(ing *array, int size);
```

### Constants

* Use UPPERCASE_WITH_UNDERSCORES for constant names.
* Example:

```c
const int MAX_VALUE = 100;
```

### Structs Names

* PascalCase: This is the most common convention for naming structs in C. It involves capitalizing the first letter of each word in the name, with no underscoes.
* Examples: `Point`, `LinkedListNode`, `EmployeeRecord`

### File and Folder Names

* Use `lowercase_with_underscores` for file and folder names.
* Choose descriptive names that reflect the content of the file or folder.
* Examples:

`data_processing.c`
`network_utils.h`
`user_interface (folder)`

## Fomatting

* Use 4 spaces for indentation.
* Place spaces around operator and after commas.
* Use curly braces even for single-line blocks.
* Break long lines at logical points, preferably after operators.
* Example:

```c
int calculate_sum(int a, int b) 
{
    return a + b;
}
```

## Comments

* Write comments to explain the purpose of the code and how it works.
* Use sentence case for comments.
* Add a period at the end of sentence-like comments.
* Update comments when you modify the code.
* Examples:

```c
// This function takes two integers as input and returns their sum.`
int calculate_sum(int a, int b) 
{
    return a + b;
}
```

ADD SYNTAX FOR STRUCTS AND OBJECTS

## Additional Tips

* Use meaninful variable names instead of single-letter variables
* Avoid magic numbers (hardcoded values without explanation). Use constants or variables with descriptive names instead.
* Check for memory leaks and other potential errors using tools like Valgrind.
* Write unit test to verify the correctness of your code.
* By following these guidelines, you can write clean, consistent, and maintainble C code that is easier to understand and work with.
