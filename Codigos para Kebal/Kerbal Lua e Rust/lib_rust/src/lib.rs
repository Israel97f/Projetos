use krpc_client::Client;
use mlua::prelude::*;
use mlua::UserData;
use std::sync::Arc;
use tokio::runtime::Runtime;
mod fases_de_lancamento;
mod gerenciador_de_dados;

struct KrpcConnection {
    runtime: Arc<Runtime>,
    client: Arc<Client>,
}

impl UserData for KrpcConnection {}

fn inicia_conexao(lua: &Lua, _: ()) -> LuaResult<LuaAnyUserData> {
    let runtime = Arc::new(Runtime::new().map_err(mlua::Error::external)?);
    let client = runtime
        .block_on(fases_de_lancamento::inicia_comunicacao())
        .map_err(mlua::Error::external)?;
    let userdata = lua.create_userdata(KrpcConnection { runtime, client })?;
    Ok(userdata)
}

fn lancamento(_lua: &Lua, conn_ud: LuaAnyUserData) -> LuaResult<()> {
    let connection = conn_ud.borrow::<KrpcConnection>()?;
    let client = connection.client.clone();
    let runtime = connection.runtime.clone();
    runtime
        .block_on(fases_de_lancamento::lancamento_basico(client))
        .map_err(mlua::Error::external)
}

fn orbitar(_lua: &Lua, conn_ud: LuaAnyUserData) -> LuaResult<()> {
    let connection = conn_ud.borrow::<KrpcConnection>()?;
    let client = connection.client.clone();
    let runtime = connection.runtime.clone();
    runtime
        .block_on(fases_de_lancamento::orbitador(client))
        .map_err(mlua::Error::external)
}

fn aterrissar(_lua: &Lua, conn_ud: LuaAnyUserData) -> LuaResult<()> {
    let connection = conn_ud.borrow::<KrpcConnection>()?;
    let client = connection.client.clone();
    let runtime = connection.runtime.clone();
    runtime
        .block_on(fases_de_lancamento::aterricador(client))
        .map_err(mlua::Error::external)
}

#[mlua::lua_module]
fn controle_de_nave(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("inicia_conexao", lua.create_function(inicia_conexao)?)?;
    exports.set("lancamento", lua.create_function(lancamento)?)?;
    exports.set("orbitar", lua.create_function(orbitar)?)?;
    exports.set("aterrissar", lua.create_function(aterrissar)?)?;
    Ok(exports)
}
