mod fases_de_lancamento;
use std::sync::Arc;


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let (client, telemetria) = fases_de_lancamento::inicia_comunicacao().await?;
    fases_de_lancamento::lancamto_basico(client.clone(), Arc::clone(&telemetria)).await?;
    fases_de_lancamento::orbitador(client.clone(), Arc::clone(&telemetria)).await?;
    Ok(())
}