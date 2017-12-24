package main

import (
	"fmt"
	"net/http"
	"os"
	"strings"
)

var colour string

func handler(w http.ResponseWriter, r *http.Request) {
	html := fmt.Sprintf("<html><head><title>%[1]s</title></head><body style=\"background-color: %[1]s; color: white\"><h1>%[1]s</h1><body><html>", colour)
	fmt.Fprintf(w, html)
}

func main() {
	colour = strings.ToUpper(os.Getenv("COLOUR"))

	http.HandleFunc("/", handler)
	fmt.Println("Serving...")
	http.ListenAndServe(":8080", nil)
}
