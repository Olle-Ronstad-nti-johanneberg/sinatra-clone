# frozen_string_literal: true

#
# A http response class as an abstration to a string with http information
#
class HTTPResponse
  attr_reader :header
  attr_accessor :body, :cookies

  #
  # Creates a resonse class with the given body and the optional status code (defaults to 200)
  #
  # @param [String] body The body of the response
  # @param [Integer] status_code Status code of the response (defaults to 200)
  #
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

  #
  # Sets the respons status code
  #
  # @param [Integer] status_code the status code to set
  #
  # @return [String] A string with the status code and its description
  #
  def status_code(status_code)
    @status_code = read_status_codes[status_code]
    raise "invalid status code :#{status_code}" if @status_code.nil?
  end

  #
  # Creates a HTTP response
  #
  # @return [String] HTTP response
  #
  def to_s
    @header['Content-Length'] = @body.bytesize.to_s

    header_str = @header.to_a.map do |key, value|
      "#{key}: #{value}"
    end.join("\r\n")

    cookies_str = @cookies.to_a.map do |key, value|
      "Set-Cookie: #{key}=#{value}"
    end.join("\r\n")
    if cookies_str == ''
      "#{@protocol} #{@status_code}\r\n#{header_str}\r\n\r\n#{@body}"
    else
      "#{@protocol} #{@status_code}\r\n#{header_str}\r\n#{cookies_str}\r\n\r\n#{@body}"
    end
  end

  #
  # Sets the status code to 301 and Location header to the given link
  #
  # @param [String] link The link to redirect to
  #
  # @return [String] The given link
  #
  def redirect(link)
    @status_code = read_status_codes[301]
    @header['Location'] = link
  end

  #
  # Sets the content_type to the given string
  #
  # @param [String] type Sets the content_type
  #
  # @return [String] The given content_type
  #
  def content_type=(type)
    @header['Content-Type'] = type
  end

  #
  # Returns a string soutable for printing
  #
  # @return [String] A string soutable for printing
  #
  def print
    "#{to_s.green}\n"
  end

  private

  #
  # Reads all status codes defined in http_codes and returns an hash where the key is its number
  #
  # @return [Hash] a hash of stustus codes, Key is status code number
  #
  def read_status_codes
    tmp = {}
    File.readlines('http_codes.txt').each do |line|
      tmp[line[0, 3].to_i] = line.chomp
    end
    tmp
  end
end
