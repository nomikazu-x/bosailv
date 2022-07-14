import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import GoTop from '@inotom/vue-go-top'
import Layout from '~/layouts/default.vue'
import TheHeader from '~/components/organisms/header/TheHeader.vue'
import TheSidebar from '~/components/organisms/sidebar/TheSidebar.vue'
import TheDestroyInfo from '~/components/organisms/application/TheDestroyInfo.vue'
import LevelUpModal from '~/components/organisms/modals/LevelUpModal.vue'
import TheFooter from '~/components/organisms/footer/TheFooter.vue'

describe('default.vue', () => {
  let routeNameMock

  beforeEach(() => {
    routeNameMock = jest.fn()
  })

  const mountFunction = () => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Layout, {
      localVue,
      vuetify,
      stubs: {
        GoTop: true,
        TheHeader: true,
        TheSidebar: true,
        TheDestroyInfo: true,
        LevelUpModal: true,
        TheFooter: true,
        Nuxt: true
      },
      mocks: {
        $route: {
          name: routeNameMock
        }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  it('表示される', () => {
    const wrapper = mountFunction()
    // console.log(wrapper.html())
    expect(wrapper.findComponent(GoTop).exists()).toBe(true) // 上に戻る
    expect(wrapper.findComponent(TheHeader).exists()).toBe(true) // ヘッダー
    expect(wrapper.findComponent(TheSidebar).exists()).toBe(true) // サイドバー
    expect(wrapper.findComponent(TheDestroyInfo).exists()).toBe(true) // レベルアップモーダル
    expect(wrapper.findComponent(LevelUpModal).exists()).toBe(true) // レベルアップモーダル
    expect(wrapper.findComponent(TheFooter).exists()).toBe(true) // フッター
    expect(wrapper.html()).toMatch('<nuxt-stub></nuxt-stub>')
  })
})
