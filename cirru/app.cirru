
#main
  :v-if !wantLogin
  #paper
    input#search
      :v-model query
      :v-on "keydown:search | key enter"
    .topic
      :v-repeat topic:topics
      .title
        a.link
          :href {{topic.url}}
          :target _blank
          :v-text topic.title
        span.date
          :v-text "topic.time | short"
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
    #has-more
      :v-if hasMore
      :v-on "click: loadMore"
      = "More"