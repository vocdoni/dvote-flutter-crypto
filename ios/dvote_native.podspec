#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint dvote_native.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'dvote_native'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin to allow native mobile apps to interact with Vocdoni decentralized votes.'
  s.description      = <<-DESC
Flutter plugin to allow native mobile apps to interact with Vocdoni decentralized votes.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.public_header_files = 'Classes**/*.h'
  s.source_files = 'Classes/**/*'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
