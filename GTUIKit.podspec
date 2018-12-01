Pod::Spec.new do |s|
  s.name             = 'GTUIKit'
  s.version          = '0.0.1'
  s.summary          = 'This spec is an aggregate of all the GTUIKit Components.'
  s.homepage         = 'https://github.com/liuxc123/GTUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/GTUIKit.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  # 基础组件
  # 视觉规范单元化的体现，构建 GTUIKit 体系的基础，主要包含原子资源、原子控件和 Iconfont 图标。基础层是由视觉规范最小的单元构建。
  s.subspec "BasicComponent" do |basic_spec|

    # IconFont
    basic_spec.subspec "IconFont" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/BasicComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/BasicComponent/#{component.base_name}/src/*.{h,m}", "components/BasicComponent/#{component.base_name}/src/private/*.{h,m}"
      component.resources = ["components/BasicComponent/#{component.base_name}/src/GT#{component.base_name}.bundle"]
    end

    # Typography
    basic_spec.subspec "Typography" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/BasicComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/BasicComponent/#{component.base_name}/src/*.{h,m}", "components/BasicComponent/#{component.base_name}/src/private/*.{h,m}"

      component.dependency "GTUIKit/private/Math"
      component.dependency "GTUIKit/private/Application"
    end

    # ShadowLayer
    basic_spec.subspec "ShadowLayer" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/BasicComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/BasicComponent/#{component.base_name}/src/*.{h,m}", "components/BasicComponent/#{component.base_name}/src/private/*.{h,m}"
    end

    # ShapeLibrary
    basic_spec.subspec "ShapeLibrary" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/BasicComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/BasicComponent/#{component.base_name}/src/*.{h,m}", "components/BasicComponent/#{component.base_name}/src/private/*.{h,m}"

      component.dependency "GTUIKit/BasicComponent/Shapes"
      component.dependency "GTUIKit/private/Math"
    end

    # Shapes
    basic_spec.subspec "Shapes" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/BasicComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/BasicComponent/#{component.base_name}/src/*.{h,m}", "components/BasicComponent/#{component.base_name}/src/private/*.{h,m}"

      component.dependency "GTUIKit/BasicComponent/ShadowLayer"
      component.dependency "GTUIKit/private/Math"
    end

    # Palettes
    basic_spec.subspec "Palettes" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/BasicComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/BasicComponent/#{component.base_name}/src/*.{h,m}", "components/BasicComponent/#{component.base_name}/src/private/*.{h,m}"
    end

  end

  # 通用UI组件
  # GTUIKit 的核心统一模块，即业务方最常用的统一控件模块，包含通用资源、基础控件和样式管理器。
  # 通过对基础层的组合和视觉化应用而构建出通用层，通用层可以应用在客户端所有常见的场景。
  s.subspec "CommonComponent" do |common_spec|

    # ActivityIndicatorView
    common_spec.subspec "ActivityIndicatorView" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
    end

    # Badge
    common_spec.subspec "Badge" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

    end

    # BottomSheet
    common_spec.subspec "BottomSheet" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTUIKit/private/KeyboardWatcher"
        component.dependency "GTUIKit/private/Math"
        component.dependency "GTUIKit/BasicComponent/ShapeLibrary"
        component.dependency "GTUIKit/BasicComponent/Shapes"
    end

    # Button
    common_spec.subspec "Button" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency 'GTFInternationalization'
        component.dependency 'GTFTextAccessibility'
        component.dependency "GTUIKit/CommonComponent/Ink"
        component.dependency "GTUIKit/BasicComponent/ShadowLayer"
        component.dependency "GTUIKit/BasicComponent/Shapes"
        component.dependency "GTUIKit/BasicComponent/Typography"
        component.dependency "GTUIKit/private/Math"
        component.dependency "GTUIKit/private/Application"
    end

    # ButtonBar
    common_spec.subspec "ButtonBar" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTUIKit/CommonComponent/Button"
    end
 
    # CheckBox
    common_spec.subspec "CheckBox" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
    end

    # Toast
    common_spec.subspec "Toast" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
        component.resources = ["components/CommonComponent/#{component.base_name}/src/resource/*.bundle"]
    end

    # Dialogs
    common_spec.subspec "Dialogs" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTUIKit/CommonComponent/BottomSheet"
        component.dependency "GTUIKit/CommonComponent/Button"
        component.dependency "GTUIKit/BasicComponent/ShadowLayer"
        component.dependency "GTUIKit/BasicComponent/Typography"
        component.dependency "GTUIKit/private/KeyboardWatcher"
        component.dependency "GTUIKit/private/UIMetrics"
        component.dependency "GTFInternationalization"
    end

    # EmptyView
    common_spec.subspec "EmptyView" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
        component.resources = ["components/CommonComponent/#{component.base_name}/src/resource/GTUINetErrorView.bundle"]

        component.dependency "GTUIKit/private/UIMetrics"
    end

    # FlexibleHeader
    common_spec.subspec "FlexibleHeader" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency 'GTFTextAccessibility'
        component.dependency "GTUIKit/private/Application"
        component.dependency "GTUIKit/private/UIMetrics"
    end

    # HeaderStackView
    common_spec.subspec "HeaderStackView" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}"
    end

    # ImageView
    common_spec.subspec "ImageView" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTUIKit/private/Math"
    end


    # Ink
    common_spec.subspec "Ink" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTUIKit/private/Math"

    end

    # Label
    common_spec.subspec "Label" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
    end


    # NavigationBar
    common_spec.subspec "NavigationBar" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        # Accessibility Configurator
        component.dependency "GTFTextAccessibility"
        component.dependency "GTFInternationalization"

        component.dependency "GTUIKit/CommonComponent/ButtonBar"
        component.dependency "GTUIKit/private/Math"
    end

    # NavigationController
    common_spec.subspec "NavigationController" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
        component.resources = ["components/CommonComponent/#{component.base_name}/src/resource/*.png"]


        # Navigation bar contents
        component.dependency "GTUIKit/CommonComponent/HeaderStackView"
        component.dependency "GTUIKit/CommonComponent/NavigationBar"
        component.dependency "GTUIKit/BasicComponent/Typography"
        component.dependency "GTUIKit/private/Application"
        # Flexible header + shadow
        component.dependency "GTUIKit/CommonComponent/FlexibleHeader"
        component.dependency "GTUIKit/BasicComponent/ShadowLayer"

        component.dependency "GTUIKit/BasicComponent/IconFont"
        component.dependency "GTFInternationalization"
        component.dependency "GTUIKit/private/UIMetrics"
    end

    # NavigationBar
    common_spec.subspec "NotificationBar" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
        component.resources = ["components/CommonComponent/#{component.base_name}/src/resource/GTNotificationBar.bundle"]

        # Accessibility Configurator
        component.dependency "GTFTextAccessibility"
        component.dependency "GTFInternationalization"


        component.dependency "GTUIKit/BasicComponent/Typography"
        component.dependency "GTUIKit/CommonComponent/OverlayWindow"
        component.dependency "GTUIKit/CommonComponent/Button"

        component.dependency "GTUIKit/private/Application"
        component.dependency "GTUIKit/private/KeyboardWatcher"
        component.dependency "GTUIKit/private/Overlay"

    end

    # OverlayWindow
    common_spec.subspec "OverlayWindow" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTUIKit/private/Application"
    end

    # PickerView
    common_spec.subspec "PickerView" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
        component.resources = ["components/CommonComponent/#{component.base_name}/src/resource/GTUIPickerView.bundle"]

        component.dependency "GTUIKit/private/UIMetrics"
    end

    # ProgressView
    common_spec.subspec "ProgressView" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"


        component.dependency "GTFInternationalization"
        component.dependency "GTMotionInterchange"
        component.dependency "GTUIKit/private/Math"

    end

    # Switch
    common_spec.subspec "Switch" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
      component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"
    end



    # TabBar
    common_spec.subspec "TabBar" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
    component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTFInternationalization"
    component.dependency "GTUIKit/BasicComponent/ShadowLayer"
    component.dependency "GTUIKit/BasicComponent/Typography"
    component.dependency "GTUIKit/CommonComponent/Ink"
    component.dependency "GTUIKit/private/AnimationTiming"
    component.dependency "GTUIKit/private/Math"
    component.dependency "GTUIKit/private/Application"

    end

    # TextFields
    common_spec.subspec "TextFields" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTUIKit/private/AnimationTiming"
        component.dependency "GTUIKit/BasicComponent/Typography"
        component.dependency "GTUIKit/BasicComponent/Palettes"
        component.dependency "GTFInternationalization"
        component.dependency "GTUIKit/private/Math"
    end

    # ToolBar
    common_spec.subspec "ToolBar" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/CommonComponent/#{component.base_name}/src/*.h"
        component.source_files = "components/CommonComponent/#{component.base_name}/src/*.{h,m}", "components/CommonComponent/#{component.base_name}/src/private/*.{h,m}"

        component.dependency "GTFInternationalization"
        component.dependency "GTUIKit/CommonComponent/Button"
        component.dependency "GTUIKit/CommonComponent/NavigationBar"
        component.dependency "GTUIKit/private/Math"
    end

    # schemes
    common_spec.subspec "schemes" do |scheme_spec|
      scheme_spec.subspec "ColorScheme" do |scheme|
        scheme.ios.deployment_target = '8.0'
        scheme.public_header_files = "components/CommonComponent/schemes/#{scheme.base_name}/src/*.h"
        scheme.source_files = "components/CommonComponent/schemes/#{scheme.base_name}/src/*.{h,m}"
      end
      scheme_spec.subspec "ShapeScheme" do |scheme|
        scheme.ios.deployment_target = '8.0'
        scheme.public_header_files = "components/CommonComponent/schemes/#{scheme.base_name}/src/*.h"
        scheme.source_files = "components/CommonComponent/schemes/#{scheme.base_name}/src/*.{h,m}"
        scheme.dependency "GTUIKit/BasicComponent/ShapeLibrary"
        scheme.dependency "GTUIKit/BasicComponent/Shapes"
      end
      scheme_spec.subspec "TypographyScheme" do |scheme|
        scheme.ios.deployment_target = '8.0'
        scheme.public_header_files = "components/CommonComponent/schemes/#{scheme.base_name}/src/*.h"
        scheme.source_files = "components/CommonComponent/schemes/#{scheme.base_name}/src/*.{h,m}"
      end
    end




  end


  # SceneComponent 场景UI组件
  # 按照分场景的方式，构建具有场景特点的控件集合，比如资金控件、商家控件、社交控件等。统一组件库搭建了场景层，按照这些场景在通用层的基础上构建处理业务个性化控件。
  # s.subspec "SceneComponent" do |scene_spec|
  # end

  # private 其他工具组件
  # 工具类组件
  s.subspec "private" do |private_spec|

    # AnimationTiming
    private_spec.subspec "AnimationTiming" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/private/#{component.base_name}/src/*.h"
        component.source_files = "components/private/#{component.base_name}/src/*.{h,m}", "components/private/#{component.base_name}/src/private/*.{h,m}"
    end

    # Application
    private_spec.subspec "Application" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
    end

    # Math
    private_spec.subspec "Math" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
    end

    # KeyboardWatcher
    private_spec.subspec "KeyboardWatcher" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"

      component.dependency "GTUIKit/private/Application"
    end

    # UIMetrics
    private_spec.subspec "UIMetrics" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}", "components/private/#{component.base_name}/src/private/*.{h,m}"

      component.dependency "GTUIKit/private/Application"
    end

    # Overlay
    private_spec.subspec "Overlay" do |component|
        component.ios.deployment_target = '8.0'
        component.public_header_files = "components/private/#{component.base_name}/src/*.h"
        component.source_files = "components/private/#{component.base_name}/src/*.{h,m}", "components/private/#{component.base_name}/src/private/*.{h,m}"
    end

  end

end
