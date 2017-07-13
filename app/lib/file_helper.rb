class FileHelper
  @@extname_to_lang = {
    '.java' => 'java',
    '.py' => 'python'
  }

  def self.filename_to_language(s)
    self.extname_to_language(File.extname(s))
  end

  def self.extname_to_language(s)
    @@extname_to_lang[s]
  end
end
