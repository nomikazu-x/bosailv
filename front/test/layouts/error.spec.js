import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import Layout from '~/layouts/error.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('error.vue', () => {
  const mountFunction = (statusCode) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Layout, {
      localVue,
      vuetify,
      propsData: {
        error: {
          statusCode
        }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper) => {
    const links = helper.getLinks(wrapper)

    // console.log(links)
    expect(links.includes('/home')).toBe(true) // トップページ
  }

  it('[401]表示される', () => {
    const wrapper = mountFunction(401)
    commonViewTest(wrapper)
  })
  it('[403]表示される', () => {
    const wrapper = mountFunction(403)
    commonViewTest(wrapper)
  })
  it('[404]表示される', () => {
    const wrapper = mountFunction(404)
    commonViewTest(wrapper)
  })
  it('[500]表示される', () => {
    const wrapper = mountFunction(500)
    commonViewTest(wrapper)
  })
})
