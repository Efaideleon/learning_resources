# Software Architecture

## Software Architecture Layer Pattern

### Presentation Layer

* The prsetnation layer is the topmost layer and is responsible for handling user interaction and presenting information to the user

* **Examples:** HTML, CSS, and JavaScript that render the user interface in the browser

### Business Logic Layer

* It implements the application's specific functionalities, processing user requests, and performing calulations or manipulations

* This layer is often divided into sub-layers like service layer, domain layer, or business logic layer
  
* **Examples:** User authentication, order processing, product recommendations

### Persistence Layer

* It abstracts the detials of data storage and retriveal opeartions from the ret of the application

* **Examples:** Data Access Objects (DAOs), Data access libraries (e.g., JDBC for JAVA), file I/O operations

### Database Layer

* This layer physcially stores the application's data. It can be relational database

* **Examples:** MySQL, NoSQL database(e.g, MongoDB) or any other data storage system