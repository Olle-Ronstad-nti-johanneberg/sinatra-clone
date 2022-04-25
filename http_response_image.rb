# frozen_string_literal: true

class HTTPResponseImage
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

    header_str = @header.to_a.map do |key, value|
      "#{key}: #{value}"
    end.join("\r\n")
    "#{@protocol} #{@status_code}\r\n#{header_str}\n\n#{@body}\n\n"
  end

  def print
    @header['Content-Length'] = @body.bytesize.to_s

    header_str = @header.to_a.map do |key, value|
      "#{key}: #{value}"
    end.join("\r\n")

    puts "#{@protocol} #{@status_code}\r\n#{header_str}\n\nimage".green
  end
end
