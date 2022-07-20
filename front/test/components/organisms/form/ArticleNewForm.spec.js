import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import ArticleThumbnailFileInput from '~/components/organisms/fileInputs/ArticleThumbnailFileInput.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import GenresCheckbox from '~/components/organisms/checkbox/GenresCheckbox.vue'
import Editor from '~/components/organisms/editor/Editor.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'
import Component from '~/components/organisms/form/ArticleNewForm.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('ArticleNewForm.vue', () => {
  const mountFunction = (values = null) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Component, {
      localVue,
      vuetify,
      stubs: {
        ArticleThumbnailFileInput: true,
        GenresCheckbox: true,
        Editor: true
      },
      data () {
        return { ...values }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(TheProcessing).exists()).toBe(false)
    expect(wrapper.findComponent(ArticleThumbnailFileInput).exists()).toBe(true)
    expect(wrapper.findComponent(BaseTextField).exists()).toBe(true)
    expect(wrapper.findComponent(GenresCheckbox).exists()).toBe(true)
    expect(wrapper.findComponent(Editor).exists()).toBe(true)
    expect(wrapper.findComponent(RedBtn).exists()).toBe(true)
  }

  it('[無効]投稿ボタンを押せない', async () => {
    const wrapper = mountFunction(false)
    commonViewTest(wrapper)

    expect(wrapper.vm.$data.title).toBe('')
    expect(wrapper.vm.$data.content).toBe('')
    expect(wrapper.vm.$data.selectedGenres).toEqual([])

    // 投稿ボタン
    const button = wrapper.find('#article_create_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(true) // 無効
  })

  it('[有効]投稿ボタンを押せる', async () => {
    const wrapper = mountFunction(false)
    commonViewTest(wrapper)

    // 入力
    wrapper.vm.$data.title = 'article_title'
    wrapper.vm.$data.content = 'article_content'
    wrapper.vm.$data.selectedGenres = [1, 2]

    expect(wrapper.vm.$data.title).toBe('article_title')
    expect(wrapper.vm.$data.content).toBe('article_content')
    expect(wrapper.vm.$data.selectedGenres).toEqual([1, 2])

    // 投稿ボタン
    const button = wrapper.find('#article_create_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (!button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(false) // 有効
  })
})
