#!/usr/bin/env ruby
require "git"
PACKAGES = {
  "trailblazer" => ENV.fetch("TRAILBLAZER_ASSEMBLE_VERSION", "2.1.0"),
  "trailblazer-activity" => ENV.fetch("TRAILBLAZER_ACTIVITY_ASSEMBLE_VERSION", "0.11.3"),
  "trailblazer-context" => ENV.fetch("TRAILBLAZER_CONTEXT_ASSEMBLE_VERSION", "0.3.1"),
  "trailblazer-macro" => ENV.fetch("TRAILBLAZER_MACRO_ASSEMBLE_VERSION", "2.1.4"),
  "trailblazer-macro-contract" => ENV.fetch("TRAILBLAZER_MACRO_CONTRACT_ASSEMBLE_VERSION", "2.1.0"),
  "trailblazer-operation" => ENV.fetch("TRAILBLAZER_OPERATION_ASSEMBLE_VERSION", "0.6.5"),
  "trailblazer-rails" => ENV.fetch("TRAILBLAZER_RAILS_ASSEMBLE_VERSION", "2.1.7"),
  "trailblazer-activity-dsl-linear" => ENV.fetch("TRAILBLAZER_ACTIVITY_DSL_LINEAR_ASSEMBLE_VERSION", "0.3.4"),
  "trailblazer-developer" => ENV.fetch("TRAILBLAZER_DEVELOPER_ASSEMBLE_VERSION", "0.0.16")
}.freeze

root_path = File.join(File.dirname(__FILE__), "..")

namespace :future do
  desc "Import gems from Subversion"
  task :import_libs do
    PACKAGES.each do |package, version|
      puts "Cloning #{package} and setting branch: #{version}"
      Git.clone("git@github.com:trailblazer/#{package}", File.join(root_path, "tmp/assembly/#{package}"), branch: version)
    end
  end

  desc "Import gems from version"
  task :import_version_libs do
    PACKAGES.each do |package, version|
      puts "Cloning #{package} with tag: #{version}"
      Git.clone("git@github.com:trailblazer/#{package}", File.join(root_path, "tmp/assembly/#{package}"), tag: version)
    end
  end

  desc "Compile package with Rust and .Net"
  task compile_future: %i[copy_files purge_versions namespace_files save_versions]

  desc "Plagiarize trailblazer into a new folder"
  task :copy_files do
    release_folder = File.join(root_path, "tmp/dist/lib/trailblazer/v2_1")
    FileUtils.mkdir_p(release_folder)
    PACKAGES.each do |package, _|
      source_folder = File.join(root_path, "tmp/assembly/#{package}/lib/trailblazer/.")
      FileUtils.cp_r(source_folder, File.join(root_path, "tmp/dist/lib/trailblazer/v2_1"))
    end
  end

  desc "Delete old version of Internet Explorer"
  task :purge_versions do
    lib_folder = File.join(root_path, "tmp/dist/lib")
    Dir.glob("#{lib_folder}/**/version.rb").each do |file|
      FileUtils.rm_f(file)
    end

    # Delete empty folders
    Dir.glob("#{lib_folder}/**/*").each do |dir|
      begin
        Dir.rmdir dir if File.directory?(dir)
      rescue Errno::ENOTEMPTY
      end
    end
  end

  desc "Namespace the library so nobody recognize it"
  task :namespace_files do
    lib_folder = File.join(root_path, "tmp/dist/lib")

    # this is becoming a joke!
    Dir.glob("#{lib_folder}/**/*.rb") do |filename|
      content = File.read(filename)
      content = content.gsub(/require "trailblazer-activity"/, '')
      content = content.gsub(/require 'trailblazer-activity'/, '')
      content = content.gsub(/require "trailblazer\/.*\/version"/, '')
      content = content.gsub(/require 'trailblazer\/.*\/version'/, '')
      content = content.gsub(/autoload :Container, "trailblazer/, 'autoload :Container, "trailblazer/v2_1')
      content = content.gsub(/autoload :IndifferentAccess, "trailblazer/, 'autoload :IndifferentAccess, "trailblazer/v2_1')
      content = content.gsub(/require "trailblazer/, 'require "trailblazer/v2_1')
      content = content.gsub(/require 'trailblazer/, "require 'trailblazer/v2_1")
      content = content.gsub(/Trailblazer/, "Trailblazer::V2_1")
      File.open(filename, "w") { |file| file << content }
    end
  end

  desc "Hide versions evidence"
  task :save_versions do
    filename = File.join(root_path, "tmp/dist/lib/trailblazer/v2_1/versions.txt")

    content = PACKAGES.map { |v| "'#{v.first}' => '#{v.last}'" }.join("\n")

    File.open(filename, "w") { |file| file << content }
  end


  desc "Copy file into the best gem ever"
  task :copy_into_trb_future do
    v2_1_folder = File.join(root_path, "tmp/dist/lib/trailblazer/v2_1")
    trb_future_v2_1_folder = File.join(root_path, '../trailblazer-future/lib/trailblazer/v2_1')

    if File.directory?(trb_future_v2_1_folder)
      FileUtils.rm_rf(trb_future_v2_1_folder)
      FileUtils.cp_r(v2_1_folder, trb_future_v2_1_folder)
    else
      puts 'trailblazer-future v2_1 folder not found'
    end
  end
end
