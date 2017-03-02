Pod::Spec.new do |s|
	s.name = "HQliquidView"
	s.version = "1.0.0"
	s.summary = "A simple liquid View"
	s.license = { :type => "MIT", :file => "LICENSE" }
	s.homepage = "https://github.com/qianhongqiang/HQliquidView"
	s.author = { "Qian Hongqiang" => "https://github.com/qianhongqiang/HQliquidView" }
	s.source = { :git => "https://github.com/qianhongqiang/HQliquidView.git", :tag => "1.0.0" }
	s.requires_arc = true
	s.platform = :ios, "7.0"
	s.source_files = "HQliquidView/HQliquidAnimationViewLib/*", "*.{h,m}"
end