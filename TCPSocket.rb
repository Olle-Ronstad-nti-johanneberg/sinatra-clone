class TCPSocket
  def get_http
    request = ''
    while line = self.gets and line !~ /^\s*$/
      request += line
    end
    content_length_line = request.split("\n").select do |line|
      line.include?('Content-Length:')
    end.first
    body_length = if content_length_line.nil?
                    0
                  else
                    content_length_line[16..-1].to_i
                  end

    body = read(body_length)
    [request, body]
  end
end
