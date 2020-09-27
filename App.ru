require_relative 'autoRequire'

$hashwd = Hash[]

config = YAML.load(File.open("SQLconfig.yml"))



$client = Mysql2::Client.new(
  :host => "#{config["SQLconfig"]["IP_address"]}",
  :username => "#{config["SQLconfig"]["User_name"]}",
  :password => "#{config["SQLconfig"]["Password"]}",
  :database => "#{config["SQLconfig"]["Data_base"]}",
  :encoding => 'utf8',
  :reconnect => true
  )
  
  
  
  def reget
    $outword = Array[]
    results = $client.query("SELECT Word FROM main")
    results.each do |row|
      $outword << row['Word']
      $hashwd = Hash["word" => $outword.reverse]
    end
  end
  
reget

  Thread.new do
    loop do
      sleep 600
      reget
    end
  end


App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)

    ws.on :message do |msg|
      puts msg.data
      if msg.data == "getword"
        # reget
        # ws.send $outword
        ws.send $hashwd.to_json
        sleep 2
      elsif msg.data == "reget"
        reget
      else
        p "error"
      end
    end

    ws.on :close do |event|
      puts "[#{Time.new.strftime('%Y-%m-%d %H:%M:%S')}][!]: 一个客户端断开连接 (#{event.code})"
      ws = nil
    end

    ws.rack_response
  else
    # 正常HTTP请求
    [200, { 'Content-Type' => 'text/html' }, ['Its not a WS req']]
  end
end


run App
