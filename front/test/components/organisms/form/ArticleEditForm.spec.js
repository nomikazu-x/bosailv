import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import ArticleThumbnailFileInput from '~/components/organisms/fileInputs/ArticleThumbnailFileInput.vue'
import ArticleTitleTextField from '~/components/organisms/textFields/ArticleTitleTextField.vue'
import GenresCheckbox from '~/components/organisms/checkbox/GenresCheckbox.vue'
import Editor from '~/components/organisms/editor/Editor.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'
import Component from '~/components/organisms/form/ArticleEditForm.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('ArticleEditForm.vue', () => {
  const mountFunction = (article, values = null) => {
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
      propsData: {
        article: { ...article }
      },
      data () {
        return { ...values }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper, article) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(TheProcessing).exists()).toBe(false)
    expect(wrapper.findComponent(ArticleThumbnailFileInput).exists()).toBe(true)
    expect(wrapper.findComponent(ArticleTitleTextField).exists()).toBe(true)
    expect(wrapper.findComponent(GenresCheckbox).exists()).toBe(true)
    expect(wrapper.findComponent(Editor).exists()).toBe(true)
    expect(wrapper.findComponent(RedBtn).exists()).toBe(true)
    expect(wrapper.vm.$data.title).toBe(article.title)
    expect(wrapper.vm.$data.content).toBe(article.content)
    expect(wrapper.vm.$data.selectedGenres).toEqual(article.genres.map((value) => { return value.id }))
  }

  it('[無効]ボタンを押せない', async () => {
    const article = Object.freeze({ title: 'article_title', content: 'article_content', genres: [{ id: 1, name: 'article_genre1' }, { id: 2, name: 'article_genre2' }], thumbnail_url: { xlarge: 'thumbnail_url_xlarge' } })
    const wrapper = mountFunction(article)
    commonViewTest(wrapper, article)

    // 削除
    wrapper.vm.$data.title = ''
    wrapper.vm.$data.content = ''
    wrapper.vm.$data.selectedGenres = []

    // 登録ボタン
    const button = wrapper.find('#article_update_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(true) // 無効
  })

  it('[有効]ボタンを押せる', async () => {
    const article = Object.freeze({ title: 'article_title', content: 'article_content', genres: [{ id: 1, name: 'article_genre1' }, { id: 2, name: 'article_genre2' }], thumbnail_url: { xlarge: 'thumbnail_url_xlarge' } })
    const wrapper = mountFunction(article)
    commonViewTest(wrapper, article)

    expect(wrapper.vm.$data.title).toBe('article_title')
    expect(wrapper.vm.$data.content).toBe('article_content')
    expect(wrapper.vm.$data.selectedGenres).toEqual([1, 2])

    // 登録ボタン
    const button = wrapper.find('#article_update_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (!button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(false) // 有効
  })
})
