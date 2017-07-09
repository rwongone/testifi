class SubmissionExecutor
  HOST_WORKDIR = '/usr/src/app'
  WORKDIR = '/tmp/sandbox'

  def self.run_tests(submission=nil)
    image = create_testing_image(submission)
    run_test(submission, image)
  end

  def self.run_test(submission=nil, image=nil)
    cmd =  ["sh", "-c", "javac submission/Solution.java -d . && java Solution < input/sample_test > output/program_output"]
    opts = {
      'Image' => image.id,
      'Cmd' => (cmd.is_a?(String) ? cmd.split(/\s+/) : cmd),
    }

    container = Docker::Container.create(opts)
    container.store_file("#{WORKDIR}/input/sample_test", File.read('var/test/sample_test.in'))
    container.store_file("#{WORKDIR}/submission/Solution.java", submission.db_file.contents)
    container.start!

    container.attach(:stream => true, :stdin => nil, :stdout => true, :stderr => true, :logs => true, :tty => false)
    container.streaming_logs(stderr: true) { |stream, chunk| puts chunk }
    container.read_file("#{WORKDIR}/output/program_output")
  end

  def self.create_testing_image(submission=nil)
    language = submission&.language || :java

    # Use src_dir build arugment to specify to directory to copy.
    # Currently, specifying an absolute path does not work.
    # Use a relative path from HOST_WORKDIR.
    image = Docker::Image.build_from_dir("#{HOST_WORKDIR}", {
      'dockerfile' => "docker/lang/#{lang_to_image[language.to_sym]}",
    } )
  end

  def self.lang_to_image
    {
      cpp: 'Dockerfile.cpp',
      java: 'Dockerfile.java',
    }
  end
end
