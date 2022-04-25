# frozen_string_literal: true

class HTTPResponse
  attr_reader :header
  attr_accessor :body, :cookies

  def initialize(body, status_code = 200)
    @protocol = 'HTTP/1.1'

    @status_code = read_status_codes[status_code]
    raise "invalid status code :#{status_code}" if @status_code.nil?

    @body = body
    @header = {
      'Content-Type' => 'text/html; charset=utf-8',
      'Server' => 'olle_server',
      'Content-Length' => '0'
    }

    @cookies = {}
  end

  def status_code(status_code)
    @status_code = @@status_codes[status_code]
    raise "invalid status code :#{status_code}" if @status_code.nil?
  end

  def to_s
    @header['Content-Length'] = @body.bytesize.to_s

    header_str = @header.to_a.map do |key, value|
      "#{key}: #{value}"
    end.join("\r\n")

    cookies_str = @cookies.to_a.map do |key, value|
      "Set-Cookie: #{key}=#{value}"
    end.join("\r\n")

    "#{@protocol} #{@status_code}\r\n#{header_str}\r\n#{cookies_str}\n#{@body}"
  end

  def redirect(link)
    @status_code = @@status_codes[301]
    @header['Location'] = link
  end

  def content_type=(type)
    @header['Content-Type'] = type
  end

  def print
    puts to_s.green
  end

  private

  def read_status_codes
    tmp = {}
    File.readlines('http_codes.txt').each do |line|
      tmp[line[0, 3].to_i] = line.chomp
    end
    tmp
  end
end
