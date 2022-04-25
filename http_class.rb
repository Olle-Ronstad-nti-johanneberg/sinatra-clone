class HTTP_response_image
  def initialize(file)
    @protocol = 'HTTP/1.1'
    @status_code = '200 OK'
    @body = File.open("public#{file}", 'rb').read
    @header = {
      'Content-Type' => "image/#{file.split('.')[-1]}; charset=utf-8",
      'Server' => 'olle_server'
    }
  end

  def to_s
    @header['Content-Length'] = @body.bytesize.to_s
    "#{@protocol} #{@status_code}\r\n#{
            @header.to_a.map do |key, value|
              key + ': ' + value
            end.join("\r\n")

          }\n\n#{@body}\n\n"
  end

  def print
    @header['Content-Length'] = @body.bytesize.to_s
    puts "#{@protocol} #{@status_code}\r\n#{
            @header.to_a.map do |key, value|
              key + ': ' + value
            end.join("\r\n")

          }\n\nimage".green
  end
end