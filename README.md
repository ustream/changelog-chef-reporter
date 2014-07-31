# Changelog-Chef-reporter

Changelog-Chef reporter is a Chef handler for
reporting the list of updated resources to changelog. The resource list can be
filtered by resource type (template, cookbook_file, etc), all types
are outputted by default.

## Installation

    gem install changelog-chef-reporter

## Usage

Append the following to your Chef client configs, usually at
`/etc/chef/client.rb`

    require "changelog-chef-reporter"
    report_handlers << ChangelogReporter.new({
    	:host_name => "http://your.changelog.host"
    	:port => "80"
    	})

Alternatively, you can use the LWRP (available @
http://community.opscode.com/cookbooks/chef_handler)

You can provide an array of resource types to be included in the
report, default is all. You can also filter by name

    report_handlers << ChefangelogReporter.new({
    	:resource_types => %w[template cookbook_file package service],
        :filters => %w[motd]
    	:host_name => "https://your.changelog.host"
    	:port => "443"
        :ssl => true
    	})

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
