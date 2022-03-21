# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

workspace 'MoviesDB.xcworkspace'

def app_pods

pod 'RxSwift'
pod 'RxCocoa'
pod 'Kingfisher'

end


#APP
  target 'MoviesDB' do
app_pods
pod 'ProgressHUD'

end


#PRESENTATION
  target 'Presentation' do
  project './Presentation/Presentation.xcodeproj'

app_pods
pod 'ProgressHUD'

end


#CORE
  target 'Core' do
  project './Core/Core.xcodeproj'

app_pods

end