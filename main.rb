#!/usr/bin/env ruby

require 'webrick'
require 'webrick/httpproxy'

handler = proc { |req, res|
  puts res.header
  puts req.unparsed_uri
  if req.unparsed_uri.match(/^http:\/\/www\.ocw\.titech\.ac\.jp\/index\.php\?.*action=DownLoad/)
    if res.header['content-disposition'].index("pdf")
      res.header['content-type'] = "application/pdf"
    end
  end
}

s = WEBrick::HTTPProxyServer.new(:BindAddress => '127.0.0.1', :Port => 8080, :ProxyVia => false, :ProxyContentHandler => handler)

Signal.trap(:SIGINT) do
  s.shutdown
end

s.start
