loop{
    if telemetria.altitude.get() <= ditancia_de_queima(){
        auto_pilot.set_throttle(1.0).await?
    
    }
}


async fn ditancia_de_queima (delta_v: f64) -> Result<f64, Box<Erro>> {
    let distancia = delta_v ** 2 - vf2 / 2 * a
    

}