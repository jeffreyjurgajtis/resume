module Helpers
  def self.project_root
    Pathname(__dir__).parent
  end

  def self.destination_directory
    project_root + 'public'
  end

  def self.source_directory
    project_root + 'content'
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
