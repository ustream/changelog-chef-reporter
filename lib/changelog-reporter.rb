# Author:
#  Balint Csergo <csergo.balint@ustream.tv>
#  Gabor Szelcsanyi <szelcsanyi.gabor@ustream.tv>

require 'rubygems'
require 'chef/handler'
require 'net/https'
require 'json'

SEVERITY = {
  'INFO' => 1,
  'NOTIFICATION' => 2,
  'WARNING' => 3,
  'ERROR' => 4,
  'CRITICAL' => 5 }

module Handlers
  class ChangelogReporter < Chef::Handler

    def initialize(options = {})
      @resource_types = options.delete(:resource_types) || %w[]
      @filters = options.delete(:filters) || %w[]
      @host = options.delete(:host) || ""
      @port = options.delete(:port) || 443
      @ssl = options.delete(:ssl) || true
    end
    
    def deflate_severity(severity)
      return severity if severity.is_a? Integer
      SEVERITY[severity]
    end

    def sendreport(message, severity, category = 'misc')
      httptrans = Net::HTTP.new @host, @port
      httptrans.use_ssl       = @ssl
      httptrans.verify_mode   = OpenSSL::SSL::VERIFY_NONE
      httptrans.open_timeout  = 7 # seconds
      httptrans.read_timeout  = 5 # seconds

      headers = {
        'User-Agent' => "chef/changelog-reporter",
        'Content-Type' => 'application/json'
      }

      data = {
        'criticality' => deflate_severity(severity),
        'unix_timestamp' => ::Time.now.to_i,
        'category' => category,
        'description' => message
      }

      begin
        response = httptrans.post('/api/events', JSON.generate(data), headers)
        unless response.body.include? '"OK"'
          Chef::Log.warn 'Failed to send changelog message to server'
        end
      rescue Exception => e
        Chef::Log.warn "Failed to send changelog message to server: #{e.message}"
      end

    end

    def report
      Chef::Log.info "Sending list of changed resources to Changelog"
      run_status.updated_resources.each do |r|
        if @resource_types.empty? or @resource_types.include? r.resource_name
          matches = false
          unless @filters.empty?
            @filters.each do |flt|
              if /#{flt}/.match(r.to_s)
                matches = true
              end
            end
          end
          unless matches
            self.sendreport("#{r} was updated on node : #{node['hostname']}", 'INFO', 'chef-run')
          end
        end
      end
    end

  end
end 