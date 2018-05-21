#!/usr/bin/env ruby
require 'git'
PACKAGES = ['trailblazer', 'trailblazer-activity', 'trailblazer-context', 'trailblazer-macro', 'trailblazer-macro-contract', 'trailblazer-operation']
TAG_VERSION = {
  "trailblazer" => "v2.1.0.beta7",
  "trailblazer-activity" => "v0.6.2",
  "trailblazer-context" => "v0.1.2",
  "trailblazer-macro" => "v2.1.0.beta7",
  "trailblazer-macro-contract" => "v2.1.0.beta4",
  "trailblazer-operation" => "v0.3.1"
}
root_path = File.join(File.dirname(__FILE__), "..")
namespace :future do
  desc "Import gems from Subversion"
  task :import_libs do
    PACKAGES.each do |package|
      Git.clone("git@github.com:trailblazer/#{package}", File.join(root_path, "tmp/assembly/#{package}"), branch: TAG_VERSION[package])
    end
  end

  desc "Compile package with Rust and .Net"
  task :compile_future => [:copy_files, :purge_versions, :namespace_files, :save_trb_versions]

  desc "Plagiarize trailblazer into a new folder"
  task :copy_files do
    release_folder = File.join(root_path, "tmp/dist/lib/trailblazer/v2_1")
    FileUtils.mkdir_p(release_folder)
    PACKAGES.each do |package|
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

  desc 'Namespace the library so nobody recognize it'
  task :namespace_files do
    lib_folder = File.join(root_path, "tmp/dist/lib")

    Dir.glob("#{lib_folder}/**/*.rb") do |filename|
      content = File.read(filename)
      content = content.gsub(/require "trailblazer/, 'require "trailblazer/v2_1')
      content = content.gsub(/Trailblazer/, "Trailblazer::V2_1")
      File.open(filename, "w") {|file| file << content}
    end
  end

  desc 'Save trb version list'
  task :save_trb_versions do
    filename = File.join(root_path, "tmp/dist/lib/trailblazer/_trb_versions.rb")

    content = TAG_VERSION.map { |v| "'#{v.first}' => '#{v.last}'"}.join("\n")

    File.open(filename, "w") {|file| file << content}
  end
end
