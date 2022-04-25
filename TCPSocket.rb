class TCPSocket
  def get_http
    body_length = 0
    request = ''
    while line = self.gets and line !~ /^\s*$/
      body_length = line[16..-1].to_i if line[0..15] == 'Content-Length: '
      request += line
    end
    body = read(body_length)
    [request, body]
  end
end
