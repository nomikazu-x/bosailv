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
    if (localStorage.getItem('token-type') === 'Bearer' && localStorage.getItem('access-token')) {
      config.headers.uid = localStorage.getItem('uid')
      config.headers.client = localStorage.getItem('client')
      config.headers['access-token'] = localStorage.getItem('access-token')
    }
  })

  $axios.onResponse((response) => {
    if (response.headers['token-type'] === 'Bearer' && response.headers['access-token']) {
      localStorage.setItem('token-type', response.headers['token-type'])
      localStorage.setItem('uid', response.headers.uid)
      localStorage.setItem('client', response.headers.client)
      localStorage.setItem('access-token', response.headers['access-token'])
      localStorage.setItem('expiry', response.headers.expiry)
    }
  })
}
