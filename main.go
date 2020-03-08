package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

const addr = ":8080"

var colour string

func handler(w http.ResponseWriter, r *http.Request) {
	//w.Header().Set("Cache-Control", "no-store")
	//w.Header().Set("Date", time.Now().Format("Mon, 2 Jan 2006 15:04:05 MST"))
	//TODO: try ETag?
	html := fmt.Sprintf("<html><head><title>%[1]s</title></head><body style=\"background-color: %[1]s; color: white\"><h1>%[1]s</h1><body><html>", colour)
	fmt.Fprintf(w, html)
}

func main() {
	colour = strings.ToUpper(os.Getenv("COLOUR"))

	http.HandleFunc("/", handler)
	log.Printf("Serving in on %s...\n", addr)
	http.ListenAndServe(addr, nil)
}
