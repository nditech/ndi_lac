class Import < ActiveRecord::Base
  
  belongs_to :user
    
  state_machine :status, initial: :new do
    
    after_transition :on => :completed, :do => :delete_file
    
    event :start do
      transition :new => :started
    end
    
    event :complete do
      transition :started => :completed
    end
    
    event :fail do
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
  
  def delete_file
    File.delete(path_file)
  end
  
  def process
    begin
      self.start!
      Contact.import(File.open(path_file))
      self.complete!
    rescue Exception => e
      self.fail!
    end
  end
end
