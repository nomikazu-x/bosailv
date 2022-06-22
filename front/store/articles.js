export const state = () => ({
  article: {},
  articles: [],
  likers: []
})

export const getters = {
  article: state => state.article,
  articles: state => state.articles,
  likers: state => state.likers
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
  },

  setLikers (state, likers) {
    state.likers = likers
  },

  addLikers (state, liker) {
    state.likers.push(liker)
  },

  deleteLiker (state, likerId) {
    state.likers = state.likers.filter(liker => liker.id !== likerId)
  }
}
