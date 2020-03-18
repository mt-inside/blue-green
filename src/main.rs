extern crate tiny_http;

use std::env;

fn main() {
    let colour = env::var("COLOUR").expect("Please supply a colour");
    let body = format!("<html><head><title>{c}</title></head><body style=\"background-color: {c}; color: white\"><h1>{c}</h1><body><html>", c=colour);

    let server = tiny_http::Server::http("0.0.0.0:8080").expect("Can't start server");
    println!("Listening on {:?}", server.server_addr());

    for request in server.incoming_requests() {
        let response = tiny_http::Response::from_string(body.clone()).with_header(
            "Content-Type: text/html"
                .parse::<tiny_http::Header>()
                .unwrap(),
        );
        let _ = request.respond(response);
    }
}
