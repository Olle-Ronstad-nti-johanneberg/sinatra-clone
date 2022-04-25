require 'socket'
require 'slim'
require_relative 'colorize'
require_relative 'http_response'
require_relative 'http_response_image'
require_relative 'http_request'
require_relative 'TCPSocket'

def slim(file_name, layout: true, locals: {})
  slim_layout = File.open('views/layout.slim', 'rb').read
  contents = File.open("views/#{file_name}.slim", 'rb').read

  l = Slim::Template.new { slim_layout }
  c = Slim::Template.new { contents }.render(nil, locals)
  l.render { c }
end

class Olle_server
  # initilazes the Olle_server object by creating a TCP server with the specified port
  def initialize(port)
    @img_types = %w[apng avif gif jpeg jpg jfif pjpeg pjp png svg webp bmp ico cur tif
                    tiff]
    @server = TCPServer.new('0.0.0.0', port)
    @get_routes = {}
    @post_routes = {}
  end

  # add the provided block of code to the specified Get PATH
  def get(path, &block)
    @get_routes[path] = block
  end

  # add the provided block of code to the specified post PATH
  def post(path, &block)
    @post_routes[path] = block
  end

  def start
    puts "\nStarted server\n".green
    loop do
      socket = @server.accept

      # Thread.new do
      puts "\n\nThe socket is: #{socket.to_s.yellow}"
      request, body = socket.get_http
      request = HTTPRequest.new(request, body)
      request.print
      send_response(socket, request)
      puts "Closing socket: #{socket.to_s.yellow}"
      socket.close
      # end
    end
  end

  private

  # puts the hash wich contains the data to the terminal with colors

  def send_response(socket, request)
    case request.type
    when 'GET'
      if !@get_routes[request.path].nil?
        response = HTTPResponse.new('Olle server: ')
        @get_routes[request.path].call(response, request)
      elsif Dir['public/*'].include?("public#{request.path}")
        response = HTTPResponse.new(File.read("public#{request.path}"))
        if request.path.split('.')[-1].downcase == 'css'
          response.content_type = 'text/css; charset=utf-8'
        elsif @@img_types.include?(request.path.split('.')[-1].downcase)
          response = HTTPResponseImage.new(request.path)
        end
      else
        response = HTTPResponse.new('error', 404)
      end

      response.print
      socket.puts response.to_s
    when 'POST'
      if !@post_routes[request.path].nil?
        response = HTTPResponse.new('Olle server: ')
        @post_routes[request.path].call(response, request)
      else
        response = HTTPResponse.new('error', 404)
      end

      response.print
      socket.puts response.to_s
    else
      socket.puts("HTTP/1.1 500\nServer: Olle_server")
    end
  end
end
