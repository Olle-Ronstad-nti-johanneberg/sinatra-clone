def adv_gets(socket)
    body_length = 0
    request = ""
    while line = socket.gets and line !~ /^\s*$/
        p line
        if line[0..15] == "Content-Length: "
            body_length = line[16..-1].to_i
        end
        request += line
    end
    p "read body"
    body = socket.read(body_length)
    p body
    return request, body
end