# frozen_string_literal: true

def write_to_file(response, filepath = 'test.out')
  File.open(filepath, 'w') do |f|
    f.write(response.body)
  end
end
