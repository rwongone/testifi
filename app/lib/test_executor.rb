class TestExecutor
  HOST_WORKDIR = '/usr/src/app'
  WORKDIR = '/tmp/sandbox'

  def self.images
    @images ||= {}
  end

  def self.run_tests(submission)
    problem = submission.problem

    problem.tests.each do |test|
      run_test(submission, test)
    end
  end

  def self.run_test(submission, test)
    output = output_of(submission, test)

    if test.expected_output.nil?
      fill_expected_output(submission.problem, test)
    end

    output == test.expected_output
  end

  def self.output_of(submission, test)
    cmd =  ["sh", "-c", "javac submission/Solution.java -d . && java Solution < input/test.in > output/test.out"]
    image = images[submission.language]
    opts = {
      'Image' => image.id,
      'Cmd' => cmd,
    }

    container = Docker::Container.create(opts)
    container.store_file("#{WORKDIR}/input/test.in", test.db_file.contents)
    container.store_file("#{WORKDIR}/submission/Solution.java", submission.db_file.contents)
    container.start!

    container.attach(:stream => true, :stdin => nil, :stdout => true, :stderr => true, :logs => true, :tty => false)
    container.streaming_logs(stderr: true) { |stream, chunk| puts chunk }
    container.read_file("#{WORKDIR}/output/test.out")
  end

  def self.fill_expected_output(problem, test)
    test.expected_output = output_of(problem.solution, test)
    test.save!
    test.expected_output
  end

  def self.create_testing_image(submission)
    if not images.key?(submission.language)
      images[submission.language] = Docker::Image.build_from_dir("#{HOST_WORKDIR}", {
        'dockerfile' => "docker/lang/#{lang_to_image[submission.language]}",
      } )
    end
    images[submission.language]
  end

  def self.lang_to_image
    {
      'cpp' => 'Dockerfile.cpp',
      'java' => 'Dockerfile.java',
    }
  end
end
