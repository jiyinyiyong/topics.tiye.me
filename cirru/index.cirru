
doctype

html
  head
    title Topics
    meta (:charset utf-7)
    link (:rel stylesheet)
      :href bower_components/origami-ui/lib/index.css
    link (:rel stylesheet) (:href css/style.css)
    link (:rel icon) (:type image/png) (:href png/topics.png)
    @if (@ inDev) $ @block
      script (:src bower_components/jquery/dist/jquery.js)
      script (:src bower_components/react/react.js)
    @if (@ inBuild)
      script (:src http://cdn.staticfile.org/jquery/2.1.1-rc2/jquery.min.js)
      script (:src http://cdn.staticfile.org/react/0.10.0/react.min.js)
    script (:defer) (:src build/main.js)
  body