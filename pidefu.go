package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("A name of file wasn't specified.")
		os.Exit(0)
	}

	var nameOfSourceFile = os.Args[1]
	description, pointerToError := os.Stat(nameOfSourceFile)

	if pointerToError != nil {
		fmt.Println("Unable to get a description about the file with the specified name.")
		os.Exit(0)
	}

	if os.IsNotExist(pointerToError) {
		fmt.Println("A file with specified name doesn't exist.")
		os.Exit(0)
	}

	if !description.Mode().IsRegular() {
		fmt.Println("Specified file isn't regular.")
		os.Exit(0)
	}
}
