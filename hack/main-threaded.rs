/* Example for the lols.
 * This really is never meant to handle high load though, and it just complicates the code (and adds 8k to the image!)
 */
extern crate num_cpus;
extern crate tiny_http;

use std::env;
use std::sync::Arc;
use std::thread;

fn main() {
    let colour = env::var("COLOUR").expect("Please supply a colour");
    let body = format!("<html><head><title>{c}</title></head><body style=\"background-color: {c}; color: white\"><h1>{c}</h1><body><html>", c=colour);

    let server = Arc::new(tiny_http::Server::http("0.0.0.0:8080").expect("Can't start server"));
    println!("Listening on {:?}", server.server_addr());

    let cpus = num_cpus::get();
    let mut handles = Vec::with_capacity(cpus);
    println!("spawning {} threads", cpus);

    for _ in 0..cpus {
        let server = server.clone();
        let body = body.clone();

        handles.push(thread::spawn(move || loop {
            let request = server.recv().unwrap();
            let response = tiny_http::Response::from_string(body.clone()).with_header(
                "Content-Type: text/html"
                    .parse::<tiny_http::Header>()
                    .unwrap(),
            );
            let _ = request.respond(response);
        }));
    }

    for g in handles {
        g.join().unwrap();
    }
}
