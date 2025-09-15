local path = tostring(arg[1])

os.execute(string.format("luastatic %s /usr/lib/x86_64-linux-gnu/liblua5.4.a -I/usr/include/lua5.4", path))

