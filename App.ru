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
  
Index = lambda do |env|
  [200, {'Content-Type' => 'text/html'}, ["This is index!"]] 
end

App = lambda do |env|
  [200, { 'Content-Type' => 'text/html' }, ['Its not a WS req']]
end

Getword = lambda do |env|
  [200, {'Content-Type' => 'application/json'}, [$hashwd.to_json]] 
end
Reget = lambda do |env|
  reget
  [200, {'Content-Type' => 'application/json'}, ["OK"]] 
end
Newestget = lambda do |env|
  [200, {'Content-Type' => 'application/json'}, [$hashwd["word"][0]]] 
end
Randomget = lambda do |env|
  [200, {'Content-Type' => 'application/json'}, [$hashwd["word"][rand($hashwd["word"].length)].to_json]] 
end


# map '/admin' {run App}
# map '/admin' {run App}


map '/' do run Index end
map '/test' do run App end
map '/getword' do run Getword end
map '/reget' do run Reget end
map '/newestget' do run Newestget end
map '/randomget' do run Randomget end