class HTTPRequest
  attr_reader :type, :path, :protocol, :headers, :cookie, :params

  def initialize(headers, body)
    space_split = headers.split(' ')
    @type = space_split[0]
    @path = space_split[1].split('?')[0]
    @protocol = space_split[2]

    headers = headers.split("\n")

    @params = parse_params(body, headers)

    @headers = parse_header(headers)

    @cookie = parse_cookie(@headers)
  end

  def parse_params(body, headers)
    body = headers[0].split(' ')[1].split('?')[1] if @type == 'GET'
    tmp = {}
    body&.split('&')&.each do |row|
      key, val = row.split('=')
      tmp[key] = val
    end
    tmp
  end

  def parse_header(headers)
    tmp = {}
    headers[1..-1].each do |row|
      key, val = row.split(': ')
      tmp[key] = val
    end
    tmp
  end

  def parse_cookie(headers)
    tmp = {}
    headers['Cookie']&.split('; ')&.each do |cookie|
      key, val = cookie.split('=')
      tmp[key] = val
    end
    tmp
  end

  def print
    puts @protocol.light_blue
    puts @type.light_blue
    puts @path.light_blue

    @headers.each do |key, value|
      puts "#{key}: #{value}".light_blue
    end
    puts ''
    @params.each do |key, value|
      puts "#{key} = #{value}".light_blue
    end
  end
end