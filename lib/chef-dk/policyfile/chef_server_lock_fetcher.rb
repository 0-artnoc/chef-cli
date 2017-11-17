require "chef-dk/policyfile_lock"
require "chef-dk/exceptions"

module ChefDK
  module Policyfile
    class ChefServerLockFetcher

      attr_accessor :name
      attr_accessor :source_options
      attr_accessor :chef_config

      def initialize(name, source_options, chef_config)
        @name = name
        @source_options = source_options
        @chef_config = chef_config
      end

      def valid?
        errors.empty?
      end

      def errors
        error_messages = []

        [:server, :policy_name].each do |key|
          error_messages << "include_policy for #{name} is missing key #{key}" unless source_options[key]
        end

        if [:policy_revision_id, :policy_group].all? { |key| source_options[key].nil? }
          error_messages << "include_policy for #{name} must specify policy_revision_id or policy_group"
        end

        error_messages
      end

      def source_options_for_lock
        source_options.merge({
          policy_revision_id: lock_data["revision_id"],
        })
      end

      def apply_locked_source_options(options_from_lock)
        options = options_from_lock.inject({}) do |acc, (key, value)|
          acc[key.to_sym] = value
          acc
        end
        source_options.merge!(options)
        raise ChefDK::InvalidLockfile, "Invalid source_options provided from lock data: #{options_from_lock_file.inspect}" if !valid?
      end

      def lock_data
        @lock_data ||= fetch_lock_data.tap do |data|
          cookbook_locks = data["cookbook_locks"].inject({}) do |acc, (cookbook_name, cookbook_lock)|
            cookbook_lock["source_options"] = {
              "chef_server_artifact" => server,
              "identifier" => cookbook_lock["identifier"]
            }

            acc[cookbook_name] = cookbook_lock

            acc
          end
        end
      end

      private

      def fetch_lock_data
        if revision
          http_client.get("policies/#{policy_name}/revisions/#{revision}")
        elsif policy_group
          http_client.get("policy_groups/#{policy_group}/policies/#{policy_name}")
        else
          raise ChefDK::BUG.new("The source_options should have been validated: #{source_options.inspect}")
        end
      rescue Net::ProtocolError => e
        if e.respond_to?(:response) && e.response.code.to_s == "404"
          raise ChefDK::PolicyfileLockDownloadError.new("No policyfile lock named '#{policy_name}' found with revision '#{revision}' at #{http_client.url}") if revision
          raise ChefDK::PolicyfileLockDownloadError.new("No policyfile lock named '#{policy_name}' found with policy group '#{policy_group}' at #{http_client.url}") if policy_group
        else
          raise ChefDK::PolicyfileLockDownloadError.new("HTTP error attempting to fetch policyfile lock from #{http_client.url}")
        end
      rescue => e
        raise e
      end

      def policy_name
        source_options[:policy_name]
      end

      def revision
        source_options[:policy_revision_id]
      end

      def policy_group
        source_options[:policy_group]
      end

      def server
        source_options[:server]
      end

      def http_client
        @http_client ||= Chef::ServerAPI.new(source_options[:server],
                                             signing_key_filename: chef_config.client_key,
                                             client_name: chef_config.node_name)
      end

    end
  end
end
