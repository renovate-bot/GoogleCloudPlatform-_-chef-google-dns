# Copyright 2018 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ----------------------------------------------------------------------------
#
#     ***     AUTO GENERATED CODE    ***    AUTO GENERATED CODE     ***
#
# ----------------------------------------------------------------------------
#
#     This file is automatically generated by Magic Modules and manual
#     changes will be clobbered when the file is regenerated.
#
#     Please read more about how to change this file in README.md and
#     CONTRIBUTING.md located at the root of this package.
#
# ----------------------------------------------------------------------------

# Add our google/ lib
$LOAD_PATH.unshift ::File.expand_path('../libraries', ::File.dirname(__FILE__))

require 'chef/resource'
require 'google/dns/network/delete'
require 'google/dns/network/get'
require 'google/dns/network/post'
require 'google/dns/network/put'
require 'google/dns/property/integer'
require 'google/dns/property/string'
require 'google/dns/property/string_array'
require 'google/dns/property/time'
require 'google/hash_utils'

module Google
  module GDNS
    # A provider to manage Google Cloud DNS resources.
    # rubocop:disable Metrics/ClassLength
    class ManagedZone < Chef::Resource
      resource_name :gdns_managed_zone

      property :description,
               String, coerce: ::Google::Dns::Property::String.coerce, desired_state: true
      property :dns_name,
               String, coerce: ::Google::Dns::Property::String.coerce, desired_state: true
      property :id, Integer, coerce: ::Google::Dns::Property::Integer.coerce, desired_state: true
      property :mz_label,
               String,
               coerce: ::Google::Dns::Property::String.coerce,
               name_property: true, desired_state: true
      # name_servers is Array of Google::Dns::Property::StringArray
      property :name_servers,
               Array, coerce: ::Google::Dns::Property::StringArray.coerce, desired_state: true
      # name_server_set is Array of Google::Dns::Property::StringArray
      property :name_server_set,
               Array, coerce: ::Google::Dns::Property::StringArray.coerce, desired_state: true
      property :creation_time,
               Time, coerce: ::Google::Dns::Property::Time.coerce, desired_state: true

      property :credential, String, desired_state: false, required: true
      property :project, String, desired_state: false, required: true

      action :create do
        fetch = fetch_resource(@new_resource, self_link(@new_resource), 'dns#managedZone')
        if fetch.nil?
          converge_by "Creating gdns_managed_zone[#{new_resource.name}]" do
            # TODO(nelsonjr): Show a list of variables to create
            # TODO(nelsonjr): Determine how to print green like update converge
            puts # making a newline until we find a better way TODO: find!
            compute_changes.each { |log| puts "    - #{log.strip}\n" }
            create_req = ::Google::Dns::Network::Post.new(
              collection(@new_resource), fetch_auth(@new_resource),
              'application/json', resource_to_request
            )
            return_if_object create_req.send, 'dns#managedZone'
          end
        else
          @current_resource = @new_resource.clone
          @current_resource.description =
            ::Google::Dns::Property::String.api_parse(fetch['description'])
          @current_resource.dns_name = ::Google::Dns::Property::String.api_parse(fetch['dnsName'])
          @current_resource.id = ::Google::Dns::Property::Integer.api_parse(fetch['id'])
          @current_resource.mz_label = ::Google::Dns::Property::String.api_parse(fetch['name'])
          @current_resource.name_servers =
            ::Google::Dns::Property::StringArray.api_parse(fetch['nameServers'])
          @current_resource.name_server_set =
            ::Google::Dns::Property::StringArray.api_parse(fetch['nameServerSet'])
          @current_resource.creation_time =
            ::Google::Dns::Property::Time.api_parse(fetch['creationTime'])

          update
        end
      end

      action :delete do
        fetch = fetch_resource(@new_resource, self_link(@new_resource), 'dns#managedZone')
        unless fetch.nil?
          converge_by "Deleting gdns_managed_zone[#{new_resource.name}]" do
            delete_req = ::Google::Dns::Network::Delete.new(
              self_link(@new_resource), fetch_auth(@new_resource)
            )
            return_if_object delete_req.send, 'dns#managedZone'
          end
        end
      end

      # TODO(nelsonjr): Add actions :manage and :modify

      def exports
        {
          name: mz_label
        }
      end

      private

      action_class do
        def resource_to_request
          request = {
            kind: 'dns#managedZone',
            description: new_resource.description,
            dnsName: new_resource.dns_name,
            name: new_resource.mz_label,
            nameServerSet: new_resource.name_server_set
          }.reject { |_, v| v.nil? }
          request.to_json
        end

        def update
          converge_if_changed do |_vars|
            # TODO(nelsonjr): Determine how to print indented like upd converge
            # TODO(nelsonjr): Check w/ Chef... can we print this in red?
            puts # making a newline until we find a better way TODO: find!
            compute_changes.each { |log| puts "    - #{log.strip}\n" }
            message = 'ManagedZone cannot be edited'
            Chef::Log.fatal message
            raise message
          end
        end

        def self.resource_to_hash(resource)
          {
            project: resource.project,
            name: resource.mz_label,
            kind: 'dns#managedZone',
            description: resource.description,
            dns_name: resource.dns_name,
            id: resource.id,
            name_servers: resource.name_servers,
            name_server_set: resource.name_server_set,
            creation_time: resource.creation_time
          }.reject { |_, v| v.nil? }
        end

        # Copied from Chef > Provider > #converge_if_changed
        def compute_changes
          properties = @new_resource.class.state_properties.map(&:name)
          properties = properties.map(&:to_sym)
          if current_resource
            compute_changes_for_existing_resource properties
          else
            compute_changes_for_new_resource properties
          end
        end

        # Collect the list of modified properties
        def compute_changes_for_existing_resource(properties)
          specified_properties = properties.select do |property|
            @new_resource.property_is_set?(property)
          end
          modified = specified_properties.reject do |p|
            @new_resource.send(p) == current_resource.send(p)
          end

          generate_pretty_green_text(modified)
        end

        def generate_pretty_green_text(modified)
          property_size = modified.map(&:size).max
          modified.map! do |p|
            properties_str = if @new_resource.sensitive
                               '(suppressed sensitive property)'
                             else
                               [
                                 @new_resource.send(p).inspect,
                                 "(was #{current_resource.send(p).inspect})"
                               ].join(' ')
                             end
            "  set #{p.to_s.ljust(property_size)} to #{properties_str}"
          end
        end

        # Write down any properties we are setting.
        def compute_changes_for_new_resource(properties)
          property_size = properties.map(&:size).max
          properties.map do |property|
            default = ' (default value)' \
              unless @new_resource.property_is_set?(property)
            next if @new_resource.send(property).nil?
            properties_str = if @new_resource.sensitive
                               '(suppressed sensitive property)'
                             else
                               @new_resource.send(property).inspect
                             end
            ["  set #{property.to_s.ljust(property_size)}",
             "to #{properties_str}#{default}"].join(' ')
          end.compact
        end

        def fetch_auth(resource)
          self.class.fetch_auth(resource)
        end

        def self.fetch_auth(resource)
          resource.resources("gauth_credential[#{resource.credential}]")
                  .authorization
        end

        def fetch_resource(resource, self_link, kind)
          self.class.fetch_resource(resource, self_link, kind)
        end

        def debug(message)
          Chef::Log.debug(message)
        end

        def self.collection(data)
          URI.join(
            'https://www.googleapis.com/dns/v1/',
            expand_variables(
              'projects/{{project}}/managedZones',
              data
            )
          )
        end

        def collection(data)
          self.class.collection(data)
        end

        def self.self_link(data)
          URI.join(
            'https://www.googleapis.com/dns/v1/',
            expand_variables(
              'projects/{{project}}/managedZones/{{name}}',
              data
            )
          )
        end

        def self_link(data)
          self.class.self_link(data)
        end

        # rubocop:disable Metrics/CyclomaticComplexity
        def self.return_if_object(response, kind)
          raise "Bad response: #{response.body}" \
            if response.is_a?(Net::HTTPBadRequest)
          raise "Bad response: #{response}" \
            unless response.is_a?(Net::HTTPResponse)
          return if response.is_a?(Net::HTTPNotFound)
          return if response.is_a?(Net::HTTPNoContent)
          result = JSON.parse(response.body)
          raise_if_errors result, %w[error errors], 'message'
          raise "Bad response: #{response}" unless response.is_a?(Net::HTTPOK)
          result
        end
        # rubocop:enable Metrics/CyclomaticComplexity

        def return_if_object(response, kind)
          self.class.return_if_object(response, kind)
        end

        def self.extract_variables(template)
          template.scan(/{{[^}]*}}/).map { |v| v.gsub(/{{([^}]*)}}/, '\1') }
                  .map(&:to_sym)
        end

        def self.expand_variables(template, var_data, extra_data = {})
          data = if var_data.class <= Hash
                   var_data.merge(extra_data)
                 else
                   resource_to_hash(var_data).merge(extra_data)
                 end
          extract_variables(template).each do |v|
            unless data.key?(v)
              raise "Missing variable :#{v} in #{data} on #{caller.join("\n")}}"
            end
            template.gsub!(/{{#{v}}}/, CGI.escape(data[v].to_s))
          end
          template
        end

        def self.fetch_resource(resource, self_link, kind)
          get_request = ::Google::Dns::Network::Get.new(
            self_link, fetch_auth(resource)
          )
          return_if_object get_request.send, kind
        end

        def self.raise_if_errors(response, err_path, msg_field)
          errors = ::Google::HashUtils.navigate(response, err_path)
          raise_error(errors, msg_field) unless errors.nil?
        end

        def self.raise_error(errors, msg_field)
          raise IOError, ['Operation failed:',
                          errors.map { |e| e[msg_field] }.join(', ')].join(' ')
        end
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
