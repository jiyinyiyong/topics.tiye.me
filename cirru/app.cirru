
#main
  :v-if !wantLogin
  #paper
    .topic
      :v-repeat topic:topics
      .title $ :v-text topic.title
      .link $ a (:href {{topic.url}})
        :target _blank
        :v-text topic.url