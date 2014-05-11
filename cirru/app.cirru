
#main
  :v-if !wantLogin
  #paper
    .topic
      :v-repeat topic:topics
      .title
        span
          :v-text topic.title
        a.link
          :href {{topic.url}}
          :target _blank
          :v-text topic.url
      .note
        :v-if !logined
        span
          :v-text topic.note
      .note
        :v-if logined
        input
          :v-on "blur: update(topic)"
          :v-model topic.note
      .delete
        :v-if logined
        :v-on "click: remove(topic._id, $index)"
        = Delete