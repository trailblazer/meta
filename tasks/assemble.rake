#!/usr/bin/env ruby
require "git"
PACKAGES = {
  "trailblazer" => ENV.fetch("TRAILBLAZER_ASSEMBLE_VERSION", "master"),
  "trailblazer-activity" => ENV.fetch("TRAILBLAZER_ACTIVITY_ASSEMBLE_VERSION", "master"),
  "trailblazer-context" => ENV.fetch("TRAILBLAZER_CONTEXT_ASSEMBLE_VERSION", "master"),
  "trailblazer-macro" => ENV.fetch("TRAILBLAZER_MACRO_ASSEMBLE_VERSION", "master"),
  "trailblazer-macro-contract" => ENV.fetch("TRAILBLAZER_MACRO_CONTRACT_ASSEMBLE_VERSION", "master"),
  "trailblazer-operation" => ENV.fetch("TRAILBLAZER_OPERATION_ASSEMBLE_VERSION", "master"),
  "trailblazer-rails" => ENV.fetch("TRAILBLAZER_RAILS_ASSEMBLE_VERSION", "master")
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

    Dir.glob("#{lib_folder}/**/*.rb") do |filename|
      content = File.read(filename)
      content = content.gsub(/require "trailblazer/, 'require "trailblazer/v2_1')
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
end
