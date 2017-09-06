
require 'rubygems/package_task'
require 'json'
require 'bump'

package_name = 'AttachStorage'

namespace :release do
  Rake::PackageTask.new(package_name, 'edge') do |p|
    p.need_zip = true
    p.package_files.include('./*')
    p.package_files.exclude('./pkg')
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

  task promote_package: [:repackage] do
    require 'fileutils'
    version = Bump::Bump.current
    FileUtils.cp "./pkg/#{package_name}-edge.zip", "./#{package_name}.zip"
    sh <<-COMMIT
      git add ./#{package_name}.zip
      git commit -m "updating the #{package_name}.zip artifact to version #{version}"
    COMMIT
  end

  desc 'releases this package'
  task all: [:bump, :promote_package, :push]
end
