class SubmissionExecutor
  HOST_WORKDIR = '/usr/src/app'
  WORKDIR = '/tmp/sandbox'

  def self.run_tests(submission=nil)
    # submission: Submission
    #   problem: Problem
    #   language: String or Symbol or Enum
    #   filepath: String representing filepath of user-submitted source file.
    #
    # problem: Problem
    #   cmd: String
    #   submissions: [Submission]
    #   test_set: [Test]

    # submission.problem.test_set.map do |test|
    # end

    image = create_testing_image(submission)
    run_test(submission, image)
  end

  def self.run_test(submission=nil, image=nil)
    problem = submission&.problem
    cmd = problem&.cmd || ["sh", "-c", "g++ submission/submitted_file.cpp && ./a.out < input/sample_test > output/program_output"] # ["ls", "-la"]
    filepath = submission&.filepath || 'var/submission/solution.cpp'

    opts = {
      'Image' => image.id,
      'Cmd' => (cmd.is_a?(String) ? cmd.split(/\s+/) : cmd),
    }
    container = Docker::Container.create(opts)
    container.store_file("#{WORKDIR}/input/sample_test", File.read('var/test/sample_test.txt'))

    # g++ gives an error if it does not recognize the file extension on the source file.
    container.store_file("#{WORKDIR}/submission/submitted_file.cpp", File.read(filepath))
    container.start!
    container.attach(:stream => true, :stdin => nil, :stdout => true, :stderr => true, :logs => true, :tty => false)
    container.streaming_logs(stderr: true) { |stream, chunk| puts chunk }
    container.read_file("#{WORKDIR}/output/program_output")
  end

  def self.create_testing_image(submission=nil)
    language = submission&.language || :cpp

    # Use src_dir build arugment to specify to directory to copy.
    # Currently, specifying an absolute path does not work.
    # Use a relative path from HOST_WORKDIR.
    image = Docker::Image.build_from_dir("#{HOST_WORKDIR}", {
      'dockerfile' => "docker/lang/#{lang_to_image[language]}",
    } )
  end

  def self.lang_to_image
    {
      cpp: 'Dockerfile.cpp',
    }
  end
end
