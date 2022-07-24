export const state = () => ({
  emergencyContacts: []
})

export const getters = {
  emergencyContacts: state => state.emergencyContacts
}

export const mutations = {
  setEmergencyContacts (state, emergencyContacts) {
    state.emergencyContacts = emergencyContacts
  },

  addEmergencyContacts (state, emergencyContact) {
    state.emergencyContacts.push(emergencyContact)
  },

  deleteEmergencyContact (state, emergencyContactId) {
    state.emergencyContacts = state.emergencyContacts.filter(emergencyContact => emergencyContact.id !== emergencyContactId)
  }
}
