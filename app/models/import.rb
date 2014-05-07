class Import < ActiveRecord::Base

  include Importer

  belongs_to :user
  has_many :failed_imports

  state_machine :status, initial: :new do

    after_transition :on => :completed, :do => :delete_file

    event :start do
      transition :new => :started
    end

    event :complete do
      transition [:started, :conflicted] => :completed, if: :can_complete_without_unresolved_failed_imports?
    end

    event :conflict do
      transition :started => :conflicted
    end

    event :failing do
      transition [:new, :started] => :failed
    end

  end

  def self.new_file(file, user_id)
    path = save_file(file)
    import = self.create path_file: path, user_id: user_id
    Workers::FileImport.perform_async(import.id)
  end

  def self.save_file(file)
    path = File.join("public/tmp", file.original_filename)
    File.open(path, "wb") { |f| f.write(file.read) }
    path
  end

  def self.started
    where(status: :started)
  end

  def self.new_imports
    where(status: :new)
  end

  def self.conflited
    where(status: :conflicted)
  end

  def delete_file
    File.delete(path_file)
  end

  def complete_if_not_failed_imports!
    complete!
  end

  def can_complete_without_unresolved_failed_imports?
    failed_imports.unresolved.count == 0
  end

  def process
    begin
      start! if can_start?
      import
      complete! if can_complete?
    rescue Exception => e
      failing!
    end
  end

  def file_name
    path_file.split('/').last
  end
end
