

Pod::Spec.new do |s|

    s.name         = "JDObjectDealloc"
    s.version      = '0.0.5' 
    s.summary      = "JDObjectDealloc"

    s.description  = <<-DESC
			JDRouter
                   DESC

    s.homepage     = "https://github.com/JDongKhan/JDObjectDealloc.git"

    s.license      = { :type => 'MIT', :file => 'LICENSE' }

    s.author             = { "wangjindong" => "419591321@qq.com" }
    s.platform     = :ios, "8.0"

    s.source       = { :git => "https://github.com/JDongKhan/JDObjectDealloc.git", :tag => s.version.to_s }


    s.frameworks = 'Foundation'
    s.requires_arc = true


    s.source_files = 'JDObjectDealloc/JDObjectDealloc/**/*.{h,m}'
    s.public_header_files = 'JDObjectDealloc/JDObjectDealloc/**/*.h'

end
