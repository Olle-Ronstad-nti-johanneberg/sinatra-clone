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
    out = ''
    out << @protocol.light_blue
    out << "\n"
    out << @type.light_blue
    out << "\n"
    out << @path.light_blue
    out << "\n"

    @headers.each do |key, value|
      out << "#{key}: #{value}".light_blue
      out << "\n"
    end
    out << "\n"
    @params.each do |key, value|
      out << "#{key} = #{value}".light_blue
      out << "\n"
    end
    out << "\n"
  end
end
