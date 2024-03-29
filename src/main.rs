/* Tested at 1000rps: p50 3ms, p99 33ms; 40% of a 2.2GHz AMD Turion(tm) II Neo N54L */

use signal_hook::{consts::signal::*, iterator::Signals};
use std::env;
use std::error::Error;
use std::io::Cursor;
use std::thread;

fn main() -> Result<(), Box<dyn Error>> {
    let sigs = [SIGHUP, SIGTERM, SIGINT, SIGQUIT];
    let mut signals = Signals::new(&sigs)?;

    thread::spawn(move || {
        for s in signals.forever() {
            println!("Caught signal {:?}; quitting", s);
            std::process::exit(0);
        }
    });

    // TODO expose color on prom
    // TODO expose error rate on prom
    // TODO all this error rate - this should be an output option for badpod
    // TODO take error rate on cmdline
    // TODO do actually try Serde and see what the resulting binary size is with all the LTO turned on

    let start = chrono::Utc::now();
    let colour = env::var("COLOUR").expect("Please supply a colour");
    let html = format!(
        "\
<html>
    <head>
        <title>{c}</title>
    </head>
    <body style=\"background-color: {c}; color: white\">
        <h1>{c}</h1>
    <body>
<html>",
        c = colour
    );
    let json = format!(r#"{{ "colour": "{c}" }}"#, c = colour); // Not taking on the heft of serde for this
                                                                // TODO try it with LTO and see how much bigger it really gets

    let server = tiny_http::Server::http("0.0.0.0:8080").expect("Can't start server"); // TODO add logging library and do JSON / text
    println!("[{}] Listening on {:?}", colour, server.server_addr());

    for request in server.incoming_requests() {
        println!("[{}] {:?}", colour, request);

        if request.url().starts_with("/ready") && (chrono::Utc::now() - start).num_seconds() < 5 {
            let response = tiny_http::Response::empty(tiny_http::StatusCode(500));
            let _ = request.respond(response);
        } else {
            let (r, t) = if request.url().starts_with("/api") {
                (json.clone(), "Content-Type: application/json")
            } else {
                (html.clone(), "Content-Type: text/html; charset=UTF-8")
                /* NB: this will also reply 200 to any other path, including /live or whatever */
                // TODO: handle /healthz and /readyz, return json with status ok, color foo
                // TODO change to US eng everywhere
                // TODO read color as args[1]
                // TODO parse flags: --port, --color
            };
            let l = Some(r.len());
            /* There is a ::from_string() but that sets a `Content-Type: text/plain` which you
             * can't get rid of. */
            let response = tiny_http::Response::empty(tiny_http::StatusCode(200))
                .with_header(t.parse::<tiny_http::Header>().unwrap())
                .with_data(Cursor::new(r.into_bytes()), l);
            let _ = request.respond(response);
        }
    }

    Ok(())
}
