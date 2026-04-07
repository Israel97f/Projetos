use mlua::prelude::*;
mod fases_de_lancamento;

async fn inicia_conexao(_lua: &Lua, _: ()) -> LuaResult<bool> {
    let _conn = fases_de_lancamento::inicia_comunicacao()
        .await
        .map_err(mlua::Error::external)?;
    Ok(true)
}

async fn lancamento(_lua: &Lua, _: ()) -> LuaResult<()> {
    let _client = fases_de_lancamento::inicia_comunicacao()
        .await
        .map_err(mlua::Error::external)?;
    Ok(())
}

#[mlua::lua_module]
fn controle_de_nave(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("inicia_conexao", lua.create_async_function(inicia_conexao)?)?;
    exports.set("lancamento", lua.create_async_function(lancamento)?)?;
    Ok(exports)
}
