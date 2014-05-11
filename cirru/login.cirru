
#login
  :v-if wantLogin
  #login-main
    input#password
      :type password
      :v-model password
    button#submit
      :v-on "click: auth"
      = submit

#admin
  div
    :v-if !logined
    :v-on "click: wantAdmin"
    span "admin"
  div
    :v-if logined
    :v-on "click: logout"
    span
      :v-text name
