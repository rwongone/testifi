class TestExecutor
  HOST_WORKDIR = '/usr/src/app'
  WORKDIR = '/tmp/sandbox'

  def self.images
    @@images ||= {}
  end

  def self.correct_submission?(submission)
    tests = Test.where(problem_id: submission.problem_id)

    tests.all? do |test|
      correct_output?(submission, test)
    end
  end

  def self.correct_output?(submission, test)
    output = run_test(submission, test)

    raise "Missing expected output" if test.expected_output.nil?

    output == test.expected_output
  end

  def self.run_tests(submission)
    tests = Test.where(problem_id: submission.problem_id)

    tests.each do |test|
      run_test(submission, test)
    end
  end

  def self.run_test(submission, test)
    create_testing_image(submission)

    docker_cmd =  ["sh", "-c", cmd[submission.language]]
    image = images[submission.language]
    opts = {
      'Image' => image.id,
      'Cmd' => docker_cmd,
    }

    container = Docker::Container.create(opts)
    container.store_file("#{WORKDIR}/input/test.in", test.db_file.contents)
    container.store_file(source_path[submission.language], submission.db_file.contents)
    container.start!

    container.attach(:stream => true, :stdin => nil, :stdout => true, :stderr => true, :logs => true, :tty => false)
    container.streaming_logs(stderr: true) { |stream, chunk| puts chunk }
    container.read_file("#{WORKDIR}/output/test.out")
  end

  def self.create_testing_image(submission)
    if !images.key?(submission.language)
      images[submission.language] = Docker::Image.build_from_dir("#{HOST_WORKDIR}", {
        'dockerfile' => "docker/lang/#{lang_to_image[submission.language]}",
      } )
    end
    images[submission.language]
  end

  def self.lang_to_image
    {
      'python' => 'Dockerfile.python',
      'java' => 'Dockerfile.java',
    }
  end

  def self.cmd
    {
      'python' => 'python submission/solution.py < input/test.in > output/test.out',
      'java' => 'javac submission/Solution.java -d . && java Solution < input/test.in > output/test.out',
    }
  end

  def self.source_path
    {
      'python' => "#{WORKDIR}/submission/solution.py",
      'java' => "#{WORKDIR}/submission/Solution.java",
    }
  end
end
