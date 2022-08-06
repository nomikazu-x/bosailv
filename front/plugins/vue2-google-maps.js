import Vue from 'vue'
import * as VueGoogleMaps from 'vue2-google-maps'

export default ({ $config }) => {
  Vue.use(VueGoogleMaps, {
    load: {
      key: $config.googleMapApi,
      language: 'ja'
    }
  })
}
