module Helpers
  def self.destination_directory
    Pathname(__dir__) + 'public'
  end

  def self.source_directory
    Pathname(__dir__) + 'content'
  end

  def self.compiled_files
    Pathname.glob(destination_directory + '**' + '*').select(&:file?)
  end

  def self.markup_files
    Pathname.glob(source_directory + '**' + '*.haml')
  end

  def self.script_files
    Pathname.glob(source_directory + 'scripts' + '**' + '*.coffee')
  end

  def self.style_files
    Pathname.glob(source_directory + 'styles' + '**' + '*.scss')
  end

  def self.static_files
    (Pathname.glob(source_directory + '**' + '*') - markup_files - script_files - style_files).select(&:file?)
  end
end
