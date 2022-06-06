export const state = () => ({
  user: {},
  point: {},
  requiredPoint: {},
  level: 1
})

export const getters = {
  user: state => state.user,
  point: state => state.point,
  requiredPoint: state => state.requiredPoint,
  level: state => state.level
}

export const mutations = {
  setUser (state, user) {
    state.user = user
  },

  setPoint (state, point) {
    state.point = point
  },

  setRequiredPoint (state, requiredPoint) {
    state.requiredPoint = requiredPoint
  },

  setLevel (state, level) {
    state.user.level = level
  }
}
