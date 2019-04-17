#!/usr/bin/awk -f

(NR % 2) {
	print "\033[34m"$0"\033[0m";
}

!(NR % 2) {
	print
}
