package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/gabriel-vasile/mimetype"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("A name of file wasn't specified.")
		os.Exit(0)
	}

	var nameOfSourceFile = os.Args[1]
	description, errorStat := os.Stat(nameOfSourceFile)

	if errorStat != nil {
		fmt.Println("Unable to get a description about the file with the specified name.")
		os.Exit(1)
	}

	if os.IsNotExist(errorStat) {
		fmt.Println("A file with specified name doesn't exist.")
		os.Exit(2)
	}

	if !description.Mode().IsRegular() {
		fmt.Println("Specified file isn't regular.")
		os.Exit(3)
	}

	pointerToTypeOfContent, errorDetect := mimetype.DetectFile(nameOfSourceFile)

	if errorDetect != nil {
		fmt.Println("Fail to detect a type of the file content.")
		os.Exit(4)
	}

	typeOfContent := pointerToTypeOfContent.String()

	if !strings.HasPrefix(typeOfContent, "text/plain") {
		fmt.Println("Unsupported file content type")
		os.Exit(5)
	}

	fmt.Println(typeOfContent)
}
