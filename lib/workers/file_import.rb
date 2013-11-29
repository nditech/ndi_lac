module Workers
  class FileImport
    include Sidekiq::Worker
    
    def perform(import_id)
      import = Import.find import_id
      import.process
    end
  end
end