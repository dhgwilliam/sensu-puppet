require 'rubygems' if RUBY_VERSION < '1.9.0' && Puppet.version < '3'
require 'json' if Puppet.features.json?
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..',
                                   'puppet_x', 'sensu', 'provider_create.rb'))

Puppet::Type.type(:sensu_enterprise_dashboard_api_config).provide(:json) do
  confine :feature => :json
  include PuppetX::Sensu::ProviderCreate

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

  # Public: Save changes to the API section of /etc/sensu/dashboard.json to disk.
  #
  # Returns nothing.
  def flush
    File.open(config_file, 'w') do |f|
      f.puts JSON.pretty_generate(@conf)
    end
  end

  def pre_create
    conf['sensu'] = {}
  end

  # Public: Remove the API configuration section.
  #
  # Returns nothing.
  def destroy
    conf.delete 'sensu'
  end

  # Public: Determine if the API configuration section is present.
  #
  # Returns a Boolean, true if present, false if absent.
  def exists?
    conf.has_key? 'sensu'
  end

  def config_file
    "#{resource[:base_path]}/dashboard.json"
  end

  def host
    conf['sensu']['host']
  end

  def host=(value)
    conf['sensu']['host'] = value
  end

  # Public: Retrieve the port number that the API is configured to listen on.
  #
  # Returns the String port number.
  def port
    conf['sensu']['port'].to_s
  end

  # Public: Set the port that the API should listen on.
  #
  # Returns nothing.
  def port=(value)
    conf['sensu']['port'] = value.to_i
  end

  def ssl
    conf['sensu']['ssl']
  end

  def ssl=(value)
    conf['sensu']['ssl'] = value
  end

  def insecure
    conf['sensu']['insecure']
  end

  def insecure=(value)
    conf['sensu']['insecure'] = value
  end

  def path
    conf['sensu']['path']
  end

  def path=(value)
    conf['sensu']['path'] = value
  end

  def timeout
    conf['sensu']['timeout'].to_s
  end

  def timeout=(value)
    conf['sensu']['timeout'] = value.to_i
  end

  def user
    conf['sensu']['user']
  end

  def user=(value)
    conf['sensu']['user'] = value
  end

  def pass
    conf['sensu']['pass']
  end

  def pass=(value)
    conf['sensu']['pass'] = value
  end

end
