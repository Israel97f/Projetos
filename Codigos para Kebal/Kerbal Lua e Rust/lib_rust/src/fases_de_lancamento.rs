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
    velocidade_vertical: Stream<f64>,
    velocidade_horizontal: Stream<f64>,
    velocidade: Stream<f64>,
    impulso_especifico: Stream<f32>,
    altitude_superficie: Stream<f64>,
    posicao_retrograde: Stream<(f64, f64, f64)>,
}


pub async fn inicia_comunicacao() -> Result<Arc<Client>, Box<dyn std::error::Error>> {
    // Conectar ao servidor kRPC
    let client = Client::new("Launch Script", "127.0.0.1", 50000, 50001).await?;
    Ok(client) 
}


pub async fn lancamento_basico (client: Arc<Client>) 
-> Result<(), Box<dyn std::error::Error>> {
    let space_center = SpaceCenter::new(client);
    let vessel = space_center.get_active_vessel().await?;
    let telemetria = Telemetria::new(&vessel).await?;
    let control = vessel.get_control().await?;

    control.set_throttle(1.0).await?;
    control.set_sas(true).await?;

    println!("iniciando lançamento...");
    for s in 0..10 {
        println!("Lançamento em: {} segundos", 10 -s);
        tokio::time::sleep(std::time::Duration::from_secs(1)).await;
    }

    let auto_pilot = vessel.get_auto_pilot().await?;
    auto_pilot.engage().await?;
    control.activate_next_stage().await?;

    loop {
        let apoastro = telemetria.apoastro.get().await.unwrap_or(0.0);
        if apoastro > 10_000.0 {
            println!("Atingiu {} km de altitude! Cortando motores...", apoastro / 1000.0);
            break;
        }
    }
    Ok(())
}


pub async fn orbitador (client: Arc<Client>) 
-> Result<(), Box<dyn std::error::Error>> {
    let space_center = SpaceCenter::new(client);
    let vessel = space_center.get_active_vessel().await?;
    let telemetria = Telemetria::new(&vessel).await?;
    let auto_pilot = vessel.get_auto_pilot().await?;

    let control = vessel.get_control().await?;
    control.set_throttle(1.0).await?;
    control.set_sas(true).await?;

    // iniciando protocolo de órbita
    let _height_taguet = 100_000.0; // Altitude alvo para órbita (100 km)

    let valor_de_throttle: f32 = 
    telemetria.massa.get().await.unwrap_or(0.0_f32) * (telemetria.gravidade_superficial as f32) * 1.5 /
    telemetria.trust_maximo.get().await.unwrap_or(1.0_f32);

    control.set_throttle(valor_de_throttle).await?;
    control.set_sas(false).await?;
    auto_pilot.engage().await?;
    auto_pilot.target_pitch_and_heading(90.0, 90.0).await?;

    loop {
        let mut curva: f32 = ((_height_taguet - telemetria.altitude.get().await.unwrap_or(0.0_f64)) / _height_taguet) as f32;

        if curva < 0.0 {
            curva = 0.0
        }

        auto_pilot.target_pitch_and_heading(90.0 * curva, 90.0).await?;

        if telemetria.apoastro.get().await? >= _height_taguet {
            break;
        }
        print!("\x1B[2J\x1B[H"); // Limpa a tela e move o cursoR para o início
        println!("tempo para apoastro: {:.2} s", telemetria.tempo_para_apoastro.get().await.unwrap_or(0.0_f64));
    }

    loop {
        let orbital_speed_taguet: f64 = (telemetria.parametro_gravitacional / (telemetria.raio_equatorial + _height_taguet)).sqrt();
        let time_burn: f64 = (orbital_speed_taguet - telemetria.velocidade_orbital.get().await.unwrap_or(0.0_f64)) / 
        ((telemetria.trust_maximo.get().await.unwrap_or(0.0_f32) / telemetria.massa.get().await.unwrap_or(1.0_f32)) as f64);

        let proximidade_alvo: f64 = _height_taguet * (((_height_taguet - telemetria.altitude.get().await.unwrap_or(0.0_f64)) 
        / _height_taguet).clamp(0.0, 1.0));

        let mut curva: f64 = _height_taguet * proximidade_alvo / 
        ((_height_taguet * 0.8).powf(2.0) * (1.0 - ((proximidade_alvo) / (_height_taguet * 0.8)).powf(2.0)).sqrt());

        if curva > 80.0 {
            curva = 80.0; // Inicia com uma inclinação mais agressiva
        }
        
        auto_pilot.target_pitch_and_heading(curva as f32, 90.0).await?;

        if _height_taguet > telemetria.apoastro.get().await.unwrap_or(0.0_f64) &&
        telemetria.apoastro.get().await.unwrap_or(0.0_f64) > _height_taguet * 0.9 {

            let throttle_slow: f32 = telemetria.massa.get().await.unwrap_or(0.0_f32) * (telemetria.gravidade_superficial as f32) * 1.2 /
            telemetria.trust_maximo.get().await.unwrap_or(1.0_f32);

            control.set_throttle(throttle_slow).await?;
        } else if telemetria.apoastro.get().await.unwrap_or(0.0_f64) > _height_taguet {
            control.set_throttle(0.0).await?;
        }

        if time_burn / 2.0 < telemetria.tempo_para_apoastro.get().await.unwrap_or(0.0_f64) &&
        _height_taguet - telemetria.altitude_nivel_mar.get().await.unwrap_or(0.0_f64) < 4_000.0 {
            println!("Iniciando queima de inserção orbital...");
            control.set_throttle(1.0).await?;
            break;
        }

        telemetria.print().await;
        tokio::time::sleep(std::time::Duration::from_millis(300)).await;
    }

    loop {
        let mut direção = -0.5;
        if telemetria.apoastro.get().await.unwrap_or(0.0_f64) > _height_taguet * 1.015 {
            direção = -5.0; // Diminuir apoastro
        } else if telemetria.apoastro.get().await.unwrap_or(0.0_f64) < _height_taguet * 0.985 {
            direção = 5.0; // Aumentar apoastro
        }

        auto_pilot.target_pitch_and_heading(direção, 90.0).await?;
        if (telemetria.apoastro.get().await.unwrap_or(0.0_f64) - telemetria.periastro.get().await.unwrap_or(0.0_f64)).abs() < 2_000.0
        || telemetria.apoastro.get().await.unwrap_or(0.0_f64) > _height_taguet * 1.30 {
            println!("Órbita estabilizada!");
            control.set_throttle(0.0).await?;
            auto_pilot.disengage().await?;
            break;
        }
        
        telemetria.print().await?;
    }

    Ok(())
}


pub async fn aterricador (client: Arc<Client>) 
-> Result<(), Box<dyn std::error::Error>> {
    let space_center = SpaceCenter::new(client);
    let vessel = space_center.get_active_vessel().await?;
    let telemetria = Telemetria::new(&vessel).await?;
    let control = vessel.get_control().await?;
    let auto_pilot = vessel.get_auto_pilot().await?;
    auto_pilot.set_sas_mode(krpc_client::services::space_center::SASMode::Retrograde).await?;

    let mut primeira_vez = true;
    let mut angulo_de_ataque_inicial = 0.0;
    let twr = telemetria.trust_maximo.get().await? / (telemetria.massa.get().await? * telemetria.gravidade_superficial as f32);

    loop{

        if telemetria.altitude_superficie.get().await? <= distancia_de_queima(25.0 * 
            (angulo_de_ataque_inicial as f64).cos(), &telemetria).await? + 70.0{
            let throttle: f32;

            let angulo_de_ataque_atual = (telemetria.velocidade_vertical.get().await? / 
                telemetria.velocidade_horizontal.get().await?).atan() as f32;

            if primeira_vez { 
                angulo_de_ataque_inicial = angulo_de_ataque_atual;
                primeira_vez = false;
            }

            if telemetria.velocidade_vertical.get().await? < -25.0 {
                throttle = telemetria.massa.get().await? * (telemetria.gravidade_superficial as f32) * 
                (twr * (angulo_de_ataque_inicial - angulo_de_ataque_atual).cos()) / telemetria.trust_maximo.get().await?;
            } else {
                 throttle = telemetria.massa.get().await? * (telemetria.gravidade_superficial as f32) * 
                (1.02) / telemetria.trust_maximo.get().await?;
            }
            control.set_throttle(throttle).await?
        
        }

        if telemetria.velocidade_vertical.get().await? > -0.5 {
            let throttle = telemetria.massa.get().await? * (telemetria.gravidade_superficial as f32) * 0.8 / 
            telemetria.trust_maximo.get().await?;
            control.set_throttle(throttle).await?;
        }

        if telemetria.velocidade.get().await? <= 25.0 {
            pouso(&vessel).await?;
            break;
        }
    }

    Ok(())
}


async fn pouso (vessel: &krpc_client::services::space_center::Vessel) -> Result<(), Box<dyn std::error::Error>> {
    let telemetria = Telemetria::new(&vessel).await?;
    let control = vessel.get_control().await?;
    let auto_pilot = vessel.get_auto_pilot().await?;

    auto_pilot.target_pitch_and_heading(90.0, 90.0).await?;
    auto_pilot.engage().await?;
    vessel.get_control().await?.set_gear(true).await?;

    let mut primeira_vez = true;

    loop {

        if telemetria.velocidade_horizontal.get().await? > 3.0 {
            if primeira_vez {
                auto_pilot.disengage().await?;
                auto_pilot.set_sas_mode(krpc_client::services::space_center::SASMode::Retrograde).await?;
                println!("teste de passagem");
                primeira_vez = false;
            }
        } else {
            // caso contrário, mantém vertical
            auto_pilot.target_pitch_and_heading(90.0, 90.0).await?;
            auto_pilot.engage().await?;
        }

        let mut throttle = telemetria.massa.get().await? as f64 * telemetria.gravidade_superficial /
        telemetria.trust_maximo.get().await? as f64;

        if telemetria.velocidade.get().await? < 3.0 {
            throttle *= 0.999;
        } else if telemetria.velocidade.get().await? < 15.0 {
            throttle *= 1.1;
        } else {
            throttle *= 1.5;
        }

        if telemetria.velocidade_vertical.get().await? > -0.5 {
            throttle *= 0.8;
        }

        control.set_throttle(throttle as f32).await?;

        if telemetria.altitude_superficie.get().await? <= 37.0 &&
        (telemetria.velocidade_vertical.get().await?).abs() <= 3.0 {
            control.set_throttle(0.0).await?;
            break;
        }
    }

    Ok(())
}


async fn distancia_de_queima (velocidade_final: f64, telemetria: &Telemetria)
-> Result<f64, Box<dyn std::error::Error>> {

    let v_inicial: f64 = telemetria.velocidade_vertical.get().await?;
    let acelerecao: f64 = ((telemetria.velocidade_vertical.get().await? / 
    telemetria.velocidade.get().await?).abs() * (telemetria.trust_maximo.get().await? as f64 /
    telemetria.massa.get().await? as f64)) - telemetria.gravidade_superficial;
    let distancia: f64 = (v_inicial.powi(2) - velocidade_final.powi(2)) / (2.0 * acelerecao).abs();
    println!("Distancia de queima: {:.2} m", distancia);
    Ok(distancia)
}
    
impl Telemetria {
    async fn new (vessel: &krpc_client::services::space_center::Vessel) -> Result<Telemetria, Box<dyn std::error::Error>> {
        // stream de altitude
        let flight = vessel.flight(None).await?;
        let orbit = vessel.get_orbit().await?;
        let body = orbit.get_body().await?;
        let veloref_flight = body.get_reference_frame().await?;
        let veloref_orbit = body.get_orbital_reference_frame().await?;

        let gravitational_parameter = body.get_gravitational_parameter().await?;
        let equatorial_radius = body.get_equatorial_radius().await?;
        let surface_gravity = body.get_surface_gravity().await?;

        let mass_stream = vessel.get_mass_stream().await?;
        let max_trust = vessel.get_max_thrust_stream().await?;
        let altitude_stream = flight.get_mean_altitude_stream().await?;
        let altitude_superficie = flight.get_surface_altitude_stream().await?;
        let apoapsis_stream = orbit.get_apoapsis_altitude_stream().await?;
        let periapsis_stream = orbit.get_periapsis_altitude_stream().await?;
        let time_apoapsis_stream = orbit.get_time_to_apoapsis_stream().await?;
        let speed_orbit_stream = vessel.flight(Some(&veloref_orbit)).await?.get_speed_stream().await?;
        let height_seia_level_stream = vessel.flight(Some(&veloref_flight)).await?.get_mean_altitude_stream().await?;
        let velocidade_vetical = vessel.flight(Some(&veloref_flight)).await?.get_vertical_speed_stream().await?;
        let velocidade_horizontal = vessel.flight(Some(&veloref_flight)).await?.get_horizontal_speed_stream().await?;
        let velocidadde = vessel.flight(Some(&veloref_flight)).await?.get_speed_stream().await?;
        let impulso_especifico = vessel.get_specific_impulse_stream().await?;
        let posicao_retrograde = vessel.flight(Some(&veloref_flight)).await?.get_retrograde_stream().await?;

        altitude_stream.set_rate(5.0).await?;
        mass_stream.set_rate(5.0).await?;
        apoapsis_stream.set_rate(5.0).await?;
        periapsis_stream.set_rate(5.0).await?;
        max_trust.set_rate(5.0).await?;
        speed_orbit_stream.set_rate(5.0).await?;
        time_apoapsis_stream.set_rate(5.0).await?;
        height_seia_level_stream.set_rate(5.0).await?;


        // Aguarda um pouco para as streams serem populadas
        tokio::time::sleep(std::time::Duration::from_millis(100)).await;

        Ok(Self {
            altitude: altitude_stream,
            massa: mass_stream,
            gravidade_superficial: surface_gravity,
            apoastro: apoapsis_stream,
            trust_maximo: max_trust,
            parametro_gravitacional: gravitational_parameter,  
            raio_equatorial: equatorial_radius,
            periastro: periapsis_stream,
            velocidade_orbital: speed_orbit_stream,
            tempo_para_apoastro: time_apoapsis_stream,
            altitude_nivel_mar: height_seia_level_stream,
            velocidade_vertical: velocidade_vetical,
            velocidade_horizontal: velocidade_horizontal,
            velocidade: velocidadde,
            impulso_especifico: impulso_especifico,
            altitude_superficie: altitude_superficie,
            posicao_retrograde: posicao_retrograde,
        })
    }


    async fn print(&self) -> Result<(), Box<dyn std::error::Error>> {
        // Coleta todos os valores primeiro para garantir que não há erros antes de limpar/imprimir
        let altitude = self.altitude.get().await?;
        let massa = self.massa.get().await?;
        let apoastro = self.apoastro.get().await?;
        let periastro = self.periastro.get().await?;
        let velocidade_orbital = self.velocidade_orbital.get().await?;
        let tempo_para_apoastro = self.tempo_para_apoastro.get().await?;
        let altitude_nivel_mar = self.altitude_nivel_mar.get().await?;
        let trust_maximo = self.trust_maximo.get().await?;
        
        // Agora que todos os dados foram obtidos com sucesso, limpa a tela e imprime
        //print!("\x1B[2J\x1B[H"); // Limpa a tela e move o cursor para o início
        println!("Altitude: {:.2} m", altitude);
        println!("Massa: {:.2} kg", massa);
        println!("Gravidade Superficial: {:.2} m/s²", self.gravidade_superficial);
        println!("Apoastro: {:.2} m", apoastro);
        println!("Periastro: {:.2} m", periastro);
        println!("Velocidade Orbital: {:.2} m/s", velocidade_orbital);
        println!("Tempo para Apoastro: {:.2} s", tempo_para_apoastro);
        println!("Altitude Nível do Mar: {:.2} m", altitude_nivel_mar);
        println!("Trust Máximo: {:.2} N", trust_maximo);
        println!("velocidade Vertical: {:.2} m/s", self.velocidade_vertical.get().await?);
        println!("velocidade Horizontal: {:.2} m/s", self.velocidade_horizontal.get().await?);
        println!("velocidade: {:.2} m/s", self.velocidade.get().await?);

        Ok(())
    }
}

fn normalize(v: (f32, f32, f32)) -> (f32, f32, f32) {
    let len = (v.0 * v.0 + v.1 * v.1 + v.2 * v.2).sqrt();
    if len == 0.0 {
        (0.0, 0.0, 0.0)
    } else {
        (v.0 / len, v.1 / len, v.2 / len)
    }
}

fn scale(v: (f32, f32, f32), factor: f32) -> (f32, f32, f32) {
    (v.0 * factor, v.1 * factor, v.2 * factor)
}

fn add(a: (f32, f32, f32), b: (f32, f32, f32)) -> (f32, f32, f32) {
    (a.0 + b.0, a.1 + b.1, a.2 + b.2)
}

async fn fuel_check(vessel: &krpc_client::services::space_center::Vessel) ->
Result<(), Box<dyn std::error::Error>> {
    let engines = vessel.get_parts().await?.get_engines().await?;
    let mut has_fuel = false;

    for engine in engines {
        if engine.get_has_fuel().await? {
            has_fuel = true;
            break;
        }
    }

    if has_fuel {
        vessel.get_control().await?.set_throttle(0.0).await?;
        tokio::time::sleep(std::time::Duration::from_secs(1)).await;
        vessel.get_control().await?.activate_next_stage().await?;
        tokio::time::sleep(std::time::Duration::from_secs(1)).await;
        vessel.get_control().await?.set_throttle(1.0).await?;
    }
    Ok(())
}


pub async fn teste (client: Arc<Client>) -> Result<(), Box<dyn std::error::Error>> {
    let space_center = SpaceCenter::new(client);
    let vessel = space_center.get_active_vessel().await?;
    let telemetria = Telemetria::new(&vessel).await?;
    let auto_pilot = vessel.get_auto_pilot().await?;

    let retrograde = telemetria.posicao_retrograde.get().await?;
    let retro_vec = normalize((retrograde.0 as f32, retrograde.1 as f32, retrograde.2 as f32));

    // vetor vertical (para cima)
    let up = (1.0, 0.0, 0.0);

    // queremos desviar 10° da vertical em direção ao retrograde
    let angulo = 30f32.to_radians();

    // combinação linear: direção = cos(θ)*up + sin(θ)*retrograde
    let target = normalize(add(scale(up, angulo.cos()), scale(retro_vec, angulo.sin())));

    println!("Ajustando para direção inclinada: ({:.2}, {:.2}, {:.2})", target.0, target.1, target.2);


    loop {
        let retrograde = telemetria.posicao_retrograde.get().await?;
        let x = retrograde.0;
        let y = retrograde.1;
        let z = retrograde.2;
        let angulo = ((x).atan2(y) * 180.0 / std::f64::consts::PI) as f32;
        let angulo0 = ((-z).atan2(-y) * 180.0 / std::f64::consts::PI) as f32;
        println!("Posição Retrograde: ({:.2}, {:.2}, {:.2})", x, y, z);
        // envia vetor alvo para o autopilot
        auto_pilot.target_pitch_and_heading(angulo0 - 40.0, angulo).await?;
        //auto_pilot.set_target_direction((target.0 as f64, target.1 as f64, target.2 as f64)).await?;
        auto_pilot.set_deceleration_time((0.5, 0.5, 0.5)).await?;
        auto_pilot.set_attenuation_angle((0.5, 0.5, 0.5)).await?;
        auto_pilot.engage().await?;
    }
}
