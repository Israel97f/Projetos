use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufReader, BufWriter, Read, Write};
use std::path::PathBuf;

fn dados_ldf_path() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .expect("lib_rust crate must be inside a project folder")
        .join("dados.ldf")
}

fn quote_lua_string(value: &str) -> String {
    let mut result = String::with_capacity(value.len() + 2);
    result.push('"');
    for c in value.chars() {
        match c {
            '"' => result.push_str("\\\""),
            '\\' => result.push_str("\\\\"),
            '\n' => result.push_str("\\n"),
            '\r' => result.push_str("\\r"),
            '\t' => result.push_str("\\t"),
            '\0' => result.push_str("\\0"),
            c if c.is_control() => result.push_str(&format!("\\x{:02x}", c as u32)),
            c => result.push(c),
        }
    }
    result.push('"');
    result
}

fn is_valid_lua_identifier(key: &str) -> bool {
    let mut chars = key.chars();
    match chars.next() {
        Some(c) if c.is_ascii_alphabetic() || c == '_' => {
            chars.all(|ch| ch.is_ascii_alphanumeric() || ch == '_')
        }
        _ => false,
    }
}

pub fn write(data: &HashMap<&str, f64>) -> io::Result<()> {
    let file = File::create(dados_ldf_path())?;
    let mut writer = BufWriter::new(file);
    writer.write_all(b"return {\n")?;

    for (key, value) in data {
        let key_repr = if is_valid_lua_identifier(key) {
            key.to_string()
        } else {
            format!("[{}]", quote_lua_string(key))
        };
        writer.write_all(format!("  {} = {},\n", key_repr, value).as_bytes())?;
    }

    writer.write_all(b"}\n")?;
    writer.flush()
}

pub fn read() -> io::Result<HashMap<&'static str, f64>> {
    let file = File::open(dados_ldf_path())?;
    let mut reader = BufReader::new(file);
    let mut contents = String::new();
    reader.read_to_string(&mut contents)?;
    parse_lua_table(&contents)
}

fn parse_lua_table(source: &str) -> io::Result<HashMap<&'static str, f64>> {
    let source = source.trim();
    let source = source
        .strip_prefix("return")
        .ok_or_else(|| io::Error::new(io::ErrorKind::InvalidData, "missing return keyword"))?
        .trim();

    let start = source
        .find('{')
        .ok_or_else(|| io::Error::new(io::ErrorKind::InvalidData, "missing '{'"))?;
    let end = source
        .rfind('}')
        .ok_or_else(|| io::Error::new(io::ErrorKind::InvalidData, "missing '}'"))?;

    let body = &source[start + 1..end];
    let mut result = HashMap::new();

    for line in body.lines() {
        let mut item = line.trim();
        if item.is_empty() {
            continue;
        }
        if let Some(stripped) = item.strip_suffix(',') {
            item = stripped.trim();
        }
        if item.is_empty() {
            continue;
        }

        let eq = item
            .find('=')
            .ok_or_else(|| io::Error::new(io::ErrorKind::InvalidData, "missing '=' in table item"))?;
        let key_part = item[..eq].trim();
        let value_part = item[eq + 1..].trim();

        let key = parse_lua_key(key_part)?;
        let value = value_part.parse::<f64>().map_err(|err| {
            io::Error::new(io::ErrorKind::InvalidData, format!("invalid number: {}", err))
        })?;
        let key: &'static str = Box::leak(key.into_boxed_str());
        result.insert(key, value);
    }

    Ok(result)
}

fn parse_lua_key(key: &str) -> io::Result<String> {
    let key = key.trim();
    if let Some(inner) = key.strip_prefix('[').and_then(|k| k.strip_suffix(']')) {
        let inner = inner.trim();
        if let Some(value) = inner.strip_prefix('"').and_then(|k| k.strip_suffix('"')) {
            return unescape_lua_string(value);
        }
        if let Some(value) = inner.strip_prefix('\'').and_then(|k| k.strip_suffix('\'')) {
            return unescape_lua_string(value);
        }
        Err(io::Error::new(
            io::ErrorKind::InvalidData,
            format!("invalid quoted key: {}", key),
        ))
    } else {
        Ok(key.to_string())
    }
}

fn unescape_lua_string(value: &str) -> io::Result<String> {
    let mut result = String::with_capacity(value.len());
    let mut chars = value.chars();

    while let Some(ch) = chars.next() {
        if ch != '\\' {
            result.push(ch);
            continue;
        }

        let next = chars.next().ok_or_else(|| {
            io::Error::new(io::ErrorKind::InvalidData, "incomplete escape sequence")
        })?;

        match next {
            '"' => result.push('"'),
            '\\' => result.push('\\'),
            'n' => result.push('\n'),
            'r' => result.push('\r'),
            't' => result.push('\t'),
            '0' => result.push('\0'),
            'x' => {
                let hex: String = chars.by_ref().take(2).collect();
                if hex.len() != 2 {
                    return Err(io::Error::new(
                        io::ErrorKind::InvalidData,
                        "invalid hex escape sequence",
                    ));
                }
                let value = u8::from_str_radix(&hex, 16).map_err(|_| {
                    io::Error::new(io::ErrorKind::InvalidData, "invalid hex escape sequence")
                })?;
                result.push(value as char);
            }
            other => result.push(other),
        }
    }

    Ok(result)
}
