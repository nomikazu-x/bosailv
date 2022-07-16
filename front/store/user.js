export const state = () => ({
  user: {},
  users: [],
  point: {},
  requiredPoint: {},
  level: 1
})

export const getters = {
  user: state => state.user,
  users: state => state.users,
  point: state => state.point,
  requiredPoint: state => state.requiredPoint,
  level: state => state.level
}

export const mutations = {
  setUser (state, user) {
    state.user = user
  },

  setUsers (state, users) {
    state.users = users
  },

  addUsers (state, user) {
    state.users.push(user)
  },

  deleteUser (state, userId) {
    state.users = state.users.filter(user => user.id !== userId)
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
