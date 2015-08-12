require 'rubygems' if RUBY_VERSION < '1.9.0' && Puppet.version < '3'
require 'json' if Puppet.features.json?
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..',
                                   'puppet_x', 'sensu', 'provider_create.rb'))

Puppet::Type.type(:sensu_enterprise_dashboard_api_config).provide(:json) do
  confine :feature => :json
  include PuppetX::Sensu::ProviderCreate

  def config_file
    "#{resource[:base_path]}/dashboard.json"
  end

  # Internal: Retrieve the current contents of /etc/sensu/dashboard.json.
  #
  # Returns a Hash representation of the JSON structure in
  # /etc/sensu/dashboard.json or an empty Hash if the file can not be read.
  def conf
    begin
      @conf ||= JSON.parse(File.read(config_file))
    rescue
      @conf ||= {}
    end
  end

  def sensu
    return @sensu if @sensu
    conf['sensu'] || []
  end

  def name
    resource[:name]
  end

  def api
    sensu.select { |e| e['name'] == name }.first
  end

  # Public: Save changes to the API section of /etc/sensu/dashboard.json to disk.
  #
  # Returns nothing.
  def flush
    @conf['sensu'] = @sensu

    File.open(config_file, 'w') do |f|
      f.puts JSON.pretty_generate(@conf)
    end
  end

  def pre_create
    conf['sensu'] = []
  end

  # Public: Remove the API configuration section.
  #
  # Returns nothing.
  def destroy
    sensu.reject! { |api| api['name'] == name }
  end

  # Public: Determine if the API configuration section is present.
  #
  # Returns a Boolean, true if present, false if absent.
  def exists?
    sensu.inject(false) do |memo, api|
      memo = true if api['name'] == name
      memo
    end
  end

  def host
    api['host']
  end

  def host=(value)
    api['host'] = value
  end

  # Public: Retrieve the port number that the API is configured to listen on.
  #
  # Returns the String port number.
  def port
    api['port'].to_s
  end

  # Public: Set the port that the API should listen on.
  #
  # Returns nothing.
  def port=(value)
    api['port'] = value.to_i
  end

  def ssl
    api['ssl']
  end

  def ssl=(value)
    api['ssl'] = value
  end

  def insecure
    api['insecure']
  end

  def insecure=(value)
    api['insecure'] = value
  end

  def path
    api['path']
  end

  def path=(value)
    api['path'] = value
  end

  def timeout
    api['timeout'].to_s
  end

  def timeout=(value)
    api['timeout'] = value.to_i
  end

  def user
    api['user']
  end

  def user=(value)
    api['user'] = value
  end

  def pass
    api['pass']
  end

  def pass=(value)
    api['pass'] = value
  end
end
