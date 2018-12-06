Pod::Spec.new do |s|
  s.name = 'LazyTransitions'
  s.version = '0.1.2'
  s.license = 'MIT'
  s.summary = 'Simple framework to add lazy pop and dismiss like in the Facebook or Instagram apps'
  s.homepage = 'https://github.com/serp1412/LazyTransitions'
  s.social_media_url = 'http://twitter.com/serp1412'
  s.authors = { 'Serghei Catraniuc' => 'catraniuc.serghei@gmail.com' }
  s.source = { :git => 'https://github.com/serp1412/LazyTransitions.git', :tag => s.version }
  s.swift_version = '4.2'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LazyTransitions/*.swift'
end
