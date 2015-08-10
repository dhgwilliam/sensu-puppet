require 'rubygems' if RUBY_VERSION < '1.9.0' && Puppet.version < '3'
require 'json' if Puppet.features.json?
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..',
                                   'puppet_x', 'sensu', 'provider_create.rb'))

Puppet::Type.type(:sensu_api_config).provide(:json) do
  confine :feature => :json
  include PuppetX::Sensu::ProviderCreate

  # Internal: Retrieve the current contents of /etc/sensu/config.json.
  #
  # Returns a Hash representation of the JSON structure in
  # /etc/sensu/config.json or an empty Hash if the file can not be read.
  def conf
    begin
      @conf ||= JSON.parse(File.read(config_file))
    rescue
      @conf ||= {}
    end
  end

  # Public: Save changes to the API section of /etc/sensu/config.json to disk.
  #
  # Returns nothing.
  def flush
    File.open(config_file, 'w') do |f|
      f.puts JSON.pretty_generate(@conf)
    end
  end

  def pre_create
    conf['sensu'] = {}
    conf['dashboard'] = {}
  end

  # Public: Remove the API configuration section.
  #
  # Returns nothing.
  def destroy
    conf.delete 'sensu'
    conf.delete 'dashboard'
  end

  # Public: Determine if the API configuration section is present.
  #
  # Returns a Boolean, true if present, false if absent.
  def exists?
    conf.has_key? 'sensu'
    conf.has_key? 'dashboard'
  end

  # Public: Retrieve the port number that the API is configured to listen on.
  #
  # Returns the String port number.
  def port
    conf['dashboard']['port'].to_s
  end

  def config_file
    "#{resource[:base_path]}/dashboard.json"
  end

  # Public: Set the port that the API should listen on.
  #
  # Returns nothing.
  def port=(value)
    conf['dashboard']['port'] = value.to_i
  end

  # Public: Retrieve the hostname that the API is configured to listen on.
  #
  # Returns the String hostname.
  def host
    conf['dashboard']['host']
  end

  # Public: Set the hostname that the API should listen on.
  #
  # Returns nothing.
  def host=(value)
    conf['dashboard']['host'] = value
  end

  # Public: Retrieve the api username
  #
  # Returns the String hostname.
  def user
    conf['dashboard']['user']
  end

  # Public: Set the api user
  #
  # Returns nothing.
  def user=(value)
    conf['dashboard']['user'] = value
  end

  # Public: Retrieve the password for the api
  #
  # Returns the String password.
  def password
    conf['dashboard']['password']
  end

  # Public: Set the api password
  #
  # Returns nothing.
  def password=(value)
    conf['dashboard']['password'] = value
  end

end
