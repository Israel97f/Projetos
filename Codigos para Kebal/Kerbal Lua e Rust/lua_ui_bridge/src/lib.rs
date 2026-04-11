use iced::{Alignment, Length, Settings, Size};
use mlua::{Function, Lua, RegistryKey, Table};
use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;

struct ButtonDef {
    label: String,
    callback: Option<Rc<RegistryKey>>,
    frame_target: Option<String>,
    action: Option<String>,
}

struct DisplayDef {
    label: String,
    value: String,
    width: u16,
    height: u16,
}

#[derive(Debug, Clone, PartialEq, Eq)]
enum DisplayPosition {
    Top,
    Bottom,
    Left,
    Right,
}

impl DisplayPosition {
    fn from_str(value: &str) -> Self {
        match value.to_lowercase().as_str() {
            "left" => DisplayPosition::Left,
            "right" => DisplayPosition::Right,
            "bottom" => DisplayPosition::Bottom,
            _ => DisplayPosition::Top,
        }
    }
}

struct FrameDef {
    buttons: Vec<ButtonDef>,
    displays: Vec<DisplayDef>,
    display_position: DisplayPosition,
    button_width: u16,
    button_height: u16,
    window_width: u16,
    window_height: u16,
    always_on_top: bool,
}

struct RuntimeState {
    lua: Rc<Lua>,
    frames: HashMap<String, FrameDef>,
    current_frame: String,
}

type AppState = Rc<RefCell<RuntimeState>>;

#[derive(Debug, Clone)]
enum Message {
    ButtonPressed(usize),
    ActionCompleted(Result<String, String>),
}

fn boot(state: AppState) -> (AppState, iced::Task<Message>) {
    (state, iced::Task::none())
}

fn update(state: &mut AppState, message: Message) -> iced::Task<Message> {
    match message {
        Message::ButtonPressed(index) => {
            let maybe_button = {
                let state_ref = state.borrow();
                state_ref
                    .frames
                    .get(&state_ref.current_frame)
                    .and_then(|frame| frame.buttons.get(index))
                    .map(|button| (
                        button.label.clone(),
                        button.frame_target.clone(),
                        button.action.clone(),
                        button.callback.clone(),
                    ))
            };

            if let Some((label, frame_target, action, callback_key)) = maybe_button {
                println!("Botão pressionado: '{}' (index={})", label, index);

                if let Some(frame_target) = frame_target {
                    println!("Mudando para frame: {}", frame_target);
                    let mut state_mut = state.borrow_mut();
                    if state_mut.frames.contains_key(&frame_target) {
                        state_mut.current_frame = frame_target;
                    } else {
                        eprintln!("Frame alvo não encontrado: {}", frame_target);
                    }
                } else if let Some(action) = action {
                    println!("Solicitando ação em background: {}", action);
                    return iced::Task::perform(
                        async move { perform_action(action) },
                        Message::ActionCompleted,
                    );
                } else if let Some(callback_key) = callback_key {
                    let lua = state.borrow().lua.clone();
                    match lua.registry_value::<Function>(callback_key.as_ref()) {
                        Ok(callback) => {
                            println!("Executando callback do botão: '{}'", label);
                            let result: mlua::Result<()> = callback.call(());
                            if let Err(error) = result {
                                eprintln!("Erro ao executar callback do botão '{}': {error}", label);
                            }
                        }
                        Err(error) => {
                            eprintln!("Callback do botão '{}' não pôde ser recuperado: {error}", label);
                        }
                    }
                } else {
                    eprintln!("Botão '{}' não tem callback nem frame definido", label);
                }
            }
        }
        Message::ActionCompleted(result) => {
            match result {
                Ok(message) => println!("Ação concluída: {}", message),
                Err(error) => eprintln!("Erro na ação de fundo: {}", error),
            }
        }
    }

    iced::Task::none()
}

fn perform_action(action: String) -> Result<String, String> {
    println!("Executando ação de fundo: {}", action);

    match action.as_str() {
        "inicia_conexao" => {
            // Aqui você pode abrir a conexão com kRPC em background.
            // Substitua pelo código real que chama a sua DLL/kRPC.
            Ok("Conexão iniciada".to_string())
        }
        "lancamento" => Ok("Lançamento concluído".to_string()),
        "orbitar" => Ok("Órbita iniciada".to_string()),
        "aterrissagem" => Ok("Aterrissagem iniciada".to_string()),
        _ => Ok(format!("Ação '{}' concluída", action)),
    }
}

fn view(state: &AppState) -> iced::Element<'_, Message, iced::Theme, iced::Renderer> {
    let state_ref = state.borrow();

    if let Some(frame) = state_ref.frames.get(&state_ref.current_frame) {
        let mut buttons_column = iced::widget::Column::new().spacing(10);
        for (index, button_def) in frame.buttons.iter().enumerate() {
            let button = iced::widget::button(iced::widget::text::<iced::Theme, iced::Renderer>(button_def.label.clone()))
                .on_press(Message::ButtonPressed(index))
                .width(Length::Fixed(frame.button_width as f32))
                .height(Length::Fixed(frame.button_height as f32));

            buttons_column = buttons_column.push(button);
        }

        if frame.displays.is_empty() {
            return iced::widget::Container::new(buttons_column)
                .padding(20)
                .into();
        }

        let mut display_column = iced::widget::Column::new().spacing(8);
        for display in &frame.displays {
            let display_text = iced::widget::text(format!("{}: {}", display.label, display.value)).size(18);
            let display_container = iced::widget::container(display_text)
                .width(Length::Fixed(display.width as f32))
                .height(Length::Fixed(display.height as f32))
                .padding(10);
            display_column = display_column.push(display_container);
        }

        match frame.display_position {
            DisplayPosition::Left => iced::widget::Row::new()
                .spacing(20)
                .align_y(Alignment::Start)
                .push(display_column)
                .push(buttons_column)
                .padding(20)
                .into(),
            DisplayPosition::Right => iced::widget::Row::new()
                .spacing(20)
                .align_y(Alignment::Start)
                .push(buttons_column)
                .push(display_column)
                .padding(20)
                .into(),
            DisplayPosition::Bottom => iced::widget::Column::new()
                .spacing(20)
                .padding(20)
                .push(buttons_column)
                .push(display_column)
                .into(),
            DisplayPosition::Top => iced::widget::Column::new()
                .spacing(20)
                .padding(20)
                .push(display_column)
                .push(buttons_column)
                .into(),
        }
    } else {
        iced::widget::Column::new().into()
    }
}

fn load_frame(
    lua: &Lua,
    frame_table: Table,
    default_window_width: u16,
    default_window_height: u16,
    default_button_width: u16,
    default_button_height: u16,
    default_display_width: u16,
    default_display_height: u16,
    default_always_on_top: bool,
) -> mlua::Result<FrameDef> {
    let button_size_table: Option<Table> = frame_table.get("button_size")?;
    let button_width = match button_size_table {
        Some(ref t) => {
            let width: Option<u16> = t.get("width")?;
            width.unwrap_or(default_button_width)
        }
        None => default_button_width,
    };
    let button_height = match button_size_table {
        Some(ref t) => {
            let height: Option<u16> = t.get("height")?;
            height.unwrap_or(default_button_height)
        }
        None => default_button_height,
    };

    let window_table: Option<Table> = frame_table.get("window")?;
    let window_width = match window_table {
        Some(ref t) => {
            let width: Option<u16> = t.get("width")?;
            width.unwrap_or(default_window_width)
        }
        None => default_window_width,
    };
    let window_height = match window_table {
        Some(ref t) => {
            let height: Option<u16> = t.get("height")?;
            height.unwrap_or(default_window_height)
        }
        None => default_window_height,
    };

    let display_size_table: Option<Table> = frame_table.get("display_size")?;
    let display_width = match display_size_table {
        Some(ref t) => {
            let width: Option<u16> = t.get("width")?;
            width.unwrap_or(default_display_width)
        }
        None => default_display_width,
    };
    let display_height = match display_size_table {
        Some(ref t) => {
            let height: Option<u16> = t.get("height")?;
            height.unwrap_or(default_display_height)
        }
        None => default_display_height,
    };

    let display_position: String = frame_table.get::<Option<String>>("display_position")?.unwrap_or_else(|| "top".to_string());
    let display_position = DisplayPosition::from_str(&display_position);

    let always_on_top: Option<bool> = frame_table.get("always_on_top")?;
    let always_on_top = always_on_top.unwrap_or(default_always_on_top);

    let mut displays = Vec::new();
    if let Some(displays_table) = frame_table.get::<Option<Table>>("displays")? {
        for pair in displays_table.sequence_values::<Table>() {
            let table = pair?;
            let label: String = table.get("label")?;
            let value: Option<String> = table.get("value")?;
            let width: Option<u16> = table.get("width")?;
            let height: Option<u16> = table.get("height")?;

            displays.push(DisplayDef {
                label,
                value: value.unwrap_or_default(),
                width: width.unwrap_or(display_width),
                height: height.unwrap_or(display_height),
            });
        }
    }

    let buttons_table: Table = match frame_table.get("buttons")? {
        Some(table) => table,
        None => frame_table,
    };

    let mut buttons = Vec::new();
    for pair in buttons_table.sequence_values::<Table>() {
        let table = pair?;
        let label: String = table.get("label")?;
        let callback: Option<Function> = table.get("callback")?;
        let callback_key = if let Some(callback_fn) = callback {
            Some(Rc::new(lua.create_registry_value(callback_fn)?))
        } else {
            None
        };
        let frame_target: Option<String> = table.get("frame")?;
        let action: Option<String> = table.get("action")?;

        buttons.push(ButtonDef { label, callback: callback_key, frame_target, action });
    }

    Ok(FrameDef {
        buttons,
        displays,
        display_position,
        button_width,
        button_height,
        window_width,
        window_height,
        always_on_top,
    })
}

#[mlua::lua_module]
fn lua_ui_bridge(lua: &Lua) -> mlua::Result<mlua::Table> {
    let exports = lua.create_table()?;
    let current_app_state: Rc<RefCell<Option<AppState>>> = Rc::new(RefCell::new(None));

    let change_frame_state = current_app_state.clone();
    exports.set(
        "mudar_frame",
        lua.create_function(move |_, frame_name: String| {
            println!("mudar_frame chamado: {}", frame_name);
            let maybe_state = change_frame_state.borrow();
            if let Some(app_state) = maybe_state.as_ref() {
                let mut state = app_state.borrow_mut();
                if state.frames.contains_key(&frame_name) {
                    state.current_frame = frame_name;
                    println!("frame alterado para: {}", state.current_frame);
                    Ok(())
                } else {
                    let err = format!("Frame '{}' não encontrado", frame_name);
                    eprintln!("{err}");
                    Err(mlua::Error::RuntimeError(err))
                }
            } else {
                let err = "Nenhum aplicativo em execução para mudar o frame".to_string();
                eprintln!("{err}");
                Err(mlua::Error::RuntimeError(err))
            }
        })?,
    )?;

    let change_frame_state = current_app_state.clone();
    exports.set(
        "definir_display",
        lua.create_function(move |_, (frame_name, display_label, value): (String, String, String)| {
            let maybe_state = change_frame_state.borrow();
            if let Some(app_state) = maybe_state.as_ref() {
                let mut state = app_state.borrow_mut();
                if let Some(frame) = state.frames.get_mut(&frame_name) {
                    if let Some(display) = frame.displays.iter_mut().find(|d| d.label == display_label) {
                        display.value = value;
                        Ok(())
                    } else {
                        let err = format!("Display '{}' não encontrado no frame '{}'", display_label, frame_name);
                        eprintln!("{err}");
                        Err(mlua::Error::RuntimeError(err))
                    }
                } else {
                    let err = format!("Frame '{}' não encontrado", frame_name);
                    eprintln!("{err}");
                    Err(mlua::Error::RuntimeError(err))
                }
            } else {
                let err = "Nenhum aplicativo em execução para definir display".to_string();
                eprintln!("{err}");
                Err(mlua::Error::RuntimeError(err))
            }
        })?,
    )?;

    exports.set(
        "abrir_janela",
        {
            let change_frame_state = current_app_state.clone();
            lua.create_function(move |lua, config: Table| {
                let lua = Rc::new(lua.clone());

                let top_button_size_table: Option<Table> = config.get("button_size")?;
                let default_button_width = match top_button_size_table {
                    Some(ref t) => {
                        let width: Option<u16> = t.get("width")?;
                        width.unwrap_or(120)
                    }
                    None => 120,
                };
                let default_button_height = match top_button_size_table {
                    Some(ref t) => {
                        let height: Option<u16> = t.get("height")?;
                        height.unwrap_or(40)
                    }
                    None => 40,
                };

                let top_window_table: Option<Table> = config.get("window")?;
                let default_window_width = match top_window_table {
                    Some(ref t) => {
                        let width: Option<u16> = t.get("width")?;
                        width.unwrap_or(800)
                    }
                    None => 800,
                };
                let default_window_height = match top_window_table {
                    Some(ref t) => {
                        let height: Option<u16> = t.get("height")?;
                        height.unwrap_or(600)
                    }
                    None => 600,
                };

                let default_display_size_table: Option<Table> = config.get("display_size")?;
                let default_display_width = match default_display_size_table {
                    Some(ref t) => {
                        let width: Option<u16> = t.get("width")?;
                        width.unwrap_or(300)
                    }
                    None => 300,
                };
                let default_display_height = match default_display_size_table {
                    Some(ref t) => {
                        let height: Option<u16> = t.get("height")?;
                        height.unwrap_or(50)
                    }
                    None => 50,
                };

                let default_always_on_top: bool = config.get::<Option<bool>>("always_on_top")?.unwrap_or(false);

                let initial_frame_opt: Option<String> = config.get("initial_frame")?;
                let initial_frame = initial_frame_opt.unwrap_or_else(|| "default".to_string());

                let mut frames: HashMap<String, FrameDef> = HashMap::new();
                let frames_table: Option<Table> = config.get("frames")?;
                let window_settings = if let Some(frames_table) = frames_table {
                    for pair in frames_table.pairs::<String, Table>() {
                        let (name, table) = pair?;
                        let frame_def = load_frame(
                            &lua,
                            table,
                            default_window_width,
                            default_window_height,
                            default_button_width,
                            default_button_height,
                            default_display_width,
                            default_display_height,
                            default_always_on_top,
                        )?;
                        frames.insert(name, frame_def);
                    }

                    if !frames.contains_key(&initial_frame) {
                        return Err(mlua::Error::RuntimeError(
                            "O frame inicial não está presente em frames".to_string(),
                        ));
                    }

                    let initial_frame_def = frames.get(&initial_frame).unwrap();
                    iced::window::Settings {
                        size: Size::new(initial_frame_def.window_width.into(), initial_frame_def.window_height.into()),
                        level: if initial_frame_def.always_on_top {
                            iced::window::Level::AlwaysOnTop
                        } else {
                            iced::window::Level::Normal
                        },
                        ..iced::window::Settings::default()
                    }
                } else {
                    let frame_def = load_frame(
                        &lua,
                        config,
                        default_window_width,
                        default_window_height,
                        default_button_width,
                        default_button_height,
                        default_display_width,
                        default_display_height,
                        default_always_on_top,
                    )?;
                    frames.insert("default".to_string(), frame_def);

                    let initial_frame = "default".to_string();
                    let initial_frame_def = frames.get(&initial_frame).unwrap();
                    iced::window::Settings {
                        size: Size::new(initial_frame_def.window_width.into(), initial_frame_def.window_height.into()),
                        level: if initial_frame_def.always_on_top {
                            iced::window::Level::AlwaysOnTop
                        } else {
                            iced::window::Level::Normal
                        },
                        ..iced::window::Settings::default()
                    }
                };

                let state = Rc::new(RefCell::new(RuntimeState {
                    lua: lua.clone(),
                    frames,
                    current_frame: initial_frame,
                }));

                *change_frame_state.borrow_mut() = Some(state.clone());
                let boot_state = state.clone();

                iced::application::<AppState, Message, iced::Theme, iced::Renderer>(
                    move || {
                        let state = boot_state.clone();
                        boot(state)
                    },
                    update,
                    view,
                )
                .settings(Settings::default())
                .window(window_settings)
                .run()
                .unwrap();

                *change_frame_state.borrow_mut() = None;
                Ok(())
            })?
        },
    )?;

    Ok(exports)
}

