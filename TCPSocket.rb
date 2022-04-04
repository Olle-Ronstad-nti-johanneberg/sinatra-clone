class TCPSocket
    def get_http
        body_length = 0
        request = ""
        while line = self.gets and line !~ /^\s*$/
            if line[0..15] == "Content-Length: "
                body_length = line[16..-1].to_i
            end
            request += line
        end
        body = self.read(body_length)
        return request, body
    end
end