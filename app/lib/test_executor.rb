# frozen_string_literal: true

class TestExecutor
  HOST_WORKDIR = '/usr/src/app'
  WORKDIR = '/tmp/sandbox'

  def self.images
    @images ||= {}
  end

  def self.run_test(submission, test)
    create_testing_image(submission)

    uploaded_filename = submission.db_file.name

    docker_cmd =  ['sh', '-c', cmd(submission.language, uploaded_filename)]
    image = images[submission.language]
    opts = {
      'Image' => image.id,
      'Cmd' => docker_cmd,
    }

    container = Docker::Container.create(opts)
    container.store_file("#{WORKDIR}/input/test.in", test.db_file.contents)
    container.store_file(source_path(submission.language, uploaded_filename), submission.db_file.contents)
    container.start!

    container.attach(stream: true, stdin: nil, stdout: true, stderr: true, logs: true, tty: false)
    output = container.read_file("#{WORKDIR}/output/test.out")
    std_error = container.read_file("#{WORKDIR}/output/test.err")
    return_code = container.read_file("#{WORKDIR}/output/returncode")
    container.remove(force: true)

    # TODO: return a struct
    [output || "", std_error, return_code]

  rescue Docker::Error::TimeoutError
    [nil, 'Timeout reached.', 1]
  end

  def self.create_testing_image(submission)
    unless images.key?(submission.language)
      images[submission.language] = Docker::Image.build_from_dir(HOST_WORKDIR.to_s, 'dockerfile' => "docker/lang/#{lang_to_image[submission.language]}")
    end
    images[submission.language]
  end

  def self.lang_to_image
    {
      'python' => 'Dockerfile.python',
      'java' => 'Dockerfile.java'
    }
  end

  def self.cmd(submission_language, filename)
    classname = filename.split('.').first
    {
      'python' => "python submission/#{filename} < input/test.in > output/test.out",
      'java' => "javac submission/#{filename} -d . 2> output/test.err && java #{classname} < input/test.in > output/test.out 2> output/test.err; echo $? > output/returncode"
    }[submission_language]
  rescue Exception
    {
      'python' => 'python submission/solution.py < input/test.in > output/test.out',
      'java' => 'javac submission/Solution.java -d . 2> output/test.err && java Solution < input/test.in > output/test.out 2> output/test.err; echo $? > output/returncode'
    }[submission_language]
  end

  def self.source_path(submission_language, filename=nil)
    {
      'python' => "#{WORKDIR}/submission/#{filename || 'solution.py'}",
      'java' => "#{WORKDIR}/submission/#{filename || 'Solution.java'}"
    }[submission_language]
  end
end
