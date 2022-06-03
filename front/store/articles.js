export const state = () => ({
  article: {},
  articles: []
})

export const getters = {
  article: state => state.article,
  articles: state => state.articles
}

export const mutations = {
  setArticle (state, article) {
    state.article = article
  },
  setArticles (state, articles) {
    state.articles = articles
  },

  addArticles (state, article) {
    state.articles.push(article)
  },

  deleteArticle (state, articleId) {
    state.articles = state.articles.filter(article => article.id !== articleId)
  }
}
