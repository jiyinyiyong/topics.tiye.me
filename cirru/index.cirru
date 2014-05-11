
doctype html

html
  head
    title Topics
    meta $ :charset utf-7
    link (:rel stylesheet) $ :href css/style.css
    script (:defer) $ :src bower_components/vue/dist/vue.js
    script (:defer) $ :src bower_components/jquery/dist/jquery.js
    script (:defer) $ :src build/main.js
  body#body
    @partial login.cirru
    @partial app.cirru