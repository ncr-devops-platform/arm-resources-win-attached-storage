
require 'rubygems/package_task'
require 'json'
require 'bump'

package_name = 'AttachStorage'

namespace :release do
  task :package do
    require 'zip'
    zipfile_path = './AttachStorage.zip'
    FileUtils.rm zipfile_path if File.exist? zipfile_path
    input_filenames = FileList['**/*'].exclude('Rakefile').exclude('*.gemspec').reject do |file|
      File.directory?(file)
    end

    Zip::File.open(zipfile_path, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(filename, filename)
      end
    end
  end

  task :bump do
    Bump::Bump.run('patch', commit: true, bundle:false, tag:false)
  end

  task :push do
    version = Bump::Bump.current
    sh <<-PUSH
      git tag -a v#{version} -m \"Releasing v#{version}\"
      git push
      git push origin v#{version}
    PUSH
  end

  task promote_package: [:package] do
    require 'fileutils'
    version = Bump::Bump.current
    sh <<-COMMIT
      git add ./#{package_name}.zip
      git commit -m "updating the #{package_name}.zip artifact to version #{version}"
    COMMIT
  end

  desc 'releases this package'
  task all: [:bump, :promote_package, :push]
end
