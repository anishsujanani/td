# td

```
td: command-line to-do
Usage: td [options]

Raw content written to ~/.td/tasks

GNU sed is needed - default on most Linux installations,
needs to be installed on MacOS with homebrew

Options:
-a item 	Add a new to-do item; returns an item ID
-x item_hash	Mark an item done
-l		List (pending) to-do items
-L		List (all) to-do items

Examples:
td -a "push code"
td -l
td -x d8e8
td -L

- Anish Sujanani, 2023
```

Tested on Debian and OSX.
