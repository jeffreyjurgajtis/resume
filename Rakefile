require 'bundler/setup'
require 'aws-sdk'
require 'fileutils'
require 'foreman'
require 'haml'
require 'pathname'
require 'pry'
require 'rack'
require 'sass'

SOURCE_DIRECTORY = Pathname(__dir__) + 'content'
DESTINATION_DIRECTORY = Pathname(__dir__) + 'public'

module Helpers
  def self.markup_files
    Pathname.glob(SOURCE_DIRECTORY + '**' + '*.haml')
  end

  def self.script_files
    Pathname.glob(SOURCE_DIRECTORY + 'scripts' + '**' + '*.coffee')
  end

  def self.style_files
    Pathname.glob(SOURCE_DIRECTORY + 'styles' + '**' + '*.scss')
  end

  def self.static_files
    (Pathname.glob(SOURCE_DIRECTORY + '**' + '*') - markup_files - script_files - style_files).select(&:file?)
  end
end

desc 'Monitor site for changes and rebuild as neccessary'
task :watch do
end

desc 'Build site to ./public'
task build: %w[build:prepare build:markup build:scripts build:styles build:static]

namespace :build do
  task :prepare do
    FileUtils.rm_r DESTINATION_DIRECTORY if DESTINATION_DIRECTORY.directory?
  end

  task :markup do
    Helpers.markup_files.each do |source|
      destination_tmp = DESTINATION_DIRECTORY + source.relative_path_from(SOURCE_DIRECTORY)
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
      destination_tmp = DESTINATION_DIRECTORY + source.relative_path_from(SOURCE_DIRECTORY)
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
      destination = DESTINATION_DIRECTORY + source.relative_path_from(SOURCE_DIRECTORY)
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
end

desc 'Build and push'
task deploy: [:build, :push]
