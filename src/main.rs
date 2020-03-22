/* Tested at 1000rps: p50 3ms, p99 33ms, 40% of a 2GHz AMD Turion(tm) II Neo N54L */

extern crate chrono;
extern crate tiny_http;

use std::env;

fn main() {
    let start = chrono::Utc::now();
    let colour = env::var("COLOUR").expect("Please supply a colour");
    let html = format!("<html><head><title>{c}</title></head><body style=\"background-color: {c}; color: white\"><h1>{c}</h1><body><html>", c=colour);
    let json = format!("{{ \"colour\": \"{c}\" }}", c = colour); // Not taking on the heft of serde for this

    let server = tiny_http::Server::http("0.0.0.0:8080").expect("Can't start server");
    println!("Listening on {:?}", server.server_addr());

    for request in server.incoming_requests() {
        if request.url().starts_with("/live") && (chrono::Utc::now() - start).num_seconds() < 5 {
            let response = tiny_http::Response::new_empty(tiny_http::StatusCode(500));
            let _ = request.respond(response);
        } else {
            let (r, t) = if request.url().starts_with("/api") {
                (json.clone(), "Content-Type: application/json")
            } else {
                (html.clone(), "Content-Type: text/html")
                /* this will also reply 200 to [/healthz,/live], so that's "fine" */
            };
            let response = tiny_http::Response::from_string(r)
                .with_header(t.parse::<tiny_http::Header>().unwrap());
            let _ = request.respond(response);
        }
    }
}
