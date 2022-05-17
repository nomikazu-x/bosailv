export const state = () => ({
  articleComments: []
})

export const getters = {
  articleComments: state => state.articleComments
}

export const mutations = {
  setArticleComments (state, articleComments) {
    state.articleComments = articleComments
  },

  addArticleComments (state, articleComment) {
    state.articleComments.push(articleComment)
  },

  deleteArticleComment (state, articleCommentId) {
    state.articleComments = state.articleComments.filter(articleComment => articleComment.id !== articleCommentId)
  }
}
