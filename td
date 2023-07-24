#!/bin/bash

usage() {
	echo "
td: command-line to-do 
Usage: td [options]

Raw content written to ~/.td/tasks

GNU sed is needed - default on most Linux installations,
needs to be installed on MacOS with homebrew

Options:
-a item 	Add a new to-do item
-x item_hash	Mark an item done
-l		List (pending) to-do items
-L		List (all) to-do items

Examples:
td -a \"push code\"
td -l
td -x d8e8 
td -L

- Anish Sujanani, 2023
"
exit 0
}

check_or_create_dir() {
	mkdir ~/.td > /dev/null 2>&1
	touch ~/.td/tasks
}

add() {
	if [[ $(uname) == "Darwin" ]]; then hash=$(md5 -qs "$1" | awk '{ print substr($1, 0, 4)  }'); fi
	if [[ $(uname) == "Linux" ]]; then hash=$(echo -n $1 | md5sum | awk '{ print substr($1, 0, 4)}'); fi
	echo -e "[ ][$hash] $1\n$(cat ~/.td/tasks)" > ~/.td/tasks
}

mark() {
	on_line=$(grep -n "\]\[$1\]\s" ~/.td/tasks | cut -d : -f 1)
	
	sedfunc=sed
	if [[ $(uname) == "Darwin" ]]; then sedfunc=gsed; fi
	
	# will handle duplicate tasks
	for i in $on_line; do 
		$sedfunc -i $(printf "%s%s" $i "s/\[\s\]/\[x\]/") ~/.td/tasks
	done
}

list() {
	listall | grep -v "\[x\]\["
}

listall() {
	cat ~/.td/tasks
}

check_macos_gsed_installed() {
	if [[ $(uname) == "Darwin" ]]; then
		if ! [[ -x "$(command -v gsed)" ]]; then
			echo "GNU sed is not installed; Install with: homebrew install gsed"
			exit 1
		fi
	fi
}

main() {
	if [[ "$#" == 0 ]]; then
		usage
		exit 0
	fi

	check_macos_gsed_installed
	check_or_create_dir

	while getopts "a:x:lLh" op; do
		case $op in
			a)   add "$OPTARG" ;;
			x)   mark "$OPTARG" ;;
			l)   list ;;
			L)   listall ;;
			h|*) usage ;;
		esac
	done
	shift $((OPTIND-1))
}

main "$@"
