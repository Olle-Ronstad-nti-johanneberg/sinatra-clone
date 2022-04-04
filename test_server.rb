require_relative 'olle_server.rb'

server = Olle_server.new(42069)

server.GET '/hek' do |response,req|
    response.body = "\n<!DOCTYPE html>
    <html lang=\"en\">
    <head>
        <meta charset=\"UTF-8\">
        <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
        <title>Document</title>
    </head>
    <body>
        <p> dina kakor är #{req.cookie}
        <form action=\"post\" method=\"post\">
            <input type=\"text\" name=\"text\">
            <input type=\"submit\" value=\"sub\">
        </form>
    </body>
    </html>"
    response.cookies["time"] = Time.new().to_s
    response.cookies["rand"] = rand.to_s
end


server.POST '/post' do |res,req|
    res.body = "dina params är #{req.params}"
end

server.GET '/' do |res|
    res.body = slim("out",locals: {key:"hej"})
end

server.start()