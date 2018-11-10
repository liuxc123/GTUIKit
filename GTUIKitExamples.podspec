Pod::Spec.new do |s|
  s.name             = 'GTUIKitExamples'
  s.version          = '0.0.1'
  s.summary          = 'This spec is an aggregate of all the GTUIKit Components examples.'
  s.homepage         = 'https://github.com/liuxc123/GTUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/GTUIKit.git', :tag => s.version.to_s }
  s.requires_arc = true

  # Conventions
  s.source_files = 'components/*/examples/*.{h,m,swift}', 'components/*/examples/supplemental/*.{h,m,swift}', 'components/private/*/examples/*.{h,m,swift}', 'components/schemes/*/examples/*.{h,m,swift}', 'components/schemes/*/examples/supplemental/*.{h,m,swift}'
  s.resources = ['components/*/examples/resources/*', 'components/private/*/examples/resources/*', 'components/schemes/*/examples/resources/*']
  s.public_header_files = 'components/*/examples/*.h', 'components/*/examples/supplemental/*.h', 'components/private/*/examples/*.h', 'components/schemes/*/examples/*.h'

  s.dependency 'GTUIKit'

end
