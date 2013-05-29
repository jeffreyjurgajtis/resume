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
    Pathname.glob(SOURCE_DIRECTORY + '**' + '*.haml').each do |source|
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
  end

  task :static do
  end
end

desc 'Push compiled site to Amazon S3'
task :push do
end

desc 'Build and push'
task deploy: [:build, :push]
