require 'json'

#ENV['PATH'] = "C:\\Program Files\\Puppet Labs\\Puppet\\bin;#{ENV['PATH']}"
#puts ENV['PATH']

params = JSON.parse(ENV['PT_foo'])
#output = %x(cmd.exe /c "C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat" --version)
%x(puppet --version)
puts output

result = {"result" => output.chomp}
puts result.to_json
