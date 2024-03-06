CC = gcc
CFLAGS = -Wall -ansi -std=c99

# List of all the .c files
MAIN_FOLDER_C_FILES = main_folder/src/main.c 
SUB_FOLDER_C_FILES = Sub_Folder/src/sub_file.c Sub_Folder/src/sub_file_copy.c

# Source directories
SUB_FOLDER_SRC_DIR = Sub_Folder/src
MAIN_FOLDER_SRC_DIR = main_folder/src

# Object directories
MAIN_FOLDER_OBJ_DIR = main_folder/objs
SUB_FOLDER_OBJ_DIR = Sub_Folder/objs


# All object files from main_folder and Sub_Folder
ALL_OBJS = $(patsubst $(MAIN_FOLDER_SRC_DIR)/%.c,$(MAIN_FOLDER_OBJ_DIR)/%.o,$(MAIN_FOLDER_C_FILES)) $(patsubst $(SUB_FOLDER_SRC_DIR)/%.c,$(SUB_FOLDER_OBJ_DIR)/%.o,$(SUB_FOLDER_C_FILES))


#Compiling files
all: main

# Executable
main: $(ALL_OBJS)
	$(CC) $(CFLAGS) $(ALL_OBJS) -o main 

# Pattern rule for compiling .c files to .o files
# Creating object files in Sub_Folder
$(SUB_FOLDER_OBJ_DIR)/%.o: $(SUB_FOLDER_SRC_DIR)/%.c $(wildcard SUB_FOLDER_SRC_DIR/*.h)   
	$(CC) $(CFLAGS) -c $< -o $@ 

# Creating object files in main_folder
$(MAIN_FOLDER_OBJ_DIR)/%.o: $(MAIN_FOLDER_SRC_DIR)/%.c $(wildcard MAIN_FOLDER_SRC_DIR*.h)  
	$(CC) $(CFLAGS) -c $< -o $@ 

# Removing all files
clean:
	rm -f *.o $(SUB_FOLDER_OBJ_DIR)/*.o $(MAIN_FOLDER_OBJ_DIR)/*.o