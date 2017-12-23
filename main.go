package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<html><head><title>BLUE</title></head><body style=\"background-color: blue; color: white\"><h1>BLUE</h1><body><html>")
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Serving...")
	http.ListenAndServe(":8080", nil)
}
