export const state = () => ({
  families: []
})

export const getters = {
  families: state => state.families
}

export const mutations = {
  setFamilies (state, families) {
    state.families = families
  },

  addFamilies (state, family) {
    state.families.push(family)
  },

  deleteFamily (state, familyId) {
    state.families = state.families.filter(family => family.id !== familyId)
  }
}
