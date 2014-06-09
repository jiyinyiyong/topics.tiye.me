
doctype html

html
  head
    title Topics
    meta $ :charset utf-7
    link (:rel stylesheet) $ :href css/style.css
    link (:rel icon) $ :href png/topics.png
    @if (@ inDev) $ @block
      script (:src bower_components/vue/dist/vue.js)
      script (:src bower_components/jquery/dist/jquery.js)
    @if (@ inBuild) $ @block
      script (:src http://cdn.staticfile.org/vue/0.10.4/vue.min.js)
      script (:src http://cdn.staticfile.org/jquery/2.1.1-rc2/jquery.min.js)
    script (:defer) $ :src build/main.js
  body#body
    @partial login.cirru
    @partial app.cirru