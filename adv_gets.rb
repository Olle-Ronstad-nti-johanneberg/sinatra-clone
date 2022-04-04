def adv_gets(socket)
    body_length = 0
    request = ""
    while line = socket.gets and line !~ /^\s*$/
        if line[0..15] == "Content-Length: "
            body_length = line[16..-1].to_i
        end
        request += line
    end
    body = socket.read(body_length)
    return request, body
end