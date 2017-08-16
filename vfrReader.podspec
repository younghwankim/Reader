Pod::Spec.new do |s|
    s.name = 'vfrReader'
    s.version = '2.8.6'
    s.summary = 'PDF Reader Core for iOS.'
    s.homepage = 'https://github.com/younghwankim/Reader'
    s.license = {
      :type => 'MIT',
      :file => 'License.txt'
    }
    s.author = {'Julius Oklamcak' => 'https://github.com/younghwankim/Reader'}
    s.source = {:git => 'https://github.com/younghwankim/Reader'}
    s.platform = :ios, '6.0'
    s.source_files = 'Sources/**/*.{h,m}'
    s.resources = ['Graphics/reader/**/*']
    s.framework = 'Foundation', 'UIKit','CoreGraphics','QuartzCore','ImageIO','MessageUI'
    s.requires_arc = true
end
