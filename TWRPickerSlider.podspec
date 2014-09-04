Pod::Spec.new do |s|

  s.name         = "TWRPickerSlider"
  s.version      = "1.5.1"
  s.summary      = "A stack of sliding cards with pickers"
  s.homepage     = "https://github.com/chasseurmic/TWRPickerSlider"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Michelangelo Chasseur" => "chasseurmic@gmail.com" }
  s.social_media_url = "http://twitter.com/chasseurmic"
  s.source       = {
    :git => "https://github.com/chasseurmic/TWRPickerSlider.git",
    :tag => "1.5.1"
  }
  s.platform     = :ios, '7.0'
  s.source_files = 'Pod/*.{h,m}'
  s.resources = ['Pod/*.{xib,png}']
  s.requires_arc = true

end
