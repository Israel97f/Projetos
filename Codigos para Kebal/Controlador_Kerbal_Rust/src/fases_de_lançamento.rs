use krpc_client::Client;
use krpc_client::services::space_center::SpaceCenter;
use krpc_client::stream::Stream;
use std::sync::Arc;

struct Telemetria {
    altitude: Stream<f64>,
    massa: Stream<f32>,
    gravidade_superficial: f64,
    apoastro: Stream<f64>,
    trust_maximo: Stream<f32>,
    parametro_gravitacional: f64,
    raio_equatorial: f64,
    velocidade_orbital: Stream<f64>,
    tempo_para_apoastro: Stream<f64>,
    altitude_nivel_mar: Stream<f64>,
    periastro: Stream<f64>,
}

pub async fn inicia_comunicacao() -> Result< Arc<Client>, Box<dyn std::error::Error>> {
    // Conectar ao servidor kRPC
    let client = Client::new("Launch Script", "127.0.0.1", 50000, 50001).await?;
    Ok(client)  
}


async fn telemetria(vessel: &krpc_client::services::space_center::Vessel) -> Result<Telemetria, Box<dyn std::error::Error>> {
    let flight = vessel.flight(None).await?;
    let orbit = vessel.get_orbit().await?;
    let body = orbit.get_body().await?;
    let veloref_flight = body.get_reference_frame().await?;
    let veloref_orbit = body.get_orbital_reference_frame().await?;

    let altitude = add_stream(flight.get_mean_altitude_stream()).await?;
    let massa = add_stream(vessel.get_mass_stream()).await?;
    let apoastro = add_stream(flight.get_apoapsis_altitude_stream()).await?;
    let trust_maximo = add_stream(vessel.get_max_thrust_stream()).await?;
    let velocidade_orbital = add_stream(vessel.flight(Some(&veloref_orbit)).get_orbital_speed_stream()).await?;
    let tempo_para_apoastro = add_stream(flight.get_time_to_apoapsis_stream()).await?;
    let altitude_nivel_mar = add_stream(flight.get_mean_altitude_stream()).await?;
    let periastro = add_stream(flight.get_periapsis_altitude_stream()).await?;

    Ok(Telemetria {
        altitude,
        massa,
        gravidade_superficial: body.get_surface_gravity().await?,
        apoastro,
        trust_maximo,
        parametro_gravitacional: body.get_gravitational_parameter().await?,
        raio_equatorial: body.get_equatorial_radius().await?,
        velocidade_orbital,
        tempo_para_apoastro,
        altitude_nivel_mar,
        periastro,
    })
}


async fn add_stream(service: Stream<f64>) -> Result<Stream<f64>, Box<dyn std::error::Error>> {
    let stream = service().await?;
    stream.set_rate(5.0).await?;
    Ok(stream)  
}
