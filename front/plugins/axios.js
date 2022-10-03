export default ({ $axios }) => {
  if (process.env.NODE_ENV === 'development') {
    // リクエストログ
    $axios.onRequest((config) => {
      // eslint-disable-next-line no-console
      console.log(config)
    })
    // レスポンスログ
    $axios.onResponse((config) => {
      // eslint-disable-next-line no-console
      console.log(config)
    })
    // エラーログ
    $axios.onError((e) => {
      // eslint-disable-next-line no-console
      console.log(e.response)
    })
  }
  // devise_token_authが通信時に用いるaccess-token,client,uidのパラメータをセット
  $axios.onRequest((config) => {
    config.headers.client = window.localStorage.getItem('client')
    config.headers['access-token'] = window.localStorage.getItem('access-token')
    config.headers.uid = window.localStorage.getItem('uid')
    config.headers['token-type'] = window.localStorage.getItem('token-type')
  })

  $axios.onResponse((response) => {
    if (response.headers.client) {
      localStorage.setItem('access-token', response.headers['access-token'])
      localStorage.setItem('client', response.headers.client)
      localStorage.setItem('uid', response.headers.uid)
      localStorage.setItem('token-type', response.headers['token-type'])
    }
  })
}
