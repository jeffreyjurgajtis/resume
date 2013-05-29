require 'bundler/setup'
require 'aws-sdk'
require 'fileutils'
require 'foreman'
require 'haml'
require 'pathname'
require 'pry'
require 'rack/mime'
require 'sass'
require_relative 'lib/helpers'
require_relative 'lib/pusher'

desc 'Monitor site for changes and rebuild as neccessary'
task :watch do
end

desc 'Build site to ./public'
task build: %w[build:prepare build:markup build:scripts build:styles build:static]

namespace :build do
  task :prepare do
    FileUtils.rm_r Helpers.destination_directory if Helpers.destination_directory.directory?
  end

  task :markup do
    Helpers.markup_files.each do |source|
      destination_tmp = Helpers.destination_directory + source.relative_path_from(Helpers.source_directory)
      destination = Pathname(destination_tmp.to_path.sub(/#{destination_tmp.extname}\z/, '.html'))
      destination.dirname.mkpath
      destination.open('w:UTF-8') do |f|
        f.binmode
        f.write Haml::Engine.new(source.read).render
      end
    end
  end

  task :scripts do
  end

  task :styles do
    Helpers.style_files.each do |source|
      destination_tmp = Helpers.destination_directory + source.relative_path_from(Helpers.source_directory)
      destination = Pathname(destination_tmp.to_path.sub(/#{destination_tmp.extname}\z/, '.css'))
      destination.dirname.mkpath
      destination.open('w:UTF-8') do |f|
        f.binmode
        f.write Sass::Engine.for_file(source.to_path, {}).render
      end
    end
  end

  task :static do
    Helpers.static_files.each do |source|
      destination = Helpers.destination_directory + source.relative_path_from(Helpers.source_directory)
      destination.dirname.mkpath
      destination.open('w:UTF-8') do |f|
        f.binmode
        f.write source.read
      end
    end
  end
end

desc 'Push compiled site to Amazon S3'
task :push do
  Pusher.push!
end

desc 'Build and push'
task deploy: [:build, :push]
