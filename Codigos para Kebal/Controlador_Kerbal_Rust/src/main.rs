mod fases_de_lancamento;


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = fases_de_lancamento::inicia_comunicacao().await?;
    //* 
    fases_de_lancamento::aterricador(client.clone()).await?;;
    // */
    //fases_de_lancamento::teste(client.clone()).await?;

    Ok(())
}