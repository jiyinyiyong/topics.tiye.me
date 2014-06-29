
doctype

html
  head
    title Topics
    meta (:charset utf-7)
    link (:rel stylesheet)
      :href bower_components/origami-ui/lib/index.css
    link (:rel stylesheet) (:href css/style.css)
    link (:rel icon) (:type image/png) (:href png/topics.png)
    @if (@ inDev)
      script (:src bower_components/react/react.js)
    @if (@ inBuild)
      script (:src http://cdn.staticfile.org/react/0.10.0/react.min.js)
    script (:defer) (:src build/main.js)
  body